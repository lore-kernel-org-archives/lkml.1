Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbZCMNqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbZCMNqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbZCMNqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:46:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844AbZCMNqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:46:13 -0400
Date: Fri, 13 Mar 2009 13:45:26 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, travis@sgi.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200903132342.42813.rusty@rustcorp.com.au>
References: <200903132342.42813.rusty@rustcorp.com.au>
Subject: [tip:cpus4096] cpumask: convert node_to_cpumask_map[] to cpumask_var_t
Message-ID: <tip-0b966252d9e5d95ec2d11e63d7e55b42913aa5b7@git.kernel.org>
Git-Commit-ID: 0b966252d9e5d95ec2d11e63d7e55b42913aa5b7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:45:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b966252d9e5d95ec2d11e63d7e55b42913aa5b7
Gitweb:     http://git.kernel.org/tip/0b966252d9e5d95ec2d11e63d7e55b42913aa5b7
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Fri, 13 Mar 2009 23:42:42 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 14:35:31 +0100

cpumask: convert node_to_cpumask_map[] to cpumask_var_t

Impact: fix (CONFIG_MAXSMP=y only) boot crash

c032ef60d1aa9af33730b7a35bbea751b131adc1 "cpumask: convert
node_to_cpumask_map[] to cpumask_var_t" didn't get this one
conversion.  There was a compile warning, but I missed it.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <200903132342.42813.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ce255e3..550df48 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -61,7 +61,7 @@ const struct cpumask *cpumask_of_node(int node)
 		dump_stack();
 		return cpu_online_mask;
 	}
-	return &node_to_cpumask_map[node];
+	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(cpumask_of_node);
 #endif
