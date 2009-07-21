Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZGUSR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZGUSR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZGUSR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:17:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:17131 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbZGUSR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:17:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,241,1246863600"; 
   d="scan'208";a="167408379"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Tejun Heo'" <tj@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Date: Tue, 21 Jul 2009 11:17:20 -0700
Subject: RE: [RFC PATCH] ia64: convert to dynamic percpu allocator
Thread-Topic: [RFC PATCH] ia64: convert to dynamic percpu allocator
Thread-Index: AcoJ/IwnpWkt5+AbT+qAnvcuY62ufAAModuA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B097D4C5@orsmsx505.amr.corp.intel.com>
References: <4A65B0AB.5000608@kernel.org>
In-Reply-To: <4A65B0AB.5000608@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>As allocation and initialization are done by the arch code, all that
>setup_per_cpu_areas() needs to do is communicating the determined
>layout to the percpu allocator.  This patch implements
>setup_per_cpu_areas() for both contig and discontig memory models and
>drops HAVE_LEGACY_PER_CPU_AREA.
>
>NOT_SIGNED_OFF_YET
>Cc: Tony Luck <tony.luck@intel.com>
>Cc: Fenghua Yu <fenghua.yu@intel.com>
>---
>I don't have access to an ia64 machine so I could only test with ski.
>With sim_defconfig, it boots but I didn't have any userland.
>discontig configuration builds fine but I couldn't test it.
>
>Can you guys please verify this patch?
>
>This patch is available in the following git tree.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-ia64
>
>Thanks.
>

Is this patch against the latest linux-next? It's applied cleanly on linux-next. But compilation reports undefined function pcpu_alloc_alloc_info() in both contig.c and discontig.c.

arch/ia64/mm/contig.c: In function 'setup_per_cpu_areas':
arch/ia64/mm/contig.c:208: error: implicit declaration of function 'pcpu_alloc_al
loc_info'
arch/ia64/mm/contig.c:208: warning: assignment makes pointer from integer without
 a cast
arch/ia64/mm/contig.c:211: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:225: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:226: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:227: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:228: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:229: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:230: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:236: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:237: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:237: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:238: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:239: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:240: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:244: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:244: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:245: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:246: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:247: error: dereferencing pointer to incomplete type
arch/ia64/mm/contig.c:250: warning: passing argument 1 of 'pcpu_setup_first_chunk
' makes integer from pointer without a cast
arch/ia64/mm/contig.c:250: warning: passing argument 2 of 'pcpu_setup_first_chunk
' makes integer from pointer without a cast
arch/ia64/mm/contig.c:250: error: too few arguments to function 'pcpu_setup_first
_chunk'
arch/ia64/mm/contig.c:254: error: implicit declaration of function 'pcpu_free_all
oc_info'
