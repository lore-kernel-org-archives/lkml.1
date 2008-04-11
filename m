Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbYDKIHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbYDKIHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYDKIGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:06:49 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:58548 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1757380AbYDKIGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:06:48 -0400
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH 1/2] RAID: Remove leading TAB on printk messages
To: mingo@elte.hu, trivial@kernel.org, neilb@suse.de
Cc: <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Date: Fri, 11 Apr 2008 18:06:37 +1000
Message-ID: <20080411080637.12362.47954.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAID: Remove leading TAB on printk messages

MD drivers use one printk() call to print 2 log messages and the second
line may be prefixed by a TAB character.  It may also output a trailing
space before newline.  klogd (I think) turns the TAB character into the
2 characters '^I' when logging to a file. This looks ugly.

Instead of a leading TAB to indicate continuation, prefix both output
lines with 'raid:' or similar. Also remove any trailing space in the
vicinity of the affected code and consistently end the sentences with
a period.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/md/multipath.c |    3 ++-
 drivers/md/raid1.c     |    4 ++--
 drivers/md/raid10.c    |    4 ++--
 drivers/md/raid5.c     |    4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)


diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 3f299d8..42ee1a2 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -244,7 +244,8 @@ static void multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
 			conf->working_disks--;
 			mddev->degraded++;
 			printk(KERN_ALERT "multipath: IO failure on %s,"
-				" disabling IO path. \n	Operation continuing"
+				" disabling IO path.\n"
+				"multipath: Operation continuing"
 				" on %d IO paths.\n",
 				bdevname (rdev->bdev,b),
 				conf->working_disks);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ff61b30..9fd473a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1008,8 +1008,8 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	} else
 		set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device. \n"
-		"	Operation continuing on %d devices\n",
+	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device.\n"
+		"raid1: Operation continuing on %d devices.\n",
 		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 32389d2..1e96aa3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1001,8 +1001,8 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "raid10: Disk failure on %s, disabling device. \n"
-		"	Operation continuing on %d devices\n",
+	printk(KERN_ALERT "raid10: Disk failure on %s, disabling device.\n"
+		"raid10: Operation continuing on %d devices.\n",
 		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c574cf5..88c2b60 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1260,8 +1260,8 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 		}
 		set_bit(Faulty, &rdev->flags);
 		printk (KERN_ALERT
-			"raid5: Disk failure on %s, disabling device."
-			" Operation continuing on %d devices\n",
+			"raid5: Disk failure on %s, disabling device.\n"
+			"raid5: Operation continuing on %d devices.\n",
 			bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
 	}
 }

