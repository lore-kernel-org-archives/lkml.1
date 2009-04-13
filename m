Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZDMBwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZDMBwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZDMBwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:52:13 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:38325 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZDMBwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:52:12 -0400
Date: Sun, 12 Apr 2009 21:52:03 -0400
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, david-b@pacbell.net, jordan@cosmicpenguin.net,
       katzj@redhat.com, tiwai@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: +
 cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch added
 to -mm tree
Message-ID: <20090412215203.45e2a876@ephemeral>
In-Reply-To: <49DFA576.6040005@oracle.com>
References: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>
	<49DFA576.6040005@oracle.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 13:00:54 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The patch titled
> >      cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
> > has been added to the -mm tree.  Its filename is
> >      cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your
> > code ***
> > 
> > See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > The current -mm tree may be found at
> > http://userweb.kernel.org/~akpm/mmotm/
> > 
> > ------------------------------------------------------
> > Subject:
> > cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix From:
> > Andres Salomon <dilinger@queued.net>
> > 
> > force GPIO_CS553X to be defined when OLPC is selected
> > 
> > We've begun using the generic GPIO stuff for geodes, so OLPC
> > implicitly depends upon this.  This patch forces selection of it.
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Cc: Jeremy Katz <katzj@redhat.com>
> > Cc: Jordan Crouse <jordan@cosmicpenguin.net>
> > Cc: David Brownell <david-b@pacbell.net>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  arch/x86/Kconfig         |    1 +
> >  pci/cs5535audio/Makefile |    0 
> >  2 files changed, 1 insertion(+)
> > 
> > diff -puN
> > arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
> > arch/x86/Kconfig ---
> > a/arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
> > +++ a/arch/x86/Kconfig @@ -1972,6 +1972,7 @@ config
> > GEODE_MFGPT_TIMER config OLPC
> >  	bool "One Laptop Per Child support"
> > +	select GPIO_CS553X
> >  	default n
> >  	---help---
> >  	  Add support for detecting the unique features of the OLPC
> 
> 
> In mmotm-2009-0410, this patch causes build errors when GPIOLIB is
> not enabled since GPIO_CS553X uses gpiolib functions & struct fields:
> 
> drivers/gpio/cs553x-gpio.c:23: error: field 'chip' has incomplete type
[...]
> 
> 
> One possible patch is also to select GPIOLIB above in the OLPC config
> block.
> 

Does the following help?  I think this is what we want (gpio-cs553x uses
gpiolib).  I'm a bit unclear how the other gpio drivers get away with
including linux/gpio.h and using gpio_chip without requiring GPIOLIB.
Maybe they implicitly are built on architectures which select
CONFIG_ARCH_REQUIRE_GPIOLIB?




Force GPIO_CS553X to select GPIOLIB, which it makes use of.

Signed-off-by: Andres Salomon <dilinger@debian.org>

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 797ff45..17d7364 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -148,6 +148,7 @@ comment "PCI GPIO expanders:"
 config GPIO_CS553X
 	tristate "AMD cs5535/cs5536 GPIO support"
 	depends on PCI && !CS5535_GPIO && !MGEODE_LX
+	select GPIOLIB
 	help
 	  The AMD cs5535 and cs5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The cs553x is found on
