Return-Path: <linux-kernel-owner+w=401wt.eu-S964872AbZKYOaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbZKYOaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934728AbZKYOae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:30:34 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:59960 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934708AbZKYOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:30:33 -0500
MIME-Version: 1.0
In-Reply-To: <20091125212959.601673f5.sfr@canb.auug.org.au>
References: <20091125212959.601673f5.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 25 Nov 2009 07:30:19 -0700
X-Google-Sender-Auth: 264bee4f2a39d307
Message-ID: <fa686aa40911250630h764c4f26xb2e7cc735261e987@mail.gmail.com>
Subject: Re: linux-next: spi tree build warning
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?=22Richard_R=F6jfors=22?= 
	<richard.rojfors@mocean-labs.com>,
       spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 3:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
>
> drivers/spi/xilinx_spi.c: In function 'xilinx_spi_init':
> drivers/spi/xilinx_spi.c:411: warning: cast from pointer to integer of different size
>
> Maybe introduced by commit 8387f616c653f878b33d859310a8ed5c568505ee
> ("xilinx_spi: Split into of driver and generic part").

Trivial fix committed to next-spi branch:

diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index b927812..9f38637 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -408,8 +408,8 @@ struct spi_master *xilinx_spi_init(struct device *dev, struc
                goto free_irq;
        }

-       dev_info(dev, "at 0x%08X mapped to 0x%08X, irq=%d\n",
-               (u32)mem->start, (u32)xspi->regs, xspi->irq);
+       dev_info(dev, "at 0x%08llX mapped to 0x%p, irq=%d\n",
+               (unsigned long long)mem->start, xspi->regs, xspi->irq);
        return master;

 free_irq:
