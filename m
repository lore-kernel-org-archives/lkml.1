Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab0BYTWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:22:11 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:52631 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab0BYTWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:22:06 -0500
Date: Thu, 25 Feb 2010 11:21:59 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Zhang Wei <zw@zh-kernel.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [async_tx-next PATCH 1/2] fsldma: Fix cookie issues
Message-ID: <20100225192159.GA32092@ovro.caltech.edu>
References: <1266860431-17310-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266860431-17310-1-git-send-email-steve@digidescorp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 25 Feb 2010 11:22:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 11:40:31AM -0600, Steven J. Magnani wrote:
> fsl_dma_tx_submit() only sets the cookie on the first descriptor of a
> transaction. It should set the cookie on all.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> --- a/drivers/dma/fsldma.c	2010-02-22 11:16:36.000000000 -0600
> +++ b/drivers/dma/fsldma.c	2010-02-22 11:24:01.000000000 -0600
> @@ -362,7 +362,7 @@ static dma_cookie_t fsl_dma_tx_submit(st
>  		if (cookie < 0)
>  			cookie = 1;
>  
> -		desc->async_tx.cookie = cookie;
> +		child->async_tx.cookie = cookie;
>  	}
>  
>  	chan->common.cookie = cookie;
> 

This looks correct to me. I'm not sure I ever tested the driver with a
chained struct dma_async_tx_descriptor.

Ira
