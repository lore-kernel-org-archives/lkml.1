Return-Path: <linux-kernel-owner+w=401wt.eu-S937335AbZFPGHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937335AbZFPGHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935994AbZFPFwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:52:04 -0400
Received: from kroah.org ([198.145.64.141]:48460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935845AbZFPFvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       openipmi-developer@lists.sourceforge.net
Subject: [PATCH 53/64] ipmi: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:42 -0700
Message-Id: <1245131213-24168-53-git-send-email-gregkh@suse.de>
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

Cc: openipmi-developer@lists.sourceforge.net
Acked-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/ipmi/ipmi_si_intf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 2596446..d2e6980 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2375,14 +2375,14 @@ static int __devinit ipmi_of_probe(struct of_device *dev,
 		info->io.addr_data, info->io.regsize, info->io.regspacing,
 		info->irq);
 
-	dev->dev.driver_data = (void *) info;
+	dev_set_drvdata(&dev->dev, info);
 
 	return try_smi_init(info);
 }
 
 static int __devexit ipmi_of_remove(struct of_device *dev)
 {
-	cleanup_one_si(dev->dev.driver_data);
+	cleanup_one_si(dev_get_drvdata(&dev->dev));
 	return 0;
 }
 
-- 
1.6.3.2

