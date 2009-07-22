Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZGVFZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZGVFZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZGVFZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:25:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:49415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbZGVFZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:25:40 -0400
Date: Wed, 22 Jul 2009 05:24:57 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <20090718065657.GA2898@basil.fritz.box>
References: <20090718065657.GA2898@basil.fritz.box>
Subject: [tip:x86/urgent] x86-64: Fix bad_srat() to clear all state
Message-ID: <tip-429b2b319af3987e808c18f6b81313104caf782c@git.kernel.org>
Git-Commit-ID: 429b2b319af3987e808c18f6b81313104caf782c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Jul 2009 05:25:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  429b2b319af3987e808c18f6b81313104caf782c
Gitweb:     http://git.kernel.org/tip/429b2b319af3987e808c18f6b81313104caf782c
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Sat, 18 Jul 2009 08:56:57 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 21 Jul 2009 15:20:01 -0700

x86-64: Fix bad_srat() to clear all state

Need to clear both nodes and nodes_add state for start/end.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20090718065657.GA2898@basil.fritz.box>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: stable@kernel.org


---
 arch/x86/mm/srat_64.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 2dfcbf9..dbb5381 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -79,8 +79,10 @@ static __init void bad_srat(void)
 	acpi_numa = -1;
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		apicid_to_node[i] = NUMA_NO_NODE;
-	for (i = 0; i < MAX_NUMNODES; i++)
-		nodes_add[i].start = nodes[i].end = 0;
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		nodes[i].start = nodes[i].end = 0;
+		nodes_add[i].start = nodes_add[i].end = 0;
+	}
 	remove_all_active_ranges();
 }
 
