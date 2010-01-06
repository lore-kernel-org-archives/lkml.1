Return-Path: <linux-kernel-owner+w=401wt.eu-S933167Ab0AFXy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab0AFXy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133Ab0AFXy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:54:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59349 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab0AFXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:54:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B4522BE.7050902@jp.fujitsu.com>
Date: Thu, 07 Jan 2010 08:54:38 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI: hotplug, fix memory leaks
References: <1262796476-17737-1-git-send-email-jslaby@suse.cz> <1262796476-17737-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1262796476-17737-2-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good catch.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Jiri Slaby wrote:
> Stanse found a cut&pasted memory leak in pciehp_queue_pushbutton_work
> and shpchp_queue_pushbutton_work. info is not freed/assigned on all
> paths. Fix that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/hotplug/pciehp_ctrl.c |    1 +
>  drivers/pci/hotplug/shpchp_ctrl.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
> index d6ac1b2..9a7f247 100644
> --- a/drivers/pci/hotplug/pciehp_ctrl.c
> +++ b/drivers/pci/hotplug/pciehp_ctrl.c
> @@ -341,6 +341,7 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
>  		p_slot->state = POWERON_STATE;
>  		break;
>  	default:
> +		kfree(info);
>  		goto out;
>  	}
>  	queue_work(pciehp_wq, &info->work);
> diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
> index b8ab279..86f6276 100644
> --- a/drivers/pci/hotplug/shpchp_ctrl.c
> +++ b/drivers/pci/hotplug/shpchp_ctrl.c
> @@ -462,6 +462,7 @@ void shpchp_queue_pushbutton_work(struct work_struct *work)
>  		p_slot->state = POWERON_STATE;
>  		break;
>  	default:
> +		kfree(info);
>  		goto out;
>  	}
>  	queue_work(shpchp_wq, &info->work);


