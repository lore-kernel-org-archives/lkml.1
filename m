Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYDIQWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYDIQWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYDIQVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:21:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58345 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbYDIQVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:21:18 -0400
Message-Id: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 00/17] Text Edit Lock and Immediate Values for 2.6.25-rc8-mm1
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the complete patchset required to get basic Immediate Values support
ported to 2.6.25-rc8-mm1. It provides the "simple", non nmi-safe version of
immediate values, which means that immediate values should not be used in code
paths reachable by NMI or MCE handlers. This version also uses
stop_machine_run() for immediate values updates, which is a very heavy lock.  In
order to make incremental, easy to review, changes, I think we could start by
this "simple" version as a first step before we switch to the nmi-safe version
later.

It applies at the end of your series files in the following order :

# The following patches are required for any kind of immediate values
# implementation
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch

x86-enhance-debug-rodata-support-alternatives.patch
fix-text-poke-for-vmalloced-pages.patch
x86-enhance-debug-rodata-support-for-hotplug-and-kprobes.patch

text-edit-lock-architecture-independent-code.patch
text-edit-lock-kprobes-architecture-independent-support.patch

# The following patches provide non nmi-safe immediate values
add-all-cpus-option-to-stop-machine-run.patch
immediate-values-architecture-independent-code.patch
implement-immediate-update-via-stop-machine-run.patch
immediate-values-kconfig-menu-in-embedded.patch
immediate-values-x86-optimization.patch
add-text-poke-and-sync-core-to-powerpc.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch

#Those are the immediate values users
scheduler-profiling-use-immediate-values.patch

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
