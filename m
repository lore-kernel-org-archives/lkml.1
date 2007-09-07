Return-Path: <linux-kernel-owner+w=401wt.eu-S965396AbXIGMq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396AbXIGMq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 08:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965100AbXIGMqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 08:46:52 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:47859 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965078AbXIGMqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 08:46:51 -0400
Date: Fri, 7 Sep 2007 08:46:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/8] Immediate Values - Kconfig menu in EMBEDDED
Message-ID: <20070907124648.GC9735@Krystal>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.692565803@polymtl.ca> <20070907064908.GG31880@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070907064908.GG31880@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:32:49 up 39 days, 12:51,  4 users,  load average: 1.57, 1.47, 1.38
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > +config IMMEDIATE
> > +	default y if !DISABLE_IMMEDIATE
> 
> It's still unclear to me why DISABLE_IMMEDIATE is needed. It would
> be better to make it just the default.
> 

It is actually the default on any non embedded configuration. Do you
think we should make it default to on on embedded configs too ?

> > +config DISABLE_IMMEDIATE
> > +	default y if EMBEDDED
> > +	bool "Disable immediate values" if EMBEDDED
> > +	depends on X86_32 || PPC || PPC64
> > +	help
> > +	  Disable code patching based immediate values for embedded systems. It
> > +	  consumes slightly more memory and requires to modify the instruction
> > +	  stream each time a variable is updated. 
> 
> >         Should really be disabled for
> > +	  embedded systems with read-only text.
> 
> There are no such on x86 at least  And for other architectures like
> PPC it would be better to have a high level CONFIG_READ_ONLY_TEXT
> then that does the necessary changes internally.  But I'm not sure it's even 
> supporting r/o text.
> 

The idea here is to give embedded system developers incentives to
create an optimized immediate value header for their architecture. I
fear that if it is not trivial to disable when they need to use ROM to
put the kernel code (as kprobes is, meaning, with a single config
option), they will refuse to event think about including an optimized
immediate value header for their architecture.

And yes, having a CONFIG_READ_ONLY_TEXT makes sense, but it implies
menu dependencies with not only immediate values but also kprobes,
paravirt, alternatives, (am I missing others ?)

As long as we find a way for people to disable _all_ code patching in
their kernel, I'm happy with that. But since every existing code
patching mechanism can currently be disabled one by one, it makes sense
to do the same for the immediate values. Having a global
CONFIG_READ_ONLY_TEXT should IMHO come in a separate effort.

Mathieu

> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
