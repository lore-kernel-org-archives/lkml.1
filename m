Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYAJArb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYAJArb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYAJArX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:47:23 -0500
Received: from ns.suse.de ([195.135.220.2]:54310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYAJArW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:47:22 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Roskin <proski@gnu.org>, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
From: Andi Kleen <andi@firstfloor.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	<20080108203235.GA772@infradead.org>
	<21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	<1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	<20080109182157.GA32754@infradead.org>
	<1199908703.6734.133.camel@pasglop>
	<20080109202254.GA5279@infradead.org>
	<20080109164241.7daa5770@laptopd505.fenrus.org>
Date: Thu, 10 Jan 2008 01:47:16 +0100
In-Reply-To: <20080109164241.7daa5770@laptopd505.fenrus.org> (Arjan van de Ven's message of "Wed\, 9 Jan 2008 16\:42\:41 -0800")
Message-ID: <p73zlveo6az.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> I'm btw all in favor of making mmio tracing full fledged kernel infrastructure.
> This doesn't mean "notifier" imo; this means a real flag in the struct page,
> and then the page fault code can do
>
> if (page->flags & FLAG_MMIO_TRACED)
> 	mmio_trace(page, regs, whatever..);
>
> (probably surrounded by a CONFIG_ ifdef)
> THis is a TON lighter than a notifier chain, and actually what you want,
> you don't really want a notifier, you want a call back when a special kind of
> page is touched.

That would assume that your mmio area has a struct page. In most PCs 
the ones in the PCI hole don't

-Andi
