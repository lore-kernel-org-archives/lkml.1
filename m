Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0BHUOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:14:17 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:37336 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab0BHUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:13:17 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 40/41] CAPI: Schedule capifs for removal
Date: Mon,  8 Feb 2010 21:12:44 +0100
Message-Id: <1e58c360417093e6ee2f45b7d97865f3d3812dd3.1265659937.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1/xR2WkWkD6d0DyNpsKjK/oNtLF0AgdZ1D9TCIF
	dR6hkQ8gDGNurAJm0GqKD1aJC9hBQvEZXnC+GxBpjskdQ0HNjX
	hNso/bbvs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dynamic TTY nodes and the help of udev, we no longer need this
special filesystem. Schedule it for removal in one year from now.

As a last duty to this feature, move its help to right option so that
users can read the rationale.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 drivers/isdn/capi/Kconfig                  |   13 +++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 2f93ac0..721a2aa 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -521,3 +521,13 @@ Why:	Duplicate functionality with the gspca_zc3xx driver, zc0301 only
 	sensors) wich are also supported by the gspca_zc3xx driver
 	(which supports 53 USB-ID's in total)
 Who:	Hans de Goede <hdegoede@redhat.com>
+
+----------------------------
+
+What:	capifs
+When:	February 2011
+Files:	drivers/isdn/capi/capifs.*
+Why:	udev fully replaces this special file system that only contains CAPI
+	NCCI TTY device nodes. User space (pppdcapiplugin) works without
+	noticing the difference.
+Who:	Jan Kiszka <jan.kiszka@web.de>
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index b2a0475..d607d46 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -35,18 +35,19 @@ config ISDN_CAPI_CAPI20
 	  Y/M here.
 
 config ISDN_CAPI_CAPIFS_BOOL
-	bool "CAPI2.0 filesystem support"
+	bool "CAPI2.0 filesystem support (DEPRECATED)"
 	depends on ISDN_CAPI_MIDDLEWARE && ISDN_CAPI_CAPI20
+	help
+	  This option provides a special file system, similar to /dev/pts with
+	  device nodes for the special ttys established by using the
+	  middleware extension above.
+	  You no longer need this, udev fully replaces it. This feature is
+	  scheduled for removal.
 
 config ISDN_CAPI_CAPIFS
 	tristate
 	depends on ISDN_CAPI_CAPIFS_BOOL
 	default ISDN_CAPI_CAPI20
-	help
-	  This option provides a special file system, similar to /dev/pts with
-	  device nodes for the special ttys established by using the
-	  middleware extension above. If you want to use pppd with
-	  pppdcapiplugin to dial up to your ISP, say Y here.
 
 config ISDN_CAPI_CAPIDRV
 	tristate "CAPI2.0 capidrv interface support"
-- 
1.6.0.2

