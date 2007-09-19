Return-Path: <linux-kernel-owner+w=401wt.eu-S1763122AbXISSqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763122AbXISSqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbXISSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:46:08 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:60747 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758198AbXISSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:46:06 -0400
Date: Wed, 19 Sep 2007 14:46:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070919184604.GA9653@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070918211459.193904061@polymtl.ca> <20070919113737.GA18177@Krystal> <200709191832.13561.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200709191832.13561.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:45:21 up 51 days, 19:04,  4 users,  load average: 0.47, 0.59, 0.86
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko (vda.linux@googlemail.com) wrote:
> On Wednesday 19 September 2007 12:37, Mathieu Desnoyers wrote:
> > > Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> > > ===================================================================
> > > --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:18.000000000 -0400
> > > +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:31.000000000 -0400
> > > @@ -129,6 +133,11 @@
> > >  		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > >  	}								\
> > >  									\
> > > +	/* Markers: strings */						\
> > > +        __markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) {	\
> > > +		*(__markers_strings)					\
> > > + 	}								\
> > > +									\
> > >  	/* Kernel symbol table: strings */				\
> > >          __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
> > >  		*(__ksymtab_strings)					\
> > [...]
> > 
> > Do you think I should also remove the __markers_strings section from here ?
> 
> Yes.
> 
> It will be beneficial if one can read include/asm-generic/vmlinux.lds.h and
> arch/$ARCH/kernel/vmlinux.lds.S and understand which sections in resulting
> vmlinux serve what purpose. A comment atop each section explaining
> its role will be nice. Even more so that not many people are fluent
> in ld script language.
> 
> Currently, one will need to grep around (and not only in kernel tree -
> you need to read depmod.c source too) in order to understand the role
> of various sections in vmlinux.
> 
> There are dearth of comments in ld scripts, and some sections
> are created "just because I felt like it". For example, there are
> ".data.page_aligned" and ".data.percpu" sections - can you
> easily tell which one has to be a section, and which does not need
> to be one (can be merged with ".data")? Maybe both must be sections?
> Or none of them?
> --
> vda

Oh, wait.. I need it in module.c:

immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");

I'll leave the section there then.

Mathieu
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
