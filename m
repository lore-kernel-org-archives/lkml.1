Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXIKFPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXIKFPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXIKFPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:15:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757585AbXIKFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:15:34 -0400
Date: Mon, 10 Sep 2007 22:15:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGPGART] intel_agp: fix GTT map size on G33
Message-Id: <20070910221502.dba1d5ce.akpm@linux-foundation.org>
In-Reply-To: <20070905071307.GB5817@zhen-devel.sh.intel.com>
References: <20070905071307.GB5817@zhen-devel.sh.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007 15:13:07 +0800 Zhenyu Wang <zhenyu.z.wang@intel.com> wrote:

> 
> Subject: [PATCH] [AGPGART] intel_agp: fix GTT map size on G33
> 
> G33 has 1MB GTT table range. Fix GTT mapping
> in case like 512MB aperture size.
> 
> Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
> ---
>  drivers/char/agp/intel-agp.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index 20d50d0..6a5c555 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -919,6 +919,7 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
>  	struct aper_size_info_fixed *size;
>  	int num_entries;
>  	u32 temp, temp2;
> +	int gtt_map_size = 256 * 1024;
>  
>  	size = agp_bridge->current_size;
>  	page_order = size->page_order;
> @@ -928,7 +929,9 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
>  	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
>  	pci_read_config_dword(intel_private.pcidev, I915_PTEADDR,&temp2);
>  
> -	intel_private.gtt = ioremap(temp2, 256 * 1024);
> +	if (IS_G33)
> +	    gtt_map_size = 1024 * 1024; /* 1M on G33 */
> +	intel_private.gtt = ioremap(temp2, gtt_map_size);
>  	if (!intel_private.gtt)
>  		return -ENOMEM;
>  

Ditto.  What happens if this patch isn't in 2.6.23?  And is it applicable to
and needed in 2.6.22?
