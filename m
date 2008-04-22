Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbYDVJxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbYDVJxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYDVJxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:53:04 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:41957 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755549AbYDVJxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:53:02 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-15.tower-29.messagelabs.com!1208857981!11691863!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] UIO: don't let UIO_CIF and UIO_SMX depend twice on UIO
Date: Tue, 22 Apr 2008 11:52:55 +0200
Message-ID: <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <20080422094708.GB27126@digi.com>
References: <20080422094708.GB27126@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Apr 2008 09:52:57.0996 (UTC) FILETIME=[A4DE1CC0:01C8A45E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15864.006
X-TM-AS-Result: No--8.457000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ae210f188614bb3d1ee3f19c64e28e3cdd44877c introduced a big "if UIO"/"endif"
where all uio drivers are defined.  So know there is no need for them to
depend explicitly on UIO.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Hello,

these hunks were part of a patch in my first series but that patch was dropped
because another patch in Greg's queue did a subset of mine.

Best regards
Uwe

 drivers/uio/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index a4aaab9..78e139c 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -15,7 +15,7 @@ if UIO
 
 config UIO_CIF
 	tristate "generic Hilscher CIF Card driver"
-	depends on UIO && PCI
+	depends on PCI
 	default n
 	help
 	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
@@ -28,7 +28,6 @@ config UIO_CIF
 
 config UIO_SMX
 	tristate "SMX cryptengine UIO interface"
-	depends on UIO
 	default n
 	help
 	  Userspace IO interface to the Cryptography engine found on the
-- 
1.5.5

