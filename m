Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYIYBgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYIYBgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 21:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYIYBgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 21:36:33 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:39769 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYIYBgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 21:36:32 -0400
Date: Thu, 25 Sep 2008 09:36:29 +0800
From: Franko Fang <huananhu@huawei.com>
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card productIDs,
 fix kernel 2.6.27-rc7
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       Lin.Lei@huawei.com, zhangqianchun@huawei.com
Message-id: <025201c91eaf$224001e0$f9100b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com>
 <f9fd97f63cf97.3cf97f9fd97f6@huawei.com> <20080924150304.GC26466@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. In this patch, we want to do one thing: add more Huawei product IDs into the USB driver. Then it can support  more Huawei data card devices. 
    So I make them in one patch.

2. To change usb_stor_huawei_e220_init function as follows, that's because in the USB standard, while sending SET_FETURE_D to the device, it requires the corresponding data to be zero, and its sending length also must be zero.
    In our old solution, it can be compatible with our WCDMA data card devices, but can not support our CDMA data card devices. 
    But in this new solution, it can be compatible with all of our data card devices.

    Hope that my interpreting can satify you.
-----------------------------
>> --- linux-2.6.27-rc7-orig/drivers/usb/storage/initializers.c 2008-09-22 06:29:55.000000000 +0800
>> +++ linux-2.6.27-rc7/drivers/usb/storage/initializers.c 2008-09-24 12:04:40.000000000 +0800
>> @@ -95,11 +95,11 @@ int usb_stor_huawei_e220_init(struct us_
>>  {
>>  int result;
>>  
>> - us->iobuf[0] = 0x1;
>> + us->iobuf[0] = 0x0;
>>  result = usb_stor_control_msg(us, us->send_ctrl_pipe,
>>        USB_REQ_SET_FEATURE,
>>        USB_TYPE_STANDARD | USB_RECIP_DEVICE,
>> -       0x01, 0x0, us->iobuf, 0x1, 1000);
>> +       0x01, 0x0, us->iobuf, 0x0, 1000);
-------------------------------------------------------------------------

Franko Fang
2008-9-25



----- Original Message ----- 
From: "Greg KH" <greg@kroah.com>
To: "fangxiaozhi 00110321" <huananhu@huawei.com>
Cc: <linux-usb@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; <Lin.Lei@huawei.com>; <zhangqianchun@huawei.com>
Sent: Wednesday, September 24, 2008 11:03 PM
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card productIDs, fix kernel 2.6.27-rc7


> On Wed, Sep 24, 2008 at 02:08:12PM +0800, fangxiaozhi 00110321 wrote:
>> 
>>  From: fangxiaozhi <huananhu@huawei.com>
>>  
>>  1. This patch is based on the kernel of 2.6.27-rc7 2. To declare the unusual device for new Huawei data card devices 
>>  in unusual_devs.h
>>  3. To modify the data value and length in the function of 
>>  usb_stor_huawei_e220_init in initializers.c
>>  4. To declare more new product IDs in option.c.
> 
> I thought I asked you to split this up into 4 different patches?  Hm,
> maybe three should be all that is needed, I thought your original one
> did 4 different things.
> 
> And isn't your modification of the usb_stor_huawei_e220_init function
> going to break the devices that it currently works for?  Or has it
> always been wrong?
> 
> thanks,
> 
> greg k-h
