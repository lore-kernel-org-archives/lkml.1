Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZBCLTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZBCLTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZBCLT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:19:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:8060 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZBCLT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:19:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fbdsJJAsTj2B0wrOKIPCfw5TTOgnS/vJUK+nCLPDAzF7lnjrtwxNIdYfqXgfWAWVtw
         iZX7rrIX6TmU+U3/nDGljWOlV2HO7hGkYGgpwxqGPFsP2x7GYHX8AhL19BAJcwlfUgcZ
         UAbeBVNthNFMkIVThMHT+7ZX2GW+iRRgIHJT8=
Message-ID: <4988283A.6030300@gmail.com>
Date: Tue, 03 Feb 2009 09:19:22 -0200
From: Manuel Naranjo <naranjo.manuel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: wgreathouse@smva.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb-serial: fix the aircable_init failure path
References: <49857F7E.9090708@gmail.com>
In-Reply-To: <49857F7E.9090708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Naranjo Manuel Francisco <naranjo.manuel@gmail.com>
> The failure path of aircable_init is wrong, fix the order of (goto) labels.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
> drivers/usb/serial/aircable.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -uprN a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
> --- a/drivers/usb/serial/aircable.c	2009-02-01 13:12:35.000000000 +0800
> +++ b/drivers/usb/serial/aircable.c	2009-02-01 13:26:28.000000000 +0800
> @@ -621,9 +621,9 @@ static int __init aircable_init(void)
>  		goto failed_usb_register;
>  	return 0;
>  
> -failed_serial_register:
> -	usb_serial_deregister(&aircable_device);
>  failed_usb_register:
> +	usb_serial_deregister(&aircable_device);
> +failed_serial_register:
>  	return retval;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

