Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYCMGxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYCMGxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYCMGw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:52:58 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38130 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYCMGw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:52:57 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] Fix fsldma.c warning messages when it's compiled underPPC64.
Date: Thu, 13 Mar 2008 14:52:56 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AED32DBF@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20803120929l41b9fec8m34db73d6e034461a@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix fsldma.c warning messages when it's compiled underPPC64.
Thread-Index: AciEXlc0lwMHxs1bTLyE6aJvwYSbngAeBBAA
References: <1205146045-17342-1-git-send-email-wei.zhang@freescale.com> <20080311142247.GA18915@lixom.net> <ABF87B0B6A38C0458E319AC973ED68AECE526A@zch01exm26.fsl.freescale.net> <e9c3a7c20803120929l41b9fec8m34db73d6e034461a@mail.gmail.com>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Olof Johansson" <olof@lixom.net>, <sfr@canb.auug.org.au>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan, 

I just consider if it could be reused on Freescale's 64bit processor in the future.
If we don't care this, I can let the driver only depends on PPC32.

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 27340a7..449c0ae 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -39,7 +39,7 @@ config INTEL_IOP_ADMA
 
 config FSL_DMA
        bool "Freescale MPC85xx/MPC83xx DMA support"
-       depends on PPC
+       depends on PPC32
        select DMA_ENGINE
        ---help---
          Enable support for the Freescale DMA engine. Now, it support

Thanks!
Wei.

> -----Original Message-----
> From: dan.j.williams@gmail.com 
> 
> On Tue, Mar 11, 2008 at 7:10 PM, Zhang Wei 
> <Wei.Zhang@freescale.com> wrote:
> >  The reason is the val will be assigned to SR register, and 
> SR register
> >   is a 32-bit only register.
> 
> If this is the case then why not disable the driver for PPC_64?
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 27340a7..89db937 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -40,6 +40,7 @@ config INTEL_IOP_ADMA
>  config FSL_DMA
>         bool "Freescale MPC85xx/MPC83xx DMA support"
>         depends on PPC
> +       depends on !PPC_64
>         select DMA_ENGINE
>         ---help---
>           Enable support for the Freescale DMA engine. Now, it support
> 
> --
> Dan
> 
