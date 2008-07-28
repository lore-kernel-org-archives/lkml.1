Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYG1PZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYG1PZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYG1PZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:25:07 -0400
Received: from main.gmane.org ([80.91.229.2]:33481 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYG1PZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:25:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH 1/3] Blackfin EMAC Driver: add proper __devinit/__devexit
 markings
Date: Mon, 28 Jul 2008 18:21:13 +0300
Message-ID: <488DE3E9.3000703@teltonika.lt>
References: <1217169905-7055-1-git-send-email-cooloney@kernel.org> <1217169905-7055-2-git-send-email-cooloney@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: netdev@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 82-135-208-232.static.zebra.lt
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
In-Reply-To: <1217169905-7055-2-git-send-email-cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/net/bfin_mac.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
> index 4144343..17951cb 100644
> --- a/drivers/net/bfin_mac.c
> +++ b/drivers/net/bfin_mac.c
> @@ -956,7 +956,7 @@ static int bfin_mac_close(struct net_device *dev)
>  	return 0;
>  }
>  
> -static int __init bfin_mac_probe(struct platform_device *pdev)
> +static int __devinit bfin_mac_probe(struct platform_device *pdev)

__init was OK here.
__devinit is for hotplug devices

>  {
>  	struct net_device *ndev;
>  	struct bfin_mac_local *lp;
> @@ -1082,7 +1082,7 @@ out_err_probe_mac:
>  	return rc;
>  }
>  
> -static int bfin_mac_remove(struct platform_device *pdev)
> +static int __devexit bfin_mac_remove(struct platform_device *pdev)

__devexit is for hotplug, use __exit

>  {
>  	struct net_device *ndev = platform_get_drvdata(pdev);
>  	struct bfin_mac_local *lp = netdev_priv(ndev);
> @@ -1129,7 +1129,7 @@ static int bfin_mac_resume(struct platform_device *pdev)
>  
>  static struct platform_driver bfin_mac_driver = {
>  	.probe = bfin_mac_probe,

.probe shouldn't be declared here. And you should use
platform_device_probe() instead of platform_device_add()

> -	.remove = bfin_mac_remove,
> +	.remove = __devexit_p(bfin_mac_remove),

should be __exit_p()

>  	.resume = bfin_mac_resume,
>  	.suspend = bfin_mac_suspend,
>  	.driver = {

