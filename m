Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXDVCHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXDVCHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 22:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXDVCHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 22:07:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:10903 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbXDVCHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 22:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Nel7KMnjOHCHqWCqPiDYSilaYDegY5L4QHXo3J8XbmI13F0lkOgTnBtY2zJoqLKcPf2pTyzBlOL3g+PyE2gVi1V8rMOCo24FfNg6DkjlMr4Hgh/zTDy19DeCCaJf3gm1K5RZeOy9CZGqxYj2VXbMHaHFjKz4LyaEZ76CFVX3ro4=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sat, 21 Apr 2007 22:07:19 -0400
User-Agent: KMail/1.9.6
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr
References: <20070420140457.GA14017@elte.hu> <200704211417.03598.gene.heskett@gmail.com> <200704221126.50917.kernel@kolivas.org>
In-Reply-To: <200704221126.50917.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704212207.19897.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007, Con Kolivas wrote:
>On Sunday 22 April 2007 04:17, Gene Heskett wrote:
>> More first impressions of sd-0.44 vs CFS-v4
>
>Thanks Gene.
>
>> CFS-v4 is quite smooth in terms of the users experience but after
>> prolonged observations approaching 24 hours, it appears to choke the cpu
>> hog off a bit even when the system has nothing else to do.  My amanda runs
>> went from 1 to 1.5 hours depending on how much time it took gzip to handle
>> the amount of data tar handed it, up to about 165m & change, or nearly 3
>> hours pretty consistently over 5 runs.
>>
>> sd-0.44 so far seems to be handling the same load (theres a backup running
>> right now) fairly well also, and possibly theres a bit more snap to the
>> system now.  A switch to screen 1 from this screen 8, and the loading of
>> that screen image, which is the Cassini shot of saturn from the backside,
>> the one showing that teeny dot to the left of Saturn that is actually us,
>> took 10 seconds with the stock 2.6.21-rc7, 3 seconds with the best of
>> Ingo's patches, and now with Con's latest, is 1 second flat. Another
>> screen however is 4 seconds, so maybe that first scren had been looked at
>> since I rebooted. However, amanda is still getting estimates so gzip
>> hasn't put a tiewrap around the kernels neck just yet.
>>
>> Some minutes later, gzip is smunching /usr/src, and the machine doesn't
>> even know its running as sd-0.44 isn't giving gzip more than 75% to gzip,
>> and probably averaging less than 50%. And it scared me a bit as it started
>> out at not over 5% for the first minute or so.  Running in the 70's now
>> according to gkrellm, with an occasional blip to 95%.  And the machine
>> generally feels good.
>>
>> I had previously given CFS-v4 a 95 score but that was before I saw the
>> general slowdown, and I believe my first impression of this one is also a
>> 95.  This on a scale of the best one of the earlier CFS patches being 100,
>> and stock 2.6.21-rc7 gets a 0.0.  This scheduler seems to be giving gzip
>> ever more cpu as time progresses, and the cpu is warming up quite nicely,
>> from about 132F idling to 149.9F now.  And my keyboard is still alive and
>> well.
>
>I'm not sure how much weight to put on what you see as the measured cpu
> usage. I have a feeling it's being wrongly reported in SD currently.
> Concentrate more on the actual progress and behaviour of things as you've
> already done.
>
>> Generally speaking, Con, I believe this one is also a keeper.  And we'll
>> see how long a backup run takes.

It looks as if it could have been 10 minutes quicker according to amplot, but 
that's entirely within the expected variations that amanda's scheduler might 
do to it.  But the one that just finished, running under CFS-v5 was only 
1h:47m, not including the verify run.  The previous backup using sd-0.44, 
took 2h:28m for a similar but not identical operation according to amplot.  
That's a big enough diff to be an indicator I believe, but without knowing 
how much of that time was burned by gzip, its an apples and oranges compare.  
We'll see if it repeats, I coded 'catchup' to do 2 in a row.

>Great thanks for feedback.

You're quite welcome, Con.

ATM I'm doing the same thing again but booted to a CFS-v5 delta that Ingo sent 
me privately,  and except for the kmail lag/freezes everything is cool except 
the cpu, it managed to hit 150.7F during the height of one of the gzip -best 
smunching operations.  I believe the /dev/hdd writes are cranked well up from 
the earlier CSF patches also.  Unforch, this isn't something that's been 
coded into amplot, so I'm stuck watching the hdd display in gkrellm and 
making SWAG's.  And we all know what they are worth.  I've made a lot of them 
in my 72 years, and my track record, with some glaring exceptions like my 2nd 
wife that I won't bore you with the details of, has been fairly decent. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
You will be run over by a beer truck.
