Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXDEAR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXDEAR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbXDEAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:26 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36888 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932267AbXDEARG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:17:06 -0400
Message-Id: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:11:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 00/20] paravirt_ops updates
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Here's a repost of the paravirt_ops update series I posted the other day.
Since then, I found a few potential bugs with patching clobbering,
cleaned up and documented paravirt.h and the patching machinery.

Overview:

add-MAINTAINERS.patch
	obvious

remove-CONFIG_DEBUG_PARAVIRT.patch
	No longer meaningful or needed.

paravirt-nop.patch
	Clean up nop paravirt_ops functions, mainly to allow the patching
	machinery to easily identify them.

paravirt-pte-accessors.patch
	Accessors to allow pv_ops to control the content of pagetable entries.

paravirt-memory-init.patch
	Hook into initial pagetable creation.

paravirt-fixmap.patch
	Create a fixmap for early paravirt_ops mappings.

shared-kernel-pmd.patch
	Make the choice of whether the kernel pmd is shared between
	processes or not a runtime selectable flag.

mm-lifetime-hooks.patch
	Hooks to allow the creation, use and destruction of an mm_struct
	to be followed.

paravirt-patch-rename-paravirt_patch.patch
	Rename a structure to make its use a bit more clear.

paravirt-use-offset-site-ids.patch
	Use the offsetof each function pointer in paravirt_ops as the
	basis of its patching identifier.

paravirt-fix-clobbers.patch
	Fix up various register/use clobber problems.  This may be 2.6.21
	material, but I don't think it will materially affect VMI.

paravirt-patchable-call-wrappers.patch
	Wrap each paravirt_ops call to allow the callsites to be runtime
	patched.

paravirt-document-paravirt_ops.patch
	Document the paravirt_ops structure itself, the patching
	mechanism, and other cleanups.

paravirt-patch-machinery.patch
	General patch machinery for use by pv_ops backends to implment
	patching.

paravirt-flush_tlb_others.patch
	Add a hook for cross-cpu tlb flushing.

revert-map_pt_hook.patch
	Back out the map_pt_hook change.

paravirt-kmap_atomic_pte.patch
	Replace map_pt_hook with kmap_atomic_pte.

cleanup-tsc-sched-clock.patch
	Clean up the tsc-based sched_clock.  (I think you already
	have this.)

paravirt-sched-clock.patch
	Add a hook for sched_clock, so that paravirt_ops backends can
	report unstolen time for use as the scheduler clock.

apply-to-page-range.patch
	Apply a function to a range of pagetable entries.

Thanks,
	J

-- 

