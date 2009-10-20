Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbZJTGon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbZJTGon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZJTGon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:44:43 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:48757 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbZJTGom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NltGH3LTdy7CCtH0V6+MrTciErcRG7MkiyS+6EzMKOH8MJe7h93iPVwAjddgE/nFWa
         YZ3L3ysSM7ej2Pc2TCXkpk8Q6I71l9ThLyM8R2b0Cnw3jokKImsRkRLegHWvTpNqse91
         A0U3f3kuVc2xSkWQg0+MwTSCwbR2lXU3+Kn1k=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510910130945w2e87d84bjfa3291989d85375b@mail.gmail.com>
References: <20091006074533.GA28889@july>
	 <ac3eb2510910130945w2e87d84bjfa3291989d85375b@mail.gmail.com>
Date: Tue, 20 Oct 2009 12:14:46 +0530
Message-ID: <5d5443650910192344v5c396033g55ad8cd85370dbb4@mail.gmail.com>
Subject: Re: [PATCH] Haptic class support (v2)
From: Trilok Soni <soni.trilok@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Tue, Oct 13, 2009 at 10:15 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Oct 6, 2009 at 09:45, Kyungmin Park <kmpark@infradead.org> wrote:
>
>> +/**
>> + * haptic_classdev_register - register a new object of haptic_classdev class.
>> + * @dev: The device to register.
>> + * @haptic_cdev: the haptic_classdev structure for this device.
>> + */
>> +int haptic_classdev_register(struct device *parent,
>> +                               struct haptic_classdev *haptic_cdev)
>> +{
>> +       int ret;
>> +
>> +       haptic_cdev->dev = device_create(haptic_class, parent, 0,
>> +                               haptic_cdev, "%s", haptic_cdev->name);
>> +       if (IS_ERR(haptic_cdev->dev))
>> +               return PTR_ERR(haptic_cdev->dev);
>> +
>> +       /* register the attributes */
>> +       ret = class_create_file(haptic_class, &class_attr_enable);
>> +       if (ret) {
>> +               printk(KERN_ERR "%s: class_create_file(enable) failed\n",
>> +                                __func__);
>> +               return ret;
>> +       }
>
> As mentioned in an earlier mail, this needs some explanation. What are
> you doing here? Creating a device below a class, and then add a bunch
> of attributes to the class itself, instead of the device you created?
>
> All calls to class_create_file() need to go, we can not allow any new
> users of this broken interface. As mentioned, if you need
> subsystem-wide attributes you need to use a bus and not a class,
> classes are flat and can not handle such things properly.
>
> Thanks,
> Kay
>

Any plan of refreshing these patches?


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
