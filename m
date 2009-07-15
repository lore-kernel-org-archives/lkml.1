Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZGOPcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZGOPcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbZGOPck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:32:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60681 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbZGOPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:32:39 -0400
Date: Wed, 15 Jul 2009 02:31:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [linux-pm] [PATCH 2/8] introduce the device async action
	mechanism
Message-ID: <20090715003144.GD2360@ucw.cz>
References: <1247643516.26272.77.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247643516.26272.77.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-15 15:38:36, Zhang Rui wrote:
> Introduce the device async action mechanism.
> 
> In order to speed up Linux suspend/resume/shutdown process,
> we introduce the device async action mechanism that allow devices
> to suspend/resume/shutdown asynchronously.
> 
> The basic idea is that,
> if the suspend/resume/shutdown process of a device set,
> including a root device and its child devices, are independent of
> other devices, we create an async domain for this device set,
> and make them suspend/resume/shutdown asynchronously.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/base/Makefile     |    3 
>  drivers/base/async_dev.c  |  180 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/async_dev.h |   40 ++++++++++
>  include/linux/device.h    |    2 
>  4 files changed, 224 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/include/linux/async_dev.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/async_dev.h
> @@ -0,0 +1,40 @@
> +/*
> + * async_dev.h: function calls for device async actions
> + *
> + * (C) Copyright 2009 Intel Corporation
> + * Author: Zhang Rui <rui.zhang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#ifndef _ASYNC_DEV_H_
> +#define _ASYNC_DEV_H_
> +
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <linux/async.h>
> +#include <linux/device.h>
> +#include <linux/pm.h>
> +
> +struct dev_async_struct {
> +	struct device *dev;
> +	int type;
> +	/* Synchronization Domain for device async actions */
> +	struct list_head domain;
> +	struct list_head node;
> +	async_cookie_t cookie;
> +};
> +
> +#define DEV_ASYNC_ACTIONS_ALL	0
> +
> +extern int dev_async_schedule(struct device *, void *,
> +			void *, int);
> +extern void dev_async_synchronization(void);

'_synchronize' to be consistent with schedule?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
