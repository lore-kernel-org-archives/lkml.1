Return-Path: <linux-kernel-owner+w=401wt.eu-S966168AbZLHU5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966168AbZLHU5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966140AbZLHU5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:57:32 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43986 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966126AbZLHU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:57:28 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] shm_signal: clearly specify endianness
Date: Tue,  8 Dec 2009 12:57:33 -0800
Message-Id: <1260305854-31472-5-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.6.0.rc1.71.gfba5.dirty
In-Reply-To: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
References: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 08 Dec 2009 12:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shm_signal code uses structures which are designed to be shared between
disparate systems, such as 32-bit and 64-bit, as well as Linux and Windows.

Since shm_signal is primarily intended to be used by qemu/kvm, which
supports virtual guests with a different CPU architecture than the host,
clearly define an endianness for the shared structures.

The endianness is defined to be little-endian, to avoid byte swapping in
the most common case: x86.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 include/linux/shm_signal.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/shm_signal.h b/include/linux/shm_signal.h
index 21cf750..b2efd72 100644
--- a/include/linux/shm_signal.h
+++ b/include/linux/shm_signal.h
@@ -32,8 +32,8 @@
  *-----------
  */
 
-#define SHM_SIGNAL_MAGIC 0x58fa39df
-#define SHM_SIGNAL_VER   1
+#define SHM_SIGNAL_MAGIC cpu_to_le32(0x58fa39df)
+#define SHM_SIGNAL_VER   cpu_to_le32(1)
 
 struct shm_signal_irq {
 	__u8                  enabled;
@@ -47,8 +47,8 @@ enum shm_signal_locality {
 };
 
 struct shm_signal_desc {
-	__u32                 magic;
-	__u32                 ver;
+	__le32                 magic;
+	__le32                 ver;
 	struct shm_signal_irq irq[2];
 };
 
-- 
1.5.4.3

