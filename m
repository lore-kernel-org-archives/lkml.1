Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbXJOMuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbXJOMuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbXJOMuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:50:06 -0400
Received: from mx2.go2.pl ([193.17.41.42]:51271 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758926AbXJOMuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:50:05 -0400
Date: Mon, 15 Oct 2007 14:53:01 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Maciej W\. Rozycki" <macro@linux-mips.org>
Cc: Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
Message-ID: <20071015125301.GC3015@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0709171750220.17606@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-09-2007 16:38, Maciej W. Rozycki wrote:
...
> @@ -661,13 +664,22 @@ int phy_stop_interrupts(struct phy_devic
>  	if (err)
>  		phy_error(phydev);
>  
> +	free_irq(phydev->irq, phydev);
> +
>  	/*
> -	 * Finish any pending work; we might have been scheduled to be called
> -	 * from keventd ourselves, but cancel_work_sync() handles that.
> +	 * Cannot call flush_scheduled_work() here as desired because
> +	 * of rtnl_lock(), but we do not really care about what would
> +	 * be done, except from enable_irq(), so cancel any work
> +	 * possibly pending and take care of the matter below.
>  	 */
>  	cancel_work_sync(&phydev->phy_queue);

Hi,

Could you explain why cancel_work_sync() is better here than
flush_scheduled_work() wrt. rtnl_lock()?

Regards,
Jarek P.
