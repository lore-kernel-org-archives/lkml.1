Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYCPTfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYCPTfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYCPTe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:34:58 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:56577 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYCPTe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:34:57 -0400
X-Greylist: delayed 3138 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2008 15:34:57 EDT
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Antonino Daplas <adaplas@pol.net>
Subject: [PATCH] i810fb: Fix console switch regression
Date: Sun, 16 Mar 2008 19:42:24 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 771
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.4 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 5ce44a36c4f4b1c7ddfb73cb65031a54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>

Commit eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 ("fix ! versus & precedence in 
various places") introduced a regression in console switching when using 
i810fb. Every 5th to 10th console switch causes 'pixel waste' - the same line 
of multi-colored pixels repeated over the whole screen.
This reverts eaa0ff1 for i810_main.c.

Signed-off-by: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Cc: Antonino Daplas <adaplas@pol.net>

---
As I'm not subscribed to the LKML, please CC me, thanks.

--- linux-2.6/drivers/video/i810/i810_main.c.orig
+++ linux-2.6/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info 
	struct i810fb_par *par = info->par;
	u8 __iomem *mmio = par->mmio_start_virtual;

-	if (!(par->dev_flags & LOCKUP))
+	if (!par->dev_flags & LOCKUP)
		return -ENXIO;

	if (cursor->image.width > 64 || cursor->image.height > 64)
