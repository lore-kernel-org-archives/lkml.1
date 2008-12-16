Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYLPSmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYLPSmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYLPSm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:42:28 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48647 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbYLPSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:42:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lgNHqZsnmysHjy5V9qHfVkaQ2eV9XK7/U6bpmbMljhZR5or4EzbTsBXK7VI7V/3mAz
         gBywjtOdUWGvFtXjqRa9pd2qPDCQa3Lmc1Qtx1G83V23+PYpxoamiPquZ8sGi/pqESY0
         5329j2+NmpWv2kIJ4HTa7bnaAsbTYPJmXPcp8=
Date: Tue, 16 Dec 2008 21:47:04 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] remove linux/hardirq.h from asm-generic/local.h
Message-ID: <20081216184704.GA4976@x200.localdomain>
References: <20081214133941.GA18035@flint.arm.linux.org.uk> <20081214095803.9d16e85f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214095803.9d16e85f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 09:58:03AM -0800, Andrew Morton wrote:
> On Sun, 14 Dec 2008 13:39:41 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> > Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
> > asm/local.h, so this patch can be viewed as bringing the generic version
> > into line with the x86 version.
> 
> Sure.  Includes are easy to add and hard to remove.  I'll queue it up
> and see if there's fallout.

Here is some (but not everything):

arch/avr32/kernel/traps.c:63: error: implicit declaration of function 'in_interrupt'
arch/avr32/kernel/traps.c:113: error: implicit declaration of function 'nmi_enter'
arch/avr32/kernel/traps.c:124: error: implicit declaration of function 'nmi_disable'
arch/avr32/kernel/traps.c:127: error: implicit declaration of function 'nmi_exit'
arch/sh/kernel/traps_32.c:104: error: implicit declaration of function 'in_interrupt'
arch/sparc64/kernel/sysfs.c:201: error: 'cpuinfo_sparc' undeclared (first use in this function)
arch/sparc64/kernel/mdesc.c:576: error: expected ')' before '*' token


diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index 0d98737..d547c8d 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bug.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
 #include <linux/kdebug.h>
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 1e5c74e..7a2dc95 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -13,6 +13,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
diff --git a/arch/sparc64/kernel/mdesc.c b/arch/sparc64/kernel/mdesc.c
index dde52bc..3c539a6 100644
--- a/arch/sparc64/kernel/mdesc.c
+++ b/arch/sparc64/kernel/mdesc.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 
+#include <asm/cpudata.h>
 #include <asm/hypervisor.h>
 #include <asm/mdesc.h>
 #include <asm/prom.h>
diff --git a/arch/sparc64/kernel/sysfs.c b/arch/sparc64/kernel/sysfs.c
index 84e5ce1..d28f496 100644
--- a/arch/sparc64/kernel/sysfs.c
+++ b/arch/sparc64/kernel/sysfs.c
@@ -8,6 +8,7 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 
+#include <asm/cpudata.h>
 #include <asm/hypervisor.h>
 #include <asm/spitfire.h>
 
