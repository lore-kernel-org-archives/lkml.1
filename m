Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbZDATKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbZDATKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbZDATKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:10:19 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:49128 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765271AbZDATKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:10:18 -0400
Date: Wed, 1 Apr 2009 21:12:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090401191220.GB29673@uranus.ravnborg.org>
References: <20090331121331.3673cf59@hobbes> <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain> <20090401101309.67d0bea5@hobbes> <20090401183749.GC8188@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401183749.GC8188@ldl.fc.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 12:37:49PM -0600, Alex Chiang wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org>:
> > On Wed, 1 Apr 2009 10:01:12 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > 
> > > 
> > > On Tue, 31 Mar 2009, Jesse Barnes wrote:
> > > >
> > > > Please consider pulling my PCI tree from
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> > > > linux-next
> > > 
> > > This produces
> > > 
> > >   WARNING: drivers/built-in.o(.text+0x69a1): Section mismatch in
> > > reference from the function dev_rescan_store() to the
> > > function .devinit.text:pci_rescan_bus() The function
> > > dev_rescan_store() references the function __devinit
> > > pci_rescan_bus(). This is often because dev_rescan_store lacks a
> > > __devinit annotation or the annotation of pci_rescan_bus is wrong.
> > > 
> > > Hmm?
> > 
> > Arg how did I miss that?  Maybe the last build I did was missing
> > hotplug support or something... Anyway looking now (at first glance I
> > think pci_rescan_bus needs to drop __devinit).
> 
> This was my fault. pci_rescan_bus() definitely does not want
> __devinit.
> 
> But I'm confused -- didn't we used to have an option in
> menuconfig under Kernel Hacking that would turn on section
> mismatch warnings? I used to have that turned on, and don't
> remember turning it off, and I can't find it now.
> 
> I'm told that we're supposed to set it on the make command line,
> like:
> 
> 	make CONFIG_DEBUG_SECTION_MISMATCH=y -j16
> 
> or something. Has this changed recently or am I just imagining
> things (or just plain stupid?)

That was maybe one year ago we had it in menuconfig.
When I get on top of things I will enable it and try to
help fixing the remaining warnings.

I have resisted enabling it for now as I cannot support the people
that see the warnings atm.

The patch to enable it is simple so if anyone want
to help fix the warnings then...

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9638d99..ee5e6f3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -95,10 +95,6 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED
-	# This option is on purpose disabled for now.
-	# It will be enabled when we are down to a resonable number
-	# of section mismatch warnings (< 10 for an allyesconfig build)
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.


	Sam
