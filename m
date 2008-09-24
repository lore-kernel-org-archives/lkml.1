Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYIXOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYIXOiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIXOiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:38:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52580 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751436AbYIXOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:38:14 -0400
Date: Wed, 24 Sep 2008 10:38:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: fangxiaozhi 00110321 <huananhu@huawei.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       <zihan@huawei.com>, <Lin.Lei@huawei.com>, <zhangqianchun@huawei.com>,
       <greg@kroah.com>
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card product
 IDs, fix kernel 2.6.27-rc7
In-Reply-To: <f9fd97f63cf97.3cf97f9fd97f6@huawei.com>
Message-ID: <Pine.LNX.4.44L0.0809241033580.2650-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, fangxiaozhi 00110321 wrote:

>  From: fangxiaozhi <huananhu@huawei.com>
>  
>  1. This patch is based on the kernel of 2.6.27-rc7 2. To declare the unusual device for new Huawei data card devices 
>  in unusual_devs.h
>  3. To modify the data value and length in the function of 
>  usb_stor_huawei_e220_init in initializers.c

Is this really a good idea?  Haven't a lot of people worked on that 
function and carefully made it do what they want?  If yes then your 
changes will break their systems.

Or have I confused it with a different initializer?


> --- linux-2.6.27-rc7-orig/drivers/usb/storage/initializers.c	2008-09-22 06:29:55.000000000 +0800
> +++ linux-2.6.27-rc7/drivers/usb/storage/initializers.c	2008-09-24 12:04:40.000000000 +0800
> @@ -95,11 +95,11 @@ int usb_stor_huawei_e220_init(struct us_
>  {
>  	int result;
>  
> -	us->iobuf[0] = 0x1;
> +	us->iobuf[0] = 0x0;
>  	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
>  				      USB_REQ_SET_FEATURE,
>  				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
> -				      0x01, 0x0, us->iobuf, 0x1, 1000);
> +				      0x01, 0x0, us->iobuf, 0x0, 1000);

What reason is there for setting us->iobuf[0] to 0, or passing
us->iobuf as an argument, if the length is 0?

> --- linux-2.6.27-rc7-orig/drivers/usb/storage/unusual_devs.h	2008-09-22 06:29:55.000000000 +0800
> +++ linux-2.6.27-rc7/drivers/usb/storage/unusual_devs.h	2008-09-24 12:08:58.000000000 +0800
> @@ -1622,11 +1622,21 @@ UNUSUAL_DEV( 0x12d1, 0x1401, 0x0000, 0x0
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
>  		0),
> +UNUSUAL_DEV( 0x12d1, 0x1402, 0x0000, 0x0000,
> +                "HUAWEI MOBILE",
> +		"Mass Storage",
> +		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> +                0),		

Please use tabs for indentation, not spaces.

Alan Stern

