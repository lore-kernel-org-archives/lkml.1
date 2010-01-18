Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154Ab0ARVml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0ARVml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125Ab0ARVmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:42:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:50287 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755146Ab0ARVmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:42:39 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18f51okZmQfG8cwWF0wyRHpQxt75GGJdQAszRqFC8
	j+Bkl2WtXuqldU
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: [PATCH v3] video/matrox: Checkpatch cleanups for matroxfb_crtc2.c
Date: Mon, 18 Jan 2010 22:42:28 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Petr Vandrovec <vandrove@vc.cvut.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <201001181934.49519.PeterHuewe@gmx.de> <1263844770.26846.134.camel@Joe-Laptop.home> <20100118221146.5d81fc0e@hyperion.delvare>
In-Reply-To: <20100118221146.5d81fc0e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001182242.28291.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Mon, 18 Jan 2010 19:21:02 +0100

This patch fixes all 77 errors reported by checkpatch - no functional
change was made. The line over 80 chars warnings were left untouched.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: 2.6.33-rc4
Patch against Linus' Tree.

 drivers/video/matrox/matroxfb_crtc2.c |  432 +++++++++++++++++----------------
 1 files changed, 220 insertions(+), 212 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_crtc2.c b/drivers/video/matrox/matroxfb_crtc2.c
