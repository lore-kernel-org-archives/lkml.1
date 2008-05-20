Return-Path: <linux-kernel-owner+w=401wt.eu-S1763990AbYETJZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763990AbYETJZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761121AbYETJY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:24:59 -0400
Received: from mail28.messagelabs.com ([216.82.249.131]:33154 "EHLO
	mail28.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbYETJY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:24:58 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-28.messagelabs.com!1211275497!15554163!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] UIO: don't let UIO_CIF and UIO_SMX depend twice on UIO
Date: Tue, 20 May 2008 11:24:41 +0200
Message-ID: <1211275482-11249-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520092312.GA10745@digi.com>
References: <20080520092312.GA10745@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 May 2008 09:24:42.0321 (UTC) FILETIME=[55BBA410:01C8BA5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ae210f188614bb3d1ee3f19c64e28e3cdd44877c introduced a big "if UIO"/"endif"
where all uio drivers are defined.  So know there is no need for them to
depend explicitly on UIO.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
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
1.5.5.1

