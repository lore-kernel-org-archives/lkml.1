Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZG1Xzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZG1Xzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZG1Xzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:55:52 -0400
Received: from kroah.org ([198.145.64.141]:35834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZG1XuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:58 2009
Message-Id: <20090728234158.412501982@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 46/71] x86-64: Fix bad_srat() to clear all state
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-64-fix-bad_srat-to-clear-all-state.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit 429b2b319af3987e808c18f6b81313104caf782c upstream.

Need to clear both nodes and nodes_add state for start/end.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20090718065657.GA2898@basil.fritz.box>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/srat_64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -89,8 +89,10 @@ static __init void bad_srat(void)
 	found_add_area = 0;
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
 


