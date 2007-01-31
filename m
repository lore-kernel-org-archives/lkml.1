Return-Path: <linux-kernel-owner+w=401wt.eu-S1161063AbXAaWHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161063AbXAaWHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 17:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161064AbXAaWHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 17:07:32 -0500
Received: from imf16aec.mail.bellsouth.net ([205.152.59.64]:57974 "EHLO
	imf16aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161063AbXAaWHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 17:07:31 -0500
Message-ID: <45C11264.1080907@bellsouth.net>
Date: Wed, 31 Jan 2007 16:04:20 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH] atl1_main: pci_module_int returns to haunt us
References: <20070131170456.69fe6441@localhost.localdomain>
In-Reply-To: <20070131170456.69fe6441@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Perhaps Adrian would care to simply delete the pci_module_init ancient compat
> code so nobody else can inadvertently merge a driver that uses it.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c linux-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c
> --- linux.vanilla-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c	2007-01-31 14:20:41.000000000 +0000
> +++ linux-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c	2007-01-31 15:25:29.083361224 +0000
> @@ -2482,12 +2482,9 @@
>   **/
>  static int __init atl1_init_module(void)
>  {
> -	int ret;
>  	printk(KERN_INFO "%s - version %s\n", atl1_driver_string, DRIVER_VERSION);
>  	printk(KERN_INFO "%s\n", atl1_copyright);
> -	ret = pci_module_init(&atl1_driver);
> -
> -	return ret;
> +	return pci_register_driver(&atl1_driver);
>  }
>  
>  module_init(atl1_init_module);

Ack.  As expected, works fine.  Thanks.

Jay

