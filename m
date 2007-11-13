Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXKMNPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXKMNPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXKMNPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:15:08 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:45126 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbXKMNPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:15:07 -0500
Message-id: <2954541622451816350.slaby@pripojeni.net>
Subject: [PATCH 1/1] DRM: i915, fix pointer strip
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: <dri-devel@lists.sourceforge.net>
Date: Tue, 13 Nov 2007 08:15:07 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i915, fix pointer strip

Beside the emitted warning, the added cast (u64 -> unsigned) strips out
part of address on 64 bit. Cast to unsigned long instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Dave Airlie <airlied@linux.ie>

---
commit 496b198ff1b261c902337f93f07e7eabebd15fcd
tree 82e09385c7079b58397c547d4213f8a7f066191e
parent 32df077a4a9ff106df31681999e869971eacb470
author Jiri Slaby <jirislaby@gmail.com> Tue, 13 Nov 2007 14:12:08 +0100
committer Jiri Slaby <jirislaby@gmail.com> Tue, 13 Nov 2007 14:12:08 +0100

 drivers/char/drm/i915_dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/drm/i915_dma.c b/drivers/char/drm/i915_dma.c
index eced445..a68e0ee 100644
--- a/drivers/char/drm/i915_dma.c
+++ b/drivers/char/drm/i915_dma.c
@@ -900,7 +900,7 @@ int i915_validate_buffer_list(struct drm_file *file_priv,
 
 		buffers[buf_count] = NULL;
 
-		if (copy_from_user(&arg, (void __user *)(unsigned)data, sizeof(arg))) {
+		if (copy_from_user(&arg, (void __user *)(unsigned long)data, sizeof(arg))) {
 			ret = -EFAULT;
 			goto out_err;
 		}
@@ -951,7 +951,7 @@ int i915_validate_buffer_list(struct drm_file *file_priv,
 		arg.handled = 1;
 		arg.d.rep = rep;
 
-		if (copy_to_user((void __user *)(unsigned)data, &arg, sizeof(arg)))
+		if (copy_to_user((void __user *)(unsigned long)data, &arg, sizeof(arg)))
 			return -EFAULT;
 
 		data = next;
