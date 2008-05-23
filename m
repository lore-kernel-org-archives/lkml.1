Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYEWPvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYEWPvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYEWPvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:51:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:45238 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYEWPvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jtnxYJDH2ql+0PypxDs7iWkjA/zjlrB2JHDpCvNcyW8S5O0GpLWcKylV1JyJk7foKpcobjWw09X9n6qpkZ3rfcR4aFT4mtOUNe4dtrWGUnv6JVpIm7TLQ9il6LsFrC8q+fR5Sym25QhVSpD5elDTYnZSafIo+F1M964FaP9XoSM=
Message-ID: <19f34abd0805230851w59a5972dk593900cf3ea8c14a@mail.gmail.com>
Date: Fri, 23 May 2008 17:51:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] kmemcheck: SMP support
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4836E55C.5000304@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523141759.GA1833@damson.getinternet.no>
	 <4836E55C.5000304@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 5:40 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Vegard Nossum wrote:
>>
>> This works on real hw, but not on qemu. It seems to get stuck waiting for
>> one
>> of the atomic values to change. Don't know why yet, it might just be yet
>> another bug in qemu... (we've hit at least two of them so far. And they
>> were
>> real bugs too.)
>>
>
> I've noticed that qemu mis-reports the eip of cmpxchg if it faults (it
> reports the eip of the start of the basic block, I think).  Does that match
> what you're seeing?

You mean the EIP that gets pushed on the stack for the page fault?
(That would be bad news for kmemcheck. I suppose the rest of the
kernel never page faults on cmpxchg addresses?)

Or do you mean the EIP that shows up in gdb?

But no, it seems to be unrelated. What I hit so far were (in 0.9.0):

1. qemu doesn't set the single-stepping flag of DR6 on single-step
debug exceptions.
2. qemu triggers int 0 (divide error) instead of int 2 on NMI IPIs.

But both of these were fixed in the latest 0.9.1.

I don't yet know if what I'm hitting now is really an error with qemu.
But I usually trust the real hardware more :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
