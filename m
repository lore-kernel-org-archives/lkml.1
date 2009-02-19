Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZBSShA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZBSShA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZBSSgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:36:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:25079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBSSgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:36:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,236,1233561600"; 
   d="scan'208";a="112379899"
Subject: Re: [PATCH 3/4 v9] i.MX31: framebuffer driver
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0902191533090.5156@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
	 <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
	 <Pine.LNX.4.64.0901161106100.4940@axis700.grange>
	 <e9c3a7c20901160939y6b3906fp41531730d4b752a@mail.gmail.com>
	 <Pine.LNX.4.64.0901162048400.9060@axis700.grange>
	 <4974F208.3020407@intel.com>
	 <Pine.LNX.4.64.0901201048090.5126@axis700.grange>
	 <Pine.LNX.4.64.0902191533090.5156@axis700.grange>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 11:36:44 -0700
Message-Id: <1235068604.18650.16.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 07:41 -0700, Guennadi Liakhovetski wrote:
> On Tue, 20 Jan 2009, Guennadi Liakhovetski wrote:
> 
> > From: Guennadi Liakhovetski <lg@denx.de>
> >
> > This is a framebuffer driver for i.MX31 SoCs. It only supports synchronous
> > displays, vertical panning supported, no overlay support.
> >
> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Please, oh, please, wake me up if I'm dreaming... In the patch below all
> the indentation in _both_ mx3fb.h and mx3fb.c is with TABs (ok, didn't
> check all, a couple). Nun im Linus' git-tree - _ALL_ (that I checked)
> indentation is with... BLANKS!!!??? Could someone, please, tell me what
> was in that cup of tee I've drunk an hour ago?... Dan, you pushed this
> patch via your tree, right? Could you double-check, please?
> 

What a mess.  The other patches in your series were applied and
checkpatched from the tarball you sent.  This last fix up patch was not
cc'd to lkml so I fell back to applying it from a saved Thunderbird
message.  The real issue is that I did not have checkpatch automated
from StackedGIT's import command.  Please double check the fix below...

Thanks,
Dan

---
i.MX31: fix tab-to-space mess in framebuffer driver

From: Dan Williams <dan.j.williams@intel.com>

Commit 86528da2 was the result of applying a saved message without
re-running checkpatch to detect that tabs had been converted to spaces.

Before:
86528da2: total: 423 errors, 80 warnings, 1618 lines checked
   text	   data	    bss	    dec	    hex	filename
   6541	    168	      4	   6713	   1a39	drivers/video/mx3fb.o

After:
mx3fb.c: total: 0 errors, 22 warnings, 1555 lines checked
mx3fb.h: total: 0 errors, 1 warnings, 38 lines checked
   text	   data	    bss	    dec	    hex	filename
   6541	    168	      4	   6713	   1a39	drivers/video/mx3fb.o

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/plat-mxc/include/mach/mx3fb.h |    8 
 drivers/video/mx3fb.c                  | 2080 ++++++++++++++++----------------
 2 files changed, 1044 insertions(+), 1044 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/mx3fb.h b/arch/arm/plat-mxc/include/mach/mx3fb.h
index e391a76..619cbfe 100644
--- a/arch/arm/plat-mxc/include/mach/mx3fb.h
+++ b/arch/arm/plat-mxc/include/mach/mx3fb.h
@@ -29,10 +29,10 @@
  * @mode:      pointer to a platform-provided per mxc_register_fb() videomode
  */
 struct mx3fb_platform_data {
-       struct device                   *dma_dev;
-       const char                      *name;
-       const struct fb_videomode       *mode;
-       int                             num_modes;
+	struct device                   *dma_dev;
+	const char                      *name;
+	const struct fb_videomode       *mode;
+	int                             num_modes;
 };
 
 #endif
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 8a75d05..8178b4a 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -63,8 +63,8 @@
 #define SDC_V_SYNC_WIDTH_L     0x00000001UL
 
 /* Display Interface registers */
-#define DI_DISP_IF_CONF                (0x0124 - MX3FB_REG_OFFSET)
-#define DI_DISP_SIG_POL                (0x0128 - MX3FB_REG_OFFSET)
+#define DI_DISP_IF_CONF        (0x0124 - MX3FB_REG_OFFSET)
+#define DI_DISP_SIG_POL        (0x0128 - MX3FB_REG_OFFSET)
 #define DI_SER_DISP1_CONF      (0x012C - MX3FB_REG_OFFSET)
 #define DI_SER_DISP2_CONF      (0x0130 - MX3FB_REG_OFFSET)
 #define DI_HSP_CLK_PER         (0x0134 - MX3FB_REG_OFFSET)
@@ -96,9 +96,9 @@
 #define DI_DISP2_CB0_MAP       (0x019C - MX3FB_REG_OFFSET)
 #define DI_DISP2_CB1_MAP       (0x01A0 - MX3FB_REG_OFFSET)
 #define DI_DISP2_CB2_MAP       (0x01A4 - MX3FB_REG_OFFSET)
-#define DI_DISP3_B0_MAP                (0x01A8 - MX3FB_REG_OFFSET)
-#define DI_DISP3_B1_MAP                (0x01AC - MX3FB_REG_OFFSET)
-#define DI_DISP3_B2_MAP                (0x01B0 - MX3FB_REG_OFFSET)
+#define DI_DISP3_B0_MAP        (0x01A8 - MX3FB_REG_OFFSET)
+#define DI_DISP3_B1_MAP        (0x01AC - MX3FB_REG_OFFSET)
+#define DI_DISP3_B2_MAP        (0x01B0 - MX3FB_REG_OFFSET)
 #define DI_DISP_ACC_CC         (0x01B4 - MX3FB_REG_OFFSET)
 #define DI_DISP_LLA_CONF       (0x01B8 - MX3FB_REG_OFFSET)
 #define DI_DISP_LLA_DATA       (0x01BC - MX3FB_REG_OFFSET)
@@ -116,158 +116,158 @@
 #define DI_D3_DATAMSK_SHIFT            24
 
 enum ipu_panel {
-       IPU_PANEL_SHARP_TFT,
-       IPU_PANEL_TFT,
+	IPU_PANEL_SHARP_TFT,
+	IPU_PANEL_TFT,
 };
 
 struct ipu_di_signal_cfg {
-       unsigned datamask_en:1;
-       unsigned clksel_en:1;
-       unsigned clkidle_en:1;
-       unsigned data_pol:1;    /* true = inverted */
-       unsigned clk_pol:1;     /* true = rising edge */
-       unsigned enable_pol:1;
-       unsigned Hsync_pol:1;   /* true = active high */
-       unsigned Vsync_pol:1;
+	unsigned datamask_en:1;
+	unsigned clksel_en:1;
+	unsigned clkidle_en:1;
+	unsigned data_pol:1;    /* true = inverted */
+	unsigned clk_pol:1;     /* true = rising edge */
+	unsigned enable_pol:1;
+	unsigned Hsync_pol:1;   /* true = active high */
+	unsigned Vsync_pol:1;
 };
 
 static const struct fb_videomode mx3fb_modedb[] = {
-       {
-               /* 240x320 @ 60 Hz */
-               .name           = "Sharp-QVGA",
-               .refresh        = 60,
-               .xres           = 240,
-               .yres           = 320,
-               .pixclock       = 185925,
-               .left_margin    = 9,
-               .right_margin   = 16,
-               .upper_margin   = 7,
-               .lower_margin   = 9,
-               .hsync_len      = 1,
-               .vsync_len      = 1,
-               .sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_SHARP_MODE |
-                                 FB_SYNC_CLK_INVERT | FB_SYNC_DATA_INVERT |
-                                 FB_SYNC_CLK_IDLE_EN,
-               .vmode          = FB_VMODE_NONINTERLACED,
-               .flag           = 0,
-       }, {
-               /* 240x33 @ 60 Hz */
-               .name           = "Sharp-CLI",
-               .refresh        = 60,
-               .xres           = 240,
-               .yres           = 33,
-               .pixclock       = 185925,
-               .left_margin    = 9,
-               .right_margin   = 16,
-               .upper_margin   = 7,
-               .lower_margin   = 9 + 287,
-               .hsync_len      = 1,
-               .vsync_len      = 1,
-               .sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_SHARP_MODE |
-                                 FB_SYNC_CLK_INVERT | FB_SYNC_DATA_INVERT |
-                                 FB_SYNC_CLK_IDLE_EN,
-               .vmode          = FB_VMODE_NONINTERLACED,
-               .flag           = 0,
-       }, {
-               /* 640x480 @ 60 Hz */
-               .name           = "NEC-VGA",
-               .refresh        = 60,
-               .xres           = 640,
-               .yres           = 480,
-               .pixclock       = 38255,
-               .left_margin    = 144,
-               .right_margin   = 0,
-               .upper_margin   = 34,
-               .lower_margin   = 40,
-               .hsync_len      = 1,
-               .vsync_len      = 1,
-               .sync           = FB_SYNC_VERT_HIGH_ACT | FB_SYNC_OE_ACT_HIGH,
-               .vmode          = FB_VMODE_NONINTERLACED,
-               .flag           = 0,
-       }, {
-               /* NTSC TV output */
-               .name           = "TV-NTSC",
-               .refresh        = 60,
-               .xres           = 640,
-               .yres           = 480,
-               .pixclock       = 37538,
-               .left_margin    = 38,
-               .right_margin   = 858 - 640 - 38 - 3,
-               .upper_margin   = 36,
-               .lower_margin   = 518 - 480 - 36 - 1,
-               .hsync_len      = 3,
-               .vsync_len      = 1,
-               .sync           = 0,
-               .vmode          = FB_VMODE_NONINTERLACED,
-               .flag           = 0,
-       }, {
-               /* PAL TV output */
-               .name           = "TV-PAL",
-               .refresh        = 50,
-               .xres           = 640,
-               .yres           = 480,
-               .pixclock       = 37538,
-               .left_margin    = 38,
-               .right_margin   = 960 - 640 - 38 - 32,
-               .upper_margin   = 32,
-               .lower_margin   = 555 - 480 - 32 - 3,
-               .hsync_len      = 32,
-               .vsync_len      = 3,
-               .sync           = 0,
-               .vmode          = FB_VMODE_NONINTERLACED,
-               .flag           = 0,
-       }, {
-               /* TV output VGA mode, 640x480 @ 65 Hz */
-               .name           = "TV-VGA",
-               .refresh        = 60,
-               .xres           = 640,
-               .yres           = 480,
-               .pixclock       = 40574,
-               .left_margin    = 35,
-               .right_margin   = 45,
-               .upper_margin   = 9,
-               .lower_margin   = 1,
-               .hsync_len      = 46,
-               .vsync_len      = 5,
-               .sync           = 0,
-               .vmode          = FB_VMODE_NONINTERLACED,
-               .flag           = 0,
-       },
+	{
+		/* 240x320 @ 60 Hz */
+		.name           = "Sharp-QVGA",
+		.refresh        = 60,
+		.xres           = 240,
+		.yres           = 320,
+		.pixclock       = 185925,
+		.left_margin    = 9,
+		.right_margin   = 16,
+		.upper_margin   = 7,
+		.lower_margin   = 9,
+		.hsync_len      = 1,
+		.vsync_len      = 1,
+		.sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_SHARP_MODE |
+				  FB_SYNC_CLK_INVERT | FB_SYNC_DATA_INVERT |
+				  FB_SYNC_CLK_IDLE_EN,
+		.vmode          = FB_VMODE_NONINTERLACED,
+		.flag           = 0,
+	}, {
+		/* 240x33 @ 60 Hz */
+		.name           = "Sharp-CLI",
+		.refresh        = 60,
+		.xres           = 240,
+		.yres           = 33,
+		.pixclock       = 185925,
+		.left_margin    = 9,
+		.right_margin   = 16,
+		.upper_margin   = 7,
+		.lower_margin   = 9 + 287,
+		.hsync_len      = 1,
+		.vsync_len      = 1,
+		.sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_SHARP_MODE |
+				  FB_SYNC_CLK_INVERT | FB_SYNC_DATA_INVERT |
+				  FB_SYNC_CLK_IDLE_EN,
+		.vmode          = FB_VMODE_NONINTERLACED,
+		.flag           = 0,
+	}, {
+		/* 640x480 @ 60 Hz */
+		.name           = "NEC-VGA",
+		.refresh        = 60,
+		.xres           = 640,
+		.yres           = 480,
+		.pixclock       = 38255,
+		.left_margin    = 144,
+		.right_margin   = 0,
+		.upper_margin   = 34,
+		.lower_margin   = 40,
+		.hsync_len      = 1,
+		.vsync_len      = 1,
+		.sync           = FB_SYNC_VERT_HIGH_ACT | FB_SYNC_OE_ACT_HIGH,
+		.vmode          = FB_VMODE_NONINTERLACED,
+		.flag           = 0,
+	}, {
+		/* NTSC TV output */
+		.name           = "TV-NTSC",
+		.refresh        = 60,
+		.xres           = 640,
+		.yres           = 480,
+		.pixclock       = 37538,
+		.left_margin    = 38,
+		.right_margin   = 858 - 640 - 38 - 3,
+		.upper_margin   = 36,
+		.lower_margin   = 518 - 480 - 36 - 1,
+		.hsync_len      = 3,
+		.vsync_len      = 1,
+		.sync           = 0,
+		.vmode          = FB_VMODE_NONINTERLACED,
+		.flag           = 0,
+	}, {
+		/* PAL TV output */
+		.name           = "TV-PAL",
+		.refresh        = 50,
+		.xres           = 640,
+		.yres           = 480,
+		.pixclock       = 37538,
+		.left_margin    = 38,
+		.right_margin   = 960 - 640 - 38 - 32,
+		.upper_margin   = 32,
+		.lower_margin   = 555 - 480 - 32 - 3,
+		.hsync_len      = 32,
+		.vsync_len      = 3,
+		.sync           = 0,
+		.vmode          = FB_VMODE_NONINTERLACED,
+		.flag           = 0,
+	}, {
+		/* TV output VGA mode, 640x480 @ 65 Hz */
+		.name           = "TV-VGA",
+		.refresh        = 60,
+		.xres           = 640,
+		.yres           = 480,
+		.pixclock       = 40574,
+		.left_margin    = 35,
+		.right_margin   = 45,
+		.upper_margin   = 9,
+		.lower_margin   = 1,
+		.hsync_len      = 46,
+		.vsync_len      = 5,
+		.sync           = 0,
+		.vmode          = FB_VMODE_NONINTERLACED,
+		.flag           = 0,
+	},
 };
 
 struct mx3fb_data {
-       struct fb_info          *fbi;
-       int                     backlight_level;
-       void __iomem            *reg_base;
-       spinlock_t              lock;
-       struct device           *dev;
-
-       uint32_t                h_start_width;
-       uint32_t                v_start_width;
+	struct fb_info          *fbi;
+	int                     backlight_level;
+	void __iomem            *reg_base;
+	spinlock_t              lock;
+	struct device           *dev;
+
+	uint32_t                h_start_width;
+	uint32_t                v_start_width;
 };
 
 struct dma_chan_request {
-       struct mx3fb_data       *mx3fb;
-       enum ipu_channel        id;
+	struct mx3fb_data       *mx3fb;
+	enum ipu_channel        id;
 };
 
 /* MX3 specific framebuffer information. */
 struct mx3fb_info {
-       int                             blank;
-       enum ipu_channel                ipu_ch;
-       uint32_t                        cur_ipu_buf;
+	int                             blank;
+	enum ipu_channel                ipu_ch;
+	uint32_t                        cur_ipu_buf;
 
-       u32                             pseudo_palette[16];
+	u32                             pseudo_palette[16];
 
-       struct completion               flip_cmpl;
-       struct mutex                    mutex;  /* Protects fb-ops */
-       struct mx3fb_data               *mx3fb;
-       struct idmac_channel            *idmac_channel;
-       struct dma_async_tx_descriptor  *txd;
-       dma_cookie_t                    cookie;
-       struct scatterlist              sg[2];
+	struct completion               flip_cmpl;
+	struct mutex                    mutex;  /* Protects fb-ops */
+	struct mx3fb_data               *mx3fb;
+	struct idmac_channel            *idmac_channel;
+	struct dma_async_tx_descriptor  *txd;
+	dma_cookie_t                    cookie;
+	struct scatterlist              sg[2];
 
-       u32                             sync;   /* preserve var->sync flags */
+	u32                             sync;   /* preserve var->sync flags */
 };
 
 static void mx3fb_dma_done(void *);
