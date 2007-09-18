Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXIREaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXIREaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbXIRE37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:29:59 -0400
Received: from smtp101.plus.mail.re1.yahoo.com ([69.147.102.64]:28909 "HELO
	smtp101.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751672AbXIRE36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:29:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=v1GWMOJYBWMcIvNFkFcl2VDFeIG6gfbGBNnn2qiiiXixY4O+0xoLy/jk81TyH7GkG9DfHm/yGZ3L+upvk+xbd47c1Ox58ZIo/Ldxiu70Ph553NH2cmgkNC2l/S24kPkR3h9RyCoa17vWEAmp6zALjoiLdMdF7ZMciiUMVw2RcU0=  ;
X-YMail-OSG: B6cWOUoVM1lIj_5JlypQUr3Wypd3eOCO6XDlggD2dYEZU8DO20l85si0TbNB0Y45SxLBw1ht3g--
Date: Tue, 18 Sep 2007 06:29:19 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v1
Message-ID: <20070918042919.GA8998@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches remove redundant DMA_..BIT_MASK definitions across two drivers.
In this version of the patches, the computation of the bitmasks is done by
the compiler.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

--
Index: 23-rc6/include/linux/dma-mapping.h
===================================================================
--- 23-rc6/include/linux/dma-mapping.h.orig	2007-09-17 17:48:20.000000000 +0200
+++ 23-rc6/include/linux/dma-mapping.h	2007-09-18 06:12:33.000000000 +0200
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
+#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
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
