Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZC3C15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZC3C15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 22:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZC3C1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 22:27:34 -0400
Received: from mail.renesas.com ([202.234.163.13]:54106 "EHLO
	mail06.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756273AbZC3C1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 22:27:32 -0400
X-AuditID: ac14038a-0000000900001ca1-11-49d02dd134d9
Date: Mon, 30 Mar 2009 11:26:23 +0900
From: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Subject: Re: [PATCH 39/58] move r8a66597_hcd's probe function to .devinit.text
In-reply-to: <1238196439-16535-39-git-send-email-u.kleine-koenig@pengutronix.de>
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@igel.co.jp>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mundt <lethal@linux-sh.org>
Message-id: <49D02DCF.5000209@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
References: <20090327232153.GA16348@pengutronix.de>
 <1238196439-16535-39-git-send-email-u.kleine-koenig@pengutronix.de>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>

Thanks,
Yoshihiro Shimoda

Uwe Kleine-König wrote:
> A pointer to r8a66597_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Magnus Damm <damm@igel.co.jp>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/usb/host/r8a66597-hcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
> index f1626e5..3e1216a 100644
> --- a/drivers/usb/host/r8a66597-hcd.c
> +++ b/drivers/usb/host/r8a66597-hcd.c
> @@ -2373,7 +2373,7 @@ static int __init_or_module r8a66597_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static int __init r8a66597_probe(struct platform_device *pdev)
> +static int __devinit r8a66597_probe(struct platform_device *pdev)
>  {
>  #if defined(CONFIG_SUPERH_ON_CHIP_R8A66597) && defined(CONFIG_HAVE_CLK)
>  	char clk_name[8];

