Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbXJRP7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbXJRP7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbXJRP6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:58:44 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:37929 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933610AbXJRP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:58:41 -0400
Date: Thu, 18 Oct 2007 16:58:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Jarek Poplawski <jarkao2@o2.pl>, Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] flush_work_sync vs. flush_scheduled_work Re: [PATCH]
 PHYLIB: IRQ event workqueue handling fixes
In-Reply-To: <20071018154819.GA425@tv-sign.ru>
Message-ID: <Pine.LNX.4.64N.0710181655120.4701@blysk.ds.pg.gda.pl>
References: <20071015125301.GC3015@ff.dom.local>
 <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl> <20071016062108.GB1000@ff.dom.local>
 <Pine.LNX.4.64N.0710161759050.22596@blysk.ds.pg.gda.pl> <20071017085809.GA1658@ff.dom.local>
 <20071018063157.GA1694@ff.dom.local> <20071018070531.GA2065@ff.dom.local>
 <20071018154819.GA425@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007, Oleg Nesterov wrote:

> If we can't just cancel the work, can't we do something like
> 
> 	if (cancel_work_sync(w))
> 		w->func(w);
> 
> instead?

 We do an equivalent of this -- all that we care about that w->func(w) 
would do is enable_irq() and the rest we want to skip at this point.  We 
probably do not need the counter in the end though.

  Maciej