@@ -278,115 +278,115 @@ static unsigned long default_bpp = 16;
 
 static u32 mx3fb_read_reg(struct mx3fb_data *mx3fb, unsigned long reg)
 {
-       return __raw_readl(mx3fb->reg_base + reg);
+	return __raw_readl(mx3fb->reg_base + reg);
 }
 
 static void mx3fb_write_reg(struct mx3fb_data *mx3fb, u32 value, unsigned long reg)
 {
-       __raw_writel(value, mx3fb->reg_base + reg);
+	__raw_writel(value, mx3fb->reg_base + reg);
 }
 
 static const uint32_t di_mappings[] = {
-       0x1600AAAA, 0x00E05555, 0x00070000, 3,  /* RGB888 */
-       0x0005000F, 0x000B000F, 0x0011000F, 1,  /* RGB666 */
-       0x0011000F, 0x000B000F, 0x0005000F, 1,  /* BGR666 */
-       0x0004003F, 0x000A000F, 0x000F003F, 1   /* RGB565 */
+	0x1600AAAA, 0x00E05555, 0x00070000, 3,  /* RGB888 */
+	0x0005000F, 0x000B000F, 0x0011000F, 1,  /* RGB666 */
+	0x0011000F, 0x000B000F, 0x0005000F, 1,  /* BGR666 */
+	0x0004003F, 0x000A000F, 0x000F003F, 1   /* RGB565 */
 };
 
 static void sdc_fb_init(struct mx3fb_info *fbi)
 {
-       struct mx3fb_data *mx3fb = fbi->mx3fb;
-       uint32_t reg;
+	struct mx3fb_data *mx3fb = fbi->mx3fb;
+	uint32_t reg;
 
-       reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
 
-       mx3fb_write_reg(mx3fb, reg | SDC_COM_BG_EN, SDC_COM_CONF);
+	mx3fb_write_reg(mx3fb, reg | SDC_COM_BG_EN, SDC_COM_CONF);
 }
 
 /* Returns enabled flag before uninit */
 static uint32_t sdc_fb_uninit(struct mx3fb_info *fbi)
 {
-       struct mx3fb_data *mx3fb = fbi->mx3fb;
-       uint32_t reg;
+	struct mx3fb_data *mx3fb = fbi->mx3fb;
+	uint32_t reg;
 
-       reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+	reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
 
-       mx3fb_write_reg(mx3fb, reg & ~SDC_COM_BG_EN, SDC_COM_CONF);
+	mx3fb_write_reg(mx3fb, reg & ~SDC_COM_BG_EN, SDC_COM_CONF);
 
-       return reg & SDC_COM_BG_EN;
+	return reg & SDC_COM_BG_EN;
 }
 
 static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
 {
-       struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
-       struct idmac_channel *ichan = mx3_fbi->idmac_channel;
-       struct dma_chan *dma_chan = &ichan->dma_chan;
-       unsigned long flags;
-       dma_cookie_t cookie;
-
-       dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
-               to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
-
-       /* This enables the channel */
-       if (mx3_fbi->cookie < 0) {
-               mx3_fbi->txd = dma_chan->device->device_prep_slave_sg(dma_chan,
-                     &mx3_fbi->sg[0], 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
-               if (!mx3_fbi->txd) {
-                       dev_err(mx3fb->dev, "Cannot allocate descriptor on %d\n",
-                               dma_chan->chan_id);
-                       return;
-               }
-
-               mx3_fbi->txd->callback_param    = mx3_fbi->txd;
-               mx3_fbi->txd->callback          = mx3fb_dma_done;
-
-               cookie = mx3_fbi->txd->tx_submit(mx3_fbi->txd);
-               dev_dbg(mx3fb->dev, "%d: Submit %p #%d [%c]\n", __LINE__,
-                      mx3_fbi->txd, cookie, list_empty(&ichan->queue) ? '-' : '+');
-       } else {
-               if (!mx3_fbi->txd || !mx3_fbi->txd->tx_submit) {
-                       dev_err(mx3fb->dev, "Cannot enable channel %d\n",
-                               dma_chan->chan_id);
-                       return;
-               }
-
-               /* Just re-activate the same buffer */
-               dma_async_issue_pending(dma_chan);
-               cookie = mx3_fbi->cookie;
-               dev_dbg(mx3fb->dev, "%d: Re-submit %p #%d [%c]\n", __LINE__,
-                      mx3_fbi->txd, cookie, list_empty(&ichan->queue) ? '-' : '+');
-       }
-
-       if (cookie >= 0) {
-               spin_lock_irqsave(&mx3fb->lock, flags);
-               sdc_fb_init(mx3_fbi);
-               mx3_fbi->cookie = cookie;
-               spin_unlock_irqrestore(&mx3fb->lock, flags);
-       }
-
-       /*
-        * Attention! Without this msleep the channel keeps generating
-        * interrupts. Next sdc_set_brightness() is going to be called
-        * from mx3fb_blank().
-        */
-       msleep(2);
+	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
+	struct idmac_channel *ichan = mx3_fbi->idmac_channel;
+	struct dma_chan *dma_chan = &ichan->dma_chan;
+	unsigned long flags;
+	dma_cookie_t cookie;
+
+	dev_dbg(mx3fb->dev, "mx3fbi %p, desc %p, sg %p\n", mx3_fbi,
+		to_tx_desc(mx3_fbi->txd), to_tx_desc(mx3_fbi->txd)->sg);
+
+	/* This enables the channel */
+	if (mx3_fbi->cookie < 0) {
+		mx3_fbi->txd = dma_chan->device->device_prep_slave_sg(dma_chan,
+				&mx3_fbi->sg[0], 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
+		if (!mx3_fbi->txd) {
+			dev_err(mx3fb->dev, "Cannot allocate descriptor on %d\n",
+				dma_chan->chan_id);
+			return;
+		}
+
+		mx3_fbi->txd->callback_param    = mx3_fbi->txd;
+		mx3_fbi->txd->callback          = mx3fb_dma_done;
+
+		cookie = mx3_fbi->txd->tx_submit(mx3_fbi->txd);
+		dev_dbg(mx3fb->dev, "%d: Submit %p #%d [%c]\n", __LINE__,
+			mx3_fbi->txd, cookie, list_empty(&ichan->queue) ? '-' : '+');
+	} else {
+		if (!mx3_fbi->txd || !mx3_fbi->txd->tx_submit) {
+			dev_err(mx3fb->dev, "Cannot enable channel %d\n",
+				dma_chan->chan_id);
+			return;
+		}
+
+		/* Just re-activate the same buffer */
+		dma_async_issue_pending(dma_chan);
+		cookie = mx3_fbi->cookie;
+		dev_dbg(mx3fb->dev, "%d: Re-submit %p #%d [%c]\n", __LINE__,
+			mx3_fbi->txd, cookie, list_empty(&ichan->queue) ? '-' : '+');
+	}
+
+	if (cookie >= 0) {
+		spin_lock_irqsave(&mx3fb->lock, flags);
+		sdc_fb_init(mx3_fbi);
+		mx3_fbi->cookie = cookie;
+		spin_unlock_irqrestore(&mx3fb->lock, flags);
+	}
+
+	/*
+	 * Attention! Without this msleep the channel keeps generating
+	 * interrupts. Next sdc_set_brightness() is going to be called
+	 * from mx3fb_blank().
+	 */
+	msleep(2);
 }
 
 static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 {
-       struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
-       uint32_t enabled;
-       unsigned long flags;
+	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
+	uint32_t enabled;
+	unsigned long flags;
 
-       spin_lock_irqsave(&mx3fb->lock, flags);
+	spin_lock_irqsave(&mx3fb->lock, flags);
 
-       enabled = sdc_fb_uninit(mx3_fbi);
+	enabled = sdc_fb_uninit(mx3_fbi);
 
-       spin_unlock_irqrestore(&mx3fb->lock, flags);
+	spin_unlock_irqrestore(&mx3fb->lock, flags);
 
-       mx3_fbi->txd->chan->device->device_terminate_all(mx3_fbi->txd->chan);
-       mx3_fbi->txd = NULL;
-       mx3_fbi->cookie = -EINVAL;
+	mx3_fbi->txd->chan->device->device_terminate_all(mx3_fbi->txd->chan);
+	mx3_fbi->txd = NULL;
+	mx3_fbi->cookie = -EINVAL;
 }
 
 /**
@@ -398,16 +398,16 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
  * @return:    0 on success or negative error code on failure.
  */
 static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel,
-                             int16_t x_pos, int16_t y_pos)
+			      int16_t x_pos, int16_t y_pos)
 {
-       x_pos += mx3fb->h_start_width;
-       y_pos += mx3fb->v_start_width;
+	x_pos += mx3fb->h_start_width;
+	y_pos += mx3fb->v_start_width;
 
-       if (channel != IDMAC_SDC_0)
-               return -EINVAL;
+	if (channel != IDMAC_SDC_0)
+		return -EINVAL;
 
-       mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
-       return 0;
+	mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
+	return 0;
 }
 
 /**
@@ -432,142 +432,142 @@ static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel
  * @return:            0 on success or negative error code on failure.
  */
 static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
