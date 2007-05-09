Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbXEIVJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbXEIVJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbXEIVJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:09:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40146 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbXEIVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:09:16 -0400
Date: Wed, 9 May 2007 22:09:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org, ak@suse.de,
       jmorris@namei.org
Subject: Re: [patch 7/9] lguest: the net driver
Message-ID: <20070509210904.GA20064@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
	ak@suse.de, jmorris@namei.org
References: <200705090951.l499pdOr020406@shell0.pdx.osdl.net> <4641BE65.3030807@garzik.org> <1178723695.7286.164.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178723695.7286.164.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:14:55AM +1000, Rusty Russell wrote:
> > > +	info->peer = (void *)ioremap(info->peer_phys, info->mapsize);
> > 
> > check for NULL
> 
> Erk, good catch!

Also the cast is bogus.  ioremap already returns void already.  Even
more importantly the lack of the __iomem annotations shows that either this
code hasn't been run through sparse or someone decided to ignore it's
errors.

