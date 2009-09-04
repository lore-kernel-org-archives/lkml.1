Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbZIDQUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbZIDQUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbZIDQUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:20:02 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40748 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759AbZIDQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:20:00 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] rtc: Document the sysfs interface
Date: Fri,  4 Sep 2009 12:26:07 -0400
Message-Id: <1252081568-6000-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.4.1
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 146.115.120.20
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs interface to the RTC class drivers is currently undocumented.
Add some basic documentation defining the semantics of the fields.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/rtc.txt |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 8deffcd..216bb8c 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -135,6 +135,28 @@ a high functionality RTC is integrated into the SOC.  That system might read
 the system clock from the discrete RTC, but use the integrated one for all
 other tasks, because of its greater functionality.
 
+SYSFS INTERFACE
+---------------
+
+The sysfs interface under /sys/class/rtc/rtcN provides access to various
+rtc attributes without requiring the use of ioctls. All dates and times
+are in the RTC's timezone, rather than in system time.
+
+date:  	   	 RTC-provided date
+max_user_freq:	 The maximum interrupt rate an unprivileged user may request
+		 from this RTC.
+name:		 The name of the RTC corresponding to this sysfs directory
+since_epoch:	 The number of seconds since the epoch according to the RTC
+time:		 RTC-provided time
+wakealarm:	 The time at which the clock will generate a system wakeup
+		 event. This is a one shot wakeup event, so must be reset
+		 after wake if a daily wakeup is required. Format is either
+		 seconds since the epoch or, if there's a leading +, seconds
+		 in the future.
+
+IOCTL INTERFACE
+---------------
+
 The ioctl() calls supported by /dev/rtc are also supported by the RTC class
 framework.  However, because the chips and systems are not standardized,
 some PC/AT functionality might not be provided.  And in the same way, some
-- 
1.6.4.1

