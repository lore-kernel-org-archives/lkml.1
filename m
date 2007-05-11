Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbXEKG4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbXEKG4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXEKG4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:56:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60385 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbXEKG4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:56:18 -0400
Date: Fri, 11 May 2007 07:56:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] lguest guest feedback tidyups
Message-ID: <20070511065613.GB25182@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>
References: <1178846246.23513.21.camel@localhost.localdomain> <1178846354.23513.23.camel@localhost.localdomain> <1178846490.23513.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178846490.23513.27.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 11:21:30AM +1000, Rusty Russell wrote:
> 1) send-dma and bind-dma hypercall wrappers for drivers to use,
> 2) formalization of the convention that devices can use the irq
>    corresponding to their index on the lguest_bus.
> 3) ___force to shut up sparse: guests *can* use ioremap as virtual mem.

No, they can't.  Even if in your case the underlying address spaces
happen to be the same anything returned by ioremap must use the proper
accessors.  That's the whole point of having this separation, otherwise
you wouldn't need to use ioremap at all.  So instead of sprinkling cast
around add lguest_read*/lguest_write* accessors that do the __force cast
once and make sure the ioremap return value is always accessed using those.