-                         uint32_t pixel_clk,
-                         uint16_t width, uint16_t height,
-                         enum pixel_fmt pixel_fmt,
-                         uint16_t h_start_width, uint16_t h_sync_width,
-                         uint16_t h_end_width, uint16_t v_start_width,
-                         uint16_t v_sync_width, uint16_t v_end_width,
-                         struct ipu_di_signal_cfg sig)
+			  uint32_t pixel_clk,
+			  uint16_t width, uint16_t height,
+			  enum pixel_fmt pixel_fmt,
+			  uint16_t h_start_width, uint16_t h_sync_width,
+			  uint16_t h_end_width, uint16_t v_start_width,
+			  uint16_t v_sync_width, uint16_t v_end_width,
+			  struct ipu_di_signal_cfg sig)
 {
-       unsigned long lock_flags;
-       uint32_t reg;
-       uint32_t old_conf;
-       uint32_t div;
-       struct clk *ipu_clk;
+	unsigned long lock_flags;
+	uint32_t reg;
+	uint32_t old_conf;
+	uint32_t div;
+	struct clk *ipu_clk;
 
-       dev_dbg(mx3fb->dev, "panel size = %d x %d", width, height);
+	dev_dbg(mx3fb->dev, "panel size = %d x %d", width, height);
 
-       if (v_sync_width == 0 || h_sync_width == 0)
-               return -EINVAL;
+	if (v_sync_width == 0 || h_sync_width == 0)
+		return -EINVAL;
 
-       /* Init panel size and blanking periods */
-       reg = ((uint32_t) (h_sync_width - 1) << 26) |
-               ((uint32_t) (width + h_start_width + h_end_width - 1) << 16);
-       mx3fb_write_reg(mx3fb, reg, SDC_HOR_CONF);
+	/* Init panel size and blanking periods */
+	reg = ((uint32_t) (h_sync_width - 1) << 26) |
+		((uint32_t) (width + h_start_width + h_end_width - 1) << 16);
+	mx3fb_write_reg(mx3fb, reg, SDC_HOR_CONF);
 
 #ifdef DEBUG
-       printk(KERN_CONT " hor_conf %x,", reg);
+	printk(KERN_CONT " hor_conf %x,", reg);
 #endif
 
-       reg = ((uint32_t) (v_sync_width - 1) << 26) | SDC_V_SYNC_WIDTH_L |
-           ((uint32_t) (height + v_start_width + v_end_width - 1) << 16);
-       mx3fb_write_reg(mx3fb, reg, SDC_VER_CONF);
+	reg = ((uint32_t) (v_sync_width - 1) << 26) | SDC_V_SYNC_WIDTH_L |
+		((uint32_t) (height + v_start_width + v_end_width - 1) << 16);
+	mx3fb_write_reg(mx3fb, reg, SDC_VER_CONF);
 
 #ifdef DEBUG
-       printk(KERN_CONT " ver_conf %x\n", reg);
+	printk(KERN_CONT " ver_conf %x\n", reg);
 #endif
 
-       mx3fb->h_start_width = h_start_width;
-       mx3fb->v_start_width = v_start_width;
-
-       switch (panel) {
-       case IPU_PANEL_SHARP_TFT:
-               mx3fb_write_reg(mx3fb, 0x00FD0102L, SDC_SHARP_CONF_1);
-               mx3fb_write_reg(mx3fb, 0x00F500F4L, SDC_SHARP_CONF_2);
-               mx3fb_write_reg(mx3fb, SDC_COM_SHARP | SDC_COM_TFT_COLOR, SDC_COM_CONF);
-               break;
-       case IPU_PANEL_TFT:
-               mx3fb_write_reg(mx3fb, SDC_COM_TFT_COLOR, SDC_COM_CONF);
-               break;
-       default:
-               return -EINVAL;
-       }
-
-       /* Init clocking */
-
-       /*
-        * Calculate divider: fractional part is 4 bits so simply multiple by
-        * 24 to get fractional part, as long as we stay under ~250MHz and on
-        * i.MX31 it (HSP_CLK) is <= 178MHz. Currently 128.267MHz
-        */
-       dev_dbg(mx3fb->dev, "pixel clk = %d\n", pixel_clk);
-
-       ipu_clk = clk_get(mx3fb->dev, "ipu_clk");
-       div = clk_get_rate(ipu_clk) * 16 / pixel_clk;
-       clk_put(ipu_clk);
-
-       if (div < 0x40) {       /* Divider less than 4 */
-               dev_dbg(mx3fb->dev,
-                       "InitPanel() - Pixel clock divider less than 4\n");
-               div = 0x40;
-       }
-
-       spin_lock_irqsave(&mx3fb->lock, lock_flags);
-
-       /*
-        * DISP3_IF_CLK_DOWN_WR is half the divider value and 2 fraction bits
-        * fewer. Subtract 1 extra from DISP3_IF_CLK_DOWN_WR based on timing
-        * debug. DISP3_IF_CLK_UP_WR is 0
-        */
-       mx3fb_write_reg(mx3fb, (((div / 8) - 1) << 22) | div, DI_DISP3_TIME_CONF);
-
-       /* DI settings */
-       old_conf = mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF) & 0x78FFFFFF;
-       old_conf |= sig.datamask_en << DI_D3_DATAMSK_SHIFT |
-           sig.clksel_en << DI_D3_CLK_SEL_SHIFT |
-           sig.clkidle_en << DI_D3_CLK_IDLE_SHIFT;
-       mx3fb_write_reg(mx3fb, old_conf, DI_DISP_IF_CONF);
-
-       old_conf = mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL) & 0xE0FFFFFF;
-       old_conf |= sig.data_pol << DI_D3_DATA_POL_SHIFT |
-           sig.clk_pol << DI_D3_CLK_POL_SHIFT |
-           sig.enable_pol << DI_D3_DRDY_SHARP_POL_SHIFT |
-           sig.Hsync_pol << DI_D3_HSYNC_POL_SHIFT |
-           sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
-       mx3fb_write_reg(mx3fb, old_conf, DI_DISP_SIG_POL);
-
-       switch (pixel_fmt) {
-       case IPU_PIX_FMT_RGB24:
-               mx3fb_write_reg(mx3fb, di_mappings[0], DI_DISP3_B0_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[1], DI_DISP3_B1_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[2], DI_DISP3_B2_MAP);
-               mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-                            ((di_mappings[3] - 1) << 12), DI_DISP_ACC_CC);
-               break;
-       case IPU_PIX_FMT_RGB666:
-               mx3fb_write_reg(mx3fb, di_mappings[4], DI_DISP3_B0_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[5], DI_DISP3_B1_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[6], DI_DISP3_B2_MAP);
-               mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-                            ((di_mappings[7] - 1) << 12), DI_DISP_ACC_CC);
-               break;
-       case IPU_PIX_FMT_BGR666:
-               mx3fb_write_reg(mx3fb, di_mappings[8], DI_DISP3_B0_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[9], DI_DISP3_B1_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[10], DI_DISP3_B2_MAP);
-               mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-                            ((di_mappings[11] - 1) << 12), DI_DISP_ACC_CC);
-               break;
-       default:
-               mx3fb_write_reg(mx3fb, di_mappings[12], DI_DISP3_B0_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[13], DI_DISP3_B1_MAP);
-               mx3fb_write_reg(mx3fb, di_mappings[14], DI_DISP3_B2_MAP);
-               mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
-                            ((di_mappings[15] - 1) << 12), DI_DISP_ACC_CC);
-               break;
-       }
-
-       spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
-
-       dev_dbg(mx3fb->dev, "DI_DISP_IF_CONF = 0x%08X\n",
-               mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF));
-       dev_dbg(mx3fb->dev, "DI_DISP_SIG_POL = 0x%08X\n",
-               mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL));
-       dev_dbg(mx3fb->dev, "DI_DISP3_TIME_CONF = 0x%08X\n",
-               mx3fb_read_reg(mx3fb, DI_DISP3_TIME_CONF));
-
-       return 0;
+	mx3fb->h_start_width = h_start_width;
+	mx3fb->v_start_width = v_start_width;
+
+	switch (panel) {
+	case IPU_PANEL_SHARP_TFT:
+		mx3fb_write_reg(mx3fb, 0x00FD0102L, SDC_SHARP_CONF_1);
+		mx3fb_write_reg(mx3fb, 0x00F500F4L, SDC_SHARP_CONF_2);
+		mx3fb_write_reg(mx3fb, SDC_COM_SHARP | SDC_COM_TFT_COLOR, SDC_COM_CONF);
+		break;
+	case IPU_PANEL_TFT:
+		mx3fb_write_reg(mx3fb, SDC_COM_TFT_COLOR, SDC_COM_CONF);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Init clocking */
+
+	/*
+	 * Calculate divider: fractional part is 4 bits so simply multiple by
+	 * 24 to get fractional part, as long as we stay under ~250MHz and on
+	 * i.MX31 it (HSP_CLK) is <= 178MHz. Currently 128.267MHz
+	 */
+	dev_dbg(mx3fb->dev, "pixel clk = %d\n", pixel_clk);
+
+	ipu_clk = clk_get(mx3fb->dev, "ipu_clk");
+	div = clk_get_rate(ipu_clk) * 16 / pixel_clk;
+	clk_put(ipu_clk);
+
+	if (div < 0x40) {       /* Divider less than 4 */
+		dev_dbg(mx3fb->dev,
+				"InitPanel() - Pixel clock divider less than 4\n");
+		div = 0x40;
+	}
+
+	spin_lock_irqsave(&mx3fb->lock, lock_flags);
+
+	/*
+	 * DISP3_IF_CLK_DOWN_WR is half the divider value and 2 fraction bits
+	 * fewer. Subtract 1 extra from DISP3_IF_CLK_DOWN_WR based on timing
+	 * debug. DISP3_IF_CLK_UP_WR is 0
+	 */
+	mx3fb_write_reg(mx3fb, (((div / 8) - 1) << 22) | div, DI_DISP3_TIME_CONF);
+
+	/* DI settings */
+	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF) & 0x78FFFFFF;
+	old_conf |= sig.datamask_en << DI_D3_DATAMSK_SHIFT |
+		sig.clksel_en << DI_D3_CLK_SEL_SHIFT |
+		sig.clkidle_en << DI_D3_CLK_IDLE_SHIFT;
+	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_IF_CONF);
+
+	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL) & 0xE0FFFFFF;
+	old_conf |= sig.data_pol << DI_D3_DATA_POL_SHIFT |
+		sig.clk_pol << DI_D3_CLK_POL_SHIFT |
+		sig.enable_pol << DI_D3_DRDY_SHARP_POL_SHIFT |
+		sig.Hsync_pol << DI_D3_HSYNC_POL_SHIFT |
+		sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
+	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_SIG_POL);
+
+	switch (pixel_fmt) {
+	case IPU_PIX_FMT_RGB24:
+		mx3fb_write_reg(mx3fb, di_mappings[0], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[1], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[2], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+				((di_mappings[3] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	case IPU_PIX_FMT_RGB666:
+		mx3fb_write_reg(mx3fb, di_mappings[4], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[5], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[6], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+				((di_mappings[7] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	case IPU_PIX_FMT_BGR666:
+		mx3fb_write_reg(mx3fb, di_mappings[8], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[9], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[10], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+				((di_mappings[11] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	default:
+		mx3fb_write_reg(mx3fb, di_mappings[12], DI_DISP3_B0_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[13], DI_DISP3_B1_MAP);
+		mx3fb_write_reg(mx3fb, di_mappings[14], DI_DISP3_B2_MAP);
+		mx3fb_write_reg(mx3fb, mx3fb_read_reg(mx3fb, DI_DISP_ACC_CC) |
+				((di_mappings[15] - 1) << 12), DI_DISP_ACC_CC);
+		break;
+	}
+
+	spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
+
+	dev_dbg(mx3fb->dev, "DI_DISP_IF_CONF = 0x%08X\n",
+		mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF));
+	dev_dbg(mx3fb->dev, "DI_DISP_SIG_POL = 0x%08X\n",
+		mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL));
+	dev_dbg(mx3fb->dev, "DI_DISP3_TIME_CONF = 0x%08X\n",
+		mx3fb_read_reg(mx3fb, DI_DISP3_TIME_CONF));
+
+	return 0;
 }
 
 /**
@@ -579,33 +579,33 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
  * @return:    0 on success or negative error code on failure.
  */
 static int sdc_set_color_key(struct mx3fb_data *mx3fb, enum ipu_channel channel,
-                            bool enable, uint32_t color_key)
+			     bool enable, uint32_t color_key)
 {
-       uint32_t reg, sdc_conf;
-       unsigned long lock_flags;
+	uint32_t reg, sdc_conf;
+	unsigned long lock_flags;
 
-       spin_lock_irqsave(&mx3fb->lock, lock_flags);
+	spin_lock_irqsave(&mx3fb->lock, lock_flags);
 
-       sdc_conf = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
-       if (channel == IDMAC_SDC_0)
-               sdc_conf &= ~SDC_COM_GWSEL;
-       else
-               sdc_conf |= SDC_COM_GWSEL;
+	sdc_conf = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+	if (channel == IDMAC_SDC_0)
+		sdc_conf &= ~SDC_COM_GWSEL;
+	else
+		sdc_conf |= SDC_COM_GWSEL;
 
-       if (enable) {
-               reg = mx3fb_read_reg(mx3fb, SDC_GW_CTRL) & 0xFF000000L;
-               mx3fb_write_reg(mx3fb, reg | (color_key & 0x00FFFFFFL),
-                            SDC_GW_CTRL);
+	if (enable) {
+		reg = mx3fb_read_reg(mx3fb, SDC_GW_CTRL) & 0xFF000000L;
+		mx3fb_write_reg(mx3fb, reg | (color_key & 0x00FFFFFFL),
+				SDC_GW_CTRL);
 
-               sdc_conf |= SDC_COM_KEY_COLOR_G;
-       } else {
-               sdc_conf &= ~SDC_COM_KEY_COLOR_G;
-       }
-       mx3fb_write_reg(mx3fb, sdc_conf, SDC_COM_CONF);
+		sdc_conf |= SDC_COM_KEY_COLOR_G;
+	} else {
+		sdc_conf &= ~SDC_COM_KEY_COLOR_G;
+	}
+	mx3fb_write_reg(mx3fb, sdc_conf, SDC_COM_CONF);
 
-       spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
+	spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
 
-       return 0;
+	return 0;
 }
 
 /**
@@ -618,49 +618,49 @@ static int sdc_set_color_key(struct mx3fb_data *mx3fb, enum ipu_channel channel,
  */
 static int sdc_set_global_alpha(struct mx3fb_data *mx3fb, bool enable, uint8_t alpha)
 {
-       uint32_t reg;
-       unsigned long lock_flags;
+	uint32_t reg;
+	unsigned long lock_flags;
 
-       spin_lock_irqsave(&mx3fb->lock, lock_flags);
+	spin_lock_irqsave(&mx3fb->lock, lock_flags);
 
-       if (enable) {
-               reg = mx3fb_read_reg(mx3fb, SDC_GW_CTRL) & 0x00FFFFFFL;
-               mx3fb_write_reg(mx3fb, reg | ((uint32_t) alpha << 24), SDC_GW_CTRL);
+	if (enable) {
+		reg = mx3fb_read_reg(mx3fb, SDC_GW_CTRL) & 0x00FFFFFFL;
+		mx3fb_write_reg(mx3fb, reg | ((uint32_t) alpha << 24), SDC_GW_CTRL);
 
-               reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
-               mx3fb_write_reg(mx3fb, reg | SDC_COM_GLB_A, SDC_COM_CONF);
-       } else {
-               reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
-               mx3fb_write_reg(mx3fb, reg & ~SDC_COM_GLB_A, SDC_COM_CONF);
-       }
+		reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+		mx3fb_write_reg(mx3fb, reg | SDC_COM_GLB_A, SDC_COM_CONF);
+	} else {
+		reg = mx3fb_read_reg(mx3fb, SDC_COM_CONF);
+		mx3fb_write_reg(mx3fb, reg & ~SDC_COM_GLB_A, SDC_COM_CONF);
+	}
 
-       spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
+	spin_unlock_irqrestore(&mx3fb->lock, lock_flags);
 
-       return 0;
+	return 0;
 }
 
 static void sdc_set_brightness(struct mx3fb_data *mx3fb, uint8_t value)
 {
-       /* This might be board-specific */
-       mx3fb_write_reg(mx3fb, 0x03000000UL | value << 16, SDC_PWM_CTRL);
-       return;
+	/* This might be board-specific */
+	mx3fb_write_reg(mx3fb, 0x03000000UL | value << 16, SDC_PWM_CTRL);
+	return;
 }
 
 static uint32_t bpp_to_pixfmt(int bpp)
 {
-       uint32_t pixfmt = 0;
-       switch (bpp) {
-       case 24:
-               pixfmt = IPU_PIX_FMT_BGR24;
-               break;
-       case 32:
-               pixfmt = IPU_PIX_FMT_BGR32;
-               break;
-       case 16:
-               pixfmt = IPU_PIX_FMT_RGB565;
-               break;
-       }
-       return pixfmt;
+	uint32_t pixfmt = 0;
+	switch (bpp) {
+	case 24:
+		pixfmt = IPU_PIX_FMT_BGR24;
+		break;
+	case 32:
+		pixfmt = IPU_PIX_FMT_BGR32;
+		break;
+	case 16:
+		pixfmt = IPU_PIX_FMT_RGB565;
+		break;
+	}
+	return pixfmt;
 }
 
 static int mx3fb_blank(int blank, struct fb_info *fbi);
@@ -674,36 +674,36 @@ static int mx3fb_unmap_video_memory(struct fb_info *fbi);
  */
 static int mx3fb_set_fix(struct fb_info *fbi)
 {
-       struct fb_fix_screeninfo *fix = &fbi->fix;
-       struct fb_var_screeninfo *var = &fbi->var;
+	struct fb_fix_screeninfo *fix = &fbi->fix;
+	struct fb_var_screeninfo *var = &fbi->var;
 
-       strncpy(fix->id, "DISP3 BG", 8);
+	strncpy(fix->id, "DISP3 BG", 8);
 
-       fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
+	fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
 
-       fix->type = FB_TYPE_PACKED_PIXELS;
-       fix->accel = FB_ACCEL_NONE;
-       fix->visual = FB_VISUAL_TRUECOLOR;
-       fix->xpanstep = 1;
-       fix->ypanstep = 1;
+	fix->type = FB_TYPE_PACKED_PIXELS;
+	fix->accel = FB_ACCEL_NONE;
+	fix->visual = FB_VISUAL_TRUECOLOR;
+	fix->xpanstep = 1;
+	fix->ypanstep = 1;
 
-       return 0;
+	return 0;
 }
 
 static void mx3fb_dma_done(void *arg)
 {
-       struct idmac_tx_desc *tx_desc = to_tx_desc(arg);
-       struct dma_chan *chan = tx_desc->txd.chan;
-       struct idmac_channel *ichannel = to_idmac_chan(chan);
-       struct mx3fb_data *mx3fb = ichannel->client;
-       struct mx3fb_info *mx3_fbi = mx3fb->fbi->par;
+	struct idmac_tx_desc *tx_desc = to_tx_desc(arg);
+	struct dma_chan *chan = tx_desc->txd.chan;
+	struct idmac_channel *ichannel = to_idmac_chan(chan);
+	struct mx3fb_data *mx3fb = ichannel->client;
+	struct mx3fb_info *mx3_fbi = mx3fb->fbi->par;
 
-       dev_dbg(mx3fb->dev, "irq %d callback\n", ichannel->eof_irq);
+	dev_dbg(mx3fb->dev, "irq %d callback\n", ichannel->eof_irq);
 
-       /* We only need one interrupt, it will be re-enabled as needed */
-       disable_irq(ichannel->eof_irq);
+	/* We only need one interrupt, it will be re-enabled as needed */
+	disable_irq(ichannel->eof_irq);
 
-       complete(&mx3_fbi->flip_cmpl);
+	complete(&mx3_fbi->flip_cmpl);
 }
 
 /**
@@ -713,105 +713,105 @@ static void mx3fb_dma_done(void *arg)
  */
 static int mx3fb_set_par(struct fb_info *fbi)
 {
-       u32 mem_len;
-       struct ipu_di_signal_cfg sig_cfg;
-       enum ipu_panel mode = IPU_PANEL_TFT;
-       struct mx3fb_info *mx3_fbi = fbi->par;
-       struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
-       struct idmac_channel *ichan = mx3_fbi->idmac_channel;
-       struct idmac_video_param *video = &ichan->params.video;
-       struct scatterlist *sg = mx3_fbi->sg;
-       size_t screen_size;
-
-       dev_dbg(mx3fb->dev, "%s [%c]\n", __func__, list_empty(&ichan->queue) ? '-' : '+');
-
-       mutex_lock(&mx3_fbi->mutex);
-
-       /* Total cleanup */
-       if (mx3_fbi->txd)
-               sdc_disable_channel(mx3_fbi);
-
-       mx3fb_set_fix(fbi);
-
-       mem_len = fbi->var.yres_virtual * fbi->fix.line_length;
-       if (mem_len > fbi->fix.smem_len) {
-               if (fbi->fix.smem_start)
-                       mx3fb_unmap_video_memory(fbi);
-
-               fbi->fix.smem_len = mem_len;
-               if (mx3fb_map_video_memory(fbi) < 0) {
-                       mutex_unlock(&mx3_fbi->mutex);
-                       return -ENOMEM;
-               }
-       }
-
-       screen_size = fbi->fix.line_length * fbi->var.yres;
-
-       sg_init_table(&sg[0], 1);
-       sg_init_table(&sg[1], 1);
-
-       sg_dma_address(&sg[0])  = fbi->fix.smem_start;
-       sg_set_page(&sg[0], virt_to_page(fbi->screen_base),
-                   fbi->fix.smem_len,
-                   offset_in_page(fbi->screen_base));
-
-       if (mx3_fbi->ipu_ch == IDMAC_SDC_0) {
-               memset(&sig_cfg, 0, sizeof(sig_cfg));
-               if (fbi->var.sync & FB_SYNC_HOR_HIGH_ACT)
-                       sig_cfg.Hsync_pol = true;
-               if (fbi->var.sync & FB_SYNC_VERT_HIGH_ACT)
-                       sig_cfg.Vsync_pol = true;
-               if (fbi->var.sync & FB_SYNC_CLK_INVERT)
-                       sig_cfg.clk_pol = true;
-               if (fbi->var.sync & FB_SYNC_DATA_INVERT)
-                       sig_cfg.data_pol = true;
-               if (fbi->var.sync & FB_SYNC_OE_ACT_HIGH)
-                       sig_cfg.enable_pol = true;
-               if (fbi->var.sync & FB_SYNC_CLK_IDLE_EN)
-                       sig_cfg.clkidle_en = true;
-               if (fbi->var.sync & FB_SYNC_CLK_SEL_EN)
-                       sig_cfg.clksel_en = true;
-               if (fbi->var.sync & FB_SYNC_SHARP_MODE)
-                       mode = IPU_PANEL_SHARP_TFT;
-
-               dev_dbg(fbi->device, "pixclock = %ul Hz\n",
-                       (u32) (PICOS2KHZ(fbi->var.pixclock) * 1000UL));
-
-               if (sdc_init_panel(mx3fb, mode,
-                                  (PICOS2KHZ(fbi->var.pixclock)) * 1000UL,
-                                  fbi->var.xres, fbi->var.yres,
-                                  (fbi->var.sync & FB_SYNC_SWAP_RGB) ?
-                                  IPU_PIX_FMT_BGR666 : IPU_PIX_FMT_RGB666,
-                                  fbi->var.left_margin,
-                                  fbi->var.hsync_len,
-                                  fbi->var.right_margin +
-                                  fbi->var.hsync_len,
-                                  fbi->var.upper_margin,
-                                  fbi->var.vsync_len,
-                                  fbi->var.lower_margin +
-                                  fbi->var.vsync_len, sig_cfg) != 0) {
-                       mutex_unlock(&mx3_fbi->mutex);
-                       dev_err(fbi->device,
-                               "mx3fb: Error initializing panel.\n");
-                       return -EINVAL;
-               }
-       }
-
-       sdc_set_window_pos(mx3fb, mx3_fbi->ipu_ch, 0, 0);
-
-       mx3_fbi->cur_ipu_buf    = 0;
-
-       video->out_pixel_fmt    = bpp_to_pixfmt(fbi->var.bits_per_pixel);
-       video->out_width        = fbi->var.xres;
-       video->out_height       = fbi->var.yres;
-       video->out_stride       = fbi->var.xres_virtual;
-
-       if (mx3_fbi->blank == FB_BLANK_UNBLANK)
-               sdc_enable_channel(mx3_fbi);
-
-       mutex_unlock(&mx3_fbi->mutex);
-
-       return 0;
+	u32 mem_len;
+	struct ipu_di_signal_cfg sig_cfg;
+	enum ipu_panel mode = IPU_PANEL_TFT;
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
+	struct idmac_channel *ichan = mx3_fbi->idmac_channel;
+	struct idmac_video_param *video = &ichan->params.video;
+	struct scatterlist *sg = mx3_fbi->sg;
+	size_t screen_size;
+
+	dev_dbg(mx3fb->dev, "%s [%c]\n", __func__, list_empty(&ichan->queue) ? '-' : '+');
+
+	mutex_lock(&mx3_fbi->mutex);
+
+	/* Total cleanup */
+	if (mx3_fbi->txd)
+		sdc_disable_channel(mx3_fbi);
+
+	mx3fb_set_fix(fbi);
+
+	mem_len = fbi->var.yres_virtual * fbi->fix.line_length;
+	if (mem_len > fbi->fix.smem_len) {
+		if (fbi->fix.smem_start)
+			mx3fb_unmap_video_memory(fbi);
+
+		fbi->fix.smem_len = mem_len;
+		if (mx3fb_map_video_memory(fbi) < 0) {
+			mutex_unlock(&mx3_fbi->mutex);
+			return -ENOMEM;
+		}
+	}
+
+	screen_size = fbi->fix.line_length * fbi->var.yres;
+
+	sg_init_table(&sg[0], 1);
+	sg_init_table(&sg[1], 1);
+
+	sg_dma_address(&sg[0])  = fbi->fix.smem_start;
+	sg_set_page(&sg[0], virt_to_page(fbi->screen_base),
+			fbi->fix.smem_len,
+			offset_in_page(fbi->screen_base));
+
+	if (mx3_fbi->ipu_ch == IDMAC_SDC_0) {
+		memset(&sig_cfg, 0, sizeof(sig_cfg));
+		if (fbi->var.sync & FB_SYNC_HOR_HIGH_ACT)
+			sig_cfg.Hsync_pol = true;
+		if (fbi->var.sync & FB_SYNC_VERT_HIGH_ACT)
+			sig_cfg.Vsync_pol = true;
+		if (fbi->var.sync & FB_SYNC_CLK_INVERT)
+			sig_cfg.clk_pol = true;
+		if (fbi->var.sync & FB_SYNC_DATA_INVERT)
+			sig_cfg.data_pol = true;
+		if (fbi->var.sync & FB_SYNC_OE_ACT_HIGH)
+			sig_cfg.enable_pol = true;
+		if (fbi->var.sync & FB_SYNC_CLK_IDLE_EN)
+			sig_cfg.clkidle_en = true;
+		if (fbi->var.sync & FB_SYNC_CLK_SEL_EN)
+			sig_cfg.clksel_en = true;
+		if (fbi->var.sync & FB_SYNC_SHARP_MODE)
+			mode = IPU_PANEL_SHARP_TFT;
+
+		dev_dbg(fbi->device, "pixclock = %ul Hz\n",
+				(u32) (PICOS2KHZ(fbi->var.pixclock) * 1000UL));
+
+		if (sdc_init_panel(mx3fb, mode,
+				   (PICOS2KHZ(fbi->var.pixclock)) * 1000UL,
+				   fbi->var.xres, fbi->var.yres,
+				   (fbi->var.sync & FB_SYNC_SWAP_RGB) ?
+				   IPU_PIX_FMT_BGR666 : IPU_PIX_FMT_RGB666,
+				   fbi->var.left_margin,
+				   fbi->var.hsync_len,
+				   fbi->var.right_margin +
+				   fbi->var.hsync_len,
+				   fbi->var.upper_margin,
+				   fbi->var.vsync_len,
+				   fbi->var.lower_margin +
+				   fbi->var.vsync_len, sig_cfg) != 0) {
+			mutex_unlock(&mx3_fbi->mutex);
+			dev_err(fbi->device,
+				"mx3fb: Error initializing panel.\n");
+			return -EINVAL;
+		}
+	}
+
+	sdc_set_window_pos(mx3fb, mx3_fbi->ipu_ch, 0, 0);
+
+	mx3_fbi->cur_ipu_buf    = 0;
+
+	video->out_pixel_fmt    = bpp_to_pixfmt(fbi->var.bits_per_pixel);
+	video->out_width        = fbi->var.xres;
+	video->out_height       = fbi->var.yres;
+	video->out_stride       = fbi->var.xres_virtual;
+
+	if (mx3_fbi->blank == FB_BLANK_UNBLANK)
+		sdc_enable_channel(mx3_fbi);
+
+	mutex_unlock(&mx3_fbi->mutex);
+
+	return 0;
 }
 
 /**
@@ -821,148 +821,148 @@ static int mx3fb_set_par(struct fb_info *fbi)
  */
 static int mx3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *fbi)
 {
-       struct mx3fb_info *mx3_fbi = fbi->par;
-       u32 vtotal;
-       u32 htotal;
-
-       dev_dbg(fbi->device, "%s\n", __func__);
-
-       if (var->xres_virtual < var->xres)
-               var->xres_virtual = var->xres;
-       if (var->yres_virtual < var->yres)
-               var->yres_virtual = var->yres;
-
-       if ((var->bits_per_pixel != 32) && (var->bits_per_pixel != 24) &&
-           (var->bits_per_pixel != 16))
-               var->bits_per_pixel = default_bpp;
-
-       switch (var->bits_per_pixel) {
-       case 16:
-               var->red.length = 5;
-               var->red.offset = 11;
-               var->red.msb_right = 0;
-
-               var->green.length = 6;
-               var->green.offset = 5;
-               var->green.msb_right = 0;
-
-               var->blue.length = 5;
-               var->blue.offset = 0;
-               var->blue.msb_right = 0;
-
-               var->transp.length = 0;
-               var->transp.offset = 0;
-               var->transp.msb_right = 0;
-               break;
-       case 24:
-               var->red.length = 8;
-               var->red.offset = 16;
-               var->red.msb_right = 0;
-
-               var->green.length = 8;
-               var->green.offset = 8;
-               var->green.msb_right = 0;
-
-               var->blue.length = 8;
-               var->blue.offset = 0;
-               var->blue.msb_right = 0;
-
-               var->transp.length = 0;
-               var->transp.offset = 0;
-               var->transp.msb_right = 0;
-               break;
-       case 32:
-               var->red.length = 8;
-               var->red.offset = 16;
-               var->red.msb_right = 0;
-
-               var->green.length = 8;
-               var->green.offset = 8;
-               var->green.msb_right = 0;
-
-               var->blue.length = 8;
-               var->blue.offset = 0;
-               var->blue.msb_right = 0;
-
-               var->transp.length = 8;
-               var->transp.offset = 24;
-               var->transp.msb_right = 0;
-               break;
-       }
-
-       if (var->pixclock < 1000) {
-               htotal = var->xres + var->right_margin + var->hsync_len +
-                   var->left_margin;
-               vtotal = var->yres + var->lower_margin + var->vsync_len +
-                   var->upper_margin;
-               var->pixclock = (vtotal * htotal * 6UL) / 100UL;
-               var->pixclock = KHZ2PICOS(var->pixclock);
-               dev_dbg(fbi->device, "pixclock set for 60Hz refresh = %u ps\n",
-                       var->pixclock);
-       }
-
-       var->height = -1;
-       var->width = -1;
-       var->grayscale = 0;
-
-       /* Preserve sync flags */
-       var->sync |= mx3_fbi->sync;
-       mx3_fbi->sync |= var->sync;
-
-       return 0;
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	u32 vtotal;
+	u32 htotal;
+
+	dev_dbg(fbi->device, "%s\n", __func__);
+
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+	if (var->yres_virtual < var->yres)
+		var->yres_virtual = var->yres;
+
+	if ((var->bits_per_pixel != 32) && (var->bits_per_pixel != 24) &&
+			(var->bits_per_pixel != 16))
+		var->bits_per_pixel = default_bpp;
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		var->red.length = 5;
+		var->red.offset = 11;
+		var->red.msb_right = 0;
+
+		var->green.length = 6;
+		var->green.offset = 5;
+		var->green.msb_right = 0;
+
+		var->blue.length = 5;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 24:
+		var->red.length = 8;
+		var->red.offset = 16;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 32:
+		var->red.length = 8;
+		var->red.offset = 16;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 8;
+		var->transp.offset = 24;
+		var->transp.msb_right = 0;
+		break;
+	}
+
+	if (var->pixclock < 1000) {
+		htotal = var->xres + var->right_margin + var->hsync_len +
+			var->left_margin;
+		vtotal = var->yres + var->lower_margin + var->vsync_len +
+			var->upper_margin;
+		var->pixclock = (vtotal * htotal * 6UL) / 100UL;
+		var->pixclock = KHZ2PICOS(var->pixclock);
+		dev_dbg(fbi->device, "pixclock set for 60Hz refresh = %u ps\n",
+			var->pixclock);
+	}
+
+	var->height = -1;
+	var->width = -1;
+	var->grayscale = 0;
+
+	/* Preserve sync flags */
+	var->sync |= mx3_fbi->sync;
+	mx3_fbi->sync |= var->sync;
+
+	return 0;
 }
 
 static u32 chan_to_field(unsigned int chan, struct fb_bitfield *bf)
 {
-       chan &= 0xffff;
-       chan >>= 16 - bf->length;
-       return chan << bf->offset;
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+	return chan << bf->offset;
 }
 
 static int mx3fb_setcolreg(unsigned int regno, unsigned int red,
-                          unsigned int green, unsigned int blue,
-                          unsigned int trans, struct fb_info *fbi)
+			   unsigned int green, unsigned int blue,
+			   unsigned int trans, struct fb_info *fbi)
 {
-       struct mx3fb_info *mx3_fbi = fbi->par;
-       u32 val;
-       int ret = 1;
-
-       dev_dbg(fbi->device, "%s\n", __func__);
-
-       mutex_lock(&mx3_fbi->mutex);
-       /*
-        * If greyscale is true, then we convert the RGB value
-        * to greyscale no matter what visual we are using.
-        */
-       if (fbi->var.grayscale)
-               red = green = blue = (19595 * red + 38470 * green +
-                                     7471 * blue) >> 16;
-       switch (fbi->fix.visual) {
-       case FB_VISUAL_TRUECOLOR:
-               /*
-                * 16-bit True Colour.  We encode the RGB value
-                * according to the RGB bitfield information.
-                */
-               if (regno < 16) {
-                       u32 *pal = fbi->pseudo_palette;
-
-                       val = chan_to_field(red, &fbi->var.red);
-                       val |= chan_to_field(green, &fbi->var.green);
-                       val |= chan_to_field(blue, &fbi->var.blue);
-
-                       pal[regno] = val;
-
-                       ret = 0;
-               }
-               break;
-
-       case FB_VISUAL_STATIC_PSEUDOCOLOR:
-       case FB_VISUAL_PSEUDOCOLOR:
-               break;
-       }
-       mutex_unlock(&mx3_fbi->mutex);
-
-       return ret;
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	u32 val;
+	int ret = 1;
+
+	dev_dbg(fbi->device, "%s\n", __func__);
+
+	mutex_lock(&mx3_fbi->mutex);
+	/*
+	 * If greyscale is true, then we convert the RGB value
+	 * to greyscale no matter what visual we are using.
+	 */
+	if (fbi->var.grayscale)
+		red = green = blue = (19595 * red + 38470 * green +
+				7471 * blue) >> 16;
+	switch (fbi->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		/*
+		 * 16-bit True Colour.  We encode the RGB value
+		 * according to the RGB bitfield information.
+		 */
+		if (regno < 16) {
+			u32 *pal = fbi->pseudo_palette;
+
+			val = chan_to_field(red, &fbi->var.red);
+			val |= chan_to_field(green, &fbi->var.green);
+			val |= chan_to_field(blue, &fbi->var.blue);
+
+			pal[regno] = val;
+
+			ret = 0;
+		}
+		break;
+
+	case FB_VISUAL_STATIC_PSEUDOCOLOR:
+	case FB_VISUAL_PSEUDOCOLOR:
+		break;
+	}
+	mutex_unlock(&mx3_fbi->mutex);
+
+	return ret;
 }
 
 /**
@@ -970,35 +970,35 @@ static int mx3fb_setcolreg(unsigned int regno, unsigned int red,
  */
 static int mx3fb_blank(int blank, struct fb_info *fbi)
 {
-       struct mx3fb_info *mx3_fbi = fbi->par;
-       struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
-
-       dev_dbg(fbi->device, "%s\n", __func__);
-
-       dev_dbg(fbi->device, "blank = %d\n", blank);
-
-       if (mx3_fbi->blank == blank)
-               return 0;
-
-       mutex_lock(&mx3_fbi->mutex);
-       mx3_fbi->blank = blank;
-
-       switch (blank) {
-       case FB_BLANK_POWERDOWN:
-       case FB_BLANK_VSYNC_SUSPEND:
-       case FB_BLANK_HSYNC_SUSPEND:
-       case FB_BLANK_NORMAL:
-               sdc_disable_channel(mx3_fbi);
-               sdc_set_brightness(mx3fb, 0);
-               break;
-       case FB_BLANK_UNBLANK:
-               sdc_enable_channel(mx3_fbi);
-               sdc_set_brightness(mx3fb, mx3fb->backlight_level);
-               break;
-       }
-       mutex_unlock(&mx3_fbi->mutex);
-
-       return 0;
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
+
+	dev_dbg(fbi->device, "%s\n", __func__);
+
+	dev_dbg(fbi->device, "blank = %d\n", blank);
+
+	if (mx3_fbi->blank == blank)
+		return 0;
+
+	mutex_lock(&mx3_fbi->mutex);
+	mx3_fbi->blank = blank;
+
+	switch (blank) {
+	case FB_BLANK_POWERDOWN:
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_NORMAL:
+		sdc_disable_channel(mx3_fbi);
+		sdc_set_brightness(mx3fb, 0);
+		break;
+	case FB_BLANK_UNBLANK:
+		sdc_enable_channel(mx3_fbi);
+		sdc_set_brightness(mx3fb, mx3fb->backlight_level);
+		break;
+	}
+	mutex_unlock(&mx3_fbi->mutex);
+
+	return 0;
 }
 
 /**
@@ -1009,113 +1009,113 @@ static int mx3fb_blank(int blank, struct fb_info *fbi)
  * We look only at xoffset, yoffset and the FB_VMODE_YWRAP flag
  */
 static int mx3fb_pan_display(struct fb_var_screeninfo *var,
-                            struct fb_info *fbi)
+			     struct fb_info *fbi)
 {
-       struct mx3fb_info *mx3_fbi = fbi->par;
-       u32 y_bottom;
-       unsigned long base;
-       off_t offset;
-       dma_cookie_t cookie;
-       struct scatterlist *sg = mx3_fbi->sg;
-       struct dma_chan *dma_chan = &mx3_fbi->idmac_channel->dma_chan;
-       struct dma_async_tx_descriptor *txd;
-       int ret;
-
-       dev_dbg(fbi->device, "%s [%c]\n", __func__,
-               list_empty(&mx3_fbi->idmac_channel->queue) ? '-' : '+');
-
-       if (var->xoffset > 0) {
-               dev_dbg(fbi->device, "x panning not supported\n");
-               return -EINVAL;
-       }
-
-       if (fbi->var.xoffset == var->xoffset &&
-           fbi->var.yoffset == var->yoffset)
-               return 0;       /* No change, do nothing */
-
-       y_bottom = var->yoffset;
-
-       if (!(var->vmode & FB_VMODE_YWRAP))
-               y_bottom += var->yres;
-
-       if (y_bottom > fbi->var.yres_virtual)
-               return -EINVAL;
-
-       mutex_lock(&mx3_fbi->mutex);
-
-       offset = (var->yoffset * var->xres_virtual + var->xoffset) *
-               (var->bits_per_pixel / 8);
-       base = fbi->fix.smem_start + offset;
-
-       dev_dbg(fbi->device, "Updating SDC BG buf %d address=0x%08lX\n",
-               mx3_fbi->cur_ipu_buf, base);
-
-       /*
-        * We enable the End of Frame interrupt, which will free a tx-descriptor,
-        * which we will need for the next device_prep_slave_sg(). The
-        * IRQ-handler will disable the IRQ again.
-        */
-       init_completion(&mx3_fbi->flip_cmpl);
-       enable_irq(mx3_fbi->idmac_channel->eof_irq);
-
-       ret = wait_for_completion_timeout(&mx3_fbi->flip_cmpl, HZ / 10);
-       if (ret <= 0) {
-               mutex_unlock(&mx3_fbi->mutex);
-               dev_info(fbi->device, "Panning failed due to %s\n", ret < 0 ?
-                        "user interrupt" : "timeout");
-               return ret ? : -ETIMEDOUT;
-       }
-
-       mx3_fbi->cur_ipu_buf = !mx3_fbi->cur_ipu_buf;
-
-       sg_dma_address(&sg[mx3_fbi->cur_ipu_buf]) = base;
-       sg_set_page(&sg[mx3_fbi->cur_ipu_buf],
-                   virt_to_page(fbi->screen_base + offset), fbi->fix.smem_len,
-                   offset_in_page(fbi->screen_base + offset));
-
-       txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
-               mx3_fbi->cur_ipu_buf, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
-       if (!txd) {
-               dev_err(fbi->device,
-                       "Error preparing a DMA transaction descriptor.\n");
-               mutex_unlock(&mx3_fbi->mutex);
-               return -EIO;
-       }
-
-       txd->callback_param     = txd;
-       txd->callback           = mx3fb_dma_done;
-
-       /*
-        * Emulate original mx3fb behaviour: each new call to idmac_tx_submit()
-        * should switch to another buffer
-        */
-       cookie = txd->tx_submit(txd);
-       dev_dbg(fbi->device, "%d: Submit %p #%d\n", __LINE__, txd, cookie);
-       if (cookie < 0) {
-               dev_err(fbi->device,
-                       "Error updating SDC buf %d to address=0x%08lX\n",
-                       mx3_fbi->cur_ipu_buf, base);
-               mutex_unlock(&mx3_fbi->mutex);
-               return -EIO;
-       }
-
-       if (mx3_fbi->txd)
-               async_tx_ack(mx3_fbi->txd);
-       mx3_fbi->txd = txd;
-
-       fbi->var.xoffset = var->xoffset;
-       fbi->var.yoffset = var->yoffset;
-
-       if (var->vmode & FB_VMODE_YWRAP)
-               fbi->var.vmode |= FB_VMODE_YWRAP;
-       else
-               fbi->var.vmode &= ~FB_VMODE_YWRAP;
-
-       mutex_unlock(&mx3_fbi->mutex);
-
-       dev_dbg(fbi->device, "Update complete\n");
-
-       return 0;
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	u32 y_bottom;
+	unsigned long base;
+	off_t offset;
+	dma_cookie_t cookie;
+	struct scatterlist *sg = mx3_fbi->sg;
+	struct dma_chan *dma_chan = &mx3_fbi->idmac_channel->dma_chan;
+	struct dma_async_tx_descriptor *txd;
+	int ret;
+
+	dev_dbg(fbi->device, "%s [%c]\n", __func__,
+		list_empty(&mx3_fbi->idmac_channel->queue) ? '-' : '+');
+
+	if (var->xoffset > 0) {
+		dev_dbg(fbi->device, "x panning not supported\n");
+		return -EINVAL;
+	}
+
+	if (fbi->var.xoffset == var->xoffset &&
+	    fbi->var.yoffset == var->yoffset)
+		return 0;       /* No change, do nothing */
+
+	y_bottom = var->yoffset;
+
+	if (!(var->vmode & FB_VMODE_YWRAP))
+		y_bottom += var->yres;
+
+	if (y_bottom > fbi->var.yres_virtual)
+		return -EINVAL;
+
+	mutex_lock(&mx3_fbi->mutex);
+
+	offset = (var->yoffset * var->xres_virtual + var->xoffset) *
+		(var->bits_per_pixel / 8);
+	base = fbi->fix.smem_start + offset;
+
+	dev_dbg(fbi->device, "Updating SDC BG buf %d address=0x%08lX\n",
+		mx3_fbi->cur_ipu_buf, base);
+
+	/*
+	 * We enable the End of Frame interrupt, which will free a tx-descriptor,
+	 * which we will need for the next device_prep_slave_sg(). The
+	 * IRQ-handler will disable the IRQ again.
+	 */
+	init_completion(&mx3_fbi->flip_cmpl);
+	enable_irq(mx3_fbi->idmac_channel->eof_irq);
+
+	ret = wait_for_completion_timeout(&mx3_fbi->flip_cmpl, HZ / 10);
+	if (ret <= 0) {
+		mutex_unlock(&mx3_fbi->mutex);
+		dev_info(fbi->device, "Panning failed due to %s\n", ret < 0 ?
+			 "user interrupt" : "timeout");
+		return ret ? : -ETIMEDOUT;
+	}
+
+	mx3_fbi->cur_ipu_buf = !mx3_fbi->cur_ipu_buf;
+
+	sg_dma_address(&sg[mx3_fbi->cur_ipu_buf]) = base;
+	sg_set_page(&sg[mx3_fbi->cur_ipu_buf],
+			virt_to_page(fbi->screen_base + offset), fbi->fix.smem_len,
+			offset_in_page(fbi->screen_base + offset));
+
+	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
+			mx3_fbi->cur_ipu_buf, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
+	if (!txd) {
+		dev_err(fbi->device,
+			"Error preparing a DMA transaction descriptor.\n");
+		mutex_unlock(&mx3_fbi->mutex);
+		return -EIO;
+	}
+
+	txd->callback_param     = txd;
+	txd->callback           = mx3fb_dma_done;
+
+	/*
+	 * Emulate original mx3fb behaviour: each new call to idmac_tx_submit()
+	 * should switch to another buffer
+	 */
+	cookie = txd->tx_submit(txd);
+	dev_dbg(fbi->device, "%d: Submit %p #%d\n", __LINE__, txd, cookie);
+	if (cookie < 0) {
+		dev_err(fbi->device,
+			"Error updating SDC buf %d to address=0x%08lX\n",
+			mx3_fbi->cur_ipu_buf, base);
+		mutex_unlock(&mx3_fbi->mutex);
+		return -EIO;
+	}
+
+	if (mx3_fbi->txd)
+		async_tx_ack(mx3_fbi->txd);
+	mx3_fbi->txd = txd;
+
+	fbi->var.xoffset = var->xoffset;
+	fbi->var.yoffset = var->yoffset;
+
+	if (var->vmode & FB_VMODE_YWRAP)
+		fbi->var.vmode |= FB_VMODE_YWRAP;
+	else
+		fbi->var.vmode &= ~FB_VMODE_YWRAP;
+
+	mutex_unlock(&mx3_fbi->mutex);
+
+	dev_dbg(fbi->device, "Update complete\n");
+
+	return 0;
 }
 
 /*
@@ -1124,15 +1124,15 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
  * blitting, rectangle filling, copy regions and cursor definition.
  */
 static struct fb_ops mx3fb_ops = {
-       .owner = THIS_MODULE,
-       .fb_set_par = mx3fb_set_par,
-       .fb_check_var = mx3fb_check_var,
-       .fb_setcolreg = mx3fb_setcolreg,
-       .fb_pan_display = mx3fb_pan_display,
-       .fb_fillrect = cfb_fillrect,
-       .fb_copyarea = cfb_copyarea,
-       .fb_imageblit = cfb_imageblit,
-       .fb_blank = mx3fb_blank,
+	.owner = THIS_MODULE,
+	.fb_set_par = mx3fb_set_par,
+	.fb_check_var = mx3fb_check_var,
+	.fb_setcolreg = mx3fb_setcolreg,
+	.fb_pan_display = mx3fb_pan_display,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_blank = mx3fb_blank,
 };
 
 #ifdef CONFIG_PM
@@ -1146,19 +1146,19 @@ static struct fb_ops mx3fb_ops = {
  */
 static int mx3fb_suspend(struct platform_device *pdev, pm_message_t state)
 {
-       struct mx3fb_data *drv_data = platform_get_drvdata(pdev);
-       struct mx3fb_info *mx3_fbi = drv_data->fbi->par;
+	struct mx3fb_data *drv_data = platform_get_drvdata(pdev);
+	struct mx3fb_info *mx3_fbi = drv_data->fbi->par;
 
-       acquire_console_sem();
-       fb_set_suspend(drv_data->fbi, 1);
-       release_console_sem();
+	acquire_console_sem();
+	fb_set_suspend(drv_data->fbi, 1);
+	release_console_sem();
 
-       if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
-               sdc_disable_channel(mx3_fbi);
-               sdc_set_brightness(mx3fb, 0);
+	if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
+		sdc_disable_channel(mx3_fbi);
+		sdc_set_brightness(mx3fb, 0);
 
-       }
-       return 0;
+	}
+	return 0;
 }
 
 /*
@@ -1166,19 +1166,19 @@ static int mx3fb_suspend(struct platform_device *pdev, pm_message_t state)
  */
 static int mx3fb_resume(struct platform_device *pdev)
 {
-       struct mx3fb_data *drv_data = platform_get_drvdata(pdev);
-       struct mx3fb_info *mx3_fbi = drv_data->fbi->par;
+	struct mx3fb_data *drv_data = platform_get_drvdata(pdev);
+	struct mx3fb_info *mx3_fbi = drv_data->fbi->par;
 
-       if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
-               sdc_enable_channel(mx3_fbi);
-               sdc_set_brightness(mx3fb, drv_data->backlight_level);
-       }
+	if (mx3_fbi->blank == FB_BLANK_UNBLANK) {
+		sdc_enable_channel(mx3_fbi);
+		sdc_set_brightness(mx3fb, drv_data->backlight_level);
+	}
 
