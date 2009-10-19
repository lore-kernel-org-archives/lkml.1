Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZJSBP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZJSBP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 21:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZJSBP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 21:15:29 -0400
Received: from outbound-mail-301.bluehost.com ([67.222.53.8]:56397 "HELO
	outbound-mail-301.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751389AbZJSBP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 21:15:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:X-Identified-User;
	b=OK1xGhJDiTAcxzOnvJmfFSthKJZ4YKao2IZHvrKXRDsp1TjvqV2toocDwqKAlqjvvlfW6nZ2YL1Crp5OH7rkvJ9sAfgipRcGxD5q9udrvUsf+h357N5IHRfIVHXIytzj;
Date: Mon, 19 Oct 2009 10:15:26 +0900
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Theodore Tso <tytso@mit.edu>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091019101526.5496d5ed@jbarnes-x200>
In-Reply-To: <20091019100437.22b6ea36@jbarnes-x200>
References: <20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
	<20091012120510.16bd1194@jbarnes-g45>
	<20091013023146.GA8414@mit.edu>
	<20091013100135.2b3d914f@jbarnes-g45>
	<20091013190055.GI8175@mit.edu>
	<20091013121426.35f409ff@jbarnes-g45>
	<20091014142252.009d03a5@jbarnes-g45>
	<20091015022645.GA8286@mit.edu>
	<20091015040204.GE8286@mit.edu>
	<20091019100437.22b6ea36@jbarnes-x200>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/MX4dRcj5ra6H=OIy=bwrKaD"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 220.106.13.183 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/MX4dRcj5ra6H=OIy=bwrKaD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 19 Oct 2009 10:04:37 +0900
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thu, 15 Oct 2009 00:02:04 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Wed, Oct 14, 2009 at 10:26:45PM -0400, Theodore Tso wrote:
> > > 
> > > If I need to live with a display glitch every 5-10 minutes or so
> > > to get better power savings, I'll take it....
> > > 
> > 
> > While mail reading and composing responses in a tty based mail
> > reader (mutt/emacs -nw), I'm seeing display glitches every 3-5
> > minutes.  Each time it's quite minor so it's the sort of thing
> > which is definitely "blink at the wrong time and you'll miss it".
> > 
> > Being a battery lifetime freak, I'll definitely take the tradeoff,
> > but given that it occurs even when I'm plugged into AC mains, I
> > could see some users being annoyed by it, and I could see them
> > wanting to be able to switch off the feature when they are on AC,
> > if we find a complete fix.
> 
> Ok, hopefully this is the "correct" patch.  It works for me, can you
> give it a try?

Here's an even more "final" patchset with some spurious hunks removed.

Thanks,
Jesse

--MP_/MX4dRcj5ra6H=OIy=bwrKaD
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-drm-i915-enable-self-refresh-on-965.patch

>From 4744d54c2cf813ebda8e4362c4361d13edf3cac0 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@jbarnes-x200.(none)>
Date: Mon, 19 Oct 2009 10:08:17 +0900
Subject: [PATCH 1/2] drm/i915: enable self-refresh on 965

Need to calculate the SR watermark and enable it.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 0466ddb..0bdd711 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1790,6 +1790,7 @@
 #define   DSPARB_AEND_SHIFT	0
 
 #define DSPFW1			0x70034
+#define   DSPFW_SR_SHIFT	23
 #define DSPFW2			0x70038
 #define DSPFW3			0x7003c
 #define   IGD_SELF_REFRESH_EN	(1<<30)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index a0f6bbe..7a18cbb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2445,15 +2445,38 @@ static void g4x_update_wm(struct drm_device *dev, int unused, int unused2,
 	I915_WRITE(FW_BLC_SELF, fw_blc_self);
 }
 
