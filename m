Return-Path: <linux-kernel-owner+w=401wt.eu-S936764AbZFPF7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936764AbZFPF7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935850AbZFPFvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:24 -0400
Received: from kroah.org ([198.145.64.141]:48394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935753AbZFPFvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/64] Driver Core: aoe: add nodename for aoe devices
Date: Mon, 15 Jun 2009 22:46:24 -0700
Message-Id: <1245131213-24168-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the AOE core to report the proper device name to
userspace for the AOE devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/aoe/aoechr.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 200efc4..1988835 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -266,6 +266,11 @@ static const struct file_operations aoe_fops = {
 	.owner = THIS_MODULE,
 };
 
+static char *aoe_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "etherd/%s", dev_name(dev));
+}
+
 int __init
 aoechr_init(void)
 {
@@ -283,6 +288,8 @@ aoechr_init(void)
 		unregister_chrdev(AOE_MAJOR, "aoechr");
 		return PTR_ERR(aoe_class);
 	}
+	aoe_class->nodename = aoe_nodename;
+
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
 		device_create(aoe_class, NULL,
 			      MKDEV(AOE_MAJOR, chardevs[i].minor), NULL,
-- 
1.6.3.2

