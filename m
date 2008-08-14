Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYHNSmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYHNSmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHNSmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:42:14 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:37192 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYHNSmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:42:13 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 1/4] AMD IOMMU: use status bit instead of memory write-back for completion wait
Date: Thu, 14 Aug 2008 20:35:30 +0200
User-Agent: KMail/1.9.9
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
References: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com> <1218736518-25301-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1218736518-25301-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808142035.32422.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Thursday 14 August 2008, Joerg Roedel wrote:
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 22d7d05..028e945 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -122,9 +119,15 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
>  
>  	while (!ready && (i < EXIT_LOOP_COUNT)) {
>  		++i;
> -		cpu_relax();

Could you elaborate, why you had to remove this?

Busy waiting loops should always do cpu_relay()
to reduce heat procution and power consumption while idle.

> +		/* wait for the bit to become one */
> +		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
> +		ready = status & MMIO_STATUS_COM_WAIT_INT_MASK;
>  	}
>  

Best Regards

Ingo Oeser
