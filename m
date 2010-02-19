Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0BSRJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:09:55 -0500
Received: from kroah.org ([198.145.64.141]:57633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab0BSRAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:47 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:45 2010
Message-Id: <20100219163244.992886742@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Gamari <bgamari.foss@gmail.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [51/93] drm/i915: remove full registers dump debug
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 823f68fd646da6a39a9c0d3eb4c60d69dab5aa13 upstream.

This one reverts 9e3a6d155ed0a7636b926a798dd7221ea107b274.
As reported by http://bugzilla.kernel.org/show_bug.cgi?id=14485,
this dump will cause hang problem on some machine. If something
really needs this kind of full registers dump, that could be done
within intel-gpu-tools.

Cc: Ben Gamari <bgamari.foss@gmail.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/gpu/drm/i915/i915_debugfs.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -384,37 +384,7 @@ out:
 	return 0;
 }
 
-static int i915_registers_info(struct seq_file *m, void *data) {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
-	struct drm_device *dev = node->minor->dev;
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	uint32_t reg;
-
-#define DUMP_RANGE(start, end) \
-	for (reg=start; reg < end; reg += 4) \
-	seq_printf(m, "%08x\t%08x\n", reg, I915_READ(reg));
-
-	DUMP_RANGE(0x00000, 0x00fff);   /* VGA registers */
-	DUMP_RANGE(0x02000, 0x02fff);   /* instruction, memory, interrupt control registers */
-	DUMP_RANGE(0x03000, 0x031ff);   /* FENCE and PPGTT control registers */
-	DUMP_RANGE(0x03200, 0x03fff);   /* frame buffer compression registers */
-	DUMP_RANGE(0x05000, 0x05fff);   /* I/O control registers */
-	DUMP_RANGE(0x06000, 0x06fff);   /* clock control registers */
-	DUMP_RANGE(0x07000, 0x07fff);   /* 3D internal debug registers */
-	DUMP_RANGE(0x07400, 0x088ff);   /* GPE debug registers */
-	DUMP_RANGE(0x0a000, 0x0afff);   /* display palette registers */
-	DUMP_RANGE(0x10000, 0x13fff);   /* MMIO MCHBAR */
-	DUMP_RANGE(0x30000, 0x3ffff);   /* overlay registers */
-	DUMP_RANGE(0x60000, 0x6ffff);   /* display engine pipeline registers */
-	DUMP_RANGE(0x70000, 0x72fff);   /* display and cursor registers */
-	DUMP_RANGE(0x73000, 0x73fff);   /* performance counters */
-
-	return 0;
-}
-
-
 static struct drm_info_list i915_debugfs_list[] = {
-	{"i915_regs", i915_registers_info, 0},
 	{"i915_gem_active", i915_gem_object_list_info, 0, (void *) ACTIVE_LIST},
 	{"i915_gem_flushing", i915_gem_object_list_info, 0, (void *) FLUSHING_LIST},
 	{"i915_gem_inactive", i915_gem_object_list_info, 0, (void *) INACTIVE_LIST},


