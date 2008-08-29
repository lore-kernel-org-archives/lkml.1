Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbYH2CqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbYH2CqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 22:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYH2CqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 22:46:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43952 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYH2CqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 22:46:00 -0400
Message-ID: <48B76287.5070404@jp.fujitsu.com>
Date: Fri, 29 Aug 2008 11:44:23 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [2.6 patch] fix pciehp_free_irq()
References: <20080827220526.GR11734@cs181140183.pp.htv.fi>
In-Reply-To: <20080827220526.GR11734@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes an obvious bug (loop was never entered) caused by
> commit 820943b6fc4781621dee52ba026106758a727dd3
> (pciehp: cleanup pcie_poll_cmd).
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 0cca78f4b7c7d6c7b64ae5acc08bb641454b4835 
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index ab31f5b..9d934dd 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -250,23 +250,23 @@ static inline void pciehp_free_irq(struct controller *ctrl)
>  static int pcie_poll_cmd(struct controller *ctrl)
>  {
>  	u16 slot_status;
>  	int timeout = 1000;
>  
>  	if (!pciehp_readw(ctrl, SLOTSTATUS, &slot_status)) {
>  		if (slot_status & CMD_COMPLETED) {
>  			pciehp_writew(ctrl, SLOTSTATUS, CMD_COMPLETED);
>  			return 1;
>  		}
>  	}
> -	while (timeout > 1000) {
> +	while (timeout > 0) {
>  		msleep(10);
>  		timeout -= 10;
>  		if (!pciehp_readw(ctrl, SLOTSTATUS, &slot_status)) {
>  			if (slot_status & CMD_COMPLETED) {
>  				pciehp_writew(ctrl, SLOTSTATUS, CMD_COMPLETED);
>  				return 1;
>  			}
>  		}
>  	}
>  	return 0;	/* timeout */
>  }
> 
> 

Sorry, that's my bad.
Thank you for the patch, Adrian.

Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Thanks,
Kenji Kaneshige


