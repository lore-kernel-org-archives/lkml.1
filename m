Return-Path: <linux-kernel-owner+w=401wt.eu-S1751509AbXBVIiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbXBVIiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXBVIiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:38:01 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:53797 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbXBVIh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=WmAtgI2hT9S2ovHKplfWLesf/yiKNbxObf46i0LXGPu+HFqmfMz0qHexfVrWXGQDvZILWoGqiSuvOnSmZ6rD9x5g9SsyQcl7TjBDHha9KPuqtjvWJ04oQfotI7r1gMINAe0jG1o1YnsQtM8JZosGF2AphhZpQte+Mxp7MN9qC5A=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
	 <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-DVDz1mYr0iiR+Spjp4iw"
Date: Thu, 22 Feb 2007 16:40:45 +0800
Message-Id: <1172133646.4086.5.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DVDz1mYr0iiR+Spjp4iw
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-02-22 at 09:01 +0100, Giuseppe Bilotta wrote:
> On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Wed, 2007-02-07 at 00:08 +0100, Giuseppe Bilotta wrote:
> > >
> > > As mentioned in another post in this thread, I can't get any info out
> > > of the i2c busses, because even when I have them available (i.e. after
> > > loading nvidiafb) I get XXXX all around (on all three of them).
> > > Suggestions on how to get the information welcome.
> >
> > Is this the same monitor you posted here?
> >
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=112807065616218&w=2
> >
> > If yes, we already have the manufacturer and model code. The main
> > problem is that the EDID of this display has no sync range (H: 75-75kHz
> > and V: 60-60Hz).  Extending Hsync from 30-75kHz as a fix to the EDID
> > block shouldn't be too hard.
> 
> Yes, that's it! Jeepers, I can't believe that even re-reading the past
> LKML posts (even those!) I couldn't find the EDID info and how we had
> gotten them. I guess I need stronger glasses.
> 
> Wonder why Luca's proposed patch makes the EDID undetectable, now, and
> why can't it be retrieved at a later time via i2c. Timeouts too small?
> 
> > I already have a patch for this which I forgot to send to you
> > before :-).  If you can confirm that this is still the same hardware,
> > I'll send you a test patch
> 
> Yes, it's the same hardware. I can try the patch, with or without Luca's.
> 
> 

Okay. Patch attached.  You may want to #define DEBUG in
drivers/video/fbmon.c so we can appreciate what happens. Load nvidiafb
with DEBUG defined before and after applying the patch, then send your
'dmesg'.

Tony

--=-DVDz1mYr0iiR+Spjp4iw
Content-Disposition: attachment; filename=fbmon_add_sharp_uxga
Content-Type: text/plain; name=fbmon_add_sharp_uxga; charset=utf-8
Content-Transfer-Encoding: 7bit

fbdev: Add Ultrasharp UXGA to broken monitor database

From:  <>

This particular monitor does not have a limits block and has only one set of
monitor timings. Fix by adding a limits block to the EDID and extend the
horizontal sync frequency range to 30 kHz and 75 Khz.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---

 drivers/video/fbmon.c |  168 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 112 insertions(+), 56 deletions(-)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 6b385c3..05a9464 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -48,8 +48,9 @@ #else
 #define DPRINTK(fmt, args...)
 #endif
 
-#define FBMON_FIX_HEADER 1
-#define FBMON_FIX_INPUT  2
+#define FBMON_FIX_HEADER  1
+#define FBMON_FIX_INPUT   2
+#define FBMON_FIX_TIMINGS 3
 
 #ifdef CONFIG_FB_MODE_HELPERS
 struct broken_edid {
@@ -71,6 +72,12 @@ static const struct broken_edid brokendb
 		.model        = 0x5a44,
 		.fix          = FBMON_FIX_INPUT,
 	},
