Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZDQBXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZDQBXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZDQBWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:22:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:34917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbZDQBWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:22:53 -0400
Date: Fri, 17 Apr 2009 01:21:35 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E68C41.4020801@kernel.org>
References: <49E68C41.4020801@kernel.org>
Subject: [tip:irq/urgent] x86/irq: mark NUMA_MIGRATE_IRQ_DESC broken
Message-ID: <tip-ca713c2ab0eea3458962983e4a7e13430ea479b8@git.kernel.org>
Git-Commit-ID: ca713c2ab0eea3458962983e4a7e13430ea479b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 01:21:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca713c2ab0eea3458962983e4a7e13430ea479b8
Gitweb:     http://git.kernel.org/tip/ca713c2ab0eea3458962983e4a7e13430ea479b8
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 15 Apr 2009 18:39:13 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 03:20:01 +0200

x86/irq: mark NUMA_MIGRATE_IRQ_DESC broken

It causes crash on system with lots of cards with MSI-X
when irq_balancer enabled...

The patches fixing it were both complex and fragile, according
to Eric they were also doing quite dangerous things to the
hardware.

Instead we now have patches that solve this problem via static
NUMA node mappings - not dynamic allocation and balancing.

The patches are much simpler than this method but are still too
large outside of the merge window, so we mark the dynamic balancer
as broken for now, and queue up the new approach for v2.6.31.

[ Impact: deactivate broken kernel feature ]

Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49E68C41.4020801@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bc25b9f..b1d2be7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -277,6 +277,7 @@ config SPARSE_IRQ
 config NUMA_MIGRATE_IRQ_DESC
 	bool "Move irq desc when changing irq smp_affinity"
 	depends on SPARSE_IRQ && NUMA
+	depends on BROKEN
 	default n
 	---help---
 	  This enables moving irq_desc to cpu/node that irq will use handled.
