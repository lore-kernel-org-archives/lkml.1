Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYGJHE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYGJHE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYGJHET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:04:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:48015 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYGJHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:04:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fss5cxvPonoWpen5qm7qmMV8Dl1x+qs2w0p16tXUVxzCunFBY4waobKSE+ykaPDZ81
         uBdXhqCdpY5+rw/HV7Km/B27c6QSazxyJikj9JCxtw6xA3hheWIedCgKWp7hEfYeOiJs
         7ungaCZe7jusucCHs0FBS45bXXdHXCUBze+V0=
Message-ID: <86802c440807100004y539fab5evb83511cba7a373c2@mail.gmail.com>
Date: Thu, 10 Jul 2008 00:04:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters for AMD IOMMU
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
In-Reply-To: <1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	 <1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 12:27 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
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
>        }
>  }
>
> +static int __init parse_amd_iommu_options(char *str)
> +{
> +       for (; *str; ++str) {
> +               if (strcmp(str, "off") == 0)
> +                       amd_iommu_disable = 1;
> +               if (strcmp(str, "isolate") == 0)
> +                       amd_iommu_isolate = 1;
> +       }
> +
> +       return 1;
> +}
> +
> +static int __init parse_amd_iommu_size_options(char *str)
> +{
> +       for (; *str; ++str) {
> +               if (strcmp(str, "32M") == 0)
> +                       amd_iommu_aperture_order = 25;
> +               if (strcmp(str, "64M") == 0)
> +                       amd_iommu_aperture_order = 26;
> +               if (strcmp(str, "128M") == 0)
> +                       amd_iommu_aperture_order = 27;
> +               if (strcmp(str, "256M") == 0)
> +                       amd_iommu_aperture_order = 28;
> +               if (strcmp(str, "512M") == 0)
> +                       amd_iommu_aperture_order = 29;
> +               if (strcmp(str, "1G") == 0)
> +                       amd_iommu_aperture_order = 30;
> +       }

could use
memparse(str, &str);

and weight...

YH
