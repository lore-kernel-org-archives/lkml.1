Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXIYEKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXIYEKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXIYEKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:10:10 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:54721 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025AbXIYEKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:10:08 -0400
Date: Tue, 25 Sep 2007 00:10:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@linux-foundation.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070925041003.GA28937@Krystal>
References: <20070924111318.f16cde07.randy.dunlap@oracle.com> <20070924181931.GA3810@infradead.org> <46F800A7.7090005@oracle.com> <20070924183042.GA4418@infradead.org> <46F806AB.1050509@oracle.com> <20070924185431.GA5618@infradead.org> <46F80863.2090102@oracle.com> <20070924133730.c9b7c0e6.randy.dunlap@oracle.com> <20070924210830.GA8554@Krystal> <20070924141258.d413abdd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924141258.d413abdd.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:08:56 up 57 days,  4:27,  3 users,  load average: 0.95, 0.81, 0.67
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Mon, 24 Sep 2007 17:08:30 -0400 Mathieu Desnoyers wrote:
> 
> > * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> > > On Mon, 24 Sep 2007 11:56:35 -0700 Randy Dunlap wrote:
> > > 
> > > > Christoph Hellwig wrote:
> > > > > On Mon, Sep 24, 2007 at 11:49:15AM -0700, Randy Dunlap wrote:
> > > > >> I think that samples are perfectly fine for documentation and
> > > > >> that the trace example is a good example.  I think that most people
> > > > >> who need something like that would need to customize it for their
> > > > >> specific needs anyway.
> > > > >>
> > > > >> We don't seem to be making progress...
> > > > > 
> > > > > Time to bring in a Tie-Breaker :)
> > > > 
> > > > Yes.  Is anyone else interested?   :(
> > > 
> > > 
> > > I guess that's everyone (except those who are sleeping).
> > > 
> > > Let's not hold up progress.  Just use samples/ for code.
> > 
> > Would you already have the 
> > 
> > Makefile
> > samples/Kconfig
> > samples/Makefile
> > 
> > core code handy per chance ? (and probably Kconfig sourcing in every
> > arch ?)
> 
> Yes.  Here it is.  I'm working on add kprobes to it, but you
> can go ahead with markers also.
> 
> 

Hi Randy,

I got everything working and I'm thinking about posting all this stuff
soon. Do you think your patch (having renamed Kbuild to Makefile) is
ready to post ?

Mathieu

> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Begin infrastructure for kernel code samples in the samples/ directory.
> Add its Kconfig and Kbuild files.
> Source its Kconfig file in all arch/ Kconfigs.
> 
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Makefile               |   10 +++++++---
>  arch/alpha/Kconfig     |    2 ++
>  arch/arm/Kconfig       |    2 ++
>  arch/avr32/Kconfig     |    2 ++
>  arch/blackfin/Kconfig  |    2 ++
>  arch/cris/Kconfig      |    2 ++
>  arch/frv/Kconfig       |    2 ++
>  arch/h8300/Kconfig     |    2 ++
>  arch/i386/Kconfig      |    2 ++
>  arch/ia64/Kconfig      |    2 ++
>  arch/m32r/Kconfig      |    2 ++
>  arch/m68k/Kconfig      |    2 ++
>  arch/m68knommu/Kconfig |    2 ++
>  arch/mips/Kconfig      |    2 ++
>  arch/parisc/Kconfig    |    2 ++
>  arch/powerpc/Kconfig   |    2 ++
>  arch/ppc/Kconfig       |    2 ++
>  arch/s390/Kconfig      |    2 ++
>  arch/sh/Kconfig        |    2 ++
>  arch/sh64/Kconfig      |    2 ++
>  arch/sparc/Kconfig     |    2 ++
>  arch/sparc64/Kconfig   |    2 ++
>  arch/um/Kconfig        |    2 ++
>  arch/v850/Kconfig      |    2 ++
>  arch/x86_64/Kconfig    |    2 ++
>  arch/xtensa/Kconfig    |    3 ++-
>  samples/Kbuild         |    2 ++
>  samples/Kconfig        |   11 +++++++++++
>  28 files changed, 70 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.23-rc7.orig/Makefile
> +++ linux-2.6.23-rc7/Makefile
> @@ -436,6 +436,7 @@ drivers-y	:= drivers/ sound/
>  net-y		:= net/
>  libs-y		:= lib/
>  core-y		:= usr/
> +samples-y	:= samples/
>  endif # KBUILD_EXTMOD
>  
>  ifeq ($(dot-config),1)
> @@ -564,10 +565,12 @@ core-y		+= kernel/ mm/ fs/ ipc/ security
>  
>  vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
>  		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
> -		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
> +		     $(net-y) $(net-m) $(libs-y) $(libs-m))	\
> +		     $(samples-y) $(samples-m))
> +
>  
>  vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
> -		     $(init-n) $(init-) \
> +		     $(init-n) $(init-) $(samples-n) $(samples-) \
>  		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
>  		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
>  
> @@ -578,6 +581,7 @@ net-y		:= $(patsubst %/, %/built-in.o, $
>  libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
>  libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
>  libs-y		:= $(libs-y1) $(libs-y2)
> +samples-y	:= $(patsubst %/, %/built-in.o, $(samples-y))
>  
>  # Build vmlinux
>  # ---------------------------------------------------------------------------
> @@ -607,7 +611,7 @@ libs-y		:= $(libs-y1) $(libs-y2)
>  # System.map is generated to document addresses of all kernel symbols
>  
>  vmlinux-init := $(head-y) $(init-y)
> -vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
> +vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y) $(samples-y)
>  vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
>  vmlinux-lds  := arch/$(ARCH)/kernel/vmlinux.lds
>  export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
> --- /dev/null
> +++ linux-2.6.23-rc7/samples/Kbuild
> @@ -0,0 +1,2 @@
> +# Makefile for Linux samples code
> +
> --- /dev/null
> +++ linux-2.6.23-rc7/samples/Kconfig
> @@ -0,0 +1,11 @@
> +# samples/Kconfig
> +
> +menuconfig SAMPLES
> +	bool "Sample kernel code"
> +	help
> +	  You can build and test sample kernel code here.
> +
> +if SAMPLES
> +
> +
> +endif # SAMPLES
> --- linux-2.6.23-rc7.orig/arch/alpha/Kconfig
> +++ linux-2.6.23-rc7/arch/alpha/Kconfig
> @@ -669,5 +669,7 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
>  
> --- linux-2.6.23-rc7.orig/arch/arm/Kconfig
> +++ linux-2.6.23-rc7/arch/arm/Kconfig
> @@ -1067,4 +1067,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/avr32/Kconfig
> +++ linux-2.6.23-rc7/arch/avr32/Kconfig
> @@ -237,4 +237,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/blackfin/Kconfig
> +++ linux-2.6.23-rc7/arch/blackfin/Kconfig
> @@ -1012,4 +1012,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/cris/Kconfig
> +++ linux-2.6.23-rc7/arch/cris/Kconfig
> @@ -202,4 +202,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/frv/Kconfig
> +++ linux-2.6.23-rc7/arch/frv/Kconfig
> @@ -381,4 +381,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/h8300/Kconfig
> +++ linux-2.6.23-rc7/arch/h8300/Kconfig
> @@ -229,4 +229,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/i386/Kconfig
> +++ linux-2.6.23-rc7/arch/i386/Kconfig
> @@ -1260,6 +1260,8 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
>  
>  #
> --- linux-2.6.23-rc7.orig/arch/ia64/Kconfig
> +++ linux-2.6.23-rc7/arch/ia64/Kconfig
> @@ -594,3 +594,5 @@ source "arch/ia64/Kconfig.debug"
>  source "security/Kconfig"
>  
>  source "crypto/Kconfig"
> +
> +source "samples/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/m32r/Kconfig
> +++ linux-2.6.23-rc7/arch/m32r/Kconfig
> @@ -434,4 +434,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/m68k/Kconfig
> +++ linux-2.6.23-rc7/arch/m68k/Kconfig
> @@ -689,4 +689,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/m68knommu/Kconfig
> +++ linux-2.6.23-rc7/arch/m68knommu/Kconfig
> @@ -702,4 +702,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/mips/Kconfig
> +++ linux-2.6.23-rc7/arch/mips/Kconfig
> @@ -1924,4 +1924,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/parisc/Kconfig
> +++ linux-2.6.23-rc7/arch/parisc/Kconfig
> @@ -275,4 +275,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/powerpc/Kconfig
> +++ linux-2.6.23-rc7/arch/powerpc/Kconfig
> @@ -662,3 +662,5 @@ config KEYS_COMPAT
>  	default y
>  
>  source "crypto/Kconfig"
> +
> +source "samples/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/ppc/Kconfig
> +++ linux-2.6.23-rc7/arch/ppc/Kconfig
> @@ -1460,3 +1460,5 @@ source "arch/ppc/Kconfig.debug"
>  source "security/Kconfig"
>  
>  source "crypto/Kconfig"
> +
> +source "samples/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/s390/Kconfig
> +++ linux-2.6.23-rc7/arch/s390/Kconfig
> @@ -551,4 +551,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/sh/Kconfig
> +++ linux-2.6.23-rc7/arch/sh/Kconfig
> @@ -739,4 +739,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/sh64/Kconfig
> +++ linux-2.6.23-rc7/arch/sh64/Kconfig
> @@ -293,6 +293,8 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
>  
>  #
> --- linux-2.6.23-rc7.orig/arch/sparc/Kconfig
> +++ linux-2.6.23-rc7/arch/sparc/Kconfig
> @@ -333,4 +333,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/sparc64/Kconfig
> +++ linux-2.6.23-rc7/arch/sparc64/Kconfig
> @@ -482,4 +482,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/um/Kconfig
> +++ linux-2.6.23-rc7/arch/um/Kconfig
> @@ -320,6 +320,8 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
>  
>  source "drivers/scsi/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/v850/Kconfig
> +++ linux-2.6.23-rc7/arch/v850/Kconfig
> @@ -337,6 +337,8 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
>  
>  #############################################################################
> --- linux-2.6.23-rc7.orig/arch/x86_64/Kconfig
> +++ linux-2.6.23-rc7/arch/x86_64/Kconfig
> @@ -805,4 +805,6 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> +source "samples/Kconfig"
> +
>  source "lib/Kconfig"
> --- linux-2.6.23-rc7.orig/arch/xtensa/Kconfig
> +++ linux-2.6.23-rc7/arch/xtensa/Kconfig
> @@ -257,6 +257,7 @@ source "security/Kconfig"
>  
>  source "crypto/Kconfig"
>  
> -source "lib/Kconfig"
> +source "samples/Kconfig"
>  
> +source "lib/Kconfig"
>  

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
