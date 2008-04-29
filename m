Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbYD2WhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbYD2WhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYD2WhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:37:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbYD2WhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:37:11 -0400
Date: Tue, 29 Apr 2008 15:36:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: benh@kernel.crashing.org
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, ajackson@redhat.com,
       airlied@redhat.com, paulus@samba.org
Subject: Re: [PATCH 2/3] powerpc ioremap_prot
Message-Id: <20080429153634.1f7ceffb.akpm@linux-foundation.org>
In-Reply-To: <1209506873.18023.197.camel@pasglop>
References: <20080429113348.3f132ebc@cuia.boston.redhat.com>
	<20080429111734.b4bc93fc.akpm@linux-foundation.org>
	<1209506873.18023.197.camel@pasglop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 08:07:53 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> On Tue, 2008-04-29 at 11:17 -0700, Andrew Morton wrote:
> > 
> > Given that x86 implements ioremap_prot() as a regular C function, it
> > would
> > be nicer to require that all architectures do that.  Especially as
> > macros
> > suck.
> > 
> > Your powerpc implementation of ioremap_prot() has a different
> > signature
> > from the x86 one: `phys_addr_t address' versus `resource_size_t
> > phys_addr'.
> > Can that be improved?
> 
> Well, we already had ioremap_flags() which is the same thing, that's why
> I made it just a #define :-)
> 
> But I'm pondering removing our ioremap_flags completely in favor of
> ioremap_prot. This was just a patch to "make it work" so Rik could move
> on with his core patch (btw. Rik, you got the SOBs in the wrong order on
> that one).
> 
> Regarding the difference, well, it has to do with us historically using
> that phys_addr_t type for ioremap. I can try to look into changing that
> but it will take a bit more effort.

It does seem pretty bad to create the same-named function in two
architectures, only with sometimes-different argument types.

A minimal fix would be to make powerpc's implementation be an out-of-line C
function which takes a resource_size_t and which calls ioremap_flags()?

> > >  static inline pte_t pte_mkspecial(pte_t pte) {
> > >       return pte; }
> > > +static inline unsigned long pte_pgprot(pte_t pte) {
> > > +     return __pgprot(pte_val(pte)) & PAGE_PROT_BITS; }
> > 
> > ick.  \n's are cheap.
> 
> Yeah well, just adapted to the style of the other ones around it :-)

I'm not a big believer in making new code match broken old code.

> Those things have been there forever, I think we can even blame
> pre-paulus maintainership here !

I blame Rusty.

> I'll change them all in one go in a different patch if you want.

whatever ;)
