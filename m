Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYGEKhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYGEKhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYGEKg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:36:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYGEKg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:36:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 3
Date: Sat, 5 Jul 2008 12:38:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       kernel-testers@vger.kernel.org
References: <20080703190948.8e7bceca.sfr@canb.auug.org.au> <200807040154.16200.rjw@sisk.pl>
In-Reply-To: <200807040154.16200.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051238.55044.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 4 of July 2008, Rafael J. Wysocki wrote:
> On Thursday, 3 of July 2008, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since next-20080702:
> > 
> > New trees:  kmemcheck and generic-ipi.
> > 
> > The pci tree gained a conflict against the driver-core tree.
> > 
> > The powerpc tree gained a conflict against the i2c tree.
> > 
> > The net tree gained a couple of conflicts against Linus' tree and the
> > wireless-current tree.
> > 
> > The wireless tree gained a couple of conflicts against the
> > wireless-current tree.
> > 
> > The rr tree lost its two build fixup patches but gained another conflict
> > against the sched tree.
> > 
> > The blk-removal tree lost its conflict with the s390 tree.
> > 
> > The kmemcheck tree gained conflicts against the ftrace, sched, and x86
> > trees.
> > 
> > The generic-ipi tree gained conflicts against the powerpc, kmemcheck and
> > net trees.  And had two build failures requiring a patch and a revert.
> > 
> > I have also applied the following patches for known problems (I assume
> > that these will be merged into their appropriate trees shortly):
> > 
> > 	NFS: Fix the mount protocol defaults for binary mounts
> > 	fix "ftrace: store mcount address in rec->ip"
> > 
> > There are several outstanding build failures due to structural changes in
> > the ttydev tree (see http://kisskb.ellerman.id.au/linux-next).
> 
> This tree didn't compile for me on x86-64.
> 
> After adding the appended patch it started to compile, but it doesn't boot
> (hangs very early, before any messages can get to the console).
> 
> I'll bisect tomorrow if I have the time.

This problem is fixed by applying the appended patch.

Thanks,
Rafael

---
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Sun Jun 29 20:02:44 2008 -0700

    x86: setup_arch() && early_ioremap_init()
    
    Looks like the setup.c unification missed the early_ioremap init from
    the early_ioremap unification.  Unconditionally call early_ioremap_init().
    
    needed for "x86/paravirt: groundwork for 64-bit Xen support".
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Mark McLoughlin <markmc@redhat.com>
    Cc: xen-devel <xen-devel@lists.xensource.com>
    Cc: Eduardo Habkost <ehabkost@redhat.com>
    Cc: Vegard Nossum <vegard.nossum@gmail.com>
    Cc: Stephen Tweedie <sct@redhat.com>
    Cc: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fb318ed..caec79f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -523,12 +523,13 @@ void __init setup_arch(char **cmdline_p)
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
-	early_ioremap_init();
 	reserve_setup_data();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	early_ioremap_init();
+
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;

--
