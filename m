Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYLIMzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYLIMzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 07:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYLIMyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 07:54:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57317 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYLIMyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 07:54:51 -0500
Date: Tue, 9 Dec 2008 13:54:18 +0100
From: Pavel Machek <pavel@suse.cz>
To: mtk.manpages@gmail.com
Cc: kernel list <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Document sysfs interface to RTC system wakeup
Message-ID: <20081209125418.GD1547@ucw.cz>
References: <20081126161524.GD1983@elf.ucw.cz> <cfd18e0f0811281349k4dafa1bdk16500af7e513460@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811281349k4dafa1bdk16500af7e513460@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add wakealarm description to rtc.txt, now including comments from
Michael and others.

Signed-off-by: Pavel Machek <pavel@suse.cz>

--- clean-cg/Documentation/rtc.txt	2008-02-07 10:28:47.000000000 +0100
+++ linux/Documentation/rtc.txt	2008-12-09 13:51:06.000000000 +0100
@@ -187,6 +187,64 @@
 
 If all else fails, check out the rtc-test.c driver!
 
+	    Even newer /sys interface
+	    ~~~~~~~~~~~~~~~~~~~~~~~~~
+	    (thanks to tino.keitel@gmx.de)
+
+How to use /sys/class/rtc/rtcX/wakealarm
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+This file can be used to view / set the time of an alarm (wakeup event).  The
+contents of the file are time measured in seconds since the Epoch
+(00:00:00h, 1 Jan 1970, UTC).
+
+     - It reads as either empty, or the scheduled alarm time as seconds
+       since the POSIX Epoch.  (That time may already have passed, since
+       nothing currently enforces one-shot alarm semantics.)
+
+     - It can be written with an alarm time in the future, again seconds
+       since the POSIX Epoch, which enables the alarm.
+
+     - It can be written with an alarm time not in the future (such as 0,
+       the start of the POSIX epoch) to disable the alarm.
+
+If the alarm was already enabled, a new alarm can only be set after the
+old alarm is disabled.
+
+    This resembles the /proc/acpi/alarm file in that nothing happens when the
+    alarm triggers ...  except possibly waking the system from sleep.  It's also
+    like that in a nasty way: not much can be done to prevent one task from
+    clobbering another task's alarm settings.
+
+
+
+Migration from /proc/acpi/alarm
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+Users of /proc/acpi/alarm have to change their code to supply the
+seconds since the Epoch instead of a date string. (The date string in
+/proc is quite and ugly hack, and it will be removed one day, with
+rest of /proc/acpi).  
+
+For shell scripts, this can be done using the date command, e.g. like
+this:
+
+date -d tomorrow "+%s"
+
+This returns the seconds since the Epoch of the current time on the
+following day.
+
+Please note that you have to disable the old alarm first, if you want
+to set a new alarm. Otherwise, you get an error. Example:
+
+# Toggle example wakeup devices. Be sure to do 'cat wakeup' to check
+# the status when you are done.
+cd /proc/acpi
+echo EXP0 > wakeup
+echo PCI1 > wakeup
+echo HDEF > wakeup
+cd /sys/class/rtc/rtc0
+echo 0 > wakealarm
+echo $(( $(cat since_epoch) + 20 )) > wakealarm
+
 
 -------------------- 8< ---------------- 8< -----------------------------
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
