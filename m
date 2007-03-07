Return-Path: <linux-kernel-owner+w=401wt.eu-S1751081AbXCGXrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbXCGXrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXCGXrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:47:48 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:61458 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751004AbXCGXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:47:47 -0500
Message-ID: <45EF4F0E.50303@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc St-Jean <stjeanma@pmc-sierra.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] drivers: PMC MSP71xx GPIO char driver
Date: Wed, 7 Mar 2007 15:47:26 -0800 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 07 Mar 2007 23:47:36.0611 (UTC) FILETIME=[FBDB5730:01C76112]
user-agent: Thunderbird 1.5.0.10 (X11/20070221)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>  > On Fri, 23 Feb 2007 17:28:19 -0600 Marc St-Jean 
> <stjeanma@pmc-sierra.com> wrote:
>  > [PATCH] drivers: PMC MSP71xx GPIO char driver
>  >
>  > Patch to add a GPIO char driver for the PMC-Sierra
>  > MSP71xx devices.
>  >
>  > This patch references some platform support files previously
>  > submitted to the linux-mips@linux-mips.org list.
>  >

Thanks for the feedback Andrew. I've implemented all your recommendations
other than the kernel thread handling, which I still have to look into.

[...]

> 
>  > +/* -- Module functions -- */
>  > +
>  > +static int msp_gpio_blinkthread( void *none )
> 
> Why is this a "module function"?

The reason is likely because it's only called by msp_gpio_init so it was
considered part of the module code. I'll move the comment to only cover
msp_gpio_init/exit.

[...]

>  > +module_init(msp_gpio_init);
>  > +module_exit(msp_gpio_exit);
>  > +
>  > +EXPORT_SYMBOL(msp_gpio_in);
>  > +EXPORT_SYMBOL(msp_gpio_out);
>  > +EXPORT_SYMBOL(msp_gpio_mode);
>  > +EXPORT_SYMBOL(msp_gpio_blink);
>  > +EXPORT_SYMBOL(msp_gpio_noblink);
> 
> What uses these exports?

These exports are needed for other drivers compiled as modules can control
the GPIO pins through this driver.

[...]

Marc
