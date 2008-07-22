Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYGVF1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYGVF1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbYGVFWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:36 -0400
Received: from mx1.suse.de ([195.135.220.2]:53763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbYGVFWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH 16/79] device create: infiniband: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:40 -0700
Message-Id: <1216703983-21448-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 35f301c..56c0eda 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -2455,7 +2455,7 @@ static int init_cdev(int minor, char *name, const struct file_operations *fops,
 		goto err_cdev;
 	}
 
-	device = device_create(ipath_class, NULL, dev, name);
+	device = device_create_drvdata(ipath_class, NULL, dev, NULL, name);
 
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
-- 
1.5.6.3

