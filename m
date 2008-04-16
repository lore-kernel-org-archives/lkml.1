Return-Path: <linux-kernel-owner+w=401wt.eu-S1765709AbYDPVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765709AbYDPVgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYDPVgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:36:04 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:34941 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYDPVgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:36:00 -0400
Message-Id: <20080416213426.298498397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 17:34:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [RFC patch 00/27] Jump-based NMI-safe immediate values and markers for sched-devel.git
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 16 Apr 2008 21:35:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is the patchset you requested. I did not port the marker reintegration
to your sched-devel tree though, because many changes happened since you have
done the original work.

It applies on top of sched-devel.git latest.

You will notice that I implemented what we discussed yesterday : using nops and
jump for the heavily optimized version of markers. Comments are welcome. Running
this with my ~120 LTTng markers on x86_32 detects 97% of the sites. 4 out of 120
did had to fall back on the standard immediate values because they have been
manipulated by gcc optimizations. The sched-devel.git port has been tested
on x86_32. Patches before the port are tested on x86_32 and x86_64.

Note that some folding of the immediate values patches could eventually be
required. At that point, add-all-cpus-option-to-stop-machine-run.patch would
become useless.

The series order is the following :

make-marker_debug-static.patch # in -mm
x86-nmi-safe-int3-and-page-fault.patch
check-for-breakpoint-in-text-poke-to-eliminate-bug-on.patch
#Kprobes mutex cleanup
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
#Text Edit Lock (depends on Enhance DEBUG_RODATA and kprobes mutex cleanup)
text-edit-lock-architecture-independent-code.patch
text-edit-lock-kprobes-architecture-independent-support.patch
#
#Immediate Values
add-all-cpus-option-to-stop-machine-run.patch
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-menu-in-embedded.patch
immediate-values-x86-optimization.patch
add-text-poke-and-sync-core-to-powerpc.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
immediate-values-support-init.patch
#
scheduler-profiling-use-immediate-values.patch
#
markers-remove-extra-format-argument.patch
markers-define-non-optimized-marker.patch
#
immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
add-discard-section-to-x86.patch
immediate-values-x86-optimization-nmi-mce-support.patch
immediate-values-powerpc-optimization-nmi-mce-support.patch
immediate-values-use-arch-nmi-mce-support.patch
linux-kernel-markers-immediate-values.patch
#
immediate-values-jump.patch
markers-use-imv-jump.patch


Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
