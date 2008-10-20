Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYJTQdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYJTQdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYJTQdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:33:07 -0400
Received: from lucidpixels.com ([75.144.35.66]:42094 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbYJTQdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:33:05 -0400
Date: Mon, 20 Oct 2008 12:33:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Isely <isely@pobox.com>
cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2
 [USB REGRESSION] (USB -> D_STATE)]
In-Reply-To: <Pine.LNX.4.64.0810201119250.12643@cnc.isely.net>
Message-ID: <alpine.DEB.1.10.0810201231020.6072@p34.internal.lan>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0810201119250.12643@cnc.isely.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Oct 2008, Mike Isely wrote:

>
> There's already a patch coming up through v4l-dvb that should remove the
> need for the reset completely for the pvrusb2 driver.  The reset had
> been there as "chicken soup" previously - it didn't hurt but its
> utility wasn't really that great at the time.  Now that it is hurting,
> I just removed it.
>
>  -Mike
>

Should I wait for the patch coming up through v4l-dvb or test Alan's patch?
2.6.27.2 has quite a few issues:

1. xfs is broken w/barrier (there is a patch for this)
2. usb hangs (patch below)
3. abit-guru (comsetic issue only, doesn't find mobo) (there is a patch 
for this now as well)

So I am sticking with 2.6.26.5 right now, let me know if you need me
to test Alan's patch to see if it fixes the issue.

Justin.

>>
>> Index: usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/media/video/pvrusb2/pvrusb2-main.c
>> +++ usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
>> @@ -68,6 +68,16 @@ static void pvr_setup_attach(struct pvr2
>>  #endif /* CONFIG_VIDEO_PVRUSB2_SYSFS */
>>  }
>>
>> +static int pvr_pre_reset(struct usb_interface *intf)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int pvr_post_reset(struct usb_interface *intf)
>> +{
>> +	return 0;
>> +}
>> +
>>  static int pvr_probe(struct usb_interface *intf,
>>  		     const struct usb_device_id *devid)
>>  {
>> @@ -109,7 +119,9 @@ static struct usb_driver pvr_driver = {
>>  	.name =         "pvrusb2",
>>  	.id_table =     pvr2_device_table,
>>  	.probe =        pvr_probe,
>> -	.disconnect =   pvr_disconnect
>> +	.disconnect =   pvr_disconnect,
>> +	.pre_reset =	pvr_pre_reset,
>> +	.post_reset =	pvr_post_reset,
>>  };
>>
>>  /*

