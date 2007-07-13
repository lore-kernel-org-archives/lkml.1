Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXGMJ0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXGMJ0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935313AbXGMJ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:26:14 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:1919 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933231AbXGMJ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:26:13 -0400
Date: Fri, 13 Jul 2007 11:26:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] w1_ds2760: Fix binary file read callback signature
Message-ID: <20070713112643.6a6daf73@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 91a6902958f052358899f58683d44e36228d85c2 changed the binary
sysfs file signatures at the same time the w1_ds2760 driver was added.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/w1/slaves/w1_ds2760.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.23-pre.orig/drivers/w1/slaves/w1_ds2760.c	2007-07-13 09:46:35.000000000 +0200
+++ linux-2.6.23-pre/drivers/w1/slaves/w1_ds2760.c	2007-07-13 11:11:38.000000000 +0200
@@ -68,8 +68,9 @@ int w1_ds2760_write(struct device *dev, 
 	return w1_ds2760_io(dev, buf, addr, count, 1);
 }
 
-static ssize_t w1_ds2760_read_bin(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t w1_ds2760_read_bin(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	return w1_ds2760_read(dev, buf, off, count);


-- 
Jean Delvare
