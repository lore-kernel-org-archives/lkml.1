Return-Path: <linux-kernel-owner+w=401wt.eu-S935366AbYCDX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366AbYCDX11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934346AbYCDXTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:19:19 -0500
Received: from ns.suse.de ([195.135.220.2]:49225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934820AbYCDXTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:19:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/8] driver core: Remove dpm_sysfs_remove() from error path of device_add()
Date: Tue,  4 Mar 2008 15:18:50 -0800
Message-Id: <1204672732-3127-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080304231519.GC3073@suse.de>
References: <20080304231519.GC3073@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since device_pm_remove(dev) calls dpm_sysfs_remove(dev), it's
incorrect to call the latter after the former in the device_add()
error path.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 1e2e0fa..7f59c2f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -839,7 +839,6 @@ int device_add(struct device *dev)
 	return error;
  BusError:
 	device_pm_remove(dev);
-	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-- 
1.5.4.3

