Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbYAJAzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbYAJAzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYAJAzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:55:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40630 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbYAJAzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:55:43 -0500
Date: Wed, 9 Jan 2008 16:55:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Roskin <proski@gnu.org>, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080109165515.4a6256a8@laptopd505.fenrus.org>
In-Reply-To: <p73zlveo6az.fsf@bingen.suse.de>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	<20080108203235.GA772@infradead.org>
	<21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	<1199838407.6734.83.camel@pasglop>
	<1199902724.8050.11.camel@dv>
	<20080109182157.GA32754@infradead.org>
	<1199908703.6734.133.camel@pasglop>
	<20080109202254.GA5279@infradead.org>
	<20080109164241.7daa5770@laptopd505.fenrus.org>
	<p73zlveo6az.fsf@bingen.suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 01:47:16 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> >
> > I'm btw all in favor of making mmio tracing full fledged kernel
> > infrastructure. This doesn't mean "notifier" imo; this means a real
> > flag in the struct page, and then the page fault code can do
> >
> > if (page->flags & FLAG_MMIO_TRACED)
> > 	mmio_trace(page, regs, whatever..);
> >
> > (probably surrounded by a CONFIG_ ifdef)
> > THis is a TON lighter than a notifier chain, and actually what you
> > want, you don't really want a notifier, you want a call back when a
> > special kind of page is touched.
> 
> That would assume that your mmio area has a struct page. In most PCs 
> the ones in the PCI hole don't
> 

so you also call the function for all traps on pages without struct page;
that should be extremely rare anyway, and the mmio_trace code can then 
look the page up.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
