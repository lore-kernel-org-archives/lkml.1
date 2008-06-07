Return-Path: <linux-kernel-owner+w=401wt.eu-S1762516AbYFGQIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762516AbYFGQIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 12:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYFGQIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 12:08:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:39626 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYFGQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 12:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eg2SrfB7Ycv4VFU8hOLqGk1XcKtGPutravo6esopoCUIy6cFNaKAlAAtEnQhRyALey
         DV1eJg4H83fb8+PfVIEM0w3ONAnPFF7gwI8hhp2yrplLpyWYIz316zfx4mHpJRLV7g80
         xDmM/LP+kf5/BrBu2tJJi+nnf7jHrxlpn5NLg=
Message-ID: <cd73a99e0806070908n5c9b6be4ned0386905555a1b7@mail.gmail.com>
Date: Sat, 7 Jun 2008 18:08:07 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 4/8] atmel_nand: Clean up and fix probe() error path
Cc: linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Patrice VILCHEZ" <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
	 <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Haavard,

> This fixes several bugs in the atmel_nand_probe() error path, including
> at least one memory leak.

There is an issue with the current at91_nand driver here.

The driver currently ioremap()'s the ECC controller's registers, but
on the AT91 the ECC controller is part of the System Peripherals and
so it is already mapped at startup.
I don't think it can/should be remapped twice.

The AT91 patch (on maxim.org.za) current does:
    regs = platform_get_resource(pdev, IORESOURCE_MEM, 1);
         ....
    host->ecc = (void __force __iomem *) (AT91_VA_BASE_SYS - AT91_BASE_SYS);
    host->ecc += regs->start;
instead of the ioremap().  But this is not portable to the AVR32.


Regards,
  Andrew Victor
