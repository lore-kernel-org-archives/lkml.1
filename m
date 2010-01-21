Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261Ab0AUN6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0AUN6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866Ab0AUN6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:58:51 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:43769 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab0AUN6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:58:50 -0500
Date: Thu, 21 Jan 2010 14:58:47 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, ok@artecdesign.ee,
       sarah.a.sharp@linux.intel.com,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] Obsolete config in kernel source (USB_HCD_DMA)
Message-ID: <20100121135847.GA25890@stud.informatik.uni-erlangen.de>
References: <20100120123540.GB3580@faui49.informatik.uni-erlangen.de> <4B571122.6060407@ru.mvista.com> <20100120083806.25b69d9f.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120083806.25b69d9f.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 08:38:06AM -0800, Randy Dunlap wrote:
> On Wed, 20 Jan 2010 17:20:18 +0300 Sergei Shtylyov wrote:
> >
> >    The patch's subject should be a terse description of change, not the 
> > substitute for the lengthy description as in your case.
> 
> Also please insert patches inline in the email body instead of using
> attachments.  mutt can surely do this -- people do it all the time
> (though I don't use mutt, so please don't ask me how).

---
>From 2e5a8a322a6cd74ecb77eda8f0a09a0a01c6dbc6 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 20 Jan 2010 13:32:36 +0100
Subject: [PATCH] remove code block depending on unreferenced config item USB_HCD_DMA

The configuration Option USB_HCD_DMA is not reachable in KConfig so
this piece of Code is effectively dead and useless. Remove it to avoid
confusion.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/usb/host/isp1362-hcd.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 73352f3..341db2c 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2716,24 +2716,11 @@ static int __init isp1362_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-#ifdef CONFIG_USB_HCD_DMA
-	if (pdev->dev.dma_mask) {
-		struct resource *dma_res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-
-		if (!dma_res) {
-			retval = -ENODEV;
-			goto err1;
-		}
-		isp1362_hcd->data_dma = dma_res->start;
-		isp1362_hcd->max_dma_size = resource_len(dma_res);
-	}
-#else
 	if (pdev->dev.dma_mask) {
 		DBG(1, "won't do DMA");
 		retval = -ENODEV;
 		goto err1;
 	}
-#endif
 
 	if (!request_mem_region(addr->start, resource_len(addr), hcd_name)) {
 		retval = -EBUSY;
-- 
1.6.3.3

