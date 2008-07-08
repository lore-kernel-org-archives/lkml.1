Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYGHUSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYGHUSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYGHUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:18:22 -0400
Received: from gw.goop.org ([64.81.55.164]:53629 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbYGHUSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:18:21 -0400
Message-ID: <4873CB82.70002@goop.org>
Date: Tue, 08 Jul 2008 13:18:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
CC: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, rjw@sisk.pl,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] xen: new power management driver calls
References: <20080708201327.GA11888@vespa.holoscopio.com>
In-Reply-To: <20080708201327.GA11888@vespa.holoscopio.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thadeu Lima de Souza Cascardo wrote:
> linux-next won't build with CONFIG_XEN and CONFIG_PM_SLEEP because
> xen_suspend calls device_power_up and device_resume, which require a
> parameter since commit 1eede070a59e1cc73da51e1aaa00d9ab86572cfc.
>   

Someone (Randy?) reported this before, but then I quietly forgot all 
about it.  Thanks for the patch.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J

> ---
>  drivers/xen/manage.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 5b546e3..64c554e 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -63,7 +63,7 @@ static int xen_suspend(void *data)
>  	gnttab_resume();
>  	xen_mm_unpin_all();
>  
> -	device_power_up();
> +	device_power_up(PMSG_RESUME);
>  
>  	if (!*cancelled) {
>  		xen_irq_resume();
> @@ -112,7 +112,7 @@ static void do_suspend(void)
>  	else
>  		xenbus_suspend_cancel();
>  
> -	device_resume();
> +	device_resume(PMSG_RESUME);
>  
>  	/* Make sure timer events get retriggered on all CPUs */
>  	clock_was_set();
>   

