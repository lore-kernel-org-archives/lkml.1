Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYG3IiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYG3IiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYG3IiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:38:11 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:34495 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbYG3IiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:38:10 -0400
Date: Wed, 30 Jul 2008 10:38:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080730083853.GB18366@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <48900EE4.8030606@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48900EE4.8030606@snapgear.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 04:49:08PM +1000, Greg Ungerer wrote:
> Hi Sam,
> 
> Sam Ravnborg wrote:
> >The traditional location of the arch specific Makefiles
> >has been at:
> >
> >	include/asm-$ARCH
> >
> >But as suggested by several people over time and lately
> >by Linus in the following post:
> >http://kerneltrap.org/mailarchive/linux-kernel/2008/5/21/1903924
> >
> >is is suggested to move the arch specific files under arch/
> >and for the header files this is arch/$ARCH/include.
> >
> >So I have hacked up support for this in kbuild so
> >for the simpler cases a simple move of header files as
> >in:
> >	git mv include/asm-$ARCH arch/$ARCH/include/asm
> >
> >is enough.
> >
> >If Linus will accept it then I think -rc1 is a perfect
> >time to do it as people has less stuff pending touching
> >the header files that are moved.
> >Validation is easy - does the usual configs build?
> >
> >For the archs that plays games with symlinks this is a
> >splendid opportunity to get rid af these.
> >The receipe is simple:
> >Use 
> >	KBUILD_CFLAGS += -Iarch/$ARCH/include/$CPU
> >
> >to select the CPU and then do a copy of the header files
> >like this:
> >
> >	git mv include/asm-$ARCH/$CPU arch/$ARCH/include/$CPU/cpu
> >
> >Then the code can continue to use:
> >
> >	#include <cpu/foo.h>
> >
> >I already converted sparc to use arch/sparc/include -
> >while I merged the header files for sparc and sparc64.
> >This change is already upstream.
> >
> >And for SH I posted a receipe which you can read here:
> >http://lkml.org/lkml/2008/7/28/83
> >
> >It is SH specific but anyway pretty generic.
> >
> >I am limited in time and resources at the moment but I
> >would be glad to help out as time permits should there
> >be any questions.
> 
> I just tried moving the include/asm-m68knommu directory
> to arch/m68knommu/include/asm and it all worked fine.
> Clean compile first go :-)  Nice.  (As noted
> asm-offsets.h was still generated in incldue/asm-m68knommu
> afterwards though).
> 
> So what is the status, should I prepare git/patch
> for Linus?
Yes please do so.

Then we can address m68k and fix the breakage that
the sparc changes introduced.

	Sam
