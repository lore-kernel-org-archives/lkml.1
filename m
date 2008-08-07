Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbYHGGbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbYHGGbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 02:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYHGGaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 02:30:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:36571 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYHGGaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 02:30:23 -0400
Subject: Re: [PATCH]: radeonfb: Fix copyarea for R300 and later.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <1218074816.24157.266.camel@pasglop>
References: <20080806.003536.204220123.davem@davemloft.net>
	 <20080806084329.9d7e6d50.akpm@linux-foundation.org>
	 <20080806.141920.30577822.davem@davemloft.net>
	 <1218074816.24157.266.camel@pasglop>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 15:52:49 +1000
Message-Id: <1218088369.24157.268.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  
> +	/* Ensure the dst cache is flushed and the engine idle before
> +	 * issuing the operation.
> +	 *
> +	 * This works around engine lockups on some cards
> +	 */
> +	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
> +	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
> +
>  	radeon_fifo_wait(2);  

Typo in the patch, missing radeon_fifo_wait before the cache flush.

Fixed version on it's way, sorry.

Cheers,
Ben.


