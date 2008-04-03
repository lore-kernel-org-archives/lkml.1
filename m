Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYDCMsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYDCMsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYDCMr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:47:58 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33474 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYDCMr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:47:57 -0400
Date: Thu, 3 Apr 2008 14:48:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       geert@linux-m68k.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 01/22] Generic show_mem() implementation
Message-ID: <20080403124820.GA30356@uranus.ravnborg.org>
References: <12071688283927-git-send-email-hannes@saeurebad.de> <1207168839586-git-send-email-hannes@saeurebad.de> <20080403075545.GC4125@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403075545.GC4125@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 09:55:45AM +0200, Heiko Carstens wrote:
> > diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> > index 729cdbd..efffa92 100644
> > --- a/arch/alpha/Kconfig
> > +++ b/arch/alpha/Kconfig
> > @@ -598,6 +598,9 @@ config ALPHA_LARGE_VMALLOC
> > 
> >  	  Say N unless you know you need gobs and gobs of vmalloc space.
> > 
> > +config HAVE_ARCH_SHOW_MEM
> > +	def_bool y
> > +
> >  config VERBOSE_MCHECK
> >  	bool "Verbose Machine Checks"
> > 
> > diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> > index 76348f0..acad217 100644
> > --- a/arch/arm/mm/Kconfig
> > +++ b/arch/arm/mm/Kconfig
> > @@ -673,3 +673,6 @@ config OUTER_CACHE
> >  config CACHE_L2X0
> >  	bool
> >  	select OUTER_CACHE
> > +
> > +config HAVE_ARCH_SHOW_MEM
> > +	def_bool y
> 
> These are all not necessary. Better add some global Kconfig option that
> gets selected by an arch if it wants the generic implementation.
> 
> e.g. we currently have this in arch/s390/Kconfig:
> 
> config S390
>         def_bool y
>         select HAVE_OPROFILE
>         select HAVE_KPROBES
>         select HAVE_KRETPROBES
> 
> just add a select HAVE_GENERIC_SHOWMEM or something like that in the arch
> specific patches.
Seconded.
See Documentation/kbuild/kconfig-language.txt for a few more hints
how to do it.

	Sam
