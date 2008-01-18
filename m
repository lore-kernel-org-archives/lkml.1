Return-Path: <linux-kernel-owner+w=401wt.eu-S1765283AbYARUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765283AbYARUpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbYARUpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:45:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57630 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760300AbYARUpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:45:44 -0500
Message-ID: <47910FF5.20206@pobox.com>
Date: Fri, 18 Jan 2008 15:45:41 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190725.24271.rusty@rustcorp.com.au> <200801190727.36567.rusty@rustcorp.com.au>
In-Reply-To: <200801190727.36567.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Just a trivial example.
> ---
>  drivers/lguest/lguest_device.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -r 00ab7672f658 drivers/lguest/lguest_device.c
> --- a/drivers/lguest/lguest_device.c	Thu Jan 17 16:54:00 2008 +1100
> +++ b/drivers/lguest/lguest_device.c	Thu Jan 17 16:59:46 2008 +1100
> @@ -179,9 +179,8 @@ static void lg_notify(struct virtqueue *
>  	hcall(LHCALL_NOTIFY, lvq->config.pfn << PAGE_SHIFT, 0, 0);
>  }
>  
> -static irqreturn_t lguest_interrupt(int irq, void *_vq)
> +static irqreturn_t lguest_interrupt(int irq, struct virtqueue *vq)
>  {
> -	struct virtqueue *vq = _vq;
>  	struct lguest_device_desc *desc = to_lgdev(vq->vdev)->desc;

Ugh.

This will be a compatibility nightmare.  I don't see how void* is so 
evil for this, or timers.

It's not like there's a huge cost associated with a pointer alias.

	Jeff