index 78414ba..946f5b7 100644
--- a/drivers/video/matrox/matroxfb_crtc2.c
+++ b/drivers/video/matrox/matroxfb_crtc2.c
@@ -27,7 +27,8 @@ MODULE_PARM_DESC(mem, "Memory size reserved for dualhead (default=8MB)");
 /* **************************************************** */
 
 static int matroxfb_dh_setcolreg(unsigned regno, unsigned red, unsigned green,
-		unsigned blue, unsigned transp, struct fb_info* info) {
+		unsigned blue, unsigned transp, struct fb_info *info)
+{
 	u_int32_t col;
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 
@@ -48,36 +49,35 @@ static int matroxfb_dh_setcolreg(unsigned regno, unsigned red, unsigned green,
 	      (transp << m2info->fbcon.var.transp.offset);
 
 	switch (m2info->fbcon.var.bits_per_pixel) {
-		case 16:
-			m2info->cmap[regno] = col | (col << 16);
-			break;
-		case 32:
-			m2info->cmap[regno] = col;
-			break;
+	case 16:
+		m2info->cmap[regno] = col | (col << 16);
+		break;
+	case 32:
+		m2info->cmap[regno] = col;
+		break;
 	}
 	return 0;
 #undef m2info
 }
 
-static void matroxfb_dh_restore(struct matroxfb_dh_fb_info* m2info,
-		struct my_timming* mt,
-		int mode,
-		unsigned int pos) {
+static void matroxfb_dh_restore(struct matroxfb_dh_fb_info *m2info,
+		struct my_timming *mt, int mode, unsigned int pos)
+{
 	u_int32_t tmp;
 	u_int32_t datactl;
 	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	switch (mode) {
-		case 15:
-			tmp = 0x00200000;
-			break;
-		case 16:
-			tmp = 0x00400000;
-			break;
-/*		case 32: */
-		default:
-			tmp = 0x00800000;
-			break;
+	case 15:
+		tmp = 0x00200000;
+		break;
+	case 16:
+		tmp = 0x00400000;
+		break;
+	/*	case 32: */
+	default:
+		tmp = 0x00800000;
+		break;
 	}
 	tmp |= 0x00000001;	/* enable CRTC2 */
 	datactl = 0;
@@ -85,9 +85,9 @@ static void matroxfb_dh_restore(struct matroxfb_dh_fb_info* m2info,
 		if (minfo->devflags.g450dac) {
 			tmp |= 0x00000006; /* source from secondary pixel PLL */
 			/* no vidrst when in monitor mode */
-			if (minfo->outputs[1].mode != MATROXFB_OUTPUT_MODE_MONITOR) {
+			if (minfo->outputs[1].mode != MATROXFB_OUTPUT_MODE_MONITOR)
 				tmp |=  0xC0001000; /* Enable H/V vidrst */
-			}
+
 		} else {
 			tmp |= 0x00000002; /* source from VDOCLK */
 			tmp |= 0xC0000000; /* enable vvidrst & hvidrst */
@@ -97,9 +97,9 @@ static void matroxfb_dh_restore(struct matroxfb_dh_fb_info* m2info,
 		tmp |= 0x00000004; /* source from pixclock */
 		/* PIXPLL is our clock source */
 	}
-	if (minfo->outputs[0].src == MATROXFB_SRC_CRTC2) {
+	if (minfo->outputs[0].src == MATROXFB_SRC_CRTC2)
 		tmp |= 0x00100000;	/* connect CRTC2 to DAC */
-	}
+
 	if (mt->interlaced) {
 		tmp |= 0x02000000;	/* interlaced, second field is bigger, as G450 apparently ignores it */
 		mt->VDisplay >>= 1;
@@ -121,7 +121,7 @@ static void matroxfb_dh_restore(struct matroxfb_dh_fb_info* m2info,
 		u_int32_t linelen = m2info->fbcon.var.xres_virtual * (m2info->fbcon.var.bits_per_pixel >> 3);
 		if (tmp & 0x02000000) {
 			/* field #0 is smaller, so... */
-			mga_outl(0x3C2C, pos);			/* field #1 vmemory start */
+			mga_outl(0x3C2C, pos);				/* field #1 vmemory start */
 			mga_outl(0x3C28, pos + linelen);	/* field #0 vmemory start */
 			linelen <<= 1;
 			m2info->interlaced = 1;
@@ -140,9 +140,8 @@ static void matroxfb_dh_restore(struct matroxfb_dh_fb_info* m2info,
 			unsigned int nl;
 			unsigned int lastl = 0;
 
-			while ((nl = mga_inl(0x3C48) & 0xFFF) >= lastl) {
+			while ((nl = mga_inl(0x3C48) & 0xFFF) >= lastl)
 				lastl = nl;
-			}
 		}
 	}
 	mga_outl(0x3C10, tmp);
@@ -156,15 +155,17 @@ static void matroxfb_dh_restore(struct matroxfb_dh_fb_info* m2info,
 	mga_outl(0x3C44, tmp);
 }
 
-static void matroxfb_dh_disable(struct matroxfb_dh_fb_info* m2info) {
+static void matroxfb_dh_disable(struct matroxfb_dh_fb_info *m2info)
+{
 	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	mga_outl(0x3C10, 0x00000004);	/* disable CRTC2, CRTC1->DAC1, PLL as clock source */
 	minfo->hw.crtc2.ctl = 0x00000004;
 }
 
-static void matroxfb_dh_pan_var(struct matroxfb_dh_fb_info* m2info,
-		struct fb_var_screeninfo* var) {
+static void matroxfb_dh_pan_var(struct matroxfb_dh_fb_info *m2info,
+		struct fb_var_screeninfo *var)
+{
 	unsigned int pos;
 	unsigned int linelen;
 	unsigned int pixelsize;
@@ -184,21 +185,23 @@ static void matroxfb_dh_pan_var(struct matroxfb_dh_fb_info* m2info,
 	}
 }
 
-static int matroxfb_dh_decode_var(struct matroxfb_dh_fb_info* m2info,
-		struct fb_var_screeninfo* var,
-		int *visual,
-		int *video_cmap_len,
-		int *mode) {
+static int matroxfb_dh_decode_var(struct matroxfb_dh_fb_info *m2info,
+		struct fb_var_screeninfo *var, int *visual, int *video_cmap_len,
+		int *mode)
+{
 	unsigned int mask;
 	unsigned int memlen;
 	unsigned int vramlen;
 
 	switch (var->bits_per_pixel) {
-		case 16:	mask = 0x1F;
-				break;
-		case 32:	mask = 0x0F;
-				break;
-		default:	return -EINVAL;
+	case 16:
+		mask = 0x1F;
+		break;
+	case 32:
+		mask = 0x0F;
+		break;
+	default:
+		return -EINVAL;
 	}
 	vramlen = m2info->video.len_usable;
 	if (var->yres_virtual < var->yres)
@@ -258,33 +261,33 @@ static int matroxfb_dh_decode_var(struct matroxfb_dh_fb_info* m2info,
 	return 0;
 }
 
-static int matroxfb_dh_open(struct fb_info* info, int user) {
+static int matroxfb_dh_open(struct fb_info *info, int user)
+{
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	if (minfo) {
 		int err;
 
-		if (minfo->dead) {
+		if (minfo->dead)
 			return -ENXIO;
-		}
+
 		err = minfo->fbops.fb_open(&minfo->fbcon, user);
-		if (err) {
+		if (err)
 			return err;
-		}
 	}
 	return 0;
 #undef m2info
 }
 
-static int matroxfb_dh_release(struct fb_info* info, int user) {
+static int matroxfb_dh_release(struct fb_info *info, int user)
+{
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	int err = 0;
 	struct matrox_fb_info *minfo = m2info->primary_dev;
 
-	if (minfo) {
+	if (minfo)
 		err = minfo->fbops.fb_release(&minfo->fbcon, user);
-	}
 	return err;
 #undef m2info
 }
@@ -309,7 +312,8 @@ static void matroxfb_dh_init_fix(struct matroxfb_dh_fb_info *m2info)
 	fix->accel = 0;		/* no accel... */
 }
 
-static int matroxfb_dh_check_var(struct fb_var_screeninfo* var, struct fb_info* info) {
+static int matroxfb_dh_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	int visual;
 	int cmap_len;
@@ -319,16 +323,18 @@ static int matroxfb_dh_check_var(struct fb_var_screeninfo* var, struct fb_info*
 #undef m2info
 }
 
-static int matroxfb_dh_set_par(struct fb_info* info) {
+static int matroxfb_dh_set_par(struct fb_info *info)
+{
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	int visual;
 	int cmap_len;
 	int mode;
 	int err;
-	struct fb_var_screeninfo* var = &info->var;
+	struct fb_var_screeninfo *var = &info->var;
 	struct matrox_fb_info *minfo = m2info->primary_dev;
 
-	if ((err = matroxfb_dh_decode_var(m2info, var, &visual, &cmap_len, &mode)) != 0)
+	err = matroxfb_dh_decode_var(m2info, var, &visual, &cmap_len, &mode);
+	if (err != 0)
 		return err;
 	/* cmap */
 	{
@@ -349,38 +355,37 @@ static int matroxfb_dh_set_par(struct fb_info* info) {
 		/* CRTC2 delay */
 		mt.delay = 34;
 
-		pos = (m2info->fbcon.var.yoffset * m2info->fbcon.var.xres_virtual + m2info->fbcon.var.xoffset) * m2info->fbcon.var.bits_per_pixel >> 3;
+		pos = (m2info->fbcon.var.yoffset * m2info->fbcon.var.xres_virtual +
+				m2info->fbcon.var.xoffset) * m2info->fbcon.var.bits_per_pixel >> 3;
 		pos += m2info->video.offbase;
 		cnt = 0;
 		down_read(&minfo->altout.lock);
 		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
 			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2) {
 				cnt++;
-				if (minfo->outputs[out].output->compute) {
+				if (minfo->outputs[out].output->compute)
 					minfo->outputs[out].output->compute(minfo->outputs[out].data, &mt);
-				}
 			}
 		}
 		minfo->crtc2.pixclock = mt.pixclock;
 		minfo->crtc2.mnp = mt.mnp;
 		up_read(&minfo->altout.lock);
-		if (cnt) {
+		if (cnt)
 			matroxfb_dh_restore(m2info, &mt, mode, pos);
-		} else {
+		else
 			matroxfb_dh_disable(m2info);
-		}
 		DAC1064_global_init(minfo);
 		DAC1064_global_restore(minfo);
 		down_read(&minfo->altout.lock);
 		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
 			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2 &&
-			    minfo->outputs[out].output->program) {
+				minfo->outputs[out].output->program) {
 				minfo->outputs[out].output->program(minfo->outputs[out].data);
 			}
 		}
 		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
 			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2 &&
-			    minfo->outputs[out].output->start) {
+				minfo->outputs[out].output->start) {
 				minfo->outputs[out].output->start(minfo->outputs[out].data);
 			}
 		}
@@ -391,14 +396,18 @@ static int matroxfb_dh_set_par(struct fb_info* info) {
 #undef m2info
 }
 
-static int matroxfb_dh_pan_display(struct fb_var_screeninfo* var, struct fb_info* info) {
+static int matroxfb_dh_pan_display(struct fb_var_screeninfo *var,
+		struct fb_info *info)
+{
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	matroxfb_dh_pan_var(m2info, var);
 	return 0;
 #undef m2info
 }
 
-static int matroxfb_dh_get_vblank(const struct matroxfb_dh_fb_info* m2info, struct fb_vblank* vblank) {
+static int matroxfb_dh_get_vblank(const struct matroxfb_dh_fb_info *m2info,
+		struct fb_vblank *vblank)
+{
 	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	matroxfb_enable_irq(minfo, 0);
@@ -410,11 +419,11 @@ static int matroxfb_dh_get_vblank(const struct matroxfb_dh_fb_info* m2info, stru
 	if (vblank->vcount >= m2info->fbcon.var.yres)
 		vblank->flags |= FB_VBLANK_VBLANKING;
 	if (test_bit(0, &minfo->irq_flags)) {
-                vblank->flags |= FB_VBLANK_HAVE_COUNT;
-                /* Only one writer, aligned int value...
-                   it should work without lock and without atomic_t */
+		vblank->flags |= FB_VBLANK_HAVE_COUNT;
+		/* Only one writer, aligned int value...
+		it should work without lock and without atomic_t */
 		vblank->count = minfo->crtc2.vsync.cnt;
-        }
+	}
 	return 0;
 }
 
@@ -428,133 +437,126 @@ static int matroxfb_dh_ioctl(struct fb_info *info,
 	DBG(__func__)
 
 	switch (cmd) {
-		case FBIOGET_VBLANK:
-			{
-				struct fb_vblank vblank;
-				int err;
-
-				err = matroxfb_dh_get_vblank(m2info, &vblank);
-				if (err)
-					return err;
-				if (copy_to_user((void __user *)arg, &vblank, sizeof(vblank)))
-					return -EFAULT;
-				return 0;
-			}
-		case FBIO_WAITFORVSYNC:
-			{
-				u_int32_t crt;
+	case FBIOGET_VBLANK: {
+		struct fb_vblank vblank;
+		int err;
 
-				if (get_user(crt, (u_int32_t __user *)arg))
-					return -EFAULT;
+		err = matroxfb_dh_get_vblank(m2info, &vblank);
+		if (err)
+			return err;
+		if (copy_to_user((void __user *)arg, &vblank, sizeof(vblank)))
+			return -EFAULT;
+		return 0;
+	}
+	case FBIO_WAITFORVSYNC: {
+		u_int32_t crt;
 
-				if (crt != 0)
-					return -ENODEV;
-				return matroxfb_wait_for_sync(minfo, 1);
-			}
-		case MATROXFB_SET_OUTPUT_MODE:
-		case MATROXFB_GET_OUTPUT_MODE:
-		case MATROXFB_GET_ALL_OUTPUTS:
-			{
-				return minfo->fbcon.fbops->fb_ioctl(&minfo->fbcon, cmd, arg);
-			}
-		case MATROXFB_SET_OUTPUT_CONNECTION:
-			{
-				u_int32_t tmp;
-				int out;
-				int changes;
-
-				if (get_user(tmp, (u_int32_t __user *)arg))
-					return -EFAULT;
-				for (out = 0; out < 32; out++) {
-					if (tmp & (1 << out)) {
-						if (out >= MATROXFB_MAX_OUTPUTS)
-							return -ENXIO;
-						if (!minfo->outputs[out].output)
-							return -ENXIO;
-						switch (minfo->outputs[out].src) {
-							case MATROXFB_SRC_NONE:
-							case MATROXFB_SRC_CRTC2:
-								break;
-							default:
-								return -EBUSY;
-						}
-					}
-				}
-				if (minfo->devflags.panellink) {
-					if (tmp & MATROXFB_OUTPUT_CONN_DFP)
-						return -EINVAL;
-					if ((minfo->outputs[2].src == MATROXFB_SRC_CRTC1) && tmp)
-						return -EBUSY;
-				}
-				changes = 0;
-				for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-					if (tmp & (1 << out)) {
-						if (minfo->outputs[out].src != MATROXFB_SRC_CRTC2) {
-							changes = 1;
-							minfo->outputs[out].src = MATROXFB_SRC_CRTC2;
-						}
-					} else if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2) {
-						changes = 1;
-						minfo->outputs[out].src = MATROXFB_SRC_NONE;
-					}
+		if (get_user(crt, (u_int32_t __user *)arg))
+			return -EFAULT;
+
+		if (crt != 0)
+			return -ENODEV;
+		return matroxfb_wait_for_sync(minfo, 1);
+	}
+	case MATROXFB_SET_OUTPUT_MODE:
+	case MATROXFB_GET_OUTPUT_MODE:
+	case MATROXFB_GET_ALL_OUTPUTS:
+		return minfo->fbcon.fbops->fb_ioctl(&minfo->fbcon, cmd, arg);
+	case MATROXFB_SET_OUTPUT_CONNECTION: {
+		u_int32_t tmp;
+		int out;
+		int changes;
+
+		if (get_user(tmp, (u_int32_t __user *)arg))
+			return -EFAULT;
+		for (out = 0; out < 32; out++) {
+			if (tmp & (1 << out)) {
+				if (out >= MATROXFB_MAX_OUTPUTS)
+					return -ENXIO;
+				if (!minfo->outputs[out].output)
+					return -ENXIO;
+				switch (minfo->outputs[out].src) {
+				case MATROXFB_SRC_NONE:
+				case MATROXFB_SRC_CRTC2:
+					break;
+				default:
+					return -EBUSY;
 				}
-				if (!changes)
-					return 0;
-				matroxfb_dh_set_par(info);
-				return 0;
 			}
-		case MATROXFB_GET_OUTPUT_CONNECTION:
-			{
-				u_int32_t conn = 0;
-				int out;
-
-				for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-					if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2) {
-						conn |= 1 << out;
-					}
+		}
+		if (minfo->devflags.panellink) {
+			if (tmp & MATROXFB_OUTPUT_CONN_DFP)
+				return -EINVAL;
+			if ((minfo->outputs[2].src == MATROXFB_SRC_CRTC1) && tmp)
+				return -EBUSY;
+		}
+		changes = 0;
+		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
+			if (tmp & (1 << out)) {
+				if (minfo->outputs[out].src != MATROXFB_SRC_CRTC2) {
+					changes = 1;
+					minfo->outputs[out].src = MATROXFB_SRC_CRTC2;
 				}
-				if (put_user(conn, (u_int32_t __user *)arg))
-					return -EFAULT;
-				return 0;
+			} else if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2) {
+				changes = 1;
+				minfo->outputs[out].src = MATROXFB_SRC_NONE;
 			}
-		case MATROXFB_GET_AVAILABLE_OUTPUTS:
-			{
-				u_int32_t tmp = 0;
-				int out;
-
-				for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
-					if (minfo->outputs[out].output) {
-						switch (minfo->outputs[out].src) {
-							case MATROXFB_SRC_NONE:
-							case MATROXFB_SRC_CRTC2:
-								tmp |= 1 << out;
-								break;
-						}
-					}
-				}
-				if (minfo->devflags.panellink) {
-					tmp &= ~MATROXFB_OUTPUT_CONN_DFP;
-					if (minfo->outputs[2].src == MATROXFB_SRC_CRTC1) {
-						tmp = 0;
-					}
+		}
+		if (!changes)
+			return 0;
+		matroxfb_dh_set_par(info);
+		return 0;
+	}
+	case MATROXFB_GET_OUTPUT_CONNECTION: {
+		u_int32_t conn = 0;
+		int out;
+
+		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
+			if (minfo->outputs[out].src == MATROXFB_SRC_CRTC2)
+				conn |= 1 << out;
+		}
+		if (put_user(conn, (u_int32_t __user *)arg))
+			return -EFAULT;
+		return 0;
+	}
+	case MATROXFB_GET_AVAILABLE_OUTPUTS: {
+		u_int32_t tmp = 0;
+		int out;
+
+		for (out = 0; out < MATROXFB_MAX_OUTPUTS; out++) {
+			if (minfo->outputs[out].output) {
+				switch (minfo->outputs[out].src) {
+				case MATROXFB_SRC_NONE:
+				case MATROXFB_SRC_CRTC2:
+					tmp |= 1 << out;
+					break;
 				}
-				if (put_user(tmp, (u_int32_t __user *)arg))
-					return -EFAULT;
-				return 0;
 			}
+		}
+		if (minfo->devflags.panellink) {
+			tmp &= ~MATROXFB_OUTPUT_CONN_DFP;
+			if (minfo->outputs[2].src == MATROXFB_SRC_CRTC1)
+				tmp = 0;
+		}
+		if (put_user(tmp, (u_int32_t __user *)arg))
+			return -EFAULT;
+		return 0;
+	}
 	}
 	return -ENOTTY;
 #undef m2info
 }
 
-static int matroxfb_dh_blank(int blank, struct fb_info* info) {
+static int matroxfb_dh_blank(int blank, struct fb_info *info)
+{
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	switch (blank) {
-		case 1:
-		case 2:
-		case 3:
-		case 4:
-		default:;
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+	default:
+		break;
 	}
 	/* do something... */
 	return 0;
@@ -568,7 +570,7 @@ static struct fb_ops matroxfb_dh_ops = {
 	.fb_check_var =	matroxfb_dh_check_var,
 	.fb_set_par =	matroxfb_dh_set_par,
 	.fb_setcolreg =	matroxfb_dh_setcolreg,
-	.fb_pan_display =matroxfb_dh_pan_display,
+	.fb_pan_display = matroxfb_dh_pan_display,
 	.fb_blank =	matroxfb_dh_blank,
 	.fb_ioctl =	matroxfb_dh_ioctl,
 	.fb_fillrect =	cfb_fillrect,
@@ -577,34 +579,34 @@ static struct fb_ops matroxfb_dh_ops = {
 };
 
 static struct fb_var_screeninfo matroxfb_dh_defined = {
-		640,480,640,480,/* W,H, virtual W,H */
-		0,0,		/* offset */
-		32,		/* depth */
-		0,		/* gray */
-		{0,0,0},	/* R */
-		{0,0,0},	/* G */
-		{0,0,0},	/* B */
-		{0,0,0},	/* alpha */
-		0,		/* nonstd */
-		FB_ACTIVATE_NOW,
-		-1,-1,		/* display size */
-		0,		/* accel flags */
-		39721L,48L,16L,33L,10L,
-		96L,2,0,	/* no sync info */
-		FB_VMODE_NONINTERLACED,
-		0, {0,0,0,0,0}
+	640, 480, 640, 480,/* W,H, virtual W,H */
+	0, 0,		/* offset */
+	32,		/* depth */
+	0,		/* gray */
+	{0, 0, 0},	/* R */
+	{0, 0, 0},	/* G */
+	{0, 0, 0},	/* B */
+	{0, 0, 0},	/* alpha */
+	0,		/* nonstd */
+	FB_ACTIVATE_NOW,
+	-1, -1,		/* display size */
+	0,		/* accel flags */
+	39721L, 48L, 16L, 33L, 10L,
+	96L, 2, 0,	/* no sync info */
+	FB_VMODE_NONINTERLACED,
+	0, {0, 0, 0, 0, 0}
 };
 
 static int matroxfb_dh_regit(const struct matrox_fb_info *minfo,
-			     struct matroxfb_dh_fb_info *m2info)
+		struct matroxfb_dh_fb_info *m2info)
 {
 #define minfo (m2info->primary_dev)
-	void* oldcrtc2;
+	void *oldcrtc2;
 
 	m2info->fbcon.fbops = &matroxfb_dh_ops;
 	m2info->fbcon.flags = FBINFO_FLAG_DEFAULT;
 	m2info->fbcon.flags |= FBINFO_HWACCEL_XPAN |
-			       FBINFO_HWACCEL_YPAN;
+				FBINFO_HWACCEL_YPAN;
 	m2info->fbcon.pseudo_palette = m2info->cmap;
 	fb_alloc_cmap(&m2info->fbcon.cmap, 256, 1);
 
@@ -630,9 +632,9 @@ static int matroxfb_dh_regit(const struct matrox_fb_info *minfo,
 	m2info->mmio.len = minfo->mmio.len;
 
 	matroxfb_dh_init_fix(m2info);
-	if (register_framebuffer(&m2info->fbcon)) {
+	if (register_framebuffer(&m2info->fbcon))
 		return -ENXIO;
-	}
+
 	if (!m2info->initialized)
 		fb_set_var(&m2info->fbcon, &matroxfb_dh_defined);
 	down_write(&minfo->crtc2.lock);
@@ -649,7 +651,8 @@ static int matroxfb_dh_regit(const struct matrox_fb_info *minfo,
 
 /* ************************** */
 
-static int matroxfb_dh_registerfb(struct matroxfb_dh_fb_info* m2info) {
+static int matroxfb_dh_registerfb(struct matroxfb_dh_fb_info *m2info)
+{
 #define minfo (m2info->primary_dev)
 	if (matroxfb_dh_regit(minfo, m2info)) {
 		printk(KERN_ERR "matroxfb_crtc2: secondary head failed to register\n");
@@ -662,11 +665,12 @@ static int matroxfb_dh_registerfb(struct matroxfb_dh_fb_info* m2info) {
 #undef minfo
 }
 
-static void matroxfb_dh_deregisterfb(struct matroxfb_dh_fb_info* m2info) {
+static void matroxfb_dh_deregisterfb(struct matroxfb_dh_fb_info *m2info)
+{
 #define minfo (m2info->primary_dev)
 	if (m2info->fbcon_registered) {
 		int id;
-		struct matroxfb_dh_fb_info* crtc2;
+		struct matroxfb_dh_fb_info *crtc2;
 
 		down_write(&minfo->crtc2.lock);
 		crtc2 = minfo->crtc2.info;
@@ -689,8 +693,9 @@ static void matroxfb_dh_deregisterfb(struct matroxfb_dh_fb_info* m2info) {
 #undef minfo
 }
 
-static void* matroxfb_crtc2_probe(struct matrox_fb_info* minfo) {
-	struct matroxfb_dh_fb_info* m2info;
+static void *matroxfb_crtc2_probe(struct matrox_fb_info *minfo)
+{
+	struct matroxfb_dh_fb_info *m2info;
 
 	/* hardware is CRTC2 incapable... */
 	if (!minfo->devflags.crtc2)
@@ -709,17 +714,19 @@ static void* matroxfb_crtc2_probe(struct matrox_fb_info* minfo) {
 	return m2info;
 }
 
-static void matroxfb_crtc2_remove(struct matrox_fb_info* minfo, void* crtc2) {
+static void matroxfb_crtc2_remove(struct matrox_fb_info *minfo, void *crtc2)
+{
 	matroxfb_dh_deregisterfb(crtc2);
 	kfree(crtc2);
 }
 
 static struct matroxfb_driver crtc2 = {
-		.name =		"Matrox G400 CRTC2",
-		.probe =	matroxfb_crtc2_probe,
-		.remove =	matroxfb_crtc2_remove };
+	.name =		"Matrox G400 CRTC2",
+	.probe =	matroxfb_crtc2_probe,
+	.remove =	matroxfb_crtc2_remove };
 
-static int matroxfb_crtc2_init(void) {
+static int matroxfb_crtc2_init(void)
+{
 	if (fb_get_options("matrox_crtc2fb", NULL))
 		return -ENODEV;
 
@@ -727,7 +734,8 @@ static int matroxfb_crtc2_init(void) {
 	return 0;
 }
 
-static void matroxfb_crtc2_exit(void) {
+static void matroxfb_crtc2_exit(void)
+{
 	matroxfb_unregister_driver(&crtc2);
 }
 
-- 
1.6.4.4