-static void i965_update_wm(struct drm_device *dev, int unused, int unused2,
-			   int unused3, int unused4)
+static void i965_update_wm(struct drm_device *dev, int planea_clock,
+			   int planeb_clock, int sr_hdisplay, int pixel_size)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned long line_time_us;
+	int sr_clock, sr_entries, srwm = 1;
+
+	/* Calc sr entries for one plane configs */
+	if (sr_hdisplay && (!planea_clock || !planeb_clock)) {
+		/* self-refresh has much higher latency */
+		const static int sr_latency_ns = 12000;
+
+		sr_clock = planea_clock ? planea_clock : planeb_clock;
+		line_time_us = ((sr_hdisplay * 1000) / sr_clock);
+
+		/* Use ns/us then divide to preserve precision */
+		sr_entries = (((sr_latency_ns / line_time_us) + 1) *
+			      pixel_size * sr_hdisplay) / 1000;
+		sr_entries = roundup(sr_entries / I915_FIFO_LINE_SIZE, 1);
+		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
+		srwm = I945_FIFO_SIZE - sr_entries;
+		if (srwm < 0)
+			srwm = 1;
+		srwm &= 0x3f;
+		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	}
 
-	DRM_DEBUG("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR 8\n");
+	DRM_DEBUG("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n", srwm);
 
 	/* 965 has limitations... */
-	I915_WRITE(DSPFW1, (8 << 16) | (8 << 8) | (8 << 0));
+	I915_WRITE(DSPFW1, (srwm << DSPFW_SR_SHIFT) | (8 << 16) | (8 << 8) |
+		   (8 << 0));
 	I915_WRITE(DSPFW2, (8 << 8) | (8 << 0));
 }
 
-- 
1.6.3.3


--MP_/MX4dRcj5ra6H=OIy=bwrKaD
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0002-drm-i915-add-FIFO-watermark-support-for-G4x.patch

>From 8133f2e34daefea6b54932af8626d3cf3f3c5b0f Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@jbarnes-x200.(none)>
Date: Mon, 19 Oct 2009 10:09:33 +0900
Subject: [PATCH 2/2] drm/i915: add FIFO watermark support for G4x

Turns out G4x needs to have sensible watermarks set, especially for
self-refresh enabled modes.  Add support for it.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_reg.h      |   11 +++++
 drivers/gpu/drm/i915/intel_display.c |   80 ++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 0bdd711..a4d791d 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1791,17 +1791,28 @@
 
 #define DSPFW1			0x70034
 #define   DSPFW_SR_SHIFT	23
+#define   DSPFW_CURSORB_SHIFT	16
+#define   DSPFW_PLANEB_SHIFT	8
 #define DSPFW2			0x70038
+#define   DSPFW_CURSORA_MASK	0x00003f00
+#define   DSPFW_CURSORA_SHIFT	16
 #define DSPFW3			0x7003c
+#define   DSPFW_HPLL_SR_EN	(1<<31)
+#define   DSPFW_CURSOR_SR_SHIFT	24
 #define   IGD_SELF_REFRESH_EN	(1<<30)
 
 /* FIFO watermark sizes etc */
+#define G4X_FIFO_LINE_SIZE	64
 #define I915_FIFO_LINE_SIZE	64
 #define I830_FIFO_LINE_SIZE	32
+
+#define G4X_FIFO_SIZE		127
 #define I945_FIFO_SIZE		127 /* 945 & 965 */
 #define I915_FIFO_SIZE		95
 #define I855GM_FIFO_SIZE	127 /* In cachelines */
 #define I830_FIFO_SIZE		95
+
+#define G4X_MAX_WM		0x3f
 #define I915_MAX_WM		0x3f
 
 #define IGD_DISPLAY_FIFO	512 /* in 64byte unit */
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7a18cbb..5419cab 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2142,6 +2142,13 @@ static struct intel_watermark_params igd_cursor_hplloff_wm = {
 	IGD_CURSOR_GUARD_WM,
 	IGD_FIFO_LINE_SIZE
 };
+static struct intel_watermark_params g4x_wm_info = {
+	G4X_FIFO_SIZE,
+	G4X_MAX_WM,
+	G4X_MAX_WM,
+	2,
+	G4X_FIFO_LINE_SIZE,
+};
 static struct intel_watermark_params i945_wm_info = {
 	I945_FIFO_SIZE,
 	I915_MAX_WM,
@@ -2432,17 +2439,74 @@ static int i830_get_fifo_size(struct drm_device *dev, int plane)
 	return size;
 }
 
