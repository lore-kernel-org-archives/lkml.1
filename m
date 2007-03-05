Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbXCEM36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbXCEM36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXCEM36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:29:58 -0500
Received: from mail06.syd.optusnet.com.au ([211.29.132.187]:37179 "EHLO
	mail06.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbXCEM35 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:29:57 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 5 Mar 2007 23:29:44 +1100
User-Agent: KMail/1.9.5
Cc: Markus =?iso-8859-1?q?T=F6rnqvist?= <mjt@nysv.org>,
       ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <20070305060732.GQ30401@nysv.org> <200703051459.44206.a1426z@gawab.com>
In-Reply-To: <200703051459.44206.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703052329.45217.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 22:59, Al Boldi wrote:
> Markus Törnqvist wrote:
> > On Mon, Mar 05, 2007 at 08:34:45AM +0300, Al Boldi wrote:
> > >Ok, gears is smooth when you run "make -j4", but with "nice make -j4",
> > > gears becomes bursty.  This looks like a problem with nice-levels.  In
> > > general, looking subjectively at top d.1, procs appear to show
> > > jerkiness when nice'd.

I wouldn't place much value on what you can see just from looking at top. 
Gears just isn't an interactive task and just about anything but gears would 
be a better test case since its behaviour varies wildly under different 
combinations of graphics cards, memory bandwidth, cpu and so on. I'm not even 
sure what you're trying to prove with gears. If it's to see "smooth 
behaviour" under load then gears is not the thing to do it with. Maybe 
unbuffered live video on xawtv or something? Perhaps even capturing video 
where you know what the cpu usage will be of the video codec you're using. 
Say you knew xvid at a fixed bitrate required 30% cpu to encode a live video 
then you could see if it did it real time with a make -j2 running assuming 
you don't run out of disk bandwidth and so on. Or something that required 75% 
cpu and you ran a nice -19 make -j4. Or even try interbench and fiddle with 
the nice values and size of the loads since those options exist and see what 
the latencies and %desired cpu are. By default without arguments interbench 
looks for unfair scheduling and finds plenty of it in other scheduler 
designs. Either way your testcase must mean something to you.

> > Don't use glxgears, please. Ever. Unless you want meaningless gears.

That I definitely agree with.

> > It displays totally erratic behaviour anyway, and does sched_yield
> > (strace tells us this) which means IT GIVES UP ITS TIME TO RUN, ie yields
> > the cpu to someone else.
>
> I just strace'd it here.  It doesn't show any yield in the mesa-5.0
> version. Which version are you using?

Curious. On a machine with onboard intel graphics (915 driver), and on an ATI 
r200 dri based driver I can see yields. Yet with the nvidia driver I see no 
yields. This sched_yield seems to be more done by the driver rather than the 
application. That would cause woeful performance. How odd that modern drivers 
out there today are still using this basically defunct unix function. No, I'm 
not interested in getting into a discussion of the "possible" uses of 
sched_yield. That's been done to death many times before.

-- 
-ck
