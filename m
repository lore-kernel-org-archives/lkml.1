Return-Path: <linux-kernel-owner+w=401wt.eu-S1161364AbXDXHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161364AbXDXHAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161427AbXDXHAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:00:18 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:37842 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161364AbXDXHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sGaTObQ7vs7gJhAJDs2OjQB6NMNFhofbhKFa5T0iaWrs48NzAcMCr5+SUntnnplkv2Nqw+5fcYEEFa+46VhTMgqzAZb2IJGjexThKm0AzFcYgSNzl/MoDD0RCwRRGQnUgsUJzUEI4tfnTn+lN4fRTYeoQMwIvONT97Uaktmmq/c=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Tue, 24 Apr 2007 03:00:07 -0400
User-Agent: KMail/1.9.6
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
References: <200704220959.34978.kernel@kolivas.org> <462DA1E8.9080201@bigpond.net.au> <20070424063633.GA17257@elte.hu>
In-Reply-To: <20070424063633.GA17257@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704240300.07689.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007, Ingo Molnar wrote:
>* Peter Williams <pwil3058@bigpond.net.au> wrote:
>> > The cases are fundamentally different in behavior, because in the
>> > first case, X hardly consumes the time it would get in any scheme,
>> > while in the second case X really is CPU bound and will happily
>> > consume any CPU time it can get.
>>
>> Which still doesn't justify an elaborate "points" sharing scheme.
>> Whichever way you look at that that's just another way of giving X
>> more CPU bandwidth and there are simpler ways to give X more CPU if it
>> needs it.  However, I think there's something seriously wrong if it
>> needs the -19 nice that I've heard mentioned.
>
>Gene has done some testing under CFS with X reniced to +10 and the
>desktop still worked smoothly for him.

As a data point here, and probably nothing to do with X, but I did manage to 
lock it up, solid, reset button time tonight, by wanting 'smart' to get done 
with an update session after amanda had started.  I took both smart processes 
I could see in htop all the way to -19, but when it was about done about 3 
minutes later, everything came to an instant, frozen, reset button required 
lockup.  I should have stopped at -17 I guess. :(

>So CFS does not 'need' a reniced 
>X. There are simply advantages to negative nice levels: for example
>screen refreshes are smoother on any scheduler i tried. BUT, there is a
>caveat: on non-CFS schedulers i tried X is much more prone to get into
>'overscheduling' scenarios that visibly hurt X's performance, while on
>CFS there's a max of 1000-1500 context switches a second at nice -10.
>(which, considering the cost of a context switch is well under 1%
>overhead.)
>
>So, my point is, the nice level of X for desktop users should not be set
>lower than a low limit suggested by that particular scheduler's author.
>That limit is scheduler-specific. Con i think recommends a nice level of
>-1 for X when using SD [Con, can you confirm?], while my tests show that
>if you want you can go as low as -10 under CFS, without any bad
>side-effects. (-19 was a bit too much)
>
>> [...]  You might as well just run it as a real time process.
>
>hm, that would be a bad idea under any scheduler (including CFS),
>because real time processes can starve other processes indefinitely.
>
>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I have discovered that all human evil comes from this, man's being unable
to sit still in a room.
		-- Blaise Pascal
