Return-Path: <linux-kernel-owner+w=401wt.eu-S936891AbZFPGAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936891AbZFPGAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935896AbZFPFv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:28 -0400
Received: from kroah.org ([198.145.64.141]:48397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935840AbZFPFvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/64] Driver Core: bsg: add nodename for bsg driver
Date: Mon, 15 Jun 2009 22:46:25 -0700
Message-Id: <1245131213-24168-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the BSG driver to report the proper device name to
userspace for the bsg devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/bsg.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 5358f9a..54106f0 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1065,6 +1065,11 @@ EXPORT_SYMBOL_GPL(bsg_register_queue);
 
 static struct cdev bsg_cdev;
 
+static char *bsg_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "bsg/%s", dev_name(dev));
+}
+
 static int __init bsg_init(void)
 {
 	int ret, i;
@@ -1085,6 +1090,7 @@ static int __init bsg_init(void)
 		ret = PTR_ERR(bsg_class);
 		goto destroy_kmemcache;
 	}
+	bsg_class->nodename = bsg_nodename;
 
 	ret = alloc_chrdev_region(&devid, 0, BSG_MAX_DEVS, "bsg");
 	if (ret)
-- 
1.6.3.2

