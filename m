Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753154AbYLQPPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYLQPPx (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYLQPPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:15:42 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:46271 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYLQPPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wCsomzjhofiEeUUXlCetaX/G6JTBuQof9Ny31SHNJg6np97tuUMdTA7xCVMo0dHC6w
         nu9M9QNO+QC+g7ZzounKMpoEWaT3MF6FiubY9APAHaTPtNm4fMLiW1VI1uhH5Fo4t2pn
         mSkwDzY7daaUpsWRN+0gtdDkvnpik4IE7fEIc=
From: tom.leiming@gmail.com
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core:fix duplicate removing driver link in __device_release_driver
Date: Wed, 17 Dec 2008 23:15:35 +0800
Message-Id: <1229526935-7505-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

In __device_release_driver(),driver_sysfs_remove() has removed the
driver link under device dir in sysfs, but sysfs_remove_link() is
called again to do such thing. Remove the duplicate call to
sys_remove_link().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/dd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 20febc0..2a0b8cc 100644
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
1.6.0

