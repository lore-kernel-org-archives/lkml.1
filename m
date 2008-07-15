Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbYGOWBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbYGOWBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbYGOWBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:01:17 -0400
Received: from gw.goop.org ([64.81.55.164]:59291 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbYGOWBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:01:15 -0400
Message-ID: <487D1E1E.9060609@goop.org>
Date: Tue, 15 Jul 2008 15:01:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] generic ipi function calls: wait on alloc failure	fallback
References: <487D0719.9000503@goop.org> <20080715214819.GA23588@elte.hu>
In-Reply-To: <20080715214819.GA23588@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> When a GFP_ATOMIC allocation fails, it falls back to allocating the 
>> data on the stack and converting it to a waiting call.
>>
>> Make sure we actually wait in this case.
>>     
>
> cool, thanks!
>
> does this explain the xen64 weirdnesses you've been seeing?
>   

No, but I haven't seen it lately.  I think the other RCU fixes may have 
helped.  But it's all a bit of a worry: I didn't have a good theory 
about what was going wrong, the RCU patches didn't look like they'd fix 
the symptoms I was seeing.

I've seen it with 32 and 64-bit Xen, but there's nothing about the 
problem which makes me think it's really Xen specific.  If it were, I'd 
expect to see failures all over the place, rather than in just in this 
one specific place.

I'm concerned there's a lurking bug, particularly if it's a generic race 
or something that happens to be triggered when running under Xen because 
of the timing changes.  I've tried reproducing it in a hvm Xen domain 
(so it's running the normal x86 kernel fully virtualized, but with the 
Xen scheduler, etc).  I didn't see a problem, but it isn't a very 
convincing test one way or the other.

    J
