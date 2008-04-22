Return-Path: <linux-kernel-owner+w=401wt.eu-S932276AbYDVBLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbYDVBLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760957AbYDVBL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:11:27 -0400
Received: from smtp.knology.net ([24.214.63.101]:35595 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760898AbYDVBLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:11:25 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 21:11:25 EDT
Subject: Re: [PATCH 2/2] drivers/net: Fix synchronize_irq() bugs,
	redundancies
From: David Dillow <dave@thedillows.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080421233537.GA5223@havoc.gtf.org>
References: <20080421233419.GA4923@havoc.gtf.org>
	 <20080421233537.GA5223@havoc.gtf.org>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 21:04:42 -0400
Message-Id: <1208826282.2748.1.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-21 at 19:35 -0400, Jeff Garzik wrote:
> free_irq() calls synchronize_irq() for you, so there is no need for
> drivers to manually do the same thing (again).  Thus, calls where
> sync-irq immediately precedes free-irq can be simplified.

> diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
> index 333961b..7d2a4c6 100644
> --- a/drivers/net/typhoon.c
> +++ b/drivers/net/typhoon.c
[...]
>  	/* Make sure there is no irq handler running on a different CPU. */
> -	typhoon_synchronize_irq(dev->irq);
>  	free_irq(dev->irq, dev);

Should probably kill the comment as well, since it was referring to the
synchronize_irq() call.

Acked-by: Dave Dillow <dave@thedillows.org>

