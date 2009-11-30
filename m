Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZK3Nc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZK3Nc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZK3Nc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:32:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57512 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753034AbZK3Ncy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:32:54 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] matroxfb: Fix problems with display stability
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Nov 2009 13:13:26 +0000
Message-ID: <20091130130921.26634.96600.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression caused in 2.6.23 and then despite repeated requests never fixed
or dealt with (Petr promised to sort it in 2008 but seems to have
forgotten).

Enough is enough - remove the problem line that was added. If it upsets
someone they've had two years to deal with it and at the very least it'll
rattle their cage and wake them up.

Closes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=9709
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: <stable@kernel.org>
---

 drivers/video/matrox/g450_pll.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/video/matrox/g450_pll.c b/drivers/video/matrox/g450_pll.c
index 09f6e04..c15f8a5 100644
--- a/drivers/video/matrox/g450_pll.c
+++ b/drivers/video/matrox/g450_pll.c
@@ -368,7 +368,8 @@ static int __g450_setclk(struct matrox_fb_info *minfo, unsigned int fout,
 					M1064_XDVICLKCTRL_C1DVICLKEN |
 					M1064_XDVICLKCTRL_DVILOOPCTL |
 					M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
-				matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp);
+                                /* Setting this breaks PC systems so don't do it */
+				/* matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp); */
 				matroxfb_DAC_out(minfo, M1064_XPWRCTRL,
 						 xpwrctrl);
 

