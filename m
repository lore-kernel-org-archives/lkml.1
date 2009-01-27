Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZA0MNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZA0MNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZA0MNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:13:15 -0500
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:35656 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbZA0MNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:13:14 -0500
Subject: Re: [PATCH] sfc: modify allocation error message
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       linux-net-drivers@solarflare.com
In-Reply-To: <497DD107.5050909@sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
	 <20090107195832.871689000@polaris-admin.engr.sgi.com>
	 <1232384910.31644.13.camel@achroite>
	 <200901201209.34854.rusty@rustcorp.com.au>  <497DD107.5050909@sgi.com>
Content-Type: text/plain; charset=utf-8
Organization: Solarflare Communications
Date: Tue, 27 Jan 2009 12:13:01 +0000
Message-Id: <1233058381.3402.1.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
X-Originating-Smarthost03-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 07:04 -0800, Mike Travis wrote:
[...]
> Subject: sfc: modify allocation error message
> 
> Impact: change error message when alloc_cpumask_var fails.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>

> ﻿--
>  drivers/net/sfc/efx.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6-for-ingo.orig/drivers/net/sfc/efx.c
> +++ linux-2.6-for-ingo/drivers/net/sfc/efx.c
> @@ -858,9 +858,9 @@ static int efx_wanted_rx_queues(void)
>         int count;
>         int cpu;
>  
> -       if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
> +       if (unlikely(!alloc_cpumask_var(&core_mask, GFP_KERNEL))) {
>                 printk(KERN_WARNING
> -                      "efx.c: allocation failure, irq balancing hobbled\n");
> +                      "sfc: RSS disabled due to allocation failure\n");
>                 return 1;
>         }
>  

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

