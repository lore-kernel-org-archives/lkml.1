Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXCTL6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXCTL6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbXCTL6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:58:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60649 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753690AbXCTL6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:58:53 -0400
Date: Tue, 20 Mar 2007 12:56:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <len.brown@intel.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: s2ram autowake regression is still there in 2.6.21-rc4-git
Message-ID: <20070320115657.GA4438@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Run this script. The s2ram at the end of it will wakeup immediately
after going to sleep, bad. I tried reproducing it with smaller
version, but was not too successful.
								Pavel

#!/bin/bash
killall klogd

echo -n "testing refrigerator (testproc)..."
echo testproc > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing drivers (test)..."
echo test > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing swsusp (reboot)..."
echo reboot > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing s2ram..."
s2ram
echo "okay"

sleep 2
echo -n "testing swsusp (shutdown)..."
echo shutdown > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing swsusp (platform)..."
echo platform > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing s2ram..."
s2ram
echo "okay"



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
