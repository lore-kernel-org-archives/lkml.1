Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbYBUFpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbYBUFpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 00:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYBUFpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 00:45:07 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44656 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYBUFpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 00:45:05 -0500
Message-ID: <47BD1069.1060109@keyaccess.nl>
Date: Thu, 21 Feb 2008 06:47:21 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Adrian Bunk <bunk@kernel.org>, ambx1@neo.rr.com,
       linux-kernel@vger.kernel.org
Subject: Re: pnp_bus_resume(): inconsequent NULL checking
References: <20080219224908.GM31955@cs181133002.pp.htv.fi> <47BB6DAB.5050506@keyaccess.nl> <200802200959.21814.bjorn.helgaas@hp.com>
In-Reply-To: <200802200959.21814.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-02-08 17:59, Bjorn Helgaas wrote:

> I agree with you that we can just delete the dev->protocol tests
> completely. So I'd rather see something like this (built but untested):
> 
> 
> PNP: remove dev->protocol NULL checks
> 
> Every PNP device should have a valid protocol pointer.  If it doesn't,
> something's wrong and we should oops so we can find and fix the problem.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Ack from a functional standpoint: we are oopsing in pnp_start/stop_dev 
_anyway_ if the protocol pointer isn't set.

Will you coach this upstream? A 2.6.25-rc1 change from me made the coverity 
checker pick up on it which might be considered enough of an excuse to call 
it a regression and submit this as a fix...

> Index: work6/drivers/pnp/driver.c
> ===================================================================
> --- work6.orig/drivers/pnp/driver.c	2008-02-20 09:46:01.000000000 -0700
> +++ work6/drivers/pnp/driver.c	2008-02-20 09:46:28.000000000 -0700
> @@ -167,7 +167,7 @@
>  			return error;
>  	}
>  
> -	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
> +	if (pnp_dev->protocol->suspend)
>  		pnp_dev->protocol->suspend(pnp_dev, state);
>  	return 0;
>  }
> @@ -181,7 +181,7 @@
>  	if (!pnp_drv)
>  		return 0;
>  
> -	if (pnp_dev->protocol && pnp_dev->protocol->resume)
> +	if (pnp_dev->protocol->resume)
>  		pnp_dev->protocol->resume(pnp_dev);
>  
>  	if (pnp_can_write(pnp_dev)) {
> 

Rene.
