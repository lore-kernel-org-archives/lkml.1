Return-Path: <linux-kernel-owner+w=401wt.eu-S965668AbXDMW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668AbXDMW6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965673AbXDMW6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:58:23 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:45686 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965668AbXDMW6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:58:22 -0400
From: Duncan Sands <baldrick@free.fr>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] usbatm_heavy_init: don't use CLONE_SIGHAND
Date: Sat, 14 Apr 2007 00:59:23 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070412235631.GA1050@tv-sign.ru>
In-Reply-To: <20070412235631.GA1050@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704140059.23475.baldrick@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 01:56:31 Oleg Nesterov wrote:
> usbatm_do_heavy_init() calls allow_signal() which plays with parent process's
> ->sighand.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Duncan Sands <baldrick@free.fr>

> --- 2.6.21-rc5/drivers/usb/atm/usbatm.c~usbatm	2006-11-27 21:19:30.000000000 +0300
> +++ 2.6.21-rc5/drivers/usb/atm/usbatm.c	2007-04-13 03:34:56.000000000 +0400
> @@ -1019,7 +1019,7 @@ static int usbatm_do_heavy_init(void *ar
>  
>  static int usbatm_heavy_init(struct usbatm_data *instance)
>  {
> -	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_KERNEL);
> +	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
>  
>  	if (ret < 0) {
>  		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
> 
> 


