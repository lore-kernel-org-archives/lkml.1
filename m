Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbYENPcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbYENPcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbYENPbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:31:55 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:45534 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYENPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zpn38c7QvKUa6d5qY39EgxnPIRsaqSFMPBZpSzJyQNChrXdQYnHEXbBD5z9UhJiNcmSHyF7ITs8gfSn2NWtMgU/KMOAIYG/MQE9w9alpom/FDs+qIOOYSxPy6fRPH1j1VwsPGhfeok3jjEoiNm0jmsvB8tIgdcmCw385iDvv+UA=
Message-ID: <19f34abd0805140831i4f358f0ao82f22be3482a243c@mail.gmail.com>
Date: Wed, 14 May 2008 17:31:49 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Paulo Marques" <pmarques@grupopie.com>
Subject: Re: [PATCH] kallsyms: fix potential overflow in binary search
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <482AD08D.7070206@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513200736.GA17909@damson.getinternet.no>
	 <482AD08D.7070206@grupopie.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 14, 2008 at 1:44 PM, Paulo Marques <pmarques@grupopie.com> wrote:
> Vegard Nossum wrote:
>>>
>>> From 61b840f071e496f632fcc293f5435428cfc98844 Mon Sep 17 00:00:00 2001
>>
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Tue, 13 May 2008 10:20:27 +0200
>> Subject: [PATCH] kallsyms: fix potential overflow in binary search
>>
>> This will probably never trigger... but it won't hurt to be careful.
>
> Not "probably", this will never trigger _period_. If you ever have more than
> 2^31 symbols in the kernel's kallsyms table you'll have worse problems to
> worry about than the binary search overflowing.
>
> So, I don't think it is worth this des-optimization at all...

You are right, and I will not push this patch through if you think it's stupid.

The change is only a matter of principle; at the very least, document
your assumptions! So my patch changed something that was not obviously
right to something that is explicitly right. Is it even remotely
possible that somebody could notice that we never have 2^32 kallsym
entries and change these array indices to a smaller type, without
taking the possibility of overflow into account? It sounds unlikely, I
agree; on the other hand, what makes this different from all the
_other_ times you thought something was impossible and it wasn't?
(Surely you've had those experiences too?)

My mentality is to make things work under as many circumstances as
possible, provided the effort is worth it, so that I won't be
surprised in the future. Documentation is another way to do that.
Would you rather see a patch that introduces a comment which explains
why the overflow isn't possible (in the current situation)?

If you still believe this is wrong, then I will ask Andrew to withdraw
the patch. Thank you for your comments.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
