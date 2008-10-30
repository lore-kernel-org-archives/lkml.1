Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYJ3Q57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYJ3Q57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYJ3Q5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:57:51 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:39160 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJ3Q5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:57:50 -0400
Subject: i7300_idle: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andy Henroid <andrew.d.henroid@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 17:57:49 +0100
Message-Id: <1225385869.21973.22.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: i7300_idle: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Andy Henroid <andrew.d.henroid@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index 59d1bbc..98a37bc 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -173,7 +173,7 @@ static int __init i7300_idle_ioat_selftest(u8 *ctl,
 }
 
 static struct device dummy_dma_dev = {
-	.bus_id = "fallback device",
+	.init_name = "fallback device",
 	.coherent_dma_mask = DMA_64BIT_MASK,
 	.dma_mask = &dummy_dma_dev.coherent_dma_mask,
 };


