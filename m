Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYJLJjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYJLJjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYJLJjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:39:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9454 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYJLJjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sh7ygVDPlCD8CJXYtOneU/ptH79Z0ub8f8HqgKjWEGBZglD2VynBfKsYDbmiFPJR3P
         1mEW52Y3zHWeH5pd7XzBSjrB5p2yReN/cqeJnVl4LxGMRhzJxiIFaaL6wgVAbunrL0Wn
         yeXtvS+wjQ7t4k0Lddgaom1tXTI/2tIxsAbfE=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/7] post x86 merge section mismatch fixes
Date: Sun, 12 Oct 2008 11:38:43 +0200
Message-Id: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/7] x86, xsave: fix section mismatch warning - setup_xstate_init
[PATCH 2/7] x86: fix section mismatch warning - reserve_region_with_split
[PATCH 3/7] x86: fix section mismatch warning - apic_flat
[PATCH 4/7] x86: fix section mismatch warning - apic_physflat
[PATCH 5/7] x86: fix section mismatch warning - apic_x2apic_uv_x
[PATCH 6/7] x86: fix section mismatch warning - apic_x2apic_cluster
[PATCH 7/7] x86: fix section mismatch warning - apic_x2apic_phys

 arch/x86/kernel/genapic_flat_64.c   |    4 ++--
 arch/x86/kernel/genx2apic_cluster.c |    2 +-
 arch/x86/kernel/genx2apic_phys.c    |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c    |    2 +-
 arch/x86/kernel/xsave.c             |    2 +-
 kernel/resource.c                   |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

One warning left:

WARNING: vmlinux.o(.cpuinit.text+0x4ad): Section mismatch in reference from the function fpu_init() to the function .init.text:init_thread_xstate()
The function __cpuinit fpu_init() references
a function __init init_thread_xstate().
If init_thread_xstate is only used by fpu_init then
annotate init_thread_xstate with a matching annotation.

x86_64 cpu_init() (marked __cpu_init) calls fpu_init() (marked __cpu_init)
and fpu_init calls init_thread_xstate (which is __init) if smp_processor_id() == 0.
So it's probably OK, but it should be fixed properly (without ugly __ref)


Marcin
