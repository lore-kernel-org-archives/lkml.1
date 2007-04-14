Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbXDNVUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbXDNVUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXDNVUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:20:14 -0400
Received: from gw.goop.org ([64.81.55.164]:59513 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXDNVUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:13 -0400
Message-Id: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:41:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: [PATCH 00/28] Updates for firstfloor paravirt-ops patches
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This is a set of updates for the firstfloor patch queue.

Quick rundown:

revert-mm-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
separate-module-percpu-space.patch
	Update the module percpu accounting patch

fix-ff-allow-percpu-variables-to-be-page-aligned.patch
	Make sure the percpu memory allocation is page-aligned

deflate-stack-usage-in-lib_inflate_c.patch
	Fix deflate stack usage.  With all the arch-fixes rolled in.

i386-gdt-cleanups-page-align-the-gdt.patch
i386-convert-pda-into-the-percpu-section.patch
i386-cleanups-to-help-using-per-cpu-variables-from-asm.patch
percpu-define-per_cpu_offset.patch
fix-uniproc-gdt-bugs.patch
	Percpu and GDT fixes.

x86-map-enough-initial-memory.patch
	Fix head.S to map enough memory.

cleanup-cleanup-asm-bugs_h.patch
cleanup-identify_cpu-fix.patch
	This is the pair I tried to post yesterday, but they
	got interrupted by an network outage.  They basically
	add a little more cleanup, and move a misplaced hunk.
	cleanup-cleanup-asm-bugs_h.patch should go after/roll
	into the clean-up-asm-(i386|x86_64)-bugs_h patches, and
	cleanup-identify_cpu-fix.patch should go after/roll into
	clean-up-identify_cpu patch.

paravirt-flush-on-kunmap_atomic.patch
	Flush pending lazy mmu operations on kunmap_atomic too.

paravirt-fix-paravirt_lazy.patch
	Fix up an apparent mismerge: remove the #defines for
	PARAVIRT_LAZY_* and add _LAZY_FLUSH to the enum.

i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
paravirt-kmap_atomic_pte-tidy.patch
vmi-supports-compat-vdso.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
buslogic-check-range-fixes.patch
pte-drop-ptep_get_and_clear-paravirt-op.patch
	A chunk of pages from Zach.

rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
	Obvious.

vmi-fix-ff.patch
	Make VMI compile in the -ff patchstack.

paravirt-sched-clock-ff.patch
	Updated paravirt-sched-lock for your sched_clock.

Thanks,
	J

-- 

