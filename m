Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYJHOHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYJHOHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 10:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYJHOHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 10:07:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51098 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752879AbYJHOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 10:07:44 -0400
Date: Wed, 8 Oct 2008 10:07:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: fangxiaozhi 00110321 <huananhu@huawei.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       <zihan@huawei.com>, <zhangqianchun@huawei.com>, <greg@kroah.com>
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card product
 IDs, fix kernel 2.6.27-rc7
In-Reply-To: <faf7b1bd45d66.45d66faf7b1bd@huawei.com>
Message-ID: <Pine.LNX.4.44L0.0810081005140.2498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008, fangxiaozhi 00110321 wrote:

> --- linux-2.6.27-rc7-orig/drivers/usb/storage/initializers.c 2008-09-22 06:29:55.000000000 +0800
> +++ linux-2.6.27-rc7/drivers/usb/storage/initializers.c 2008-09-24 12:04:40.000000000 +0800
> @@ -95,11 +95,11 @@ int usb_stor_huawei_e220_init(struct us_
>  {
>   int result;
>  
> - us->iobuf[0] = 0x1;
> + us->iobuf[0] = 0x0;
>   result = usb_stor_control_msg(us, us->send_ctrl_pipe,
>                                        USB_REQ_SET_FEATURE,
>                                        USB_TYPE_STANDARD | USB_RECIP_DEVICE,
> -                                      0x01, 0x0, us->iobuf, 0x1, 1000);
> +                                      0x01, 0x0, us->iobuf, 0x0, 1000);

If you insist on doing this, you should at least do it right.

Take out entirely the line that sets usb->iobuf[0], and replace
us->iobuf in the line above with NULL.  You can also replace your
foolish-looking 0x0 with a plain simple 0 -- after all, 0 is 0 whether
in base 10 or base 16.

Alan Stern

