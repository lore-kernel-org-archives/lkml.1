Return-Path: <linux-kernel-owner+w=401wt.eu-S934688AbXHYUWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688AbXHYUWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 16:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934186AbXHYUW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 16:22:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934013AbXHYUW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 16:22:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on x86_64
Date: Sat, 25 Aug 2007 22:32:42 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708241206.57178.rjw@sisk.pl> <200708241211.55319.rjw@sisk.pl> <20070824162346.ec57f508.akpm@linux-foundation.org>
In-Reply-To: <20070824162346.ec57f508.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708252232.43478.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 August 2007 01:23, Andrew Morton wrote:
> On Fri, 24 Aug 2007 12:11:54 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Index: linux-2.6.23-rc3/include/asm-x86_64/suspend.h
> > ===================================================================
> > --- linux-2.6.23-rc3.orig/include/asm-x86_64/suspend.h	2007-08-21 20:36:49.000000000 +0200
> > +++ linux-2.6.23-rc3/include/asm-x86_64/suspend.h	2007-08-21 20:37:47.000000000 +0200
> > @@ -43,4 +43,10 @@ extern void fix_processor_context(void);
> >  /* routines for saving/restoring kernel state */
> >  extern int acpi_save_state_mem(void);
> >  
> > +#define ARCH_HAS_HIBERNATION_HEADER
> 
> The preferred way of doing this is via Kconfig, please.  ie: add a
> CONFIG_HIBERNATION_HEADER to arch/x86_64/Kconfig.

OK

> > +
> > +/* arch/x86_64/kernel/suspend.c */
> > +extern int arch_hibernation_header_save(void *addr, unsigned int max_size);
> > +extern int arch_hibernation_header_restore(void *addr);
> 
> Given that these are called from non-arch-specific code, they must have the
> same signature across all architectures.  So there's no point in putting
> the prototypes into an arch-specific header file.
> 
> It would be better to do something like this in (say) suspend.h:
> 
> #ifdef CONFIG_HIBERNATION_HEADER
> extern int arch_hibernation_header_save(void *addr, unsigned int max_size);
> extern int arch_hibernation_header_restore(void *addr);
> #else
> static inline int arch_hibernation_header_save(void *addr,
> 						unsigned int max_size)
> {
> 	return 0;
> }
> 
> static inline int arch_hibernation_header_restore(void *addr)
> {
> 	return 0;
> }
> #endif
> 
> then go nuke some ifdefs from the .c files.

The ifdefs in snapshot.c are necessary anyway, because they are around some
code that is only compiled when the CONFIG_HIBERNATION_HEADER is undefined.

I'll post the reworked patches in a new thread once again after the other issue
raised by Pavel gets settled.
