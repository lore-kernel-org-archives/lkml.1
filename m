Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYBJVMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYBJVMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYBJVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:12:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:24759 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbYBJVMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:12:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=c8BNfE+HmvGs8OlbHYDjh+jHd3DOvbltNetPYk1FTaAP9m/ocoC2Xk3NL5CRw0l4w3VjqYVw1ZOy0tBv0dJQ2bMmeWtpLvdEL6yNrzP2YWMs6G17RnLurxZbNaVQt33APowNm0NrpCbdsW0OqcvzQHLUVYiknvsaEkLTbUJXJMg=
Date: Mon, 11 Feb 2008 00:12:03 +0300
To: Julia Lawall <julia@diku.dk>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers/usb: Use FIELD_SIZEOF
Message-ID: <20080210211203.GD1754@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0802102114330.23906@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802102114330.23906@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 09:15:09PM +0100, Julia Lawall wrote:
> --- a/drivers/usb/atm/usbatm.c
> +++ b/drivers/usb/atm/usbatm.c
> @@ -1349,7 +1349,7 @@ static int __init usbatm_usb_init(void)
>  {
>  	dbg("%s: driver version %s", __func__, DRIVER_VERSION);
>  
> -	if (sizeof(struct usbatm_control) > sizeof(((struct sk_buff *) 0)->cb)) {
> +	if (sizeof(struct usbatm_control) > FIELD_SIZEOF(struct sk_buff, cb)) {

NAK. Driver should BUILD_BUG_ON instead.

>  		printk(KERN_ERR "%s unusable with this kernel!\n", usbatm_driver_name);
>  		return -EIO;
>  	}
