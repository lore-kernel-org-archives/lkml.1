Return-Path: <linux-kernel-owner+w=401wt.eu-S1760477AbZJMQrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbZJMQrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbZJMQrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:47:16 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:55851 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZJMQrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:47:16 -0400
MIME-Version: 1.0
In-Reply-To: <20091006074533.GA28889@july>
References: <20091006074533.GA28889@july>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 13 Oct 2009 18:45:48 +0200
Message-ID: <ac3eb2510910130945w2e87d84bjfa3291989d85375b@mail.gmail.com>
Subject: Re: [PATCH] Haptic class support (v2)
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       soni.trilok@gmail.com, Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 09:45, Kyungmin Park <kmpark@infradead.org> wrote:

> +/**
> + * haptic_classdev_register - register a new object of haptic_classdev class.
> + * @dev: The device to register.
> + * @haptic_cdev: the haptic_classdev structure for this device.
> + */
> +int haptic_classdev_register(struct device *parent,
> +                               struct haptic_classdev *haptic_cdev)
> +{
> +       int ret;
> +
> +       haptic_cdev->dev = device_create(haptic_class, parent, 0,
> +                               haptic_cdev, "%s", haptic_cdev->name);
> +       if (IS_ERR(haptic_cdev->dev))
> +               return PTR_ERR(haptic_cdev->dev);
> +
> +       /* register the attributes */
> +       ret = class_create_file(haptic_class, &class_attr_enable);
> +       if (ret) {
> +               printk(KERN_ERR "%s: class_create_file(enable) failed\n",
> +                                __func__);
> +               return ret;
> +       }

As mentioned in an earlier mail, this needs some explanation. What are
you doing here? Creating a device below a class, and then add a bunch
of attributes to the class itself, instead of the device you created?

All calls to class_create_file() need to go, we can not allow any new
users of this broken interface. As mentioned, if you need
subsystem-wide attributes you need to use a bus and not a class,
classes are flat and can not handle such things properly.

Thanks,
Kay
