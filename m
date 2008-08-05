Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbYHEN00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbYHEN00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbYHEN0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:26:19 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34010 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736AbYHEN0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:26:18 -0400
Date: Tue, 5 Aug 2008 15:26:09 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: full list of unused CONFIGs under drivers/
Message-ID: <20080805152609.1119f0b1@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <alpine.LFD.1.10.0808031737280.16642@localhost.localdomain>
References: <alpine.LFD.1.10.0808031737280.16642@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Aug 2008 13:26:10.0755 (UTC) FILETIME=[D351F930:01C8F6FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> ===== MTD_NAND_ATMEL_ECC_SOFT
> drivers/mtd/nand/Kconfig:313:config MTD_NAND_ATMEL_ECC_SOFT

It may be unreferenced, but it behaves as expected. It's part of a set
of three mutually exclusive choices, so after checking for the two
others, there's no point checking for the last one.

Of course, we could apply the patch below ;-)

Haavard

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 3387e0d..d5775a9 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -47,6 +47,10 @@
 #define no_ecc		0
 #endif
 
+#ifdef CONFIG_MTD_NAND_ATMEL_ECC_SOFT
+/* Avoid incessant nagging */
+#endif
+
 /* Register access macros */
 #define ecc_readl(add, reg)				\
 	__raw_readl(add + ATMEL_ECC_##reg)
