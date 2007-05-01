Return-Path: <linux-kernel-owner+w=401wt.eu-S1161776AbXEATIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161776AbXEATIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161787AbXEATIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:08:13 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2441 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161776AbXEATIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:08:12 -0400
Date: Tue, 1 May 2007 20:08:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 1/4] SoC base drivers: SoC helper API
Message-ID: <20070501190803.GB19872@flint.arm.linux.org.uk>
Mail-Followup-To: Paul Sokolovsky <pmiscml@gmail.com>,
	linux-kernel@vger.kernel.org
References: <181733600.20070501080827@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <181733600.20070501080827@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 08:08:27AM +0300, Paul Sokolovsky wrote:
> +void soc_free_devices(struct platform_device *devices, int nr_devs)
> +{
> +	struct platform_device *dev = devices;
> +	int i;
> +
> +	for (i = 0; i < nr_devs; i++) {
> +		struct resource *res = dev->resource;
> +		platform_device_unregister(dev++);
> +		kfree(res);
> +	}
> +	kfree(devices);

Utterly unsafe.  Repeat after me: kfreeing the memory assocated with any
kobject is asking for an OOPS.  Do not do it.

There's a reason that platform_device_alloc() and friends exist.  If you
want to unregister platform devices, use those functions.  Don't try to
invent your own buggy variants.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
