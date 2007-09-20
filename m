Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXITKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXITKwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXITKwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:52:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46334 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXITKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:52:08 -0400
Date: Thu, 20 Sep 2007 12:50:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       kernel list <linux-kernel@vger.kernel.org>,
       dbrownell@users.sourceforge.net
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20070920105002.GA4611@elf.ucw.cz>
References: <20070920103225.GA4410@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920103225.GA4410@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> ...should they be changed to 200? Or perhaps file should be readable?
> 
> root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> root@amd:/sys/class/rtc/rtc0# echo 132719 > wakealarm 
> root@amd:/sys/class/rtc/rtc0# ls -al wakealarm 
> -rw-r--r-- 1 root root 0 Sep 20 12:30 wakealarm
> root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> root@amd:/sys/class/rtc/rtc0# cat wakealarm 
> root@amd:/sys/class/rtc/rtc0# 
> 
> 
> ...standard PC with reasonably recent kernel...

Hmm, something is definitely wrong in here. I sometimes _do_ get
something back.

root@amd:~# s2ram
Switching from vt9 to vt1


switching back to vt9
root@amd:~# 
root@amd:~# 
root@amd:~# cd /sys/class/rtc/rtc0
root@amd:/sys/class/rtc/rtc0# ls
date  dev  device@  name  power/  since_epoch  subsystem@  time
uevent  wakealarm
root@amd:/sys/class/rtc/rtc0# cat wakealarm 
2051629528
root@amd:/sys/class/rtc/rtc0# cat power/wakeup 

root@amd:/sys/class/rtc/rtc0# cat wakealarm 
2051629528
root@amd:/sys/class/rtc/rtc0# date +%s
1190285030
root@amd:/sys/class/rtc/rtc0# echo 1190285050 > wakealarm 
root@amd:/sys/class/rtc/rtc0# s2ram
Switching from vt9 to vt1


switching back to vt9
root@amd:/sys/class/rtc/rtc0# 
root@amd:/sys/class/rtc/rtc0# 
root@amd:/sys/class/rtc/rtc0# cat wakealarm 
root@amd:/sys/class/rtc/rtc0# cat wakealarm 
root@amd:/sys/class/rtc/rtc0# date +%s
1190285229
root@amd:/sys/class/rtc/rtc0# cat wakealarm 
root@amd:/sys/class/rtc/rtc0# 

Also, is there some documentation for wakealarm?

sh-3.1$ cd Documentation/
sh-3.1$ grep -ri wakealarm .

...is it time in seconds? In UTC? In whatever timezone rtc clocks are
using? It does not seem to work for me :-(.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
