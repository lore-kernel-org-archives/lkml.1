Return-Path: <linux-kernel-owner+w=401wt.eu-S1764337AbYARSak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764337AbYARSak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764022AbYARS35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:29:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60688 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760276AbYARS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:29:55 -0500
Message-Id: <20080118182953.748071000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jan 2008 10:29:53 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] percpu: Per cpu code simplification fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset simplifies the code that arches need to maintain to support
per cpu functionality. Most of the code is moved into arch independent
code. Only a minimal set of definitions is kept for each arch.

The patch also unifies the x86 arch so that there is only a single
asm-x86/percpu.h

Based on: 2.6.24-rc8-mm1

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---

fixup:

  - rebased from 2.6.24-rc6-mm1 to 2.6.24-rc8-mm1
    (removed changes that are in the git-x86.patch)
  - added back in missing fold-percpu_modcopy pieces

V3->V4:
  - rebased patchset on 2.6.24-rc6-mm1
    (removes the percpu_modcopy changes that are already in.)
  - change config ARCH_SETS_UP_PER_CPU_AREA to a global var
    and use select HAVE_SETUP_PER_CPU_AREA to specify.

V2->V3:
  - fix x86_64 non-SMP case
  - change SHIFT_PTR to SHIFT_PERCPU_PTR
  - fix various percpu_modcopy()'s to reference correct per_cpu_offset()
  - s390 has a special way to determine the pointer to a per cpu area

V1->V2:
- Add support for specifying attributes for per cpu declarations (preserves
  IA64 model(small) attribute).
  - Drop first patch that removes the model(small) attribute for IA64
  - Missing #endif in powerpc generic config /  Wrong Kconfig
  - Follow Randy's suggestions on how to do the Kconfig settings

-- 
