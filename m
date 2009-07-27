Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZG0SJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZG0SJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZG0SJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:09:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZG0SJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:09:54 -0400
Date: Mon, 27 Jul 2009 10:48:52 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: damm@igel.co.jp, linux-kernel@vger.kernel.org
Subject: Re: early platform drivers vs resource lookup by name
Message-ID: <20090727174852.GA3137@suse.de>
References: <8bd0f97a0907262320y3c5c3505h5d47d5c51025a536@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0907262320y3c5c3505h5d47d5c51025a536@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 02:20:06AM -0400, Mike Frysinger wrote:
> ive been toying with the new early platform driver framework and
> noticed a not-so-friendly feature wrt resource handling.  the
> platform_device_add() function will take care of making sure that
> every resource's name field is not NULL:
> int platform_device_add(struct platform_device *pdev)
> {
> ...
>         if (r->name == NULL)
>             r->name = dev_name(&pdev->dev);
> ...
> 
> unfortunately, the early_platform_add_devices() function does not have
> similar code.  this leads to NULL pointer crashes if you attempt to
> use any of the "byname" resource functions (e.g.
> platform_get_resource_byname) and the resources in question arent
> fully named.
> 
> is the simple fix here to add a resource loop to
> early_platform_add_devices() that makes sure all the name fields are
> non-NULL ?

I really do not know, what do you think would resolve this best for you?

thanks,

greg k-h
