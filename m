Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZCSLzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZCSLzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZCSLz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:55:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:45872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZCSLz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:55:26 -0400
Date: Thu, 19 Mar 2009 11:54:27 GMT
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
In-Reply-To: <20090319220322.3baa4613.sfr@canb.auug.org.au>
References: <20090319220322.3baa4613.sfr@canb.auug.org.au>
Subject: [tip:cpus4096] numa, cpumask: move numa_node_id default implementation to topology.h, fix
Message-ID: <tip-17ad6ea621b1c7952ebd7330ce65de26b6ee9cca@git.kernel.org>
Git-Commit-ID: 17ad6ea621b1c7952ebd7330ce65de26b6ee9cca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 11:54:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17ad6ea621b1c7952ebd7330ce65de26b6ee9cca
Gitweb:     http://git.kernel.org/tip/17ad6ea621b1c7952ebd7330ce65de26b6ee9cca
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Thu, 19 Mar 2009 22:03:22 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 12:51:25 +0100

numa, cpumask: move numa_node_id default implementation to topology.h, fix

Impact: build fix for powerpc and sparc

Today's linux-next build (powerpc allyesconfig) failed like this:

> In file included from include/linux/mmzone.h:776,
>                  from include/linux/gfp.h:5,
>                  from include/linux/kmod.h:23,
>                  from include/linux/module.h:14,
>                  from init/version.c:11:
> arch/powerpc/include/asm/mmzone.h:32: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'numa_cpumask_lookup_table'

Caused by commit 082edb7bf443eb8eda15b482d16ad9dd8137ad24 ("numa,
cpumask: move numa_node_id default implementation to topology.h") from
the cpus4096 tree which removed the include of linux/topology.h from
linux/mmzone.h.

Same for sparc64 defconfig.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-b: Rusty Russell <rusty@rustcorp.com.au>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>
LKML-Reference: <20090319220322.3baa4613.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/include/asm/mmzone.h |    1 +
 arch/sparc/include/asm/mmzone.h   |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index 19f299b..35acac9 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -8,6 +8,7 @@
 #define _ASM_MMZONE_H_
 #ifdef __KERNEL__
 
+#include <linux/cpumask.h>
 
 /*
  * generic non-linear memory support:
diff --git a/arch/sparc/include/asm/mmzone.h b/arch/sparc/include/asm/mmzone.h
index ebf5986..e8c6487 100644
--- a/arch/sparc/include/asm/mmzone.h
+++ b/arch/sparc/include/asm/mmzone.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
 
+#include <linux/cpumask.h>
+
 extern struct pglist_data *node_data[];
 
 #define NODE_DATA(nid)		(node_data[nid])
