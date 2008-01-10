Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYAJAnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYAJAnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYAJAnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:43:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55980 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYAJAnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:43:10 -0500
Date: Wed, 9 Jan 2008 16:42:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Hellwig <hch@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Dave Airlie <airlied@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080109164241.7daa5770@laptopd505.fenrus.org>
In-Reply-To: <20080109202254.GA5279@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	<20080108203235.GA772@infradead.org>
	<21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	<1199838407.6734.83.camel@pasglop>
	<1199902724.8050.11.camel@dv>
	<20080109182157.GA32754@infradead.org>
	<1199908703.6734.133.camel@pasglop>
	<20080109202254.GA5279@infradead.org>
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

On Wed, 9 Jan 2008 20:22:54 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jan 10, 2008 at 06:58:23AM +1100, Benjamin Herrenschmidt
> wrote:
> > It's a sane thing to do, Christoph, I don't think it's a
> > unreasonable request to put the hooks back in.
> 
> As said a few times before there's simply no way we're going to put
> exactly that crap back.  For one the patch removed a whole lot of
> crud from the kprobes code that simply isn't going to come back just
> because there are some pagefault notifiers.  Second the page fault
> notifiers were horribly implemented and quite inefficient.  And third
> we're not going to put something in just for out of tree code.
> 

I'm btw all in favor of making mmio tracing full fledged kernel infrastructure.
This doesn't mean "notifier" imo; this means a real flag in the struct page,
and then the page fault code can do

if (page->flags & FLAG_MMIO_TRACED)
	mmio_trace(page, regs, whatever..);

(probably surrounded by a CONFIG_ ifdef)
THis is a TON lighter than a notifier chain, and actually what you want,
you don't really want a notifier, you want a call back when a special kind of
page is touched.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
