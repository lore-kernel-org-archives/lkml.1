Return-Path: <linux-kernel-owner+w=401wt.eu-S936496AbZFPGEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936496AbZFPGEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935945AbZFPFvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:42 -0400
Received: from kroah.org ([198.145.64.141]:48465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935852AbZFPFvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Matthias Fuchs <mfuchs@ma-fu.de>
Subject: [PATCH 55/64] of_serial: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:44 -0700
Message-Id: <1245131213-24168-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Matthias Fuchs <mfuchs@ma-fu.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/of_serial.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
index 14f8fa9..54483cd 100644
--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -122,7 +122,7 @@ static int __devinit of_platform_serial_probe(struct of_device *ofdev,
 
 	info->type = port_type;
 	info->line = ret;
-	ofdev->dev.driver_data = info;
+	dev_set_drvdata(&ofdev->dev, info);
 	return 0;
 out:
 	kfree(info);
@@ -135,7 +135,7 @@ out:
  */
 static int of_platform_serial_remove(struct of_device *ofdev)
 {
-	struct of_serial_info *info = ofdev->dev.driver_data;
+	struct of_serial_info *info = dev_get_drvdata(&ofdev->dev);
 	switch (info->type) {
 #ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:
-- 
1.6.3.2

