Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbXIKUXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbXIKUXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbXIKUXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:23:13 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:48146 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762940AbXIKUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:23:11 -0400
Date: Tue, 11 Sep 2007 16:22:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/8] Immediate Values - Kconfig menu in EMBEDDED
Message-ID: <20070911202259.GB23251@Krystal>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.692565803@polymtl.ca> <20070907064908.GG31880@one.firstfloor.org> <20070907124648.GC9735@Krystal> <20070907223950.GB22646@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070907223950.GB22646@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:00:52 up 43 days, 20:19,  6 users,  load average: 0.34, 0.56, 0.69
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Fri, Sep 07, 2007 at 08:46:48AM -0400, Mathieu Desnoyers wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> > > > +config IMMEDIATE
> > > > +	default y if !DISABLE_IMMEDIATE
> > > 
> > > It's still unclear to me why DISABLE_IMMEDIATE is needed. It would
> > > be better to make it just the default.
> > > 
> > 
> > It is actually the default on any non embedded configuration. Do you
> > think we should make it default to on on embedded configs too ?
> 
> I would prefer to not have any config options at all and let
> the non converted architectures always use a asm-generic fallback.
> 
> > The idea here is to give embedded system developers incentives to
> > create an optimized immediate value header for their architecture. I
> 
> Sounds like a quite bogus way to do this.
> 
> > fear that if it is not trivial to disable when they need to use ROM to
> > put the kernel code (as kprobes is, meaning, with a single config
> > option), they will refuse to event think about including an optimized
> > immediate value header for their architecture.
> 
> #ifdef CONFIG_ARCH_SPECIFIC_READONLY
> #include <asm-generic/generic-immediate.h> 
> #else
> /* optimized implementation */
> #endif
> 
> That's trivial.
> 

Yeah, but then you would make immediate.o an obj-y (both for
kernel/Makefile and arch/*/kernel/Makefile) and it would be built
even on systems that would be configured not to use immediate values.

Therefore, it would compile-in unused code if we do as you propose,
which I am reluctant to do on embedded systems where code size matters.

Mathieu

> > And yes, having a CONFIG_READ_ONLY_TEXT makes sense, but it implies
> > menu dependencies with not only immediate values but also kprobes,
> > paravirt, alternatives, (am I missing others ?)
> 
> paravirt and alternatives are x86 only.
> 
> I don't think CONFIG_READ_ONLY_TEXT on x86 makes sense.
> 
> On other architectures they have to deal with kprobes, but they
> presumably do this already. Not really your problem I suspect.
> 
> 
> > As long as we find a way for people to disable _all_ code patching in
> > their kernel, I'm happy with that. But since every existing code
> > patching mechanism can currently be disabled one by one, it makes sense
> > to do the same for the immediate values. Having a global
> > CONFIG_READ_ONLY_TEXT should IMHO come in a separate effort.
> 
> You're clearly deep into overdesign territory here.
> 
> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
