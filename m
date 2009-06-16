Return-Path: <linux-kernel-owner+w=401wt.eu-S937445AbZFPGI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937445AbZFPGI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935906AbZFPFwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:52:21 -0400
Received: from kroah.org ([198.145.64.141]:48389 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbZFPFvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/64] Driver Core: raw: add nodename for raw devices
Date: Mon, 15 Jun 2009 22:46:22 -0700
Message-Id: <1245131213-24168-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the raw driver to report the proper device name to
userspace for the raw devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/raw.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index db32f0e..05f9d18 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -261,6 +261,11 @@ static const struct file_operations raw_ctl_fops = {
 
 static struct cdev raw_cdev;
 
+static char *raw_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "raw/%s", dev_name(dev));
+}
+
 static int __init raw_init(void)
 {
 	dev_t dev = MKDEV(RAW_MAJOR, 0);
@@ -284,6 +289,7 @@ static int __init raw_init(void)
 		ret = PTR_ERR(raw_class);
 		goto error_region;
 	}
+	raw_class->nodename = raw_nodename;
 	device_create(raw_class, NULL, MKDEV(RAW_MAJOR, 0), NULL, "rawctl");
 
 	return 0;
-- 
1.6.3.2

