Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXIRGQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXIRGQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbXIRGQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:16:49 -0400
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:24622 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754446AbXIRGQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:16:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=yBrVtX1HZDdKoWtmnlcH75tiyez6BooqlR0YCCK+1W0Qs4Q9F+yNW8eOYMGVv/00bRrI8q00KD8u59+FHMBuSa4NbuEe1Hetv5b+iqJNbuf9mrhNGvcK07nf44w8hZqKLGTP/nYlA1gbqH0vPCDP5Y8KSV2noK4UmGEtO2eOGhU=  ;
X-YMail-OSG: F.zon2kVM1l3ToW3c9xhzHsjU2eMU2ZvvNsLzi9k6wVbYG.PNnGp.JxCgkRTip3IO7BJaK.PQQ--
Date: Tue, 18 Sep 2007 08:16:09 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v2
Message-ID: <20070918061609.GA15940@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches remove redundant DMA_..BIT_MASK definitions across
two drivers. In this version of the patches, the computation
of the majority of the bitmasks is done by the compiler.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>

---
 23-rc6/include/linux/dma-mapping.h |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

Index: b/23-rc6/include/linux/dma-mapping.h
===================================================================
--- a/23-rc6/include/linux/dma-mapping.h	2007-09-17 17:48:20.000000000 +0200
+++ b/23-rc6/include/linux/dma-mapping.h	2007-09-18 08:11:19.000000000 +0200
@@ -13,16 +13,19 @@
 	DMA_NONE = 3,
 };
 
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#define DMA_48BIT_MASK	0x0000ffffffffffffULL
-#define DMA_40BIT_MASK	0x000000ffffffffffULL
-#define DMA_39BIT_MASK	0x0000007fffffffffULL
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_31BIT_MASK	0x000000007fffffffULL
-#define DMA_30BIT_MASK	0x000000003fffffffULL
-#define DMA_29BIT_MASK	0x000000001fffffffULL
-#define DMA_28BIT_MASK	0x000000000fffffffULL
-#define DMA_24BIT_MASK	0x0000000000ffffffULL
+#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
+
+#define DMA_64BIT_MASK	~0ULL
+#define DMA_48BIT_MASK	DMA_BIT_MASK(48)
+#define DMA_40BIT_MASK	DMA_BIT_MASK(40)
+#define DMA_39BIT_MASK	DMA_BIT_MASK(39)
+#define DMA_35BIT_MASK	DMA_BIT_MASK(35)
+#define DMA_32BIT_MASK	DMA_BIT_MASK(32)
+#define DMA_31BIT_MASK	DMA_BIT_MASK(31)
+#define DMA_30BIT_MASK	DMA_BIT_MASK(30)
+#define DMA_29BIT_MASK	DMA_BIT_MASK(29)
+#define DMA_28BIT_MASK	DMA_BIT_MASK(28)
+#define DMA_24BIT_MASK	DMA_BIT_MASK(24)
 
 static inline int valid_dma_direction(int dma_direction)
 {

-- 
Regards/Gruß,
    Boris.
