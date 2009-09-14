Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZINKf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZINKf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZINKfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:35:55 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:61839 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZINKft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rPjJ6JScGMy0uw9FwcRTv/QqVGyLB6ZlbO20ZeCUO16BcZyhULqmAwvY6snITT7zaH
         SeeoiHPq5PQbezc7eU8K+I8s7OyXN7RC/z0IbPeS1itwIokouFlWvTGV0fdGD1Jazn/f
         mbjhu4Ed7GeA7v/awHy+qpKH+2fZzG1N2NTsw=
MIME-Version: 1.0
In-Reply-To: <4AA62BFF.2050703@samsung.com>
References: <4AA62BFF.2050703@samsung.com>
Date: Mon, 14 Sep 2009 16:05:52 +0530
Message-ID: <5d5443650909140335h6a81c684h2846c5365e144425@mail.gmail.com>
Subject: Re: [PATCH] HAPTIC: add HAPTIC class
From: Trilok Soni <soni.trilok@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kmpark@infradead.org, dg77.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin Park,

> +
> +static ssize_t haptic_value_store(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t size)
> +{
> +       struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev);
> +       ssize_t ret = -EINVAL;
> +       char *after;
> +       unsigned long state = simple_strtoul(buf, &after, 10);

s/simple_strtoul/strict_strtoul. code looks clean, but let's scan it
through scripts/checkpatch.pl.

> diff --git a/drivers/haptic/haptic.h b/drivers/haptic/haptic.h
> new file mode 100644
> index 0000000..888aaa3
> --- /dev/null
> +++ b/drivers/haptic/haptic.h
> @@ -0,0 +1,35 @@
> +/*
> + *  Haptic Core
> + *
> + *  Copyright (C) 2008 Samsung Electronics
> + *  Kyungmin Park <kyungmin.park@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __HAPTIC_H_INCLUDED
> +#define __HAPTIC_H_INCLUDED
> +
> +#include <linux/device.h>
> +#include <linux/rwsem.h>
> +#include <linux/haptic.h>
> +
> +static inline void haptic_set_value(struct haptic_classdev *haptic_cdev,
> +                                       enum haptic_value value)
> +{
> +       if (value > HAPTIC_FULL)
> +               value = HAPTIC_FULL;
> +       haptic_cdev->value = value;
> +       if (!(haptic_cdev->flags & HAPTIC_SUSPENDED))
> +               haptic_cdev->set(haptic_cdev, value);
> +}
> +
> +static inline int haptic_get_value(struct haptic_classdev *haptic_cdev)
> +{
> +       return haptic_cdev->value;
> +}

You had mentioned in Kconfig help text that haptics set/get APIs can
be accessed from kernel drivers too, I am not able to understand that
from this code.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
