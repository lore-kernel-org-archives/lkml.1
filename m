Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYLJRrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYLJRrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYLJRrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:47:09 -0500
Received: from mail25.svc.cra.dublin.eircom.net ([159.134.118.54]:32059 "HELO
	mail25.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752994AbYLJRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:47:06 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Mark McLoughlin <markmc@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5/6] kvm-s390: use register_virtio_root_device()
Date: Wed, 10 Dec 2008 17:45:38 +0000
Message-Id: <1228931139-12956-5-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1228931139-12956-4-git-send-email-markmc@redhat.com>
References: <1228931096.5384.63.camel@blaa>
 <1228931139-12956-1-git-send-email-markmc@redhat.com>
 <1228931139-12956-2-git-send-email-markmc@redhat.com>
 <1228931139-12956-3-git-send-email-markmc@redhat.com>
 <1228931139-12956-4-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically a no-op change, since it does exactly the
same thing as s390_root_dev_register() when the caller isn't
a module.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/s390/kvm/kvm_virtio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index c79cf05..d3f7d94 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -335,7 +335,7 @@ static int __init kvm_devices_init(void)
 	if (!MACHINE_IS_KVM)
 		return -ENODEV;
 
-	kvm_root = s390_root_dev_register("kvm_s390");
+	kvm_root = register_virtio_root_device("kvm_s390");
 	if (IS_ERR(kvm_root)) {
 		rc = PTR_ERR(kvm_root);
 		printk(KERN_ERR "Could not register kvm_s390 root device");
@@ -344,7 +344,7 @@ static int __init kvm_devices_init(void)
 
 	rc = vmem_add_mapping(real_memory_size, PAGE_SIZE);
 	if (rc) {
-		s390_root_dev_unregister(kvm_root);
+		unregister_virtio_root_device(kvm_root);
 		return rc;
 	}
 
-- 
1.5.4.3

