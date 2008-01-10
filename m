Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYAJA7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYAJA7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbYAJA6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:58:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60436 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbYAJA6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:58:40 -0500
Date: Thu, 10 Jan 2008 02:01:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Roskin <proski@gnu.org>, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080110010111.GF18480@one.firstfloor.org>
References: <20080108203235.GA772@infradead.org> <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com> <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv> <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop> <20080109202254.GA5279@infradead.org> <20080109164241.7daa5770@laptopd505.fenrus.org> <p73zlveo6az.fsf@bingen.suse.de> <20080109165515.4a6256a8@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109165515.4a6256a8@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 04:55:15PM -0800, Arjan van de Ven wrote:
> On Thu, 10 Jan 2008 01:47:16 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > >
> > > I'm btw all in favor of making mmio tracing full fledged kernel
> > > infrastructure. This doesn't mean "notifier" imo; this means a real
> > > flag in the struct page, and then the page fault code can do
> > >
> > > if (page->flags & FLAG_MMIO_TRACED)
> > > 	mmio_trace(page, regs, whatever..);
> > >
> > > (probably surrounded by a CONFIG_ ifdef)
> > > THis is a TON lighter than a notifier chain, and actually what you
> > > want, you don't really want a notifier, you want a call back when a
> > > special kind of page is touched.
> > 
> > That would assume that your mmio area has a struct page. In most PCs 
> > the ones in the PCI hole don't
> > 
> 
> so you also call the function for all traps on pages without struct page;
> that should be extremely rare anyway, and the mmio_trace code can then 
> look the page up.

But there's really no page to look up. These are typically !pfn_valid()

You would need to create an own backing infrastructure. Perhaps you can reuse
some of that from the future PAT code, but integrating that into the page fault
will be probably ugly.

-Andi
