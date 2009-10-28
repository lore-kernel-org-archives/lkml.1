Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZJ1WLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZJ1WLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZJ1WLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:11:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56601 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZJ1WLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:11:34 -0400
Date: Wed, 28 Oct 2009 23:11:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Brian Swetland <swetland@google.com>
Subject: Add missing header for HTC Dream framebuffer
Message-ID: <20091028221131.GC8053@elf.ucw.cz>
References: <20090629111029.GA15514@elf.ucw.cz>
 <20091026221129.GB23415@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026221129.GB23415@game.jcrosoft.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I cleaned up dead code, a lot of debugging infastructure and horrific
> > logo code. I had to remove earlysuspend support, because neccessary
> > headers are not in mainline. The driver still works :-).
> > 
> > I'd like to see it applied, working framebuffer is quite important for
> > debugging / getting other drivers into working state.
> > 
> the include/linux/msm_mdp.h is missing
> 
> could you send a patch to add it?

---

This should fix compilation by adding missing include/linux/msm_mdp.h
file.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/include/linux/msm_mdp.h b/include/linux/msm_mdp.h
new file mode 100644
index 0000000..228e46e
--- /dev/null
+++ b/include/linux/msm_mdp.h
@@ -0,0 +1,86 @@
+/* include/linux/msm_mdp.h
+ *
+ * Copyright (C) 2007 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _MSM_MDP_H_
+#define _MSM_MDP_H_
+
+#include <linux/types.h>
+
+#define MSMFB_IOCTL_MAGIC 'm'
+#define MSMFB_GRP_DISP          _IOW(MSMFB_IOCTL_MAGIC, 1, unsigned int)
+#define MSMFB_BLIT              _IOW(MSMFB_IOCTL_MAGIC, 2, unsigned int)
+
+enum {
+	MDP_RGB_565,      /* RGB 565 planer */
+	MDP_XRGB_8888,    /* RGB 888 padded */
+	MDP_Y_CBCR_H2V2,  /* Y and CbCr, pseudo planer w/ Cb is in MSB */
+	MDP_ARGB_8888,    /* ARGB 888 */
+	MDP_RGB_888,      /* RGB 888 planer */
+	MDP_Y_CRCB_H2V2,  /* Y and CrCb, pseudo planer w/ Cr is in MSB */
+	MDP_YCRYCB_H2V1,  /* YCrYCb interleave */
+	MDP_Y_CRCB_H2V1,  /* Y and CrCb, pseduo planer w/ Cr is in MSB */
+	MDP_Y_CBCR_H2V1,  /* Y and CrCb, pseduo planer w/ Cr is in MSB */
+	MDP_RGBA_8888,    /* ARGB 888 */
+	MDP_BGRA_8888,    /* ARGB 888 */
+	MDP_IMGTYPE_LIMIT /* Non valid image type after this enum */
+};
+
+enum {
+	PMEM_IMG,
+	FB_IMG,
+};
+
+/* flag values */
+#define MDP_ROT_NOP 0
+#define MDP_FLIP_LR 0x1
+#define MDP_FLIP_UD 0x2
+#define MDP_ROT_90 0x4
+#define MDP_ROT_180 (MDP_FLIP_UD|MDP_FLIP_LR)
+#define MDP_ROT_270 (MDP_ROT_90|MDP_FLIP_UD|MDP_FLIP_LR)
+#define MDP_DITHER 0x8
+#define MDP_BLUR 0x10
+
+#define MDP_TRANSP_NOP 0xffffffff
+#define MDP_ALPHA_NOP 0xff
+
+struct mdp_rect {
+	uint32_t x;
+	uint32_t y;
+	uint32_t w;
+	uint32_t h;
+};
+
+struct mdp_img {
+	uint32_t width;
+	uint32_t height;
+	uint32_t format;
+	uint32_t offset;
+	int memory_id;		/* the file descriptor */
+};
+
+struct mdp_blit_req {
+	struct mdp_img src;
+	struct mdp_img dst;
+	struct mdp_rect src_rect;
+	struct mdp_rect dst_rect;
+	uint32_t alpha;
+	uint32_t transp_mask;
+	uint32_t flags;
+};
+
+struct mdp_blit_req_list {
+	uint32_t count;
+	struct mdp_blit_req req[];
+};
+
+#endif


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
