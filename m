Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbXKHCrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbXKHCrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbXKHCql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:46:41 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51899 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbXKHCqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:46:38 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org,
       kvm-devel@lists.sourceforge.net
Subject: [PATCH 2/3] Put the virtio under the virtualization menu
Date: Wed,  7 Nov 2007 20:46:31 -0600
Message-Id: <11944900152750-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11944900141678-git-send-email-aliguori@us.ibm.com>
References: <11944899922822-git-send-email-aliguori@us.ibm.com>
 <11944900141678-git-send-email-aliguori@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves virtio under the virtualization menu and changes virtio
devices to not claim to only be for lguest.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/Kconfig b/drivers/Kconfig
index f4076d9..d945ffc 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -93,6 +93,4 @@ source "drivers/auxdisplay/Kconfig"
 source "drivers/kvm/Kconfig"
 
 source "drivers/uio/Kconfig"
-
-source "drivers/virtio/Kconfig"
 endmenu
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 4d0119e..be4b224 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -429,6 +429,7 @@ config VIRTIO_BLK
 	tristate "Virtio block driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && VIRTIO
 	---help---
-	  This is the virtual block driver for lguest.  Say Y or M.
+	  This is the virtual block driver for virtio.  It can be used with
+          lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
 
 endif # BLK_DEV
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 6569206..ac4bcdf 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -50,5 +50,6 @@ config KVM_AMD
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/lguest/Kconfig
+source drivers/virtio/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 86b8641..e66aec4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3107,6 +3107,7 @@ config VIRTIO_NET
 	tristate "Virtio network driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && VIRTIO
 	---help---
-	  This is the virtual network driver for lguest.  Say Y or M.
+	  This is the virtual network driver for virtio.  It can be used with
+          lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
 
 endif # NETDEVICES
