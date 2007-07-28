Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbXG1PTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbXG1PTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 11:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbXG1PTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 11:19:30 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:28683 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXG1PT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 11:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DuByglLYP20hJlsbYfm2/LLlcK6QSHkd7xkHoPmWW7NKCBQ8wpfdudbs6M27R6eTPqvGbW5stZUGL59ean1om2Wx3LQcG9/HcAeLvZTDudY3VCiws/O3KX3XjPdmnen0mNYGu37h2nvl7kYxhTye37fkfkye5sD0D1I3DsEjwu8=
Message-ID: <8b67d60707280819k4a33e17axda16c006b3a60417@mail.gmail.com>
Date: Sat, 28 Jul 2007 16:19:26 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: lethal@users.sourceforge.net
Subject: [PATCH] Documentation - update Documentation/fb/pvr2fb.txt
Cc: linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current version is very old and does not correctly specify how to
set the video mode.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/Documentation/fb/pvr2fb.txt b/Documentation/fb/pvr2fb.txt
index 2bf6c23..1489f9b 100644
--- a/Documentation/fb/pvr2fb.txt
+++ b/Documentation/fb/pvr2fb.txt
@@ -9,14 +9,13 @@ one found in the Dreamcast.
 Advantages:

  * It provides a nice large console (128 cols + 48 lines with 1024x768)
-   without using tiny, unreadable fonts.
+   without using tiny, unreadable fonts (NOT on the Dreamcast)
  * You can run XF86_FBDev on top of /dev/fb0
  * Most important: boot logo :-)

 Disadvantages:

- * Driver is currently limited to the Dreamcast PowerVR 2 implementation
-   at the time of this writing.
+ * Driver is largely untested on non-Dremcast systems.

 Configuration
 =============
@@ -29,11 +28,15 @@ Accepted options:
 font:X    - default font to use. All fonts are supported, including the
             SUN12x22 font which is very nice at high resolutions.

-mode:X    - default video mode. The following video modes are supported:
-            640x240-60, 640x480-60.
+mode:X    - default video mode with format [xres]x[yres]-<bpp>@<refresh rate>
+            The following video modes are supported:
+            640x640-16@60, 640x480-24@60, 640x480-32@60. The Dreamcast
+           defaults to 640x480-16@60. At the time of writing the
+            24bpp and 32bpp modes function poorly. Work to fix that is
+            ongoing

             Note: the 640x240 mode is currently broken, and should not be
-            used for any reason. It is only mentioned as a reference.
+            used for any reason. It is only mentioned here as a reference.

 inverse   - invert colors on screen (for LCD displays)

@@ -52,10 +55,10 @@ output:X  - output type. This can be any of the
following: pal, ntsc, and
 X11
 ===

-XF86_FBDev should work, in theory. At the time of this writing it is
-totally untested and may or may not even portray the beginnings of
-working. If you end up testing this, please let me know!
+XF86_FBDev has been shown to work on the Dremcast in the past - though not yet
+on any 2.6 series kernel.

 --
 Paul Mundt <lethal@linuxdc.org>
+Updated by Adrian McMenamin <adrian@mcmen.demon.co.uk>
