Return-Path: <linux-kernel-owner+w=401wt.eu-S934587AbXEMQc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbXEMQc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbXEMQcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:32:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbXEMQcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:32:21 -0400
Date: Sun, 13 May 2007 12:32:20 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: undeprecate raw driver.
Message-ID: <20070513163220.GA31902@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Despite repeated attempts over the last two and half years, this driver
seems somewhat persistant.  Remove its deprecated status as it has
existing users who may not be in a position to migrate their apps
to O_DIRECT.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 498ff31..5108619 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -41,14 +41,6 @@ Who:	Pavel Machek <pavel@suse.cz>
 
 ---------------------------
 
-What:	RAW driver (CONFIG_RAW_DRIVER)
-When:	December 2005
-Why:	declared obsolete since kernel 2.6.3
-	O_DIRECT can be used instead
-Who:	Adrian Bunk <bunk@stusta.de>
-
----------------------------
-
 What:	raw1394: requests of type RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN
 When:	June 2007
 Why:	Deprecated in favour of the more efficient and robust rawiso interface.
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index abcafac..1e4d688 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -993,15 +993,14 @@ config GPIO_VR41XX
 	depends on CPU_VR41XX
 
 config RAW_DRIVER
-	tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
+	tristate "RAW driver (/dev/raw/rawN)"
 	depends on BLOCK
 	help
-	  The raw driver permits block devices to be bound to /dev/raw/rawN. 
-	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O. 
+	  The raw driver permits block devices to be bound to /dev/raw/rawN.
+	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
 	  See the raw(8) manpage for more details.
 
-          The raw driver is deprecated and will be removed soon.
-          Applications should simply open the device (eg /dev/hda1)
+          Applications should preferably open the device (eg /dev/hda1)
           with the O_DIRECT flag.
 
 config MAX_RAW_DEVS

-- 
http://www.codemonkey.org.uk