+	/* Sharp UXGA? */
+	{
+		.manufacturer = "SHP",
+		.model        = 0x138e,
+		.fix          = FBMON_FIX_TIMINGS,
+	},
 };
 
 static const unsigned char edid_v1_header[] = { 0x00, 0xff, 0xff, 0xff,
@@ -87,6 +94,55 @@ static void copy_string(unsigned char *c
   while (i-- && (*--s == 0x20)) *s = 0;
 }
 
+static int edid_is_serial_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xff) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_ascii_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xfe) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_limits_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xfd) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_monitor_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xfc) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_timing_block(unsigned char *block)
+{
+	if ((block[0] != 0x00) || (block[1] != 0x00) ||
+	    (block[2] != 0x00) || (block[4] != 0x00))
+		return 1;
+	else
+		return 0;
+}
+
 static int check_edid(unsigned char *edid)
 {
 	unsigned char *block = edid + ID_MANUFACTURER_NAME, manufacturer[4];
@@ -104,9 +160,6 @@ static int check_edid(unsigned char *edi
 	for (i = 0; i < ARRAY_SIZE(brokendb); i++) {
 		if (!strncmp(manufacturer, brokendb[i].manufacturer, 4) &&
 			brokendb[i].model == model) {
-			printk("fbmon: The EDID Block of "
-			       "Manufacturer: %s Model: 0x%x is known to "
-			       "be broken,\n",  manufacturer, model);
  			fix = brokendb[i].fix;
  			break;
 		}
@@ -115,8 +168,10 @@ static int check_edid(unsigned char *edi
 	switch (fix) {
 	case FBMON_FIX_HEADER:
 		for (i = 0; i < 8; i++) {
-			if (edid[i] != edid_v1_header[i])
+			if (edid[i] != edid_v1_header[i]) {
 				ret = fix;
+				break;
+			}
 		}
 		break;
 	case FBMON_FIX_INPUT:
@@ -126,14 +181,33 @@ static int check_edid(unsigned char *edi
 		if (b[4] & 0x01 && b[0] & 0x80)
 			ret = fix;
 		break;
+	case FBMON_FIX_TIMINGS:
+		b = edid + DETAILED_TIMING_DESCRIPTIONS_START;
+
+		for (i = 0; i < 4; i++) {
+			if (edid_is_limits_block(b)) {
+				ret = fix;
+				break;
+			}
+
+			b += DETAILED_TIMING_DESCRIPTION_SIZE;
+		}
+
+		break;
 	}
 
+	if (ret)
+		printk("fbmon: The EDID Block of "
+		       "Manufacturer: %s Model: 0x%x is known to "
+		       "be broken,\n",  manufacturer, model);
+
 	return ret;
 }
 
 static void fix_edid(unsigned char *edid, int fix)
 {
-	unsigned char *b;
+	int i;
+	unsigned char *b, csum = 0;
 
 	switch (fix) {
 	case FBMON_FIX_HEADER:
@@ -145,6 +219,37 @@ static void fix_edid(unsigned char *edid
 		b = edid + EDID_STRUCT_DISPLAY;
 		b[0] &= ~0x80;
 		edid[127] += 0x80;
+		break;
+	case FBMON_FIX_TIMINGS:
+		printk("fbmon: trying to fix monitor timings\n");
+		b = edid + DETAILED_TIMING_DESCRIPTIONS_START;
+		for (i = 0; i < 4; i++) {
+			if (!(edid_is_serial_block(b) ||
+			      edid_is_ascii_block(b) ||
+			      edid_is_monitor_block(b) ||
+			      edid_is_timing_block(b))) {
+				b[0] = 0x00;
+				b[1] = 0x00;
+				b[2] = 0x00;
+				b[3] = 0xfd;
+				b[4] = 0x00;
+				b[5] = 60;   /* vfmin */
+				b[6] = 60;   /* vfmax */
+				b[7] = 30;   /* hfmin */
+				b[8] = 75;   /* hfmax */
+				b[9] = 17;   /* pixclock - 170 MHz*/
+				b[10] = 0;   /* GTF */
+				break;
+			}
+
+			b += DETAILED_TIMING_DESCRIPTION_SIZE;
+		}
+
+		for (i = 0; i < EDID_LENGTH - 1; i++)
+			csum += edid[i];
+
+		edid[127] = 256 - csum;
+		break;
 	}
 }
 
@@ -273,46 +378,6 @@ static void get_chroma(unsigned char *bl
 	DPRINTK("WhiteY:   0.%03d\n", specs->chroma.whitey);
 }
 
-static int edid_is_serial_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xff) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
-static int edid_is_ascii_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xfe) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
-static int edid_is_limits_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xfd) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
-static int edid_is_monitor_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xfc) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
 static void calc_mode_timings(int xres, int yres, int refresh,
 			      struct fb_videomode *mode)
 {
@@ -795,15 +860,6 @@ static void get_monspecs(unsigned char *
 	}
 }
 
-static int edid_is_timing_block(unsigned char *block)
-{
-	if ((block[0] != 0x00) || (block[1] != 0x00) ||
-	    (block[2] != 0x00) || (block[4] != 0x00))
-		return 1;
-	else
-		return 0;
-}
-
 int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
 {
 	int i;

--=-DVDz1mYr0iiR+Spjp4iw--

