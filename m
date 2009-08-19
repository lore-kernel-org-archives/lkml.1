Return-Path: <linux-kernel-owner+w=401wt.eu-S1751070AbZHSFWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbZHSFWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 01:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZHSFWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 01:22:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44121 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750859AbZHSFWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 01:22:14 -0400
From: Dave Airlie <airlied@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH] PCI/vgaarb: cleanup some warnings + cleanup some comments.
Date: Wed, 19 Aug 2009 15:21:57 +1000
Message-Id: <1250659317-28062-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

Fix some warnings reported in linux-next + also cleanup some
comment errors noticed by Pekka Paalanen.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/vga/vgaarb.c |   11 ++++-----
 include/linux/vgaarb.h   |   49 +++++++++++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 199138f..1ac0c93 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -609,7 +609,6 @@ void vga_set_legacy_decoding(struct pci_dev *pdev, unsigned int decodes)
 }
 EXPORT_SYMBOL(vga_set_legacy_decoding);
 
-/* return number of active VGA devices */
 /* call with NULL to unregister */
 int vga_client_register(struct pci_dev *pdev, void *cookie,
 			void (*irq_set_state)(void *cookie, bool state),
@@ -831,7 +830,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 5;
 		remaining -= 5;
 
-		pr_devel("client 0x%X called 'lock'\n", (int)priv);
+		pr_devel("client 0x%p called 'lock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -867,7 +866,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 7;
 		remaining -= 7;
 
-		pr_devel("client 0x%X called 'unlock'\n", (int)priv);
+		pr_devel("client 0x%p called 'unlock'\n", priv);
 
 		if (strncmp(curr_pos, "all", 3) == 0)
 			io_state = VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
@@ -917,7 +916,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 8;
 		remaining -= 8;
 
-		pr_devel("client 0x%X called 'trylock'\n", (int)priv);
+		pr_devel("client 0x%p called 'trylock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -960,7 +959,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 
 		curr_pos += 7;
 		remaining -= 7;
-		pr_devel("client 0x%X called 'target'\n", (int)priv);
+		pr_devel("client 0x%p called 'target'\n", priv);
 		/* if target is default */
 		if (!strncmp(buf, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
@@ -1014,7 +1013,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	} else if (strncmp(curr_pos, "decodes ", 8) == 0) {
 		curr_pos += 8;
 		remaining -= 8;
-		pr_devel("vgaarb: client 0x%X called 'decodes'\n", (int)priv);
+		pr_devel("vgaarb: client 0x%p called 'decodes'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 68229ce..e81c64a 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -46,9 +46,9 @@ extern void vga_set_legacy_decoding(struct pci_dev *pdev,
 /**
  *     vga_get         - acquire & locks VGA resources
  *
- *     pdev: pci device of the VGA card or NULL for the system default
- *     rsrc: bit mask of resources to acquire and lock
- *     interruptible: blocking should be interruptible by signals ?
+ *     @pdev: pci device of the VGA card or NULL for the system default
+ *     @rsrc: bit mask of resources to acquire and lock
+ *     @interruptible: blocking should be interruptible by signals ?
  *
  *     This function acquires VGA resources for the given
  *     card and mark those resources locked. If the resource requested
@@ -81,19 +81,19 @@ extern int vga_get(struct pci_dev *pdev, unsigned int rsrc,
  */
 
 static inline int vga_get_interruptible(struct pci_dev *pdev,
-										unsigned int rsrc)
+					unsigned int rsrc)
 {
        return vga_get(pdev, rsrc, 1);
 }
 
 /**
- *     vga_get_interruptible
+ *     vga_get_uninterruptible
  *
  *     Shortcut to vga_get
  */
 
 static inline int vga_get_uninterruptible(struct pci_dev *pdev,
-											unsigned int rsrc)
+					  unsigned int rsrc)
 {
        return vga_get(pdev, rsrc, 0);
 }
@@ -165,28 +165,33 @@ static inline int vga_conflicts(struct pci_dev *p1, struct pci_dev *p2)
 }
 #endif
 
-/*
- * Register a client with the VGA arbitration logic
- * return value: number of VGA devices in system.
- *
- * Clients have two callback mechanisms they can use.
- * irq enable/disable callback -
- *    If a client can't disable its GPUs VGA resources, then we
- *    need to be able to ask it to turn off its irqs when we
- *    turn off its mem and io decoding.
- * set_vga_decode
- *    If a client can disable its GPU VGA resource, it will
- *    get a callback from this to set the encode/decode state
- *
- * Clients with disable abilities should check the return value
- * of this function and if the VGA device count is > 1, should
- * disable VGA decoding resources.
+/**
+ *	vga_client_register
+ *
+ *	@pdev: pci device of the VGA client
+ *	@cookie: client cookie to be used in callbacks
+ *	@irq_set_state: irq state change callback
+ *	@set_vga_decode: vga decode change callback
+ *
+ * 	return value: 0 on success, -1 on failure
+ * 	Register a client with the VGA arbitration logic
+ *
+ *	Clients have two callback mechanisms they can use.
+ *	irq enable/disable callback -
+ *		If a client can't disable its GPUs VGA resources, then we
+ *		need to be able to ask it to turn off its irqs when we
+ *		turn off its mem and io decoding.
+ *	set_vga_decode
+ *		If a client can disable its GPU VGA resource, it will
+ *		get a callback from this to set the encode/decode state
  *
  * Rationale: we cannot disable VGA decode resources unconditionally
  * some single GPU laptops seem to require ACPI or BIOS access to the
  * VGA registers to control things like backlights etc.
  * Hopefully newer multi-GPU laptops do something saner, and desktops
  * won't have any special ACPI for this.
+ * They driver will get a callback when VGA arbitration is first used
+ * by userspace since we some older X servers have issues.
  */
 int vga_client_register(struct pci_dev *pdev, void *cookie,
 			void (*irq_set_state)(void *cookie, bool state),
-- 
1.6.2.5

