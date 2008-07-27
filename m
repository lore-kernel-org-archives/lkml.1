Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYG0BIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYG0BIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbYG0BIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:08:45 -0400
Received: from ns.suse.de ([195.135.220.2]:42392 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526AbYG0BIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:08:44 -0400
Date: Sun, 27 Jul 2008 03:08:37 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] Add mISDN driver
Message-ID: <20080727010837.GA3415@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this and the following patches from 
git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master

mISDN is a new modular ISDN driver, in the long term it should replace
the old I4L driver architecture for passiv ISDN cards.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 Documentation/isdn/README.mISDN |    6 ++++++
 drivers/isdn/Kconfig            |    4 +++-
 drivers/isdn/Makefile           |    1 +
 drivers/isdn/hardware/Makefile  |    1 +
 4 files changed, 11 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/isdn/README.mISDN

diff --git a/Documentation/isdn/README.mISDN b/Documentation/isdn/README.mISDN
new file mode 100644
index 0000000..cd8bf92
--- /dev/null
+++ b/Documentation/isdn/README.mISDN
@@ -0,0 +1,6 @@
+mISDN is a new modular ISDN driver, in the long term it should replace
+the old I4L driver architecture for passiv ISDN cards.
+It was designed to allow a broad range of applications and interfaces
+but only have the basic function in kernel, the interface to the user
+space is based on sockets with a own address family AF_ISDN.
+
diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index 66f946a..3d113c6 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig ISDN
-	tristate "ISDN support"
+	bool "ISDN support"
 	depends on NET
 	depends on !S390
 	---help---
@@ -21,6 +21,8 @@ menuconfig ISDN
 
 if ISDN
 
+source "drivers/isdn/mISDN/Kconfig"
+
 menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
 	---help---
diff --git a/drivers/isdn/Makefile b/drivers/isdn/Makefile
index 988142c..8380a45 100644
--- a/drivers/isdn/Makefile
+++ b/drivers/isdn/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_ISDN_I4L)			+= i4l/
 obj-$(CONFIG_ISDN_CAPI)			+= capi/
+obj-$(CONFIG_MISDN)			+= mISDN/
 obj-$(CONFIG_ISDN_CAPI)			+= hardware/
 obj-$(CONFIG_ISDN_DIVERSION)		+= divert/
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax/
diff --git a/drivers/isdn/hardware/Makefile b/drivers/isdn/hardware/Makefile
index 11c8a18..a5d8fce 100644
--- a/drivers/isdn/hardware/Makefile
+++ b/drivers/isdn/hardware/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_CAPI_AVM)		+= avm/
 obj-$(CONFIG_CAPI_EICON)	+= eicon/
+obj-$(CONFIG_MISDN)		+= mISDN/
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
