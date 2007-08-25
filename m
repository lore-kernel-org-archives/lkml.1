Return-Path: <linux-kernel-owner+w=401wt.eu-S933995AbXHYJOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbXHYJOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933172AbXHYJOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:14:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47452 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765066AbXHYJN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:13:59 -0400
Date: Sat, 25 Aug 2007 11:13:58 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] atyfb: force 29MHz xtal on G3 PowerBooks
Message-ID: <20070825091358.GA12235@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The atyfb does not work on my 233MHz PowerBook with Mach64 LP, when the
kernel is booted from firmware. aty_ld_pll_ct() returns 0x22 and xtal
remains at 14.31818. When booted from MacOS, aty_ld_pll_ct() returns 0x3c
and xtal is changed to 29.498928.
Google indicates that all 4 PowerBook models need the higher value.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2411,7 +2411,7 @@ static int __devinit aty_init(struct fb_
 				diff1 = -diff1;
 			if (diff2 < 0)
 				diff2 = -diff2;
-			if (diff2 < diff1) {
+			if (diff2 < diff1 || (M64_HAS(G3_PB_1024x768))) {
 				par->ref_clk_per = 1000000000000ULL / 29498928;
 				xtal = "29.498928";
 			}
