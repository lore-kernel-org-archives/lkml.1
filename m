Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYEZL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYEZL6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbYEZL62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:58:28 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47129 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbYEZL61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:58:27 -0400
Date: Mon, 26 May 2008 13:58:26 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Toralf F?rster <toralf.foerster@gmx.de>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  MTD: fix 2 "unused variables" warnings  in
	drivers/mtd/nand/cafe_nand.c
Message-ID: <20080526115825.GA6722@Chamillionaire.breakpoint.cc>
References: <200805261347.55492.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200805261347.55492.toralf.foerster@gmx.de>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Toralf F?rster | 2008-05-26 13:47:51 [+0200]:

>--- a/drivers/mtd/nand/cafe_nand.c
>+++ b/drivers/mtd/nand/cafe_nand.c
>@@ -626,9 +626,7 @@ static int __devinit cafe_nand_probe(struct pci_dev *pdev,
> {
>        struct mtd_info *mtd;
>        struct cafe_priv *cafe;
>-       struct mtd_partition *parts;
>        uint32_t ctrl;
>-       int nr_parts;
>        int err = 0;
>
>        /* Very old versions shared the same PCI ident for all three
>@@ -800,6 +798,9 @@ static int __devinit cafe_nand_probe(struct pci_dev *pdev,
>        add_mtd_device(mtd);
>
> #ifdef CONFIG_MTD_PARTITIONS
>+       struct mtd_partition *parts;
>+       int nr_parts;
>+
You can't declare variables in the middle of the code, can you?

>        nr_parts = parse_mtd_partitions(mtd, part_probes, &parts, 0);
>        if (nr_parts > 0) {
>                cafe->parts = parts;

Sebastian
