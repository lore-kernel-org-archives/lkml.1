Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbYD2WIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbYD2WIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYD2WIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:08:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:58016 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYD2WIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:08:16 -0400
Subject: Re: [PATCH 2/3] powerpc ioremap_prot
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       ajackson@redhat.com, airlied@redhat.com,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080429111734.b4bc93fc.akpm@linux-foundation.org>
References: <20080429113348.3f132ebc@cuia.boston.redhat.com>
	 <20080429111734.b4bc93fc.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 08:07:53 +1000
Message-Id: <1209506873.18023.197.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-29 at 11:17 -0700, Andrew Morton wrote:
> 
> Given that x86 implements ioremap_prot() as a regular C function, it
> would
> be nicer to require that all architectures do that.  Especially as
> macros
> suck.
> 
> Your powerpc implementation of ioremap_prot() has a different
> signature
> from the x86 one: `phys_addr_t address' versus `resource_size_t
> phys_addr'.
> Can that be improved?

Well, we already had ioremap_flags() which is the same thing, that's why
I made it just a #define :-)

But I'm pondering removing our ioremap_flags completely in favor of
ioremap_prot. This was just a patch to "make it work" so Rik could move
on with his core patch (btw. Rik, you got the SOBs in the wrong order on
that one).

Regarding the difference, well, it has to do with us historically using
that phys_addr_t type for ioremap. I can try to look into changing that
but it will take a bit more effort.

> >  static inline pte_t pte_mkspecial(pte_t pte) {
> >       return pte; }
> > +static inline unsigned long pte_pgprot(pte_t pte) {
> > +     return __pgprot(pte_val(pte)) & PAGE_PROT_BITS; }
> 
> ick.  \n's are cheap.

Yeah well, just adapted to the style of the other ones around it :-)

Those things have been there forever, I think we can even blame
pre-paulus maintainership here !

I'll change them all in one go in a different patch if you want.

> > +static inline unsigned long pte_pgprot(pte_t pte) {
> > +     return __pgprot(pte_val(pte)) & PAGE_PROT_BITS; }

Ben.


