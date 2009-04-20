Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZDTWIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZDTWIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZDTWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:08:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:41597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbZDTWIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:08:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,219,1239001200"; 
   d="scan'208";a="683253165"
From: "Luck, Tony" <tony.luck@intel.com>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next ia64 build problems in slqb
Date: Mon, 20 Apr 2009 15:08:30 -0700
Message-Id: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ia64 "allnoconfig" build ends up with the (possibly dubious) combination
of .config options:

	CONFIG_SMP=n
	CONFIG_NUMA=y

which leads to the following build problems with mm/slqb.c

  CC      mm/slqb.o
mm/slqb.c: In function ‘__slab_free’:
mm/slqb.c:1735: error: implicit declaration of function ‘slab_free_to_remote’
mm/slqb.c: In function ‘kmem_cache_open’:
mm/slqb.c:2274: error: implicit declaration of function ‘kmem_cache_dyn_array_free’
mm/slqb.c:2275: warning: label ‘error_cpu_array’ defined but not used
mm/slqb.c: In function ‘kmem_cache_destroy’:
mm/slqb.c:2395: error: implicit declaration of function ‘claim_remote_free_list’
mm/slqb.c: In function ‘kmem_cache_init’:
mm/slqb.c:2885: error: ‘per_cpu__kmem_cpu_nodes’ undeclared (first use in this function)
mm/slqb.c:2885: error: (Each undeclared identifier is reported only once
mm/slqb.c:2885: error: for each function it appears in.)
mm/slqb.c:2886: error: ‘kmem_cpu_cache’ undeclared (first use in this function)

-Tony
