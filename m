Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606Ab0AINvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0AINvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302Ab0AINvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:51:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:17936 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0AINvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=sfJ4DaZZ8iL9vv4NAIBG79S1SXR9G/5giYcr51WZpgJp+BrC4Wx+ooJ416Othjl4EG
         igrvOt4E6lFrjLJuY0dudTJJt69IDHNIshVqd7wQVlut3HdypZu3qbQrm33ukEOZ7pmA
         0B/bs8k79FkaVeqpR/xsaHMfplcXdyG4Mw4qQ=
Message-ID: <4B488ABF.4070403@gmail.com>
Date: Sat, 09 Jan 2010 14:55:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP: dma_chan[lch_head].flag & OMAP_DMA_ACTIVE tested twice
 in omap_dma_unlink_lch()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same flag and bits were tested twice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/plat-omap/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Is this what was intended? please review.

diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 09d82b3..728c642 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -1183,7 +1183,7 @@ void omap_dma_unlink_lch(int lch_head, int lch_queue)
 	}
 
 	if ((dma_chan[lch_head].flags & OMAP_DMA_ACTIVE) ||
-	    (dma_chan[lch_head].flags & OMAP_DMA_ACTIVE)) {
+	    (dma_chan[lch_queue].flags & OMAP_DMA_ACTIVE)) {
 		printk(KERN_ERR "omap_dma: You need to stop the DMA channels "
 		       "before unlinking\n");
 		dump_stack();
