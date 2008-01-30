Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbYA3NTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbYA3NTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYA3NTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:19:12 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:51762 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbYA3NTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JOHMLKhkU6BBGbxelKHlnb+5D5zInbzutIWs64a6uSmNKIDWpKKooCpdpA9qOpPScy2P0YPMLyuG3mL4brLgtLheWkY5abp3oFacIPWbn2DFrte9f9xDa20DP9K6rlEhFwTiasjrKOIiuNgO5ul20PAQcrCh7/kW1LoRBDPVTic=
Message-ID: <8bd0f97a0801300519g22c5b66fjcba22a027e7043cc@mail.gmail.com>
Date: Wed, 30 Jan 2008 08:19:06 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>
In-Reply-To: <47A058B3.6000009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>
	 <47A058B3.6000009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 6:00 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/30/2008 11:36 AM, Bryan Wu wrote:
> > +DEFINE_MUTEX(bfin_otp_lock);
>
> static?

the macro threw me ... fixed now, thanks

> > +static int __init bfin_otp_init(void)
> > +{
> > +     int ret;
> > +
> > +     stampit();
> > +
> > +     ret = alloc_chrdev_region(&bfin_otp_dev_node, 0, 1, "otp");
> > +     if (ret) {
> > +             printk(KERN_ERR PFX "unable to get a char device\n");
> > +             return ret;
> > +     }
> > +
> > +     cdev_init(&bfin_otp_cdev, &bfin_otp_fops);
> > +     bfin_otp_cdev.owner = THIS_MODULE;
> > +     bfin_otp_cdev.ops = &bfin_otp_fops;
>
> You don't need to set the fops again.

i did research this a bit but the information on the topic seemed
spotty and usage was inconsistent ... i guess recent things have
smartened up, so i'll drop the assignment

> > +     ret = cdev_add(&bfin_otp_cdev, bfin_otp_dev_node, 1);
> > +     if (ret) {
> > +             unregister_chrdev_region(bfin_otp_dev_node, 1);
> > +             printk(KERN_ERR PFX "unable to register char device\n");
> > +             return ret;
> > +     }
> > +
> > +     bfin_otp_class = class_create(THIS_MODULE, "otp");
> > +     device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");
>
> Anyway, wouldn't be easier/better to use misc.c functionality here
> (misc_register() et al.)?

probably ... i just didnt want to statically allocate a number in the
range that would be Blackfin specific ...
-mike
