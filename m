Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYAJA7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYAJA7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYAJA73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:59:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:40798 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbYAJA72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:59:28 -0500
Subject: Re: Replacement for page fault notifiers?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Pavel Roskin <proski@gnu.org>, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
In-Reply-To: <20080109165515.4a6256a8@laptopd505.fenrus.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	 <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop>
	 <20080109202254.GA5279@infradead.org>
	 <20080109164241.7daa5770@laptopd505.fenrus.org>
	 <p73zlveo6az.fsf@bingen.suse.de>
	 <20080109165515.4a6256a8@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 11:58:45 +1100
Message-Id: <1199926725.6734.161.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 16:55 -0800, Arjan van de Ven wrote:
> > That would assume that your mmio area has a struct page. In most
> PCs 
> > the ones in the PCI hole don't
> > 
> 
> so you also call the function for all traps on pages without struct
> page;
> that should be extremely rare anyway, and the mmio_trace code can
> then 
> look the page up.

Not that rare if you use a modern DRI :-)

In fact, the thing here is that it's mostly kernel mappings though, not
user mappings. So we never get there, we die before we even reach
generic code most of the time iirc.

The whole ioremap stuff is very platform specific, not everybody even
uses the code in mm/vmalloc.c for it, so at this stage, I see no other
option but a hook in do_page_fault().

Cheers,
Ben.

