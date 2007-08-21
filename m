Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXHUJOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXHUJOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXHUJOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:14:15 -0400
Received: from ns.suse.de ([195.135.220.2]:36399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbXHUJOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:14:14 -0400
Date: Tue, 21 Aug 2007 11:14:12 +0200
From: Karsten Keil <kkeil@suse.de>
To: tonyj@suse.de
Cc: linux-kernel@vger.kernel.org, calle@calle.de, kkeil@suse.de,
       kay.sievers@vrfy.org
Subject: Re: [patch 14/14] Convert from class_device to device for ISDN capi
Message-ID: <20070821091412.GA6021@pingi.kke.suse.de>
Mail-Followup-To: tonyj@suse.de, linux-kernel@vger.kernel.org,
	calle@calle.de, kkeil@suse.de, kay.sievers@vrfy.org
References: <20070820224806.154198000@suse.de> <20070820225145.074790000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820225145.074790000@suse.de>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 03:48:20PM -0700, tonyj@suse.de wrote:
> -- 
> Content-Disposition: inline; filename=isdn-capi.patch
> 
> Convert from class_device to device for drivers/isdn/capi.  This is
> part of the work to eliminate struct class_device.
> 

If you add a Signed-off-by:
I'll ack this patch.

> ---
>  drivers/isdn/capi/capi.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/drivers/isdn/capi/capi.c
> +++ b/drivers/isdn/capi/capi.c
> @@ -1544,11 +1544,11 @@ static int __init capi_init(void)
>  		return PTR_ERR(capi_class);
>  	}
>  
> -	class_device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi");
> +	device_create(capi_class, NULL, MKDEV(capi_major, 0), "capi");
>  
>  #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
>  	if (capinc_tty_init() < 0) {
> -		class_device_destroy(capi_class, MKDEV(capi_major, 0));
> +		device_destroy(capi_class, MKDEV(capi_major, 0));
>  		class_destroy(capi_class);
>  		unregister_chrdev(capi_major, "capi20");
>  		return -ENOMEM;
> @@ -1576,7 +1576,7 @@ static void __exit capi_exit(void)
>  {
>  	proc_exit();
>  
> -	class_device_destroy(capi_class, MKDEV(capi_major, 0));
> +	device_destroy(capi_class, MKDEV(capi_major, 0));
>  	class_destroy(capi_class);
>  	unregister_chrdev(capi_major, "capi20");
>  
> 
> -- 

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
