Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYCQPli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYCQPli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYCQPl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:41:28 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:33216 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYCQPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:41:27 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: [PATCH] i810fb: Fix console switch regression
Date: Mon, 17 Mar 2008 16:41:10 +0100
User-Agent: KMail/1.9.5
References: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de> <Pine.LNX.4.64.0803162042460.7207@anakin> <200803170920.33626.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200803170920.33626.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171641.10750.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.4 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 2da4cb75faf7b3f12212370ffd4cc0ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for the spaces in the second patch, here's a clean one with tabs.

---
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>

Since 4c7ffe0b9f7f40bd818fe3af51342f64c483908e ("fbdev: prevent drivers that 
have hardware cursors from calling software cursor code") every call of 
i810fb_cursor fails with -ENXIO because of a incorrect "!".

This hasn't striked until eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 ("fix ! 
versus & precedence in various places") surrounded the expression with 
braces, so that the intended behavior was inverted. That caused 'pixel 
waste' - the same line of multi-colored pixels repeated over the whole 
screen - during console switch.

This switches back to the original pre-4c7ffe0 behavior.

Signed-off-by: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Antonino Daplas <adaplas@pol.net>

--- linux-2.6/drivers/video/i810/i810_main.c.orig
+++ linux-2.6/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info 
 	struct i810fb_par *par = info->par;
 	u8 __iomem *mmio = par->mmio_start_virtual;
 
-	if (!(par->dev_flags & LOCKUP))
+	if (par->dev_flags & LOCKUP)
 		return -ENXIO;
 
 	if (cursor->image.width > 64 || cursor->image.height > 64)
