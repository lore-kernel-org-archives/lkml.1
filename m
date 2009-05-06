Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZEFI7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZEFI7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZEFI6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:58:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbZEFI6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:58:51 -0400
Date: Wed, 6 May 2009 08:58:00 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, yanmin_zhang@linux.intel.com, tglx@linutronix.de,
       rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, yanmin_zhang@linux.intel.com, tglx@linutronix.de,
       rientjes@google.com, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0905051248150.20021@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905051248150.20021@chino.kir.corp.google.com>
Subject: [tip:x86/urgent] x86, srat: do not register nodes beyond e820 map
Message-ID: <tip-7eccf7b227b6d3b1745b937ce35efc9c27f9b0e5@git.kernel.org>
Git-Commit-ID: 7eccf7b227b6d3b1745b937ce35efc9c27f9b0e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 08:58:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7eccf7b227b6d3b1745b937ce35efc9c27f9b0e5
Gitweb:     http://git.kernel.org/tip/7eccf7b227b6d3b1745b937ce35efc9c27f9b0e5
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Tue, 5 May 2009 12:50:02 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 10:49:07 +0200

x86, srat: do not register nodes beyond e820 map

The mem= option will truncate the memory map at a specified address so
it's not possible to register nodes with memory beyond the e820 upper
bound.

unparse_node() is only called when then node had memory associated with
it, although with the mem= option it is no longer addressable.

[ Impact: fix boot hang on certain (large) systems ]

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <alpine.DEB.2.00.0905051248150.20021@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/srat_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 33c5fa5..0176595 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -361,6 +361,7 @@ static void __init unparse_node(int node)
 {
 	int i;
 	node_clear(node, nodes_parsed);
+	node_clear(node, cpu_nodes_parsed);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
