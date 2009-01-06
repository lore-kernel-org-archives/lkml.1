Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZAFWUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZAFWUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZAFWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:37 -0500
Received: from kroah.org ([198.145.64.141]:51222 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752569AbZAFWNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:36 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/60] driver core:fix duplicate removing driver link in __device_release_driver
Date: Tue,  6 Jan 2009 14:11:38 -0800
Message-Id: <1231279939-32728-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

In __device_release_driver(),driver_sysfs_remove() has removed the
driver link under device dir in sysfs, but sysfs_remove_link() is
called again to do such thing. Remove the duplicate call to
sys_remove_link().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index bb5f1eb..6fdaf76 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -298,7 +298,6 @@ static void __device_release_driver(struct device *dev)
 	drv = dev->driver;
 	if (drv) {
 		driver_sysfs_remove(dev);
-		sysfs_remove_link(&dev->kobj, "driver");
 
 		if (dev->bus)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-- 
1.6.0.4

