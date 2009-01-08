Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbZAHQu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbZAHQu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZAHQue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:50:34 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:49044 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZAHQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:50:32 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 3/4] hvc_console: free_irq only if request_irq was successful
Date: Thu, 8 Jan 2009 17:50:31 +0100
User-Agent: KMail/1.9.9
Cc: Benjiman Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <hvc-console-29-3-3@bga.com>
In-Reply-To: <hvc-console-29-3-3@bga.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081750.31637.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. Januar 2009 schrieb Milton Miller:
> Only call free_irq if we marked the request_irq has having succeeded
> instead of whenever the the sub-driver identified the interrupt to use.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> ---
> Appears to be a bugfix but might use a bit of time in -next.
> This code was created in 2.6.28 to allow s390 to build without adding 
ifdefs.
> Many hvc-console sub-drivers have a single channel and are not modules.
> 
> Index: work.git/drivers/char/hvc_irq.c
> ===================================================================
> --- work.git.orig/drivers/char/hvc_irq.c	2009-01-08 04:07:28.000000000 -0600
> +++ work.git/drivers/char/hvc_irq.c	2009-01-08 04:07:47.000000000 -0600
> @@ -37,7 +37,7 @@ int notifier_add_irq(struct hvc_struct *
> 
>  void notifier_del_irq(struct hvc_struct *hp, int irq)
>  {
> -	if (!irq)
> +	if (!hp->irq_requested)
>  		return;
>  	free_irq(irq, hp);
>  	hp->irq_requested = 0;
> 

Looks sane.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
