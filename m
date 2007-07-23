Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXGWMRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXGWMRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbXGWMRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:17:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53261 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbXGWMRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pQhFmPAmssQHnNoiGbOV1+Eiw8TA+bXloadiaCndOVIm7SJt5PvyZz2eVBjlD8sVHNM/37vAypgekC68ZL78jbASP0jX5g0ZHMXyr9qFD5hGOrKJnmZ74jkAFOKKXKOQ2eHYnnbgkvySiJe65vNYpItV5nUhyvnwt2H1r9HajYk=
Message-ID: <46A49BCE.6020406@googlemail.com>
Date: Mon, 23 Jul 2007 14:15:10 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andreas Gruenbacher <agruen@suse.de>
CC: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [FIX] struct led_classdev conversion compile fallout
References: <200707231403.06015.agruen@suse.de>
In-Reply-To: <200707231403.06015.agruen@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher wrote:
> Commit f8a7c6fe switched from a struct class_device to a struct device in 
> struct led_classdev. Need to adjust drivers/misc/asus-laptop.c as well.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> 
> diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
> index f753060..2fdee5b 100644
> --- a/drivers/misc/asus-laptop.c
> +++ b/drivers/misc/asus-laptop.c
> @@ -1067,8 +1067,8 @@ static void asus_backlight_exit(void)
>  }
>  
>  #define  ASUS_LED_UNREGISTER(object)				\
> -	if(object##_led.class_dev				\
> -	   && !IS_ERR(object##_led.class_dev))			\
> +	if(object##_led.dev					\
> +	   && !IS_ERR(object##_led.dev))			\
>  		led_classdev_unregister(&object##_led)
>  
>  static void asus_led_exit(void)

Same fix here -> http://lkml.org/lkml/2007/7/23/137 but see Al Viro comment about -> http://lkml.org/lkml/2007/7/23/139 

Regards,

Gabriel C
