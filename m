Return-Path: <linux-kernel-owner+w=401wt.eu-S936313AbYEBUfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936313AbYEBUfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936285AbYEBUeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:34:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46411 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936251AbYEBUeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:34:14 -0400
Date: Fri, 2 May 2008 22:33:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] patches for stop_machine
Message-ID: <20080502203346.GC3956@ucw.cz>
References: <481678F5.7080504@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481678F5.7080504@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hi Rusty and all,
> 
> This is a proposal of minor improvement for kernel/stop_machine.c
> 
> [PATCH 1/3] stop_machine: short exit path for if we cannot create enough threads
> [PATCH 2/3] stop_machine: add timeout for child thread deployment
> [PATCH 3/3] stop_machine: add stopmachine_timeout sysctl entry
> 
> The main topic is "how about adding timeout for stop_machine?"
> I think it will act as a safety net.
> 
> For example (of silly situation), system can hung with following way:
> 
>   # ./silly.sh
>   run an evil loop task on AP
>    pid 6138's current affinity mask: ff
>    pid 6138's new affinity mask: fe
>    to pretend lock up, chrt -f -p 99 6138
>    loop[6138] is on CPU #4
>   to do stopmachine, try to off #7
>   echo 0 > /sys/devices/system/cpu/cpu7/online
>   (never return)
> 
> After applying patch set here, it can be prevented.
> 
>   # ./silly.sh
>    :
>   echo 0 > /sys/devices/system/cpu/cpu7/online
>   stopmachine: Failed to stop machine in time(5s). Are there any CPUs on file?
>   ./silly.sh: line 22: echo: write error: Device or resource busy
>   offline is failed

I'd expect at least WARN_ON here. -EBUSY is not good enough indication
that one of your cpus is now dead.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
