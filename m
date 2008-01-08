Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYAHVKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYAHVKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYAHVK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:10:26 -0500
Received: from relay2.sgi.com ([192.48.171.30]:60523 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751100AbYAHVKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:10:25 -0500
Message-Id: <20080108211023.923047000@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jan 2008 13:10:23 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] percpu: Per cpu code simplification V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset simplifies the code that arches need to maintain to support
per cpu functionality. Most of the code is moved into arch independent
code. Only a minimal set of definitions is kept for each arch.

The patch also unifies the x86 arch so that there is only a single
asm-x86/percpu.h

Based on: 2.6.24-rc6-mm1
---

V1->V2:
- Add support for specifying attributes for per cpu declarations (preserves
  IA64 model(small) attribute).
  - Drop first patch that removes the model(small) attribute for IA64
  - Missing #endif in powerpc generic config /  Wrong Kconfig
  - Follow Randy's suggestions on how to do the Kconfig settings

V2->V3:
  - fix x86_64 non-SMP case
  - change SHIFT_PTR to SHIFT_PERCPU_PTR
  - fix various percpu_modcopy()'s to reference correct per_cpu_offset()
  - s390 has a special way to determine the pointer to a per cpu area

V3->V4:
  - rebased patchset on 2.6.24-rc6-mm1
    (removes the percpu_modcopy changes that are already in.)
  - change config ARCH_SETS_UP_PER_CPU_AREA to a global var
    and use select HAVE_SETUP_PER_CPU_AREA to specify.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>

-- 
