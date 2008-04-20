Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYDTIcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYDTIcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYDTIbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:31:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:51200 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYDTIbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XFkeTHp02ONOCur1y6MNFr2XaeEBYp5p1ZQNH6uv00d00wmsI+q6Zc14C4AMPnbQflimh4d91F0Y4LtjoQC14xrwMPmJKUXEPKpAZHsyrSc+oDqCm4gE1VEK2Oxn1aI9LfcbljbWxzHFb6MhNCdBTzAfLY2Is4HjnzuJsrLuk6g=
Date: Sun, 20 Apr 2008 12:31:10 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [PATCH 5/5] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080420083110.GA353@doriath.ww600.siemens.net>
References: <20080420082925.GA32739@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420082925.GA32739@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/net/irda/pxaficp_ir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index 8db71ab..1aae2d6 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -815,7 +815,7 @@ static int pxa_irda_probe(struct platform_device *pdev)
 	si->dev = &pdev->dev;
 	si->pdata = pdev->dev.platform_data;
 
-	si->sir_clk = clk_get(&pdev->dev, "UARTCLK");
+	si->sir_clk = clk_get(&pdev->dev, "STUARTCLK");
 	si->fir_clk = clk_get(&pdev->dev, "FICPCLK");
 	if (IS_ERR(si->sir_clk) || IS_ERR(si->fir_clk)) {
 		err = PTR_ERR(IS_ERR(si->sir_clk) ? si->sir_clk : si->fir_clk);
-- 
1.5.4.4


-- 
With best wishes
Dmitry

