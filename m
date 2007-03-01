Return-Path: <linux-kernel-owner+w=401wt.eu-S1161292AbXCAX4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161292AbXCAX4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161266AbXCAX4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:56:49 -0500
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:47843 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161146AbXCAX4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:56:48 -0500
Message-Id: <20070301232443.195603797@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Mar 2007 15:24:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for paravirt_ops interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This patch series implements the Linux Xen guest as a paravirt_ops
backend.  The features in implemented this patch series are:
 * domU only
 * UP only (most code is SMP-safe, but there's no way to create a new vcpu)
 * writable pagetables, with late pinning/early unpinning
   (no shadow pagetable support)
 * supports both PAE and non-PAE modes
 * xen hvc console (console=hvc0)
 * virtual block device (blockfront)
 * virtual network device (netfront)

The patch series is in three parts:
  1-2	Cleanup patches to various parts of the kernel
  3-15	Extensions to the core code and/or paravirt ops, needed to support
	Xen. Includes hooks into get/setting pte values and the new
	patching machinery.
 16-26	The Xen paravirt_ops implementation itself.

(Some of the earlier patches in the series have already been posted,
 but are included to make the series self-contained.)

I've tried to make each patch as self-explanatory as possible.  The
series is based on 2.6.21-rc2-git1.

Changes since the previous posting:
- Moved the arch_*_mmap stubs to asm-generic/mm_hooks.h, and included that in
  asm-*/mmu_context.h (James Bottomley)
- Use unsigned long consistently for addresses (Andi Kleen)
- Moved xenboot_console declaration to its own header. (Andi Kleen)
- Renamed FIX_PARAVIRT to FIX_PARAVIRT_BOOTMAP to emphasize that its intended
  for bootstrap only (Ingo Molnar)
- Cleaned up headers a fair bit.  Moved a lot of the native_*
  functions to their "home" headers, so that they can be used either for
  native paravirt boots, or when CONFIG_PARAVIRT is disabled.  This cuts
  down on duplication, and makes paravirt.h simpler.
- Various cleanups from Adrian Bunk

Thanks,
	J
-- 

