Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYKDQrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYKDQrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYKDQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:46:07 -0500
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:37571 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYKDQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:46:05 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com,
       Pete Wyckoff <pw@padd.com>
Subject: [PATCH 17/18] osd: Kconfig file for in-tree builds
Date: Tue,  4 Nov 2008 18:44:54 +0200
Message-Id: <1225817094-6270-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <491073BB.4000900@panasas.com>
References: <491073BB.4000900@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig file for the drivers/scsi/osd subdirectory.
Adds the following config items:
	config SCSI_OSD_INITIATOR
	config SCSI_OSD_ULD
	config SCSI_OSD_DEBUG

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/Kconfig |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/osd/Kconfig

diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
new file mode 100644
index 0000000..ac3be8a
--- /dev/null
+++ b/drivers/scsi/osd/Kconfig
@@ -0,0 +1,41 @@
+#
+# Kernel configuration file for the OSD scsi protocol
+#
+# Copyright (C) 2008 Panasas Inc.  All rights reserved.
+#
+# Authors:
+#   Boaz Harrosh <bharrosh@panasas.com>
+#   Benny Halevy <bhalevy@panasas.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public version 2 License as
+# published by the Free Software Foundation
+#
+# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
+#        How is it done properly?
+#
+
+config SCSI_OSD_INITIATOR
+	tristate "OSD-Initiator library"
+	depends on SCSI
+	help
+		Enable the OSD-Initiator library (libosd.ko).
+		NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
+		dependencies
+
+config SCSI_OSD_ULD
+	tristate "OSD Upper Level driver"
+	depends on SCSI_OSD_INITIATOR
+	help
+		Build a SCSI upper layer driver that exports /dev/osdX devices
+		to user-mode for testing and controlling OSD devices. It is also
+		needed by osdfs, for mounting an OSD based file system.
+
+config SCSI_OSD_DEBUG
+	bool "Compile All OSD modules with lots of DEBUG prints"
+	default n
+	depends on SCSI_OSD_INITIATOR
+	help
+		OSD Code is populated with lots of OSD_DEBUG(..) printouts to
+		dmesg. Enable this if you found a bug and you want to help us
+		track the problem (see also MAINTAINERS).
-- 
1.6.0.1

