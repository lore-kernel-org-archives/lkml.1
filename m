Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbZFVNWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbZFVNWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZFVNWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:22:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39781 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZFVNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:22:15 -0400
Subject: Re: [PATCH -tip 2/5] x86: use asm-generic/dma-mapping-common.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       akpm@linux-foundation.org, sam@ravnborg.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1245676212.15580.68.camel@pc1117.cambridge.arm.com>
References: <20090620155605.GD12901@elte.hu>
	 <20090622135717T.fujita.tomonori@lab.ntt.co.jp>
	 <1245650501.18751.0.camel@penberg-laptop>
	 <20090622203333U.fujita.tomonori@lab.ntt.co.jp>
	 <19f34abd0906220459w39271e29x99d578d0a49d593b@mail.gmail.com>
	 <19f34abd0906220543v64b5418di8b97d36214d093cc@mail.gmail.com>
	 <20090622124916.GA30553@elte.hu>
	 <1245676212.15580.68.camel@pc1117.cambridge.arm.com>
Date: Mon, 22 Jun 2009 16:22:15 +0300
Message-Id: <1245676935.6227.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 14:10 +0100, Catalin Marinas wrote:
> On Mon, 2009-06-22 at 14:49 +0200, Ingo Molnar wrote:
> > * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > Seems to be CONFIG_DEBUG_SLAB=y that is the culprit in this case. Hm,
> > > is Kconfig busted?
> > > 
> > > lib/Kconfig.debug:301:config DEBUG_SLAB
> > > lib/Kconfig.debug-302-  bool "Debug slab memory allocations"
> > > lib/Kconfig.debug:303:  depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
> > > 
> > > fujita-config:1475:CONFIG_DEBUG_SLAB=y
> > > fujita-config:1558:CONFIG_KMEMCHECK=y
> > > 
> > > ...what gives? Pekka?
> > 
> > Kmemleak introduced this piece of not so nice solution recently:
> > 
> > +config DEBUG_KMEMLEAK
> > +       bool "Kernel memory leak detector"
> > +       depends on DEBUG_KERNEL && EXPERIMENTAL && (X86 || ARM) && \
> > +               !MEMORY_HOTPLUG
> > +       select DEBUG_SLAB if SLAB
> > +       select SLUB_DEBUG if SLUB
> > +       select DEBUG_FS if SYSFS
> > +       select STACKTRACE if STACKTRACE_SUPPORT
> > +       select KALLSYMS
> > 
> > that should be a depends line, not a select line.
> 
> Kmemleak doesn't strictly need DEBUG_SLAB to make it a dependency. But
> enabling it may reduce (in theory) the false negatives by poisoning the
> allocated objects (and hence clearing any possible pointers to other
> objects). But I don't have any figures to show this is the case. I'll
> post a patch to drop those selects.
> 
> BTW, wouldn't it be feasible for kbuild to ignore the select statements
> if the selected config has unmet dependencies?

Hmm, no idea, lets cc some relevant people here. But can we remove the
select and add a config option help text to kmemleak as a short-term
solution?

			Pekka

