Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbXDIRKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbXDIRKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXDIRKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:10:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44617 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXDIRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:10:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 9 Apr 2007 19:10:13 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394: change deprecation status of dv1394
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.c0b0fd71777944c3@s5r6.in-berlin.de>
Message-ID: <tkrat.7ff85515f8b78cff@s5r6.in-berlin.de>
References: <tkrat.792fbaf365daed11@s5r6.in-berlin.de>
 <tkrat.b2b116c1f23637be@s5r6.in-berlin.de>
 <tkrat.c0b0fd71777944c3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the appended clarification (?) about the dv1394 driver and
ABI.  It has been discussed on linux1394-devel and linux1394-user.
Or apply from this mail.  Thanks.

 Documentation/ABI/obsolete/dv1394          |    9 +++++++++
 Documentation/feature-removal-schedule.txt |   11 -----------
 drivers/ieee1394/Kconfig                   |    6 +++---
 drivers/ieee1394/dv1394.c                  |    4 ++--
 4 files changed, 14 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/dv1394



commit 199c1167f5e8123a9b0a9ab1e8b78a6aa4b2733f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Mar 22 00:40:06 2007 +0100

ieee1394: change deprecation status of dv1394

Nobody ported ffmpeg from dv1394 to rawiso yet, and there is no
justification to remove dv1394 right now.

Nevertheless, a strong deprecation of this ABI makes a lot of sense,
especially as Kristian H's drivers shape up to be an attractive
alternative to the existing ones.  But we don't have a schedule at the
moment.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
diff --git a/Documentation/ABI/obsolete/dv1394 b/Documentation/ABI/obsolete/dv1394
new file mode 100644
index 0000000..2ee3686
--- /dev/null
+++ b/Documentation/ABI/obsolete/dv1394
@@ -0,0 +1,9 @@
+What:		dv1394 (a.k.a. "OHCI-DV I/O support" for FireWire)
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+	New application development should use raw1394 + userspace libraries
+	instead, notably libiec61883 which is functionally equivalent.
+
+Users:
+	ffmpeg/libavformat (used by a variety of media players)
+	dvgrab v1.x (replaced by dvgrab2 on top of raw1394 and resp. libraries)
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0bc8b0b..19b4c96 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -39,17 +39,6 @@ Who:	Dan Dennedy <dan@dennedy.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
 
 ---------------------------
 
-What:	dv1394 driver (CONFIG_IEEE1394_DV1394)
-When:	June 2007
-Why:	Replaced by raw1394 + userspace libraries, notably libiec61883.  This
-	shift of application support has been indicated on www.linux1394.org
-	and developers' mailinglists for quite some time.  Major applications
-	have been converted, with the exception of ffmpeg and hence xine.
-	Piped output of dvgrab2 is a partial equivalent to dv1394.
-Who:	Dan Dennedy <dan@dennedy.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
-
----------------------------
-
 What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
 When:	December 2006
 Why:	V4L1 AP1 was replaced by V4L2 API. during migration from 2.4 to 2.6
diff --git a/drivers/ieee1394/Kconfig b/drivers/ieee1394/Kconfig
index b8a4734..cd84a55 100644
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -138,9 +138,9 @@ config IEEE1394_DV1394
 	tristate "OHCI-DV I/O support (deprecated)"
 	depends on IEEE1394 && IEEE1394_OHCI1394
 	help
-	  The dv1394 driver will be removed from Linux in a future release.
-	  Its functionality is now provided by raw1394 together with libraries
-	  such as libiec61883.
+	  The dv1394 driver is unsupported and may be removed from Linux in a
+	  future release.  Its functionality is now provided by raw1394 together
+	  with libraries such as libiec61883.
 
 config IEEE1394_RAWIO
 	tristate "Raw IEEE1394 I/O support"
diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index dee9529..026e38f 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -2564,8 +2564,8 @@ static int __init dv1394_init_module(void)
 	int ret;
 
 	printk(KERN_WARNING
-	       "WARNING: The dv1394 driver is unsupported and will be removed "
-	       "from Linux soon. Use raw1394 instead.\n");
+	       "NOTE: The dv1394 driver is unsupported and may be removed in a "
+	       "future Linux release. Use raw1394 instead.\n");
 
 	cdev_init(&dv1394_cdev, &dv1394_fops);
 	dv1394_cdev.owner = THIS_MODULE;


-- 
Stefan Richter
-=====-=-=== -=-- -=--=
http://arcgraph.de/sr/