-static void g4x_update_wm(struct drm_device *dev, int unused, int unused2,
-			  int unused3, int unused4)
+static void g4x_update_wm(struct drm_device *dev,  int planea_clock,
+			  int planeb_clock, int sr_hdisplay, int pixel_size)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 fw_blc_self = I915_READ(FW_BLC_SELF);
+	int total_size, cacheline_size;
+	int planea_wm, planeb_wm, cursora_wm, cursorb_wm, cursor_sr;
+	struct intel_watermark_params planea_params, planeb_params;
+	unsigned long line_time_us;
+	int sr_clock, sr_entries = 0, entries_required;
 
-	if (i915_powersave)
-		fw_blc_self |= FW_BLC_SELF_EN;
-	else
-		fw_blc_self &= ~FW_BLC_SELF_EN;
-	I915_WRITE(FW_BLC_SELF, fw_blc_self);
+	/* Create copies of the base settings for each pipe */
+	planea_params = planeb_params = g4x_wm_info;
+
+	/* Grab a couple of global values before we overwrite them */
+	total_size = planea_params.fifo_size;
+	cacheline_size = planea_params.cacheline_size;
+
+	/*
+	 * Note: we need to make sure we don't overflow for various clock &
+	 * latency values.
+	 * clocks go from a few thousand to several hundred thousand.
+	 * latency is usually a few thousand
+	 */
+	entries_required = ((planea_clock / 1000) * pixel_size * latency_ns) /
+		1000;
+	entries_required /= G4X_FIFO_LINE_SIZE;
+	planea_wm = entries_required + planea_params.guard_size;
+
+	entries_required = ((planeb_clock / 1000) * pixel_size * latency_ns) /
+		1000;
+	entries_required /= G4X_FIFO_LINE_SIZE;
+	planeb_wm = entries_required + planeb_params.guard_size;
+
+	cursora_wm = cursorb_wm = 16;
+	cursor_sr = 32;
+
+	DRM_DEBUG("FIFO watermarks - A: %d, B: %d\n", planea_wm, planeb_wm);
+
+	/* Calc sr entries for one plane configs */
+	if (sr_hdisplay && (!planea_clock || !planeb_clock)) {
+		/* self-refresh has much higher latency */
+		const static int sr_latency_ns = 12000;
+
+		sr_clock = planea_clock ? planea_clock : planeb_clock;
+		line_time_us = ((sr_hdisplay * 1000) / sr_clock);
+
+		/* Use ns/us then divide to preserve precision */
+		sr_entries = (((sr_latency_ns / line_time_us) + 1) *
+			      pixel_size * sr_hdisplay) / 1000;
+		sr_entries = roundup(sr_entries / cacheline_size, 1);
+		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
+		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	}
+
+	DRM_DEBUG("Setting FIFO watermarks - A: %d, B: %d, SR %d\n",
+		  planea_wm, planeb_wm, sr_entries);
+
+	planea_wm &= 0x3f;
+	planeb_wm &= 0x3f;
+
+	I915_WRITE(DSPFW1, (sr_entries << DSPFW_SR_SHIFT) |
+		   (cursorb_wm << DSPFW_CURSORB_SHIFT) |
+		   (planeb_wm << DSPFW_PLANEB_SHIFT) | planea_wm);
+	I915_WRITE(DSPFW2, (I915_READ(DSPFW2) & DSPFW_CURSORA_MASK) |
+		   (cursora_wm << DSPFW_CURSORA_SHIFT));
+	/* HPLL off in SR has some issues on G4x... disable it */
+	I915_WRITE(DSPFW3, (I915_READ(DSPFW3) & ~DSPFW_HPLL_SR_EN) |
+		   (cursor_sr << DSPFW_CURSOR_SR_SHIFT));
 }
 
 static void i965_update_wm(struct drm_device *dev, int planea_clock,
-- 
1.6.3.3


--MP_/MX4dRcj5ra6H=OIy=bwrKaD--
