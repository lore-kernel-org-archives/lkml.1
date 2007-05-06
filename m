Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXEFLLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXEFLLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933612AbXEFLLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:11:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609AbXEFLLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:11:15 -0400
From: Christian <christiand59@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: CFS v9 vs SD 0.48
Date: Sun, 6 May 2007 13:10:24 +0200
User-Agent: KMail/1.9.6
References: <20070506061053.GA16399@comcast.net>
In-Reply-To: <20070506061053.GA16399@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705061310.24183.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX18LWIrY0V+xHc1wCh8XmzK/fZZco4Fg3DeHKI0
 qbZGzFylxmkept+OVmGjvbf7bxuF01sJoQrYx3Rvji3gekHR5Y
 L6iwtam1d+9Zy5JWQ4PTA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 May 2007 08:10:53 Ron wrote:
> Here's my experiences with CFS v9 and -ck1. Base for the two kernels is
> 2.6.21-git4-nohz (x86_64 nohz patches I snagged off LKML a month or so
> back). The extra features in CK shouldn't matter, most of the tests are
> running on an otherwise unloaded system, with the apps already warmed up.
>
> Let's start with some game benchmarks.
>
> Doom 3 is run at 640*480@60Hz with custom settings roughly near high
> quality. QuakeForge is run at 1680x1050@60Hz with max quality settings and
> a customized replacement texture set based on the QRP set.
> ( http://facelift.quakedev.com/retexture )
>                 doom 3 demo1            QF overkill
> -cfs9  X -10    66.9 fps                181.7 fps +-0.040 fps
> -cfs9  X  0     67.6 fps                181.5 fps +-0.025 fps
> -ck1   X -10    67.1 fps                182.1 fps +-0.063 fps
> -ck1   X  0     67.9 fps                182.5 fps +-0.094 fps
> Average is calculated from 5 runs, throw out low & high, average remaining
> 3. Exception: Doom 3 was EXTREMELY variable under CFS v9 at X -10, and had
> nasty lower average framerates as low as 64 fps on a few runs. So Doom 3
> for X at -10 was calculated by throwing out the high & low of 9 runs, and
> averaging remaining 7. It's nicely consistent under SD regardless of X
> renicing. Unfortunately I forgot to record the deviation for Doom 3, but it
> was around 0.08fps, except for CFS v9 with X reniced runs. Note the
> variance is without outliers, with outliers it looks much worse for cfs.
>
> Both are quite resistant to music stalls or sputtering, with a music player
> going during the compile.
>
> It seems to me that renicing is dangerous under CFS. It can easily cause
> horrendous latencies. With the compile mentioned above going in one
> gnome-terminal, and waving the pointer around (sloppy focus/follows
> pointer) and typing, I can easily wind up with text not appearing for 4-5
> seconds, or even losing characters, under CFS with X at -10. Everything
> else is running at default priority. Unreniced, CFS is better than
> mainline, but still has small lags in mouse movement during the compile &
> wave test.
>
> Under SD, which has less of a delay to window borders being redrawn, it
> gets even better with X at -10. Other than that there's no overt penalty
> for varying nice. Latency gains for renicing X aren't as large as with
> older SD.
>
> The harshest test for CFS is games running in wine. Diablo II: Lord of
> Destruction in winehq 0.9.36 doesn't stall audio like older versions of CFS
> did... Instead it stalls rendering during heavy combat. As unpleasant as
> static and dropouts are to listen to, character death due to badly behaved
> scheduler is worse.
>
> Guild Wars under Cedega (unplayable in winehq on my machine, or I'd use
> that) CFS gets horrible stalls during heavy action, and also unpredictably
> during normal play. Also prone to audio breakup.
>
> SD runs D2 & GW perfectly smoothly, and without any audio glitches at all.
> I've had zero audio glitches in 2.6.21-ck1 even when deliberately trying to
> provoke them. I haven't resorted to negatively niced parallel make, yet.
>
> My system is a socket 754 Athlon 64 3000+, 1GB PC3200, NForce3 250
> motherboard, GF6800GT using Nvidia's 100.14.03 beta drivers. I'm using
> libata with CFQ disk scheduler for my ATA133 & ATA100 hard drives. Ubuntu
> x86_64 Gutsy Gibbon with a 32bit chroot for old games and all the web cruft
> that doesn't have 64bit support yet. USB trackball is polled at 200Hz.
>
> On a 10 scale, I'd rank SD a 9, windows around 6, CFS 5, and the stock
> scheduler 3 (up from a 1 last year), for interactivity and load handling.
> I've used linux by preference for years, but UI latency has not been one of
> it's strong points. Nor resistance to audio underruns on my systems. Until
> now. Bottom line, SD won on everything I tested. Which were all picked from
> things stock used to trip over. CFS doesn't entirely fix them, it shifts
> where and how badly.
>
> Thanks!
> Ragnvald "Despair" Maartmann-Moe IV
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This mail pretty exactly says what I would say too! Even though I don't have a 
single core but an AMD X2 3400, Nforce 4 and NVIDIA Graphics card.

> On a 10 scale, I'd rank SD a 9, windows around 6, CFS 5, and the stock
> scheduler 3 (up from a 1 last year), for interactivity and load handling.

I would give SD a 9.5 on my system. With SD linux owns gaming ;-) I have never 
seen such smooth 3D animations before in my life!

CFS is good too. But on my system I can't really feel a large difference 
between CFS and mainline. I never had any real problems with mainline, except 
compiling a kernel (without nice) while playing enemy-territory. Currently I 
would clearly vote for SD, it works good as desktop and absolutely amazing 
as "gaming-load" scheduler.

p.s:
It would be nice if one could switch the schedulers in the kernel config, or 
even at runtime. Then you could simply switch schedulers while you stress the 
system and see the difference instantly without a reboot.

-Christian
