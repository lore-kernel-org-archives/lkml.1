Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYCUV4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYCUV4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbYCUVzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:55:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:9367 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbYCUVzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=qWx+P2KM0WvFPhuIpsZwPcEg//8dTnsjkThNcr4ue+41g9+fo2YjfqOPReQbeDlCwtwHNaBDD7H/CeIpdZnVEgGKY/n7mZNv+3WrO7n8oaWqPoMG9u8Z7tPszDpwj21bETY4uINM1yKFY6gCpdE112le75G9aoGRgm8R3TA9ctU=
Date: Fri, 21 Mar 2008 22:55:45 +0100 (CET)
To: linux-usb@vger.kernel.org
cc: Roman Weissgaerber <weissg@vienna.at>,
       Lennert Buytenhek <kernel@wantstofly.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] test for NULL return from platform_get_resource() in
 ohci_hcd_sm501_drv_remove()
Message-ID: <alpine.LNX.1.00.0803212250210.9597@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


platform_get_resource() may return null, so although it seems it will never
do so here unless there's a bug elsewhere, it does no harm to be defensive 
and test.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 ohci-sm501.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index a970701..1ffc272 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -199,7 +199,8 @@ static int ohci_hcd_sm501_drv_remove(struct platform_device *pdev)
 	usb_put_hcd(hcd);
 	dma_release_declared_memory(&pdev->dev);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(mem->start, mem->end - mem->start + 1);
+	if (mem)
+		release_mem_region(mem->start, mem->end - mem->start + 1);
 
 	/* mask interrupts and disable power */
 