-       acquire_console_sem();
-       fb_set_suspend(drv_data->fbi, 0);
-       release_console_sem();
+	acquire_console_sem();
+	fb_set_suspend(drv_data->fbi, 0);
+	release_console_sem();
 
-       return 0;
+	return 0;
 }
 #else
 #define mx3fb_suspend   NULL
@@ -1201,37 +1201,37 @@ static int mx3fb_resume(struct platform_device *pdev)
  */
 static int mx3fb_map_video_memory(struct fb_info *fbi)
 {
-       int retval = 0;
-       dma_addr_t addr;
+	int retval = 0;
+	dma_addr_t addr;
 
-       fbi->screen_base = dma_alloc_writecombine(fbi->device,
-                                                 fbi->fix.smem_len,
-                                                 &addr, GFP_DMA);
+	fbi->screen_base = dma_alloc_writecombine(fbi->device,
+						  fbi->fix.smem_len,
+						  &addr, GFP_DMA);
 
-       if (!fbi->screen_base) {
-               dev_err(fbi->device, "Cannot allocate %u bytes framebuffer memory\n",
-                       fbi->fix.smem_len);
-               retval = -EBUSY;
-               goto err0;
-       }
+	if (!fbi->screen_base) {
+		dev_err(fbi->device, "Cannot allocate %u bytes framebuffer memory\n",
+			fbi->fix.smem_len);
+		retval = -EBUSY;
+		goto err0;
+	}
 
-       fbi->fix.smem_start = addr;
+	fbi->fix.smem_start = addr;
 
-       dev_dbg(fbi->device, "allocated fb @ p=0x%08x, v=0x%p, size=%d.\n",
-               (uint32_t) fbi->fix.smem_start, fbi->screen_base, fbi->fix.smem_len);
+	dev_dbg(fbi->device, "allocated fb @ p=0x%08x, v=0x%p, size=%d.\n",
+		(uint32_t) fbi->fix.smem_start, fbi->screen_base, fbi->fix.smem_len);
 
-       fbi->screen_size = fbi->fix.smem_len;
+	fbi->screen_size = fbi->fix.smem_len;
 
-       /* Clear the screen */
-       memset((char *)fbi->screen_base, 0, fbi->fix.smem_len);
+	/* Clear the screen */
+	memset((char *)fbi->screen_base, 0, fbi->fix.smem_len);
 
-       return 0;
+	return 0;
 
 err0:
-       fbi->fix.smem_len = 0;
-       fbi->fix.smem_start = 0;
-       fbi->screen_base = NULL;
-       return retval;
+	fbi->fix.smem_len = 0;
+	fbi->fix.smem_start = 0;
+	fbi->screen_base = NULL;
+	return retval;
 }
 
 /**
@@ -1241,13 +1241,13 @@ err0:
  */
 static int mx3fb_unmap_video_memory(struct fb_info *fbi)
 {
-       dma_free_writecombine(fbi->device, fbi->fix.smem_len,
-                             fbi->screen_base, fbi->fix.smem_start);
+	dma_free_writecombine(fbi->device, fbi->fix.smem_len,
+			      fbi->screen_base, fbi->fix.smem_start);
 
-       fbi->screen_base = 0;
-       fbi->fix.smem_start = 0;
-       fbi->fix.smem_len = 0;
-       return 0;
+	fbi->screen_base = 0;
+	fbi->fix.smem_start = 0;
+	fbi->fix.smem_len = 0;
+	return 0;
 }
 
 /**
@@ -1256,249 +1256,249 @@ static int mx3fb_unmap_video_memory(struct fb_info *fbi)
  */
 static struct fb_info *mx3fb_init_fbinfo(struct device *dev, struct fb_ops *ops)
 {
-       struct fb_info *fbi;
-       struct mx3fb_info *mx3fbi;
-       int ret;
+	struct fb_info *fbi;
+	struct mx3fb_info *mx3fbi;
+	int ret;
 
-       /* Allocate sufficient memory for the fb structure */
-       fbi = framebuffer_alloc(sizeof(struct mx3fb_info), dev);
-       if (!fbi)
-               return NULL;
+	/* Allocate sufficient memory for the fb structure */
+	fbi = framebuffer_alloc(sizeof(struct mx3fb_info), dev);
+	if (!fbi)
+		return NULL;
 
-       mx3fbi                  = fbi->par;
-       mx3fbi->cookie          = -EINVAL;
-       mx3fbi->cur_ipu_buf     = 0;
+	mx3fbi                  = fbi->par;
+	mx3fbi->cookie          = -EINVAL;
+	mx3fbi->cur_ipu_buf     = 0;
 
-       fbi->var.activate       = FB_ACTIVATE_NOW;
+	fbi->var.activate       = FB_ACTIVATE_NOW;
 
-       fbi->fbops              = ops;
-       fbi->flags              = FBINFO_FLAG_DEFAULT;
-       fbi->pseudo_palette     = mx3fbi->pseudo_palette;
+	fbi->fbops              = ops;
+	fbi->flags              = FBINFO_FLAG_DEFAULT;
+	fbi->pseudo_palette     = mx3fbi->pseudo_palette;
 
-       mutex_init(&mx3fbi->mutex);
+	mutex_init(&mx3fbi->mutex);
 
-       /* Allocate colormap */
-       ret = fb_alloc_cmap(&fbi->cmap, 16, 0);
-       if (ret < 0) {
-               framebuffer_release(fbi);
-               return NULL;
-       }
+	/* Allocate colormap */
+	ret = fb_alloc_cmap(&fbi->cmap, 16, 0);
+	if (ret < 0) {
+		framebuffer_release(fbi);
+		return NULL;
+	}
 
-       return fbi;
+	return fbi;
 }
 
 static int init_fb_chan(struct mx3fb_data *mx3fb, struct idmac_channel *ichan)
 {
-       struct device *dev = mx3fb->dev;
-       struct mx3fb_platform_data *mx3fb_pdata = dev->platform_data;
-       const char *name = mx3fb_pdata->name;
-       unsigned int irq;
-       struct fb_info *fbi;
-       struct mx3fb_info *mx3fbi;
-       const struct fb_videomode *mode;
-       int ret, num_modes;
+	struct device *dev = mx3fb->dev;
+	struct mx3fb_platform_data *mx3fb_pdata = dev->platform_data;
+	const char *name = mx3fb_pdata->name;
+	unsigned int irq;
+	struct fb_info *fbi;
+	struct mx3fb_info *mx3fbi;
+	const struct fb_videomode *mode;
+	int ret, num_modes;
 
-       ichan->client = mx3fb;
-       irq = ichan->eof_irq;
+	ichan->client = mx3fb;
+	irq = ichan->eof_irq;
 
-       if (ichan->dma_chan.chan_id != IDMAC_SDC_0)
-               return -EINVAL;
+	if (ichan->dma_chan.chan_id != IDMAC_SDC_0)
+		return -EINVAL;
 
-       fbi = mx3fb_init_fbinfo(dev, &mx3fb_ops);
-       if (!fbi)
-               return -ENOMEM;
+	fbi = mx3fb_init_fbinfo(dev, &mx3fb_ops);
+	if (!fbi)
+		return -ENOMEM;
 
-       if (!fb_mode)
-               fb_mode = name;
+	if (!fb_mode)
+		fb_mode = name;
 
-       if (!fb_mode) {
-               ret = -EINVAL;
-               goto emode;
-       }
+	if (!fb_mode) {
+		ret = -EINVAL;
+		goto emode;
+	}
 
-       if (mx3fb_pdata->mode && mx3fb_pdata->num_modes) {
-               mode = mx3fb_pdata->mode;
-               num_modes = mx3fb_pdata->num_modes;
-       } else {
-               mode = mx3fb_modedb;
-               num_modes = ARRAY_SIZE(mx3fb_modedb);
-       }
+	if (mx3fb_pdata->mode && mx3fb_pdata->num_modes) {
+		mode = mx3fb_pdata->mode;
+		num_modes = mx3fb_pdata->num_modes;
+	} else {
+		mode = mx3fb_modedb;
+		num_modes = ARRAY_SIZE(mx3fb_modedb);
+	}
 
-       if (!fb_find_mode(&fbi->var, fbi, fb_mode, mode,
-                         num_modes, NULL, default_bpp)) {
-               ret = -EBUSY;
-               goto emode;
-       }
+	if (!fb_find_mode(&fbi->var, fbi, fb_mode, mode,
+				num_modes, NULL, default_bpp)) {
+		ret = -EBUSY;
+		goto emode;
+	}
 
-       fb_videomode_to_modelist(mode, num_modes, &fbi->modelist);
+	fb_videomode_to_modelist(mode, num_modes, &fbi->modelist);
 
-       /* Default Y virtual size is 2x panel size */
-       fbi->var.yres_virtual = fbi->var.yres * 2;
+	/* Default Y virtual size is 2x panel size */
+	fbi->var.yres_virtual = fbi->var.yres * 2;
 
-       mx3fb->fbi = fbi;
+	mx3fb->fbi = fbi;
 
-       /* set Display Interface clock period */
-       mx3fb_write_reg(mx3fb, 0x00100010L, DI_HSP_CLK_PER);
-       /* Might need to trigger HSP clock change - see 44.3.3.8.5 */
+	/* set Display Interface clock period */
+	mx3fb_write_reg(mx3fb, 0x00100010L, DI_HSP_CLK_PER);
+	/* Might need to trigger HSP clock change - see 44.3.3.8.5 */
 
-       sdc_set_brightness(mx3fb, 255);
-       sdc_set_global_alpha(mx3fb, true, 0xFF);
-       sdc_set_color_key(mx3fb, IDMAC_SDC_0, false, 0);
+	sdc_set_brightness(mx3fb, 255);
+	sdc_set_global_alpha(mx3fb, true, 0xFF);
+	sdc_set_color_key(mx3fb, IDMAC_SDC_0, false, 0);
 
-       mx3fbi                  = fbi->par;
-       mx3fbi->idmac_channel   = ichan;
-       mx3fbi->ipu_ch          = ichan->dma_chan.chan_id;
-       mx3fbi->mx3fb           = mx3fb;
-       mx3fbi->blank           = FB_BLANK_NORMAL;
+	mx3fbi                  = fbi->par;
+	mx3fbi->idmac_channel   = ichan;
+	mx3fbi->ipu_ch          = ichan->dma_chan.chan_id;
+	mx3fbi->mx3fb           = mx3fb;
+	mx3fbi->blank           = FB_BLANK_NORMAL;
 
-       init_completion(&mx3fbi->flip_cmpl);
-       disable_irq(ichan->eof_irq);
-       dev_dbg(mx3fb->dev, "disabling irq %d\n", ichan->eof_irq);
-       ret = mx3fb_set_par(fbi);
-       if (ret < 0)
-               goto esetpar;
+	init_completion(&mx3fbi->flip_cmpl);
+	disable_irq(ichan->eof_irq);
+	dev_dbg(mx3fb->dev, "disabling irq %d\n", ichan->eof_irq);
+	ret = mx3fb_set_par(fbi);
+	if (ret < 0)
+		goto esetpar;
 
-       mx3fb_blank(FB_BLANK_UNBLANK, fbi);
+	mx3fb_blank(FB_BLANK_UNBLANK, fbi);
 
-       dev_info(dev, "mx3fb: fb registered, using mode %s\n", fb_mode);
+	dev_info(dev, "mx3fb: fb registered, using mode %s\n", fb_mode);
 
-       ret = register_framebuffer(fbi);
-       if (ret < 0)
-               goto erfb;
+	ret = register_framebuffer(fbi);
+	if (ret < 0)
+		goto erfb;
 
-       return 0;
+	return 0;
 
 erfb:
 esetpar:
 emode:
-       fb_dealloc_cmap(&fbi->cmap);
-       framebuffer_release(fbi);
+	fb_dealloc_cmap(&fbi->cmap);
+	framebuffer_release(fbi);
 
-       return ret;
+	return ret;
 }
 
 static bool chan_filter(struct dma_chan *chan, void *arg)
 {
-       struct dma_chan_request *rq = arg;
-       struct device *dev;
-       struct mx3fb_platform_data *mx3fb_pdata;
+	struct dma_chan_request *rq = arg;
+	struct device *dev;
+	struct mx3fb_platform_data *mx3fb_pdata;
 
-       if (!rq)
-               return false;
+	if (!rq)
+		return false;
 
-       dev = rq->mx3fb->dev;
-       mx3fb_pdata = dev->platform_data;
+	dev = rq->mx3fb->dev;
+	mx3fb_pdata = dev->platform_data;
 
-       return rq->id == chan->chan_id &&
-               mx3fb_pdata->dma_dev == chan->device->dev;
+	return rq->id == chan->chan_id &&
+		mx3fb_pdata->dma_dev == chan->device->dev;
 }
 
 static void release_fbi(struct fb_info *fbi)
 {
-       mx3fb_unmap_video_memory(fbi);
+	mx3fb_unmap_video_memory(fbi);
 
-       fb_dealloc_cmap(&fbi->cmap);
+	fb_dealloc_cmap(&fbi->cmap);
 
-       unregister_framebuffer(fbi);
-       framebuffer_release(fbi);
+	unregister_framebuffer(fbi);
+	framebuffer_release(fbi);
 }
 
 static int mx3fb_probe(struct platform_device *pdev)
 {
-       struct device *dev = &pdev->dev;
-       int ret;
-       struct resource *sdc_reg;
-       struct mx3fb_data *mx3fb;
-       dma_cap_mask_t mask;
-       struct dma_chan *chan;
-       struct dma_chan_request rq;
-
-       /*
-        * Display Interface (DI) and Synchronous Display Controller (SDC)
-        * registers
-        */
-       sdc_reg = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-       if (!sdc_reg)
-               return -EINVAL;
-
-       mx3fb = kzalloc(sizeof(*mx3fb), GFP_KERNEL);
-       if (!mx3fb)
-               return -ENOMEM;
-
-       spin_lock_init(&mx3fb->lock);
-
-       mx3fb->reg_base = ioremap(sdc_reg->start, resource_size(sdc_reg));
-       if (!mx3fb->reg_base) {
-               ret = -ENOMEM;
-               goto eremap;
-       }
-
-       pr_debug("Remapped %x to %x at %p\n", sdc_reg->start, sdc_reg->end,
-                mx3fb->reg_base);
-
-       /* IDMAC interface */
-       dmaengine_get();
-
-       mx3fb->dev = dev;
-       platform_set_drvdata(pdev, mx3fb);
-
-       rq.mx3fb = mx3fb;
-
-       dma_cap_zero(mask);
-       dma_cap_set(DMA_SLAVE, mask);
-       dma_cap_set(DMA_PRIVATE, mask);
-       rq.id = IDMAC_SDC_0;
-       chan = dma_request_channel(mask, chan_filter, &rq);
-       if (!chan) {
-               ret = -EBUSY;
-               goto ersdc0;
-       }
-
-       ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
-       if (ret < 0)
-               goto eisdc0;
-
-       mx3fb->backlight_level = 255;
-
-       return 0;
+	struct device *dev = &pdev->dev;
+	int ret;
+	struct resource *sdc_reg;
+	struct mx3fb_data *mx3fb;
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	struct dma_chan_request rq;
+
+	/*
+	 * Display Interface (DI) and Synchronous Display Controller (SDC)
+	 * registers
+	 */
+	sdc_reg = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!sdc_reg)
+		return -EINVAL;
+
+	mx3fb = kzalloc(sizeof(*mx3fb), GFP_KERNEL);
+	if (!mx3fb)
+		return -ENOMEM;
+
+	spin_lock_init(&mx3fb->lock);
+
+	mx3fb->reg_base = ioremap(sdc_reg->start, resource_size(sdc_reg));
+	if (!mx3fb->reg_base) {
+		ret = -ENOMEM;
+		goto eremap;
+	}
+
+	pr_debug("Remapped %x to %x at %p\n", sdc_reg->start, sdc_reg->end,
+			mx3fb->reg_base);
+
+	/* IDMAC interface */
+	dmaengine_get();
+
+	mx3fb->dev = dev;
+	platform_set_drvdata(pdev, mx3fb);
+
+	rq.mx3fb = mx3fb;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_PRIVATE, mask);
+	rq.id = IDMAC_SDC_0;
+	chan = dma_request_channel(mask, chan_filter, &rq);
+	if (!chan) {
+		ret = -EBUSY;
+		goto ersdc0;
+	}
+
+	ret = init_fb_chan(mx3fb, to_idmac_chan(chan));
+	if (ret < 0)
+		goto eisdc0;
+
+	mx3fb->backlight_level = 255;
+
+	return 0;
 
 eisdc0:
