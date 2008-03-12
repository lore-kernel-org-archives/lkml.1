Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYCLQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYCLQad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYCLQaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:30:04 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:43254 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYCLQaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tKgbNDvP2hor/uI5Fl++/ZBVJ04g7cBF1BP4LiG4uqPqo39AhjTxuYh8IhDFGhSKWEdG4O17BprkwngxyQNy19ibCpul31FOUHPCr9QxQnBo5s3fadn7LKmv9q+MtixRkdwNTQZtjuJECQmRMQM8vEXi7RTHtQuRsPZWQvajxJI=
Message-ID: <e9c3a7c20803120929l41b9fec8m34db73d6e034461a@mail.gmail.com>
Date: Wed, 12 Mar 2008 09:29:58 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei" <Wei.Zhang@freescale.com>
Subject: Re: [PATCH] Fix fsldma.c warning messages when it's compiled underPPC64.
Cc: "Olof Johansson" <olof@lixom.net>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AECE526A@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1205146045-17342-1-git-send-email-wei.zhang@freescale.com>
	 <20080311142247.GA18915@lixom.net>
	 <ABF87B0B6A38C0458E319AC973ED68AECE526A@zch01exm26.fsl.freescale.net>
X-Google-Sender-Auth: d514a49908eec64a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 7:10 PM, Zhang Wei <Wei.Zhang@freescale.com> wrote:
>  The reason is the val will be assigned to SR register, and SR register
>   is a 32-bit only register.

If this is the case then why not disable the driver for PPC_64?

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 27340a7..89db937 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -40,6 +40,7 @@ config INTEL_IOP_ADMA
 config FSL_DMA
        bool "Freescale MPC85xx/MPC83xx DMA support"
        depends on PPC
+       depends on !PPC_64
        select DMA_ENGINE
        ---help---
          Enable support for the Freescale DMA engine. Now, it support

--
Dan
