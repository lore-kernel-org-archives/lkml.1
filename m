Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYAJRe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYAJRe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYAJReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:34:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34754 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYAJReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:34:17 -0500
Date: Thu, 10 Jan 2008 09:34:18 -0800
From: Greg KH <greg@kroah.com>
To: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [2.6.24-rc6-mm1]Build failure in drivers/net/ehea/ehea_main.c
Message-ID: <20080110173418.GA14728@kroah.com>
References: <20080108163305.GB10026@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108163305.GB10026@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 10:03:05PM +0530, Sudhir Kumar wrote:
> Hi Andrew,
> Kernel build fails on my machine with error :
> 
> 
>   LD      drivers/net/ehea/built-in.o
>   CC [M]  drivers/net/ehea/ehea_main.o
> drivers/net/ehea/ehea_main.c: In function ???ehea_driver_sysfs_add???:
> drivers/net/ehea/ehea_main.c:2812: error: ???struct device_driver??? has no
> member named ???kobj???
> drivers/net/ehea/ehea_main.c:2815: error: ???struct device_driver??? has no
> member named ???kobj???
> drivers/net/ehea/ehea_main.c:2818: error: ???struct device_driver??? has no
> member named ???kobj???
> drivers/net/ehea/ehea_main.c: In function ???ehea_driver_sysfs_remove???:
> drivers/net/ehea/ehea_main.c:2830: error: ???struct device_driver??? has no
> member named ???kobj???
> make[3]: *** [drivers/net/ehea/ehea_main.o] Error 1
> make[2]: *** [drivers/net/ehea] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> The structure device_driver(in device.h) has a member struct driver_private which
> contains the member kobj (according to drivers/base/base.h).
> But in device.h struct driver_private has been declared localy and 
> neither defined nor included from base.h.
> So my effort to use driver->driver_private->obj also does not work.
> (I am surprised from where do you access the struct device_driver)

That is because a driver should not be accessing such a field.

And especially not in this manner, why would this driver be creating a
symlink that has already been created by the driver core?  This whole
thing can just be removed with no problems.  Can you try just removing
the ehea_driver_sysfs_add and ehea_driver_sysfs_remove functions to
verify this as I don't have the hardware present to test it out.

thanks,

greg k-h
