Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYBXLR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYBXLR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYBXLRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:17:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYBXLRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:17:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.25 patch] fix drivers/usb/host/u132-hcd.c compilation
Date: Sun, 24 Feb 2008 12:15:49 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080224034440.GA1596@cs181133002.pp.htv.fi>
In-Reply-To: <20080224034440.GA1596@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802241215.50224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Adrian Bunk wrote:
> This patch fixes the following compile error caused by
> commit 3a2d5b700132f35401f1d9e22fe3c2cab02c2549:

Thanks, it has already been fixed in the mainline.

> <--  snip  -->
> 
> ...
>   CC      drivers/usb/host/u132-hcd.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c: 
> In function ‘u132_suspend’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3224: error: expected expression before ‘int’
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3225: error: ‘ports’ undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3225: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/usb/host/u132-hcd.c:3225: error: for each function it appears in.)
> make[4]: *** [drivers/usb/host/u132-hcd.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 69cf78da6371ad2aca30844858eeea318b37b3ec diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
> index 6fca069..325c6c7 100644
> --- a/drivers/usb/host/u132-hcd.c
> +++ b/drivers/usb/host/u132-hcd.c
> @@ -3221,9 +3221,11 @@ static int u132_suspend(struct platform_device *pdev, pm_message_t state)
>  			break;
>  		case PM_EVENT_SUSPEND:
>  		case PM_EVENT_HIBERNATE:
> -                        int ports = MAX_U132_PORTS;
> -                        while (ports-- > 0) {
> -                                port_power(u132, ports, 0);
> +			{
> +				int ports = MAX_U132_PORTS;
> +				while (ports-- > 0) {
> +					port_power(u132, ports, 0);
> +				}
>                          }
>  			break;
>  		}
> 
> 
