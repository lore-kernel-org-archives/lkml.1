Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZGVRAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZGVRAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZGVRAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:00:03 -0400
Received: from mail.vyatta.com ([76.74.103.46]:51896 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZGVRAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:00:00 -0400
Date: Wed, 22 Jul 2009 09:59:53 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: netdev@vger.kernel.org, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michael Guntsche <mike@it-loops.com>
Subject: Re: [PATCH] NET / skge: Enable WoL by default if supported
Message-ID: <20090722095953.0806bea2@nehalam>
In-Reply-To: <200907221458.55616.rjw@sisk.pl>
References: <200907221458.55616.rjw@sisk.pl>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 14:58:55 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If skge hardware is capable of waking up the system from sleep,
> enable magic packet WoL during driver initialisation.
> 
> This makes WoL work without calling 'ethtool -s ethX wol g'
> for each adapter.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Tested-by: Michael Guntsche <mike@it-loops.com>
> ---
>  drivers/net/skge.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/net/skge.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/skge.c
> +++ linux-2.6/drivers/net/skge.c
> @@ -3856,8 +3856,10 @@ static struct net_device *skge_devinit(s
>  	skge->speed = -1;
>  	skge->advertising = skge_supported_modes(hw);
>  
> -	if (device_may_wakeup(&hw->pdev->dev))
> +	if (device_can_wakeup(&hw->pdev->dev)) {
>  		skge->wol = wol_supported(hw) & WAKE_MAGIC;
> +		device_set_wakeup_enable(&hw->pdev->dev, skge->wol);
> +	}
>  
>  	hw->dev[port] = dev;
>  

Acked-by: Stephen Hemminger <shemminger@vyatta.com>
-- 
