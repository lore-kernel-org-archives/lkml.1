Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXKPDoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXKPDoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbXKPDoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:44:38 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59733 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbXKPDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:44:37 -0500
Date: Thu, 15 Nov 2007 19:44:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config
 targets
Message-Id: <20071115194412.d7e076ec.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0711160205340.1817@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
	<11947274093185-git-send-email-sam@ravnborg.org>
	<11947274091127-git-send-email-sam@ravnborg.org>
	<Pine.LNX.4.64.0711142116500.1818@scrub.home>
	<20071114220840.GB10920@uranus.ravnborg.org>
	<Pine.LNX.4.64.0711151616330.1817@scrub.home>
	<20071115192555.GD23914@uranus.ravnborg.org>
	<Pine.LNX.4.64.0711152036430.1817@scrub.home>
	<20071115204520.GA24851@uranus.ravnborg.org>
	<Pine.LNX.4.64.0711152158310.1817@scrub.home>
	<20071115220640.GA25265@uranus.ravnborg.org>
	<Pine.LNX.4.64.0711160205340.1817@scrub.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 02:28:09 +0100 (CET) Roman Zippel wrote:

> Hi,
> 
> On Thu, 15 Nov 2007, Sam Ravnborg wrote:
> 
> > You suggest just to check ARCH value and not apply your patch. This was
> > not my initial understanding as was hopefully obvious from my reply.
> 
> This patch only adds some extra features.
> 
> > If user did NOT specify ARCH we should use the kernel configuration - which
> > your solution fail to do.
> 
> To make this easy I attached the patch which reverts the problematic 
> changes and then you only need this simple change to force the 64BIT value 
> for ARCH={i386,x86_64}, otherwise it's set by the user:

Roman,

This all began (AFAIK) because some of us want to continue to be
able to specify ARCH={i386,x86_64} on the (make) command line --
not by using a .config file.  Taking away ARCH= on the command line
is a regression (in some minds, at least), so Sam provided that
capability.  Is that capability still present after this patch?

Thanks.


> bye, Roman
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> 
> ---
>  Makefile         |    3 ++-
>  arch/x86/Kconfig |    4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/Makefile
> ===================================================================
> --- linux-2.6.orig/Makefile
> +++ linux-2.6/Makefile
> @@ -165,7 +165,8 @@ export srctree objtree VPATH TOPDIR
>  # then ARCH is assigned, getting whatever value it gets normally, and 
>  # SUBARCH is subsequently ignored.
>  
> -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
> +				  -e s/sun4u/sparc64/ \
>  				  -e s/arm.*/arm/ -e s/sa110/arm/ \
>  				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
>  				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -3,8 +3,8 @@ mainmenu "Linux Kernel Configuration for
>  
>  # Select 32 or 64 bit
>  config 64BIT
> -	bool "64-bit kernel"
> -	default n
> +	bool "64-bit kernel" if ARCH="x86"
> +	default ARCH="x86_64"
>  	help
>  	  Say yes to build a 64-bit kernel - formerly known as x86_64
>  	  Say no to build a 32-bit kernel - formerly known as i386


---
~Randy
