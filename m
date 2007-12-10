Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbXLJNme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbXLJNme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbXLJNm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:42:26 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33378 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbXLJNmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:42:25 -0500
Date: Mon, 10 Dec 2007 19:12:14 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com
Subject: Re: [PATCH 2/2] Kprobes: Build kretprobe samples only if arch supports kretprobes - updated
Message-ID: <20071210134214.GA30004@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071210095221.GA19425@in.ibm.com> <20071210095350.GB19425@in.ibm.com> <20071210120026.GA14992@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210120026.GA14992@uranus.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 01:00:26PM +0100, Sam Ravnborg wrote:
> On Mon, Dec 10, 2007 at 03:23:50PM +0530, Ananth N Mavinakayanahalli wrote:
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > This patch builds samples/kprobes/kretprobe_example.c only on archs that
> > support kretprobes.
> > 
> > 
> > Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > ---
> >  samples/kprobes/Makefile |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.24-rc4/samples/kprobes/Makefile
> > ===================================================================
> > --- linux-2.6.24-rc4.orig/samples/kprobes/Makefile
> > +++ linux-2.6.24-rc4/samples/kprobes/Makefile
> > @@ -1,5 +1,8 @@
> >  # builds the kprobes example kernel modules;
> >  # then to use one (as root):  insmod <module_name.ko>
> >  
> > -obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
> > -		kretprobe_example.o
> > +obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
> > +
> > +ifeq ($(CONFIG_HAVE_KRETPROBES),y)
> > +obj-$(CONFIG_SAMPLE_KPROBES) += kretprobe_example.o
> > +endif
> 
> It would be nice to push this configuration dependency to Kconfig.
> Something like:
> 
> config SAMPLE_KRETPROBES
> 	default y
> 	depends on SAMPLE_KPROBES
> 
> And then in the Makefile have:
> obj-$(CONFIG_SAMPLE_KRETPROBES) += kretprobe_example.o

Done. Updated patch below...

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch builds samples/kprobes/kretprobe_example.c only on archs that
support kretprobes. Thanks to Sam Ravnborg for Kconfig suggestions.


Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 samples/Kconfig          |    5 +++++
 samples/kprobes/Makefile |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc4/samples/kprobes/Makefile
===================================================================
--- linux-2.6.24-rc4.orig/samples/kprobes/Makefile
+++ linux-2.6.24-rc4/samples/kprobes/Makefile
@@ -1,5 +1,5 @@
 # builds the kprobes example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
-		kretprobe_example.o
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
+obj-$(CONFIG_SAMPLE_KRETPROBES) += kretprobe_example.o
Index: linux-2.6.24-rc4/samples/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/samples/Kconfig
+++ linux-2.6.24-rc4/samples/Kconfig
@@ -28,5 +28,10 @@ config SAMPLE_KPROBES
 	help
 	  This build several kprobes example modules.
 
+config SAMPLE_KRETPROBES
+	tristate "Build kretprobes example -- loadable modules only"
+	default m
+	depends on SAMPLE_KPROBES && HAVE_KRETPROBES
+
 endif # SAMPLES
 
