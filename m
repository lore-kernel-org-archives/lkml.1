Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYGJCDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYGJCDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYGJCDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:03:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbYGJCC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:02:59 -0400
Date: Wed, 9 Jul 2008 18:56:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters for
 AMD IOMMU
Message-Id: <20080709185634.08c60937.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:52 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds two parameters to the kernel command line to control behavior
> of the AMD IOMMU.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index d7a75bf..ec6f13b 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -789,3 +789,37 @@ void __init amd_iommu_detect(void)
>  	}
>  }
>  
> +static int __init parse_amd_iommu_options(char *str)
> +{
> +	for (; *str; ++str) {
> +		if (strcmp(str, "off") == 0)
> +			amd_iommu_disable = 1;
> +		if (strcmp(str, "isolate") == 0)
> +			amd_iommu_isolate = 1;
> +	}
> +
> +	return 1;
> +}
> +
> +static int __init parse_amd_iommu_size_options(char *str)
> +{
> +	for (; *str; ++str) {
> +		if (strcmp(str, "32M") == 0)
> +			amd_iommu_aperture_order = 25;
> +		if (strcmp(str, "64M") == 0)
> +			amd_iommu_aperture_order = 26;
> +		if (strcmp(str, "128M") == 0)
> +			amd_iommu_aperture_order = 27;
> +		if (strcmp(str, "256M") == 0)
> +			amd_iommu_aperture_order = 28;
> +		if (strcmp(str, "512M") == 0)
> +			amd_iommu_aperture_order = 29;
> +		if (strcmp(str, "1G") == 0)
> +			amd_iommu_aperture_order = 30;
> +	}
> +
> +	return 1;
> +}
> +
> +__setup("amd_iommu=", parse_amd_iommu_options);
> +__setup("amd_iommu_size=", parse_amd_iommu_size_options);

Please document kernel boot parameters in Documentation/kernel-parameters.txt.

I think you just reimplemented memparse().
