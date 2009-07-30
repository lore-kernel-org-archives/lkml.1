Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZG3LKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZG3LKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZG3LKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:10:20 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:35417 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZG3LKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:10:19 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2009 07:10:18 EDT
Date: Thu, 30 Jul 2009 15:00:52 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       stanley.miao@windriver.com, rmk+kernel@arm.linux.org.uk,
       madhu.cr@ti.com, felipe.balbi@nokia.com
Subject: Re: [PATCH] missing mutex unlock
Message-ID: <20090730110048.GA24094@2ka.mipt.ru>
References: <1248947838-20087-1-git-send-email-sgayda2@uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248947838-20087-1-git-send-email-sgayda2@uiuc.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 04:57:18AM -0500, Stoyan Gaydarov (sgayda2@uiuc.edu) wrote:
> This was found using a semantic patch, more info can be found at:
> http://www.emn.fr/x-info/coccinelle/
> 
> Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>

Yup, that's correct.
Ack, thank you.

Andrew, please apply.

> ---
>  drivers/w1/masters/omap_hdq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
> index a7e3b70..0d92969 100644
> --- a/drivers/w1/masters/omap_hdq.c
> +++ b/drivers/w1/masters/omap_hdq.c
> @@ -687,6 +687,7 @@ static int omap_hdq_remove(struct platform_device *pdev)
>  
>  	if (hdq_data->hdq_usecount) {
>  		dev_dbg(&pdev->dev, "removed when use count is not zero\n");
> +		mutex_unlock(&hdq_data->hdq_mutex);
>  		return -EBUSY;
>  	}
>  
> -- 
> 1.6.3.3