-       dma_release_channel(chan);
+	dma_release_channel(chan);
 ersdc0:
-       dmaengine_put();
-       iounmap(mx3fb->reg_base);
+	dmaengine_put();
+	iounmap(mx3fb->reg_base);
 eremap:
-       kfree(mx3fb);
-       dev_err(dev, "mx3fb: failed to register fb\n");
-       return ret;
+	kfree(mx3fb);
+	dev_err(dev, "mx3fb: failed to register fb\n");
+	return ret;
 }
 
 static int mx3fb_remove(struct platform_device *dev)
 {
-       struct mx3fb_data *mx3fb = platform_get_drvdata(dev);
-       struct fb_info *fbi = mx3fb->fbi;
-       struct mx3fb_info *mx3_fbi = fbi->par;
-       struct dma_chan *chan;
+	struct mx3fb_data *mx3fb = platform_get_drvdata(dev);
+	struct fb_info *fbi = mx3fb->fbi;
+	struct mx3fb_info *mx3_fbi = fbi->par;
+	struct dma_chan *chan;
 
-       chan = &mx3_fbi->idmac_channel->dma_chan;
-       release_fbi(fbi);
+	chan = &mx3_fbi->idmac_channel->dma_chan;
+	release_fbi(fbi);
 
-       dma_release_channel(chan);
-       dmaengine_put();
+	dma_release_channel(chan);
+	dmaengine_put();
 
-       iounmap(mx3fb->reg_base);
-       kfree(mx3fb);
-       return 0;
+	iounmap(mx3fb->reg_base);
+	kfree(mx3fb);
+	return 0;
 }
 
 static struct platform_driver mx3fb_driver = {
-       .driver = {
-                  .name = MX3FB_NAME,
-       },
-       .probe = mx3fb_probe,
-       .remove = mx3fb_remove,
-       .suspend = mx3fb_suspend,
-       .resume = mx3fb_resume,
+	.driver = {
+		.name = MX3FB_NAME,
+	},
+	.probe = mx3fb_probe,
+	.remove = mx3fb_remove,
+	.suspend = mx3fb_suspend,
+	.resume = mx3fb_resume,
 };
 
 /*
@@ -1509,41 +1509,41 @@ static struct platform_driver mx3fb_driver = {
 static int mx3fb_setup(void)
 {
 #ifndef MODULE
-       char *opt, *options = NULL;
-
-       if (fb_get_options("mx3fb", &options))
-               return -ENODEV;
-
-       if (!options || !*options)
-               return 0;
-
-       while ((opt = strsep(&options, ",")) != NULL) {
-               if (!*opt)
-                       continue;
-               if (!strncmp(opt, "bpp=", 4))
-                       default_bpp = simple_strtoul(opt + 4, NULL, 0);
-               else
-                       fb_mode = opt;
-       }
+	char *opt, *options = NULL;
+
+	if (fb_get_options("mx3fb", &options))
+		return -ENODEV;
+
+	if (!options || !*options)
+		return 0;
+
+	while ((opt = strsep(&options, ",")) != NULL) {
+		if (!*opt)
+			continue;
+		if (!strncmp(opt, "bpp=", 4))
+			default_bpp = simple_strtoul(opt + 4, NULL, 0);
+		else
+			fb_mode = opt;
+	}
 #endif
 
-       return 0;
+	return 0;
 }
 
 static int __init mx3fb_init(void)
 {
-       int ret = mx3fb_setup();
+	int ret = mx3fb_setup();
 
-       if (ret < 0)
-               return ret;
+	if (ret < 0)
+		return ret;
 
-       ret = platform_driver_register(&mx3fb_driver);
-       return ret;
+	ret = platform_driver_register(&mx3fb_driver);
+	return ret;
 }
 
 static void __exit mx3fb_exit(void)
 {
-       platform_driver_unregister(&mx3fb_driver);
+	platform_driver_unregister(&mx3fb_driver);
 }
 
 module_init(mx3fb_init);


