Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbZENNry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbZENNry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZENNro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:47:44 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:6828 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751970AbZENNro convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:47:44 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fJzz1202hzzz32i6bh43j)
X-FB-SS: 5,13,8,
X-WSS-ID: 0KJMZN3-02-5K5-01
Date: Thu, 14 May 2009 15:47:30 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Neil Turton <nturton@solarflare.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] Fixed the handling of device aliases in the AMD IOMMU
	driver.
Message-ID: <20090514134730.GM9835@amd.com>
References: <4A0C17BB.4010300@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A0C17BB.4010300@solarflare.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 May 2009 13:47:31.0193 (UTC) FILETIME=[8702CE90:01C9D49A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 02:08:11PM +0100, Neil Turton wrote:
> The devid parameter to set_dev_entry_from_acpi is the requester ID
> rather than the device ID since it is used to index the IOMMU device
> table.  The handling of IVHD_DEV_ALIAS used to pass the device ID.
> This patch fixes it to pass the requester ID.
> 
> Signed-off-by: Neil Turton <nturton@solarflare.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index 61479ba..c013906 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -618,7 +618,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
>  		case IVHD_DEV_ALIAS:
>  			devid = e->devid;
>  			devid_to = e->ext >> 8;
> -			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
> +			set_dev_entry_from_acpi(iommu, devid_to, e->flags, 0);
>  			amd_iommu_alias_table[devid] = devid_to;
>  			break;
>  		case IVHD_DEV_ALIAS_RANGE:

Applied too, thanks.

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

