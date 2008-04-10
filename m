Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYDJMho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYDJMho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYDJMhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:37:22 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:49498 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755384AbYDJMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:37:19 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-29.messagelabs.com!1207831038!10511181!3
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] UIO: wrap all uio drivers in "if UIO" and "endif"
Date: Thu, 10 Apr 2008 14:37:02 +0200
Message-Id: <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
 <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
 <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Apr 2008 12:37:03.0560 (UTC) FILETIME=[9452F480:01C89B07]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15840.007
X-TM-AS-Result: No--5.173000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently there is only one driver, but new entries don't need to depend
explicitly on UIO.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 drivers/uio/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index a899306..6bc2891 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -11,9 +11,11 @@ menuconfig UIO
 
 	  If you don't know what to do here, say N.
 
+if UIO
+
 config UIO_CIF
 	tristate "generic Hilscher CIF Card driver"
-	depends on UIO && PCI
+	depends on PCI
 	default n
 	help
 	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
@@ -23,3 +25,5 @@ config UIO_CIF
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called uio_cif.
+
+endif
-- 
1.5.4.5

