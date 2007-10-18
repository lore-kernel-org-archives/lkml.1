Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbXJRG0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbXJRG0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbXJRGZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:25:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44822
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbXJRGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:25:53 -0400
Date: Wed, 17 Oct 2007 23:26:05 -0700 (PDT)
Message-Id: <20071017.232605.74748149.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFA] sch_generic: fix carrier-on bug?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071016215555.GA4732@havoc.gtf.org>
References: <20071016215555.GA4732@havoc.gtf.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Tue, 16 Oct 2007 17:55:55 -0400

> While looking at a net driver with the following construct,
> 
> 	if (!netif_carrier_ok(dev))
> 		netif_carrier_on(dev);
> 
> it stuck me that the netif_carrier_ok() check was redundant, since
> netif_carrier_on() checks bit __LINK_STATE_NOCARRIER anyway.  This is
> the same reason why netif_queue_stopped() need not be called prior to
> netif_wake_queue().
> 
> This is true, but there is however an unwanted side effect from assuming
> that netif_carrier_on() can be called multiple times:  it touches the
> watchdog, regardless of pre-existing carrier state.
> 
> The fix:  move watchdog-up inside the bit-cleared code path.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

I see no problems with this patch, I'll apply it, thanks!
