Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZLJPZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZLJPZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZLJPZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:25:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:46621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZLJPZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:25:07 -0500
Date: Thu, 10 Dec 2009 07:20:54 -0800
From: Greg KH <gregkh@suse.de>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Potential NULL pointer reference in platform_device_register()
Message-ID: <20091210152054.GA11913@suse.de>
References: <1260433202.7913.24.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260433202.7913.24.camel@falcon.domain.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:20:02PM +0800, Wu Zhangjin wrote:
> Hi, Greg KH,
> 
> Should we filter the potential NULL pointer in
> platform_device_register() like this?
> 
> drivers/base/platform.c:
> 
> int platform_device_register(struct platform_device *pdev)
> {
> +	 if (!pdev)
> +                return -EINVAL;

Why, who is calling this function with a NULL pointer?

> 
>         device_initialize(&pdev->dev);
>         return platform_device_add(pdev);
> }
> EXPORT_SYMBOL_GPL(platform_device_register);
> 
> Of course, the developers need to ensure they not register a NULL
> platform device, but sometimes they will not know that.

Why would you never know that?

> Perhaps the above method will hide the real bug, so, what about BUG_ON(!
> pdev).

That is what happens today anyway if you pass a NULL pointer in :)

thanks,

greg k-h
