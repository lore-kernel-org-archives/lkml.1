Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbYFMGhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbYFMGhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 02:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYFMGhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 02:37:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:5611 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYFMGhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:37:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,636,1204531200"; 
   d="scan'208";a="394763509"
Subject: [BUGFIX] lockdep: output lock_class key instead of address for
	forward dependency output
From: "Huang, Ying" <ying.huang@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 14:40:17 +0800
Message-Id: <1213339217.17201.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 13 Jun 2008 06:37:35.0035 (UTC) FILETIME=[F6EB38B0:01C8CD1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key instead of address of lock_class should be output in
/proc/lockdep when forward dependency is output, because key is
output for lock_class itself as identifier too.

This patch is based on x86/auto-latest branch of git-x86 tree, and has
been tested on x86_64 platform.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 kernel/lockdep_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -139,7 +139,7 @@ static int l_show(struct seq_file *m, vo
 
 	list_for_each_entry(entry, &class->locks_after, entry) {
 		if (entry->distance == 1) {
-			seq_printf(m, " -> [%p] ", entry->class);
+			seq_printf(m, " -> [%p] ", entry->class->key);
 			print_name(m, entry->class);
 			seq_puts(m, "\n");
 		}

