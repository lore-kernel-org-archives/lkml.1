Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZENNyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZENNyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZENNyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:54:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:45229 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZENNyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:54:08 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fJzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJMZMS-04-J9L-01
Date: Thu, 14 May 2009 15:47:17 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Neil Turton <nturton@solarflare.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] Fixed an off-by-one error in the AMD IOMMU driver.
Message-ID: <20090514134717.GL9835@amd.com>
References: <4A0C15F3.1090601@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A0C15F3.1090601@solarflare.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 May 2009 13:47:17.0647 (UTC) FILETIME=[7EEFD9F0:01C9D49A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 02:00:35PM +0100, Neil Turton wrote:
> The variable amd_iommu_last_bdf holds the maximum bdf of any device
> controlled by an IOMMU, so the number of device entries needed is
> amd_iommu_last_bdf+1.  The function tbl_size used amd_iommu_last_bdf
> instead.  This would be a problem if the last device were a large
> enough power of 2.
> 
> Signed-off-by: Neil Turton <nturton@solarflare.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index 42c33ce..61479ba 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -175,7 +175,7 @@ static inline void update_last_devid(u16 devid)
>  static inline unsigned long tbl_size(int entry_size)
>  {
>  	unsigned shift = PAGE_SHIFT +
> -			 get_order(amd_iommu_last_bdf * entry_size);
> +			 get_order(((int)amd_iommu_last_bdf+1) * entry_size);
> 
>  	return 1UL << shift;
>  }

Applied, thanks Neil.

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

