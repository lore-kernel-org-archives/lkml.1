Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYAJCDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYAJCDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYAJCDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:03:41 -0500
Received: from waste.org ([66.93.16.53]:39989 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYAJCDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:03:41 -0500
Subject: Re: Replacement for page fault notifiers?
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Roskin <proski@gnu.org>, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
In-Reply-To: <20080109164241.7daa5770@laptopd505.fenrus.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	 <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop>
	 <20080109202254.GA5279@infradead.org>
	 <20080109164241.7daa5770@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 20:03:10 -0600
Message-Id: <1199930590.6245.104.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 16:42 -0800, Arjan van de Ven wrote:
> On Wed, 9 Jan 2008 20:22:54 +0000
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Thu, Jan 10, 2008 at 06:58:23AM +1100, Benjamin Herrenschmidt
> > wrote:
> > > It's a sane thing to do, Christoph, I don't think it's a
> > > unreasonable request to put the hooks back in.
> > 
> > As said a few times before there's simply no way we're going to put
> > exactly that crap back.  For one the patch removed a whole lot of
> > crud from the kprobes code that simply isn't going to come back just
> > because there are some pagefault notifiers.  Second the page fault
> > notifiers were horribly implemented and quite inefficient.  And third
> > we're not going to put something in just for out of tree code.
> > 
> 
> I'm btw all in favor of making mmio tracing full fledged kernel infrastructure.
> This doesn't mean "notifier" imo; this means a real flag in the struct page,
> and then the page fault code can do
> 
> if (page->flags & FLAG_MMIO_TRACED)
> 	mmio_trace(page, regs, whatever..);

That makes it way too easy for drivers of questionable legality to just
clear that bit. Also, we've got a shortage of page bits, etc.

-- 
Mathematics is the supreme nostalgia of our time.

