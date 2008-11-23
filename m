Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYKWT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYKWT5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYKWT5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:57:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:24943 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYKWT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:57:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=piRt541Px57NFzUyxdpYaaxgu4RG5XFPQF/gIrPxKWUflr/qCZVLxIUyvZFIc2RntL
         RKF5onxqMyw/nE8YnnUQ8eOwT7Bod8kmu6B8A0bbTH9Hx/yNxVIwIzTQPM0pXZhKYue8
         oaYZFaTvoYmYZzWgETzKmmBbD49+8EC8/aB/o=
Subject: Re: processors core stuck in full throttle after waking up from
 s2ram
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081123172426.GA7447@ucw.cz>
References: <1227168699.4276.24.camel@LiNuX>
	 <200811222151.49273.rjw@sisk.pl> <1227389306.3171.14.camel@LiNuX>
	 <20081123172426.GA7447@ucw.cz>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 11:57:15 -0800
Message-Id: <1227470235.3202.29.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-23 at 18:24 +0100, Pavel Machek wrote:
> Hi!
> 
> 
> > > > the processor is full throttle on one of the cores.
> > > 
> > > Surely not.  The first core shows 2.16 GHz.
> > > 
> > > Anyway, it certainly is not related to the s2ram program in any way.
> > 
> > 
> > Normally I would see cpu MHz: 1000 under both entries,
> > this time upon wakeup theres 1000 and 2167.00. the 2167.00 doesn't move
> > down to 1000 i.g. example of system normally:
> >  cat /proc/cpuinfo <below>
> 
> 
> > will move between 2167.00 to 1000 simultaneously under load with both
> > cores, but then back down to 1000, for both when settled down.
> > in this situation as I reported, the 2167.00 just
> > stays at that number for one of the cores(if thats what I'm seeing) when
> > waking up from suspend for some reason or another. 
> 
> Can you check with top that no process is running/eating time?
> 
> If you change cpufreq governor to powersave, will it react?
> 
> Can you check with powertop if the cpu is idle (C2/C3)or if it is
> running something?
> 
> Actually, booting with nosmp might be useful. Is it always same core?

>From what I'm seeing now, the issue seems to be resolved.
(between commits:2.6.28-rc5-00118-geef8eed
and 2.6.28-rc6-00011-g3791555 seems to have fixed this,
although I don't know what commit was the successful commit); 

As for processes happening upon wakeup,
I can try and see with top.
(I'm certain though that the video card switches to full
throttle upon wakeup, i.g. when starting the system I use
"./radeontool power low" to lower the video cards power, so she's not too
hot; after waking up "./radeontool power status", reveals that those settings
go back to it's default, full throttle with the card). When this issue
was occurring this aspect made no difference.

As for switching between cpufreq_ondemand and cpufreq_powersave:
I did, when this issue was happening, 
I did a watch cat /proc/cpuinfo(saw the one core stuck)
then in another terminal issue the command:
powersave -e Powersave, then powersave -l
which puts the box into cpufreq_powersave mode.
when looking at the other terminal watching cpuinfo
I had noticed that the core that was stuck, moved down in frequency,
then a few seconds later move back up to it's full frequency,
and stayed there. 

As for finding a solution, 
My goal yesterday was to downgrade the xserver to use an older video
module, to see if this was graphics module, or something else("isolate the issue"); 
So now after being unable to reproduce this,
(before git-pulling yesterday it was vary reproducible) 
And feeling like a dunce, I'm going to just run s2ram
numerous times, to see if this occurs and report any interesting
anomalies.
  
regards;

-- 
Justin P. Mattock <justinmattock@gmail.com>

