Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0CCIhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:37:25 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:62659 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab0CCIhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:37:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=UpD3lRnE+KaBhs3Pz3xR25f1yRzPY9aztSWA5NnfMLdhiGzWb/NmTWziqGnsAmYHpA
         YtGSvPCrJZ9nhO6Ui50sFVUrstNWkL/K2s2BGfLFg87EchG5kq6sGLnow7tA5k7e3WB4
         KOm94wv7ZpOP9xItRapKf/Xc3OmTx0dmvl5AI=
Date: Wed, 3 Mar 2010 11:31:28 +0300
From: Dan Carpenter <error27@gmail.com>
To: imunsie@au1.ibm.com
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
       "David S. Miller" <davem@davemloft.net>,
       Andreas Eversberg <andreas@eversberg.eu>, Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] Explicitly ignore unused return value of
	_hfcpci_softirq
Message-ID: <20100303083128.GA17283@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, imunsie@au1.ibm.com,
	linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Eversberg <andreas@eversberg.eu>,
	Andreas Mohr <andi@lisas.de>
References: <1267574453-7228-1-git-send-email-imunsie@au.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267574453-7228-1-git-send-email-imunsie@au.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:00:53AM +1100, imunsie@au1.ibm.com wrote:
> From: Ian Munsie <imunsie@au.ibm.com>
> 
> The compiler throws the following warning during compilation:
> 
> drivers/isdn/hardware/mISDN/hfcpci.c:2319: warning: ignoring return value of 'driver_for_each_device', declared with attribute warn_unused_result
> 
> driver_for_each_device is being used to call _hfcpci_softirq for each
> device, which will only ever return 0.
> This patch explicitly ignores the return value to silence the warning.
> 
> Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
> ---
>  drivers/isdn/hardware/mISDN/hfcpci.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> index 70e6b0e..1333d4a 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -2316,7 +2316,8 @@ _hfcpci_softirq(struct device *dev, void *arg)
>  static void
>  hfcpci_softirq(void *arg)
>  {
> -	(void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
> +	int err;
> +	err = driver_for_each_device(&hfc_driver.driver, NULL, arg,
>  					_hfcpci_softirq);
>  

Could you name the variable "dummy" instead of "err"?  Every few months I go through 
and look for code like what you have done here and it sucks to try figure out if 
people are ignoring the errors on purpose or not.

regards,
dan carpenter

>  	/* if next event would be in the past ... */
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
