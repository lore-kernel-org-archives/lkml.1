Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbXFWHrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbXFWHrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXFWHrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:47:06 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:59582 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbXFWHrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:47:03 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 09:46:43 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <B6065113-E9C7-42CE-A43D-55E6BF1EE2C0@mac.com>
In-Reply-To: <B6065113-E9C7-42CE-A43D-55E6BF1EE2C0@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706230946.44023.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Kyle Moffett wrote:
> On Jun 22, 2007, at 18:07:15, Alberto Gonzalez wrote:
> > Ok, so what will a fair scheduler do in this case? It is my
> > understanding that it would give 50% CPU to each task, resulting in
> > the video dropping frames. Is this correct?
>
> Yes, that's correct.
>
> What this *actually* means is that you want the media player to have
> higher priority than the DVD ripping program.  Ergo you should run
> "nice +20 my_dvd_burner" or "nice +20 my_vorbis_encoder" under CFS or
> other fair schedulers.

Ok, that makes sense. The problem is that desktop users don't know about such 
things, so the ideal situation would be that the scheduler knows about it and 
does it for you.

> Well, typically your video player *doesn't* chew up all of the CPU,
> so the fairness helps.  Here's another scenario for you:  You are
> running un-niced HD video player and recoding processes side-by-side,
> so that the HD video player only gets 50% of the CPU.  Under older
> schedulers the video player would not get uniformly allocated CPU, it
> would get it in fits and spurts, causing more _visibly_dropped_
> frames (IE: render 30 frames, drop 8, render 15, drop 2, etc).  Under
> the new CFS scheduler it will get evenly allocated CPU and so while
> you *will* get dropped frames, they will be less visible (IE: Render
> 7 frames, drop 1, render 7 frames, drop 1, render 7 frames, drop 1).

Yes, I see your point. In a scenario of dropping frames it seems that CFS does 
a better job. It's just that an ideal scheduler shouldn't drop frames in this 
case (it should give 70% to the video even without nicing the encoder).

> > If I ask this question is because today I tested it and found that
> > using the -ck kernel (with SD scheduler) the video would drop
> > frames, while with the mainline kernel it played fine.
>
> Basically you are telling the kernel that your video player is no
> more important than your re-encoder process which, judging by your
> email, is completely untrue.  If you really want it to treat the
> video player as specially important (or alternatively treat the
> reencoder process and specially unimportant) then you must tell it so
> with "nice" or "renice".

That's my whole point. On a desktop, some tasks have by nature a higher 
priority than others. A fair scheduler treats them all the same (hence, fair) 
way. So a user must nice/renice processes for them to get the correct CPU 
time (something you can't expect normal desktop users to do).

> > My conclusion is that SD behaves as expected: it's more fair. But
> > for a desktop, shouldn't an "intelligently unfair" scheduler be
> > better?
>
> Well, it is "intelligently unfair", but you the user have to tell it
> what is more important for *YOU*.  If I _really_ have to get some
> music recoded quickly then I may be willing to deal with some dropped
> frames in order to let that happen appropriately.

Well, my point is that encoding music or video can use 100% CPU if available, 
but if you give it just 10% the job will also be completed successfully 
(though slower). OTOH, playing audio or video won't use 100% CPU (in most 
cases), but whatever CPU they need, they _really_ need it. It makes no sense 
to watch a video or listen to music with constant skips. So in 99.9% of the 
cases a user would want to watch a video smoothly, not dropping frames so 
that the encoding finishes faster (if he wants the encoding to be as fast as 
possible he shouldn't watch a video at the same time, I guess).

> Cheers,
> Kyle Moffett

Thanks for your answers,
Alberto.

