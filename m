Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYAJPyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYAJPyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbYAJPyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:54:14 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35779 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbYAJPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:54:13 -0500
Date: Thu, 10 Jan 2008 21:24:20 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 1/7] Add tests/ directory
Message-ID: <20080110155420.GA8138@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080110115428.GA26577@in.ibm.com> <20080110115537.GB26577@in.ibm.com> <20080110151635.GA15361@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110151635.GA15361@uranus.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 04:16:35PM +0100, Sam Ravnborg wrote:
> On Thu, Jan 10, 2008 at 05:25:37PM +0530, Ananth N Mavinakayanahalli wrote:
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > Create a toplevel tests/ directory to house in-kernel subsystem specific
> > tests.
> > 
> > PS: I am not sure if I've gotten the Makefile change right.
> > 
> > Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > ---
> >  Makefile          |    3 +++
> >  lib/Kconfig.debug |    2 ++
> >  tests/Kconfig     |   11 +++++++++++
> >  tests/Makefile    |    3 +++
> >  4 files changed, 19 insertions(+)
> > 
> > Index: linux-2.6.24-rc6/lib/Kconfig.debug
> > ===================================================================
> > --- linux-2.6.24-rc6.orig/lib/Kconfig.debug
> > +++ linux-2.6.24-rc6/lib/Kconfig.debug
> > @@ -596,3 +596,5 @@ config PROVIDE_OHCI1394_DMA_INIT
> >  	  See Documentation/debugging-via-ohci1394.txt for more information.
> >  
> >  source "samples/Kconfig"
> > +
> > +source "tests/Kconfig"
> > Index: linux-2.6.24-rc6/tests/Kconfig
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.24-rc6/tests/Kconfig
> > @@ -0,0 +1,11 @@
> > +# tests/Kconfig
> > +
> > +menuconfig KERNEL_TESTS
> > +	bool "Kernel subsystem tests"
> > +	help
> > +	  You can build kernel subsystem specific tests.
> > +
> > +if KERNEL_TESTS
> > +
> > +endif # KERNEL_TESTS
> > +
> > Index: linux-2.6.24-rc6/tests/Makefile
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.24-rc6/tests/Makefile
> > @@ -0,0 +1,3 @@
> > +#
> > +# Makefile for kernel subsystem specific tests
> > +#
> > Index: linux-2.6.24-rc6/Makefile
> > ===================================================================
> > --- linux-2.6.24-rc6.orig/Makefile
> > +++ linux-2.6.24-rc6/Makefile
> > @@ -598,6 +598,9 @@ export mod_strip_cmd
> >  
> >  ifeq ($(KBUILD_EXTMOD),)
> >  core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> > +ifdef CONFIG_KERNEL_TESTS
> > +core-y		+= tests/
> > +endif
> 
> CONFIG_KERNEL_TESTS is a bool so this should be written as:
> core-$(CONFIG_KERNEL_TESTS) += tests/
> 
> With this change:
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks Sam!

Updated patch below...

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Create a toplevel tests/ directory to house in-kernel subsystem specific
tests.

PS: I am not sure if I've gotten the Makefile change right.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile          |    1 +
 lib/Kconfig.debug |    2 ++
 tests/Kconfig     |   11 +++++++++++
 tests/Makefile    |    3 +++
 4 files changed, 17 insertions(+)

Index: linux-2.6.24-rc6/lib/Kconfig.debug
===================================================================
--- linux-2.6.24-rc6.orig/lib/Kconfig.debug
+++ linux-2.6.24-rc6/lib/Kconfig.debug
@@ -596,3 +596,5 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
 source "samples/Kconfig"
+
+source "tests/Kconfig"
Index: linux-2.6.24-rc6/tests/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.24-rc6/tests/Kconfig
@@ -0,0 +1,11 @@
+# tests/Kconfig
+
+menuconfig KERNEL_TESTS
+	bool "Kernel subsystem tests"
+	help
+	  You can build kernel subsystem specific tests.
+
+if KERNEL_TESTS
+
+endif # KERNEL_TESTS
+
Index: linux-2.6.24-rc6/tests/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.24-rc6/tests/Makefile
@@ -0,0 +1,3 @@
+#
+# Makefile for kernel subsystem specific tests
+#
Index: linux-2.6.24-rc6/Makefile
===================================================================
--- linux-2.6.24-rc6.orig/Makefile
+++ linux-2.6.24-rc6/Makefile
@@ -598,6 +598,7 @@ export mod_strip_cmd
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_KERNEL_TESTS) += tests/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
