Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYJKEVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYJKEVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 00:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYJKEUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 00:20:54 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:19365 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYJKEUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 00:20:53 -0400
Date: Sat, 11 Oct 2008 12:20:50 +0800
From: Franko Fang <huananhu@huawei.com>
Subject: Re: PATCH 10/8]linux-usb: To support more Huawei data card productIDs,
 fix kernel 2.6.27-rc7
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       zhangqianchun@huawei.com, Alan Stern <stern@rowland.harvard.edu>
Message-id: <003f01c92b58$be5a11a0$f9100b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <f9029a2044fb8.44fb8f9029a20@huawei.com>
 <20081010211559.GC17701@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg and Alan,

Well, OK, but I will change it as follows:
 
  result = usb_stor_control_msg(us, us->send_ctrl_pipe,
           USB_REQ_SET_FEATURE,
           USB_TYPE_STANDARD | USB_RECIP_DEVICE,
           0x01, 0x0, NULL, 0x0, 1000);

Because the parameters of  USB_REQ_SET_FEATURE, USB_TYPE_STANDARD and USB_RECIP_DEVICE are all Hex, so I want to keep my other parameters to be consistant with them.
And I see the same using with me in the kernel. Such as the code of the  function usb_stor_euscsi_init in initializers.c file.

Is this changing can be accepted by you? 

If so, I will resubmit the new patch as soon as possible.

Hope for your reply soon.

Thanks.

The original codes are:
us->iobuf[0] = 0x1;
  result = usb_stor_control_msg(us, us->send_ctrl_pipe,
           USB_REQ_SET_FEATURE,
           USB_TYPE_STANDARD | USB_RECIP_DEVICE,
         0x01, 0x0, us->iobuf, 0x1, 1000);

Best Regards,

Franko Fang
2008-10-11

----- Original Message ----- 
From: "Greg KH" <greg@kroah.com>
To: "fangxiaozhi 00110321" <huananhu@huawei.com>
Cc: <linux-usb@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; <zhangqianchun@huawei.com>
Sent: Saturday, October 11, 2008 5:15 AM
Subject: Re: PATCH 10/8]linux-usb: To support more Huawei data card productIDs, fix kernel 2.6.27-rc7


> On Wed, Oct 08, 2008 at 12:02:46PM +0800, fangxiaozhi 00110321 wrote:
>> From: fangxiaozhi <huananhu@huawei.com>
>>  
>> 1. This patch is based on the kernel of 2.6.27-rc7 
>> 2. In this patch, we want to do one thing: add more Huawei product IDs into the USB driver. Then it can support  more Huawei data card devices. So to declare the unusual device for new Huawei data card devices 
>> in unusual_devs.h and to declare more new product IDs in option.c.
>> 3. To modify the data value and length in the function of 
>> usb_stor_huawei_e220_init in initializers.c
>> That's because based on the USB standard, while sending SET_FETURE_D to the device, it requires the corresponding data to be zero, and its sending length also must be zero.
>> In our old solution, it can be compatible with our WCDMA data card devices, but can not support our CDMA data card devices. 
>> But in this new solution, it can be compatible with all of our data card devices.
> 
> Can you make the changes Alan suggested?
> 
> I'll hold off for a new version after you have integrated that change.
> 
> thanks,
> 
> greg k-h
