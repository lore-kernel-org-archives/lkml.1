Return-Path: <linux-kernel-owner+w=401wt.eu-S966178AbZLHU5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966178AbZLHU5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966143AbZLHU5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:57:34 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43982 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966124AbZLHU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:57:28 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] vbus: pci-bridge: fix sparse warnings
Date: Tue,  8 Dec 2009 12:57:31 -0800
Message-Id: <1260305854-31472-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.6.0.rc1.71.gfba5.dirty
In-Reply-To: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
References: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 08 Dec 2009 12:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sparse tool caught many missing static declarations. Add them.

There are still many address space errors, but I'm unsure about the best
way to fix these.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/vbus/pci-bridge.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index aa683ae..078b8f4 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -66,7 +66,7 @@ struct vbus_pci_device {
 	struct work_struct       drop;
 };
 
-DEFINE_PER_CPU(struct vbus_pci_fastcall_desc, vbus_pci_percpu_fastcall)
+static DEFINE_PER_CPU(struct vbus_pci_fastcall_desc, vbus_pci_percpu_fastcall)
 ____cacheline_aligned;
 
 /*
@@ -123,7 +123,7 @@ vbus_pci_buscall(unsigned long nr, void *data, unsigned long len)
 	return ret;
 }
 
-struct vbus_pci_device *
+static struct vbus_pci_device *
 to_dev(struct vbus_device_proxy *vdev)
 {
 	return container_of(vdev, struct vbus_pci_device, vdev);
@@ -412,7 +412,7 @@ vbus_pci_device_release(struct vbus_device_proxy *vdev)
 	kfree(_dev);
 }
 
-struct vbus_device_proxy_ops vbus_pci_device_ops = {
+static struct vbus_device_proxy_ops vbus_pci_device_ops = {
 	.open    = vbus_pci_device_open,
 	.close   = vbus_pci_device_close,
 	.shm     = vbus_pci_device_shm,
@@ -667,7 +667,7 @@ static struct ioq_notifier eventq_notifier = {
 };
 
 /* Injected whenever the host issues an ioq_signal() on the eventq */
-irqreturn_t
+static irqreturn_t
 eventq_intr(int irq, void *dev)
 {
 	vbus_pci.stats.qnotify++;
@@ -995,7 +995,7 @@ static struct pci_driver vbus_pci_driver = {
 	.remove   = vbus_pci_remove,
 };
 
-int __init
+static int __init
 vbus_pci_init(void)
 {
 	memset(&vbus_pci, 0, sizeof(vbus_pci));
-- 
1.5.4.3

