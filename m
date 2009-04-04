Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZDDEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZDDEST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 00:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZDDESF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 00:18:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:36814 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZDDESE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 00:18:04 -0400
Date: Fri, 3 Apr 2009 21:17:40 -0700
From: Greg KH <gregkh@suse.de>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Ming Lei <tom.leiming@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Commit 7a192ec is build breaking
Message-ID: <20090404041740.GA6504@suse.de>
References: <20090328140049.GA4344@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328140049.GA4344@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 02:00:49PM +0000, Russell King wrote:
> The commit:
> 
>     platform driver: fix incorrect use of 'platform_bus_type' with 'struct device_driver'
> 
> contains this:
> 
> -static int __exit pxa2xx_flash_remove(struct device *dev)
> +static int __exit pxa2xx_flash_remove(struct platform_device *dev)
> ...
> -       .remove         = __exit_p(pxa2xx_flash_remove),
> +       .remove         = __devexit_p(pxa2xx_flash_remove),
> 
> which leads to the following build error:
> 
> `pxa2xx_flash_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> 
> This is not the only instance of it in this patch - all __exit_p's
> touched by this patch have been converted to __devexit_p's without
> regard to the original function.
> 
> Let's revert this change and, if we are going to convert functions
> to be __devexit/__devinit, lets have that as a _separate_ patch doing
> just that change.

Ick, Ming, any thoughts?  I'll revert your patch as it looks like it is
incorrect in this way.

thanks,

greg k-h
