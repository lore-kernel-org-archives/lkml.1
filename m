Return-Path: <linux-kernel-owner+w=401wt.eu-S2992916AbXEBIvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992916AbXEBIvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXEBIvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:51:33 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:58088 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992916AbXEBIvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qfEhn3jJANASxlaWm4JIKBbqhTtgVSXs9qzTZUlItVMv+KFaX35absJz9husLONzF2lc1y66zUtbp66Y814fXRtc0noJmpyCxK3Ft5wdTA/s5oKXfQfISrIOsTmA6xSIhDgql6RL5Ww6Ogo3T/5FFwnM5d3fsqp79Gy2ZrlVV5E=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v8
Date: Wed, 2 May 2007 04:51:27 -0400
User-Agent: KMail/1.9.6
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
References: <20070501212223.GA29867@elte.hu> <200705020403.35385.gene.heskett@gmail.com> <20070502081356.GA21827@elte.hu>
In-Reply-To: <20070502081356.GA21827@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705020451.27704.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> > I noticed a (harmless) bounds warning triggered by the reduction in
>> > size of array->bitmap.  Patchlet below.
>>
>> I just checked my logs, and it appears my workload didn't trigger this
>> one Mike. [...]
>
>yeah: this is a build-time warning and it needs a newer/smarter gcc to
>notice that provably redundant piece of code. It's a harmless thing -
>but nevertheless Mike's fix is a nice little micro-optimization as well:
>it always bothered me a bit that at 140 priority levels we were _just_
>past the 128 bits boundary by 12 bits. Now on 64-bit boxes it's just two
>64-bit words to cover all 100 priority levels of RT tasks.
>
>> [...]  And so far, v8 is working great here.  And that great is in my
>> best "Tony the Tiger" voice, stolen shamelessly from the breakfast
>> cereal tv commercial of 30+ years ago. :)
>
>heh :-)
>
>> Ingo asked for a 0-100 rating, where 0 is mainline as I recall it, and
>> 100 is the best of the breed.  I'll give this one a 100 till something
>> better shows up.
>
>nice - and you arent even using any OpenGL games ;)
>
>The 0-100 rating is really useful to me so that i can see the impact of
>regressions (if any) and it's also one single number representing the
>subjective impression - that way it's easier to keep tab of things.
>
>btw., do you still renice kmail slightly, or does it now work out of box
>with default nice 0?
>
>	Ingo

For this last couple of boots, its "right out of the box" and isn't getting 
under my skin.  A make -j4 didn't bother it either.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The goys have proven the following theorem...
		-- Physicist John von Neumann, at the start of a classroom
		   lecture.
