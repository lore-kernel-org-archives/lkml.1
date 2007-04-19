Return-Path: <linux-kernel-owner+w=401wt.eu-S1766891AbXDSRcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766891AbXDSRcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766895AbXDSRcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:32:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:15294 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766891AbXDSRcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fJ8kaoWJHT9AaydCjV2+f0ApwwCxkpVSk0uBhvMyvfu/OpLipPJkVNi2hNXtpSB2HkFBz9lsNGtN7njVHxjopRNIYgT/tVTIyB4tj/uL4nrsbeKM+s80oEWpGPt5GmIRa6UhJ2ctDu3vIVSxCVHBYahmJNbrFiRmYYifOXqs8Gs=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Thu, 19 Apr 2007 13:32:08 -0400
User-Agent: KMail/1.9.6
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu>
In-Reply-To: <20070419090144.GA17100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191332.08701.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007, Ingo Molnar wrote:
>* Willy Tarreau <w@1wt.eu> wrote:
>> Good idea. The machine I'm typing from now has 1000 scheddos running
>> at +19, and 12 gears at nice 0. [...]
>>
>> From time to time, one of the 12 aligned gears will quickly perform a
>> full quarter of round while others slowly turn by a few degrees. In
>> fact, while I don't know this process's CPU usage pattern, there's
>> something useful in it : it allows me to visually see when process
>> accelerate/decelerate. [...]
>
>cool idea - i have just tried this and it rocks - you can easily see the
>'nature' of CPU time distribution just via visual feedback. (Is there
>any easy way to start up 12 glxgears fully aligned, or does one always
>have to mouse around to get them into proper position?)
>
>btw., i am using another method to quickly judge X's behavior: i started
>the 'snowflakes' plugin in Beryl on Fedora 7, which puts a nice smooth
>opengl-rendered snow fall on the desktop background. That gives me an
>idea about how well X is scheduling under various workloads, without
>having to instrument it explicitly.
>
yes, its a  cute idea, till you switch away from that screen to check progress 
on something else, like to compose this message.

===========
5913 frames in 5.0 seconds = 1182.499 FPS
6238 frames in 5.0 seconds = 1247.556 FPS
11380 frames in 5.0 seconds = 2275.905 FPS
10691 frames in 5.0 seconds = 2138.173 FPS
8707 frames in 5.0 seconds = 1741.305 FPS
10669 frames in 5.0 seconds = 2133.708 FPS
11392 frames in 5.0 seconds = 2278.037 FPS
11379 frames in 5.0 seconds = 2275.711 FPS
11310 frames in 5.0 seconds = 2261.861 FPS
11386 frames in 5.0 seconds = 2277.081 FPS
11292 frames in 5.0 seconds = 2258.353 FPS
11352 frames in 5.0 seconds = 2270.297 FPS
11415 frames in 5.0 seconds = 2282.886 FPS
11406 frames in 5.0 seconds = 2281.037 FPS
11483 frames in 5.0 seconds = 2296.533 FPS
11510 frames in 5.0 seconds = 2301.883 FPS
11123 frames in 5.0 seconds = 2224.266 FPS
8980 frames in 5.0 seconds = 1795.861 FPS
=======
The over 2000fps reports were while I was either looking at htop, or starting 
this message, both on different screens.  htop said it was using 95+ % of the 
cpu even when its display was going to /dev/null.  So 'Kewl' doesn't seem to 
get us apples to apples numbers we can go to the window and bet 
win-place-show based on them alone.

FWIW, running the nvidia-9755 drivers here.

So if we are going to use that as a judgement operator, it obviously needs 
some intelligently applied scaling before they are worth more than a 
subjective feel is.

>	Ingo
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The confusion of a staff member is measured by the length of his memos.
		-- New York Times, Jan. 20, 1981
