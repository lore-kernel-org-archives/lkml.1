Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbXISLN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbXISLN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbXISLNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:13:22 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:44301 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431AbXISLNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:13:21 -0400
Date: Wed, 19 Sep 2007 07:13:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/7] Immediate Values - Kconfig menu in EMBEDDED
Message-ID: <20070919111317.GD15500@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210852.945316226@polymtl.ca> <20070918150232.128397b4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070918150232.128397b4.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:10:48 up 51 days, 11:29,  4 users,  load average: 1.62, 1.43, 1.23
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Tue, 18 Sep 2007 17:07:49 -0400 Mathieu Desnoyers wrote:
> 
> > Immediate values provide a way to use dynamic code patching to update variables
> > sitting within the instruction stream. It saves caches lines normally used by
> > static read mostly variables. Enable it by default, but let users disable it
> > through the EMBEDDED menu with the "Disable immediate values" submenu entry.
> > 
> > Note: Since I think that I really should let embedded systems developers using
> > RO memory the option to disable the immediate values, I choose to leave this
> > menu option there, in the EMBEDDED menu. Also, the "CONFIG_IMMEDIATE" makes
> > sense because we want to compile out all the immediate code when we decide not
> > to use optimized immediate values at all (it removes otherwise unused code).
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Adrian Bunk <bunk@stusta.de>
> > CC: Andi Kleen <andi@firstfloor.org>
> > CC: Alexey Dobriyan <adobriyan@gmail.com>
> > CC: Christoph Hellwig <hch@infradead.org>
> > ---
> >  init/Kconfig |   21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > Index: linux-2.6-lttng/init/Kconfig
> > ===================================================================
> > --- linux-2.6-lttng.orig/init/Kconfig	2007-09-18 10:09:40.000000000 -0400
> > +++ linux-2.6-lttng/init/Kconfig	2007-09-18 13:14:58.000000000 -0400
> > @@ -407,6 +407,17 @@ config CC_OPTIMIZE_FOR_SIZE
> >  config SYSCTL
> >  	bool
> >  
> > +config IMMEDIATE
> > +	default y if !DISABLE_IMMEDIATE
> 
> So DISABLE_IMMEDIATE is just an intermediate symbol to make this option
> be displayed in the EMBEDDED menu instead of in the General Setup menu ?
> 

I simply prefer to use a positive logic (CONFIG_IMMEDIATE) rather than
the opposite. It makes makefiles and ifdefs much cleaner. Actually, the
IMMEDIATE config option is not shown in any menu at all; it is totally
controlled by DISABLE_IMMEDIATE. And yes, DISABLE_IMMEDIATE appears in
the embedded menu.

> 
> > +	depends on X86_32 || PPC || PPC64
> > +	bool
> > +	help
> > +	  Immediate values are used as read-mostly variables that are rarely
> > +	  updated. They use code patching to modify the values inscribed in the
> > +	  instruction stream. It provides a way to save precious cache lines
> > +	  that would otherwise have to be used by these variables. They can be
> > +	  disabled through the EMBEDDED menu.
> > +
> >  menuconfig EMBEDDED
> >  	bool "Configure standard kernel features (for small systems)"
> >  	help
> > @@ -646,6 +657,16 @@ config PROC_KPAGEMAP
> >            information on page-level memory usage. Disabling this interface
> >            will reduce the size of the kernel by around 600 bytes.
> >  
> > +config DISABLE_IMMEDIATE
> > +	default y if EMBEDDED
> > +	bool "Disable immediate values" if EMBEDDED
> > +	depends on X86_32 || PPC || PPC64
> > +	help
> > +	  Disable code patching based immediate values for embedded systems. It
> > +	  consumes slightly more memory and requires to modify the instruction
> > +	  stream each time a variable is updated. Should really be disabled for
> > +	  embedded systems with read-only text.
> > +
> >  endmenu		# General setup
> >  
> >  config RT_MUTEXES
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
