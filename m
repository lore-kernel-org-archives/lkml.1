Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXEJKwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXEJKwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbXEJKwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:52:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbXEJKwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:52:38 -0400
Date: Thu, 10 May 2007 03:52:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/13] i386 sg: add support for chaining scatterlists
Message-Id: <20070510035207.37a528ae.akpm@linux-foundation.org>
In-Reply-To: <20070510104653.GM4629@kernel.dk>
References: <11787925152319-git-send-email-jens.axboe@oracle.com>
	<11787925162760-git-send-email-jens.axboe@oracle.com>
	<20070510034331.2d3e9410.akpm@linux-foundation.org>
	<20070510104454.GL4629@kernel.dk>
	<20070510104653.GM4629@kernel.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 12:46:53 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, May 10 2007, Jens Axboe wrote:
> > Yeah, I'm inclined to agree. Perhaps it would be better to put this
> > stuff in lib/scatterlist.c or something like that instead?
> > 
> > > > +/*
> > > > + * Chain previous sglist to this one
> > > > + */
> > > > +static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
> > > > +			    struct scatterlist *sgl)
> > > > +{
> > > > +#ifndef ARCH_HAS_SG_CHAIN
> > > > +	BUG();
> > > > +#endif
> > > 
> > > Can use BUILD_BUG_ON here.  Or just #error.
> > 
> > Good idea, thanks!
> 
> No wait a second, that wont work. The code is always being built in sg
> scsi_lib.c, it should just not be called unless we can do chaining. We
> will never have a large number of segments that require chaining without
> ARCH_HAS_SG_CHAIN, so it'll never be called in that case. So it has to
> remain as it is, a BUG().

Confused.  If it should never be called, why does it even get compiled in?
