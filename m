Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbZIZIjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbZIZIjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 04:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZIZIjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 04:39:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50771 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZIZIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 04:39:50 -0400
Date: Sat, 26 Sep 2009 10:39:44 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Lennert Buytenhek <buytenh@marvell.com>,
       Frans Pop <elendil@planet.nl>, lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] make Linux bootable on ARM again
Message-ID: <20090926083944.GA31699@pengutronix.de>
References: <200909252039.19789.elendil@planet.nl> <alpine.LFD.2.00.0909251613240.4997@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0909251613240.4997@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 25, 2009 at 04:28:02PM -0400, Nicolas Pitre wrote:
> Commit 200b812d00 "Clear the exclusive monitor when returning from an 
> exception" broke the vast majority of ARM systems in the wild which are 
> still pre ARMv6.  The kernel is crashing on the first occurrence of an 
> exception due to the removal of the actual return instruction for them.  
> Let's add it back.
> 
> Signed-off-by: Nicolas Pitre <nico@marvell.com>
> ---
> 
> diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
> index e17e3c3..ac34c0d 100644
> --- a/arch/arm/kernel/entry-header.S
> +++ b/arch/arm/kernel/entry-header.S
> @@ -83,6 +83,8 @@
>  	ldr	r0, [sp]
>  	strex	r1, r2, [sp]			@ clear the exclusive monitor
>  	ldmib	sp, {r1 - pc}^			@ load r1 - pc, cpsr
> +#else
> +	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
>  #endif
>  	.endm
I sent the same patch only 30 minutes later (and only to LAKML).  So
please take that as an

	Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

and the plea to take it before -rc1.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
