Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXFOLJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXFOLJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXFOLJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:09:12 -0400
Received: from aun.it.uu.se ([130.238.12.36]:41406 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbXFOLJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:09:11 -0400
Date: Fri, 15 Jun 2007 13:08:11 +0200 (MEST)
Message-Id: <200706151108.l5FB8BWH008633@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: arnd@arndb.de, mikpe@it.uu.se
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
Cc: akpm@linux-foundation.org, dev@sw.ru, devel@openvz.org, jack@suse.cz,
       linux-kernel@vger.kernel.org, nataliep@google.com, vtaras@openvz.org,
       vvs@sw.ru
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 12:43:01 +0200, Arnd Bergmann wrote:
> On Friday 15 June 2007, Mikael Pettersson wrote:
> > > --- linux-2.6.22-rc4-fixed/fs/quota.c.orig=A0=A0=A0=A02007-06-14 15:55:=
> 26.000000000 +0400
> > > +++ linux-2.6.22-rc4-fixed/fs/quota.c=A02007-06-14 19:50:13.000000000 +=
> 0400
> > ...
> > > +#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
> > > +/*
> > > + * This code works only for 32 bit quota tools over 64 bit OS (x86_64,=
>  ia64)
> > > + * and is necessary due to alignment problems.
> > > + */
> >=20
> > The #ifdef looks way too arch-specific. And isn't there a shared
> > compat.c module somewhere that this should go into?
> >=20
> 
> Only x86_64 and ia64 have this particular problem, the other architectures,
> and hopefully all future 64 bit platforms with 32 bit user space use
> the same alignment rules in elf32 and elf64.

Ah yes, alignof(u64) is the same in 32- and 64-bit modes on !x86,
thus they don't have a problem here.

Thanks for explaining that. I consider this is an essential
piece of information that should be included in the patch.
(In a comment in the code, not buried in some commit log.)

/Mikael
