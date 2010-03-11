Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0CKVWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:22:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55841 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab0CKVWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:22:08 -0500
Date: Thu, 11 Mar 2010 15:21:57 -0600
From: Sonny Rao <sonnyrao@us.ibm.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       tklauser@distanz.ch, jkosina@suse.cz
Subject: Re: [PATCH] powerpc/BSR: fix device_create() return value check
Message-ID: <20100311212157.GD5204@us.ibm.com>
References: <1268324153-30345-1-git-send-email-ext-jani.1.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268324153-30345-1-git-send-email-ext-jani.1.nikula@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 06:15:53PM +0200, Jani Nikula wrote:
> From: Jani Nikula <ext-jani.1.nikula@nokia.com>
> 
> Use IS_ERR() instead of comparing to NULL.
> 
> Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
> 
> ---
> 
> NOTE: I'm afraid I'm unable to test this; please consider this more a
> bug report than a complete patch.
> ---
>  drivers/char/bsr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
> index c02db01..3b31f74 100644
> --- a/drivers/char/bsr.c
> +++ b/drivers/char/bsr.c
> @@ -252,7 +252,7 @@ static int bsr_add_node(struct device_node *bn)
> 
>  		cur->bsr_device = device_create(bsr_class, NULL, cur->bsr_dev,
>  						cur, cur->bsr_name);
> -		if (!cur->bsr_device) {
> +		if (IS_ERR(cur->bsr_device)) {
>  			printk(KERN_ERR "device_create failed for %s\n",
>  			       cur->bsr_name);
>  			cdev_del(&cur->bsr_cdev);
> -- 
> 1.6.5.2
> 

This looks fine to me, good catch.

Acked-by: Sonny Rao <sonnyrao@us.ibm.com>

