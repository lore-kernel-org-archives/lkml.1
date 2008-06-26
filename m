Return-Path: <linux-kernel-owner+w=401wt.eu-S1765280AbYFZNLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765280AbYFZNLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762047AbYFZNC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:02:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:36965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761934AbYFZNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:02:26 -0400
Date: Thu, 26 Jun 2008 06:02:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Airlie <airlied@linux.ie>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
Message-ID: <20080626060216.1fe210c4@infradead.org>
In-Reply-To: <20080626033614.0ef55f9d@infradead.org>
References: <1214242487.11887.35.camel@koto.keithp.com>
	<4862EE4C.4060009@goop.org>
	<21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
	<20080625213603.0e82805b@infradead.org>
	<1214458589.1044.45.camel@koto.keithp.com>
	<48633057.1040106@goop.org>
	<alpine.DEB.0.82.0806260701260.25035@skynet.skynet.ie>
	<20080626033614.0ef55f9d@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 03:36:14 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 26 Jun 2008 07:02:15 +0100 (IST)
> Dave Airlie <airlied@linux.ie> wrote:
> 
> > > >   
> > > 
> > > Anything that does any kind of pagetable manipulation needs to do
> > > tlb flushes. kunmap_atomic handles the flushing.
> > 
> > It doesn't however need to do an IPI dance which is the worst part
> > of doing a tlb flush on SMP machines.
> > 
> > flushing local CPU tlbs is bad, but doing IPIs and waiting for
> > everyone else is brutal.
> 
> but you only do IPI's for the multithreaded case to cpus where you're
> running; otoh I guess games are multithreaded nowadays
eh never mind this is total bogus
yes a full ipi is needed.

note that with ioremap you may need certain tricks as well to deal with
cache type aliasing, depending on the type of ioremap you want (wc?)

> 
> > 
> > Dave.
> 
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
