Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZKWS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZKWS2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZKWS2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:28:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:41124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbZKWS2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:28:15 -0500
Date: Mon, 23 Nov 2009 18:28:04 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1NBGB9-0005nU-Dp@eag09.americas.sgi.com>
References: <E1NBGB9-0005nU-Dp@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: SGI UV: Fix BAU initialization
Message-ID: <tip-e38e2af1c57c3eb5211331a5b4fcaae0c4a2a918@git.kernel.org>
Git-Commit-ID: e38e2af1c57c3eb5211331a5b4fcaae0c4a2a918
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e38e2af1c57c3eb5211331a5b4fcaae0c4a2a918
Gitweb:     http://git.kernel.org/tip/e38e2af1c57c3eb5211331a5b4fcaae0c4a2a918
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Thu, 19 Nov 2009 17:12:43 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 19:12:50 +0100

x86: SGI UV: Fix BAU initialization

A memory mapped register that affects the SGI UV Broadcast
Assist Unit's interrupt handling may sometimes be unintialized.

Remove the condition on its initialization, as that condition
can be randomly satisfied by a hardware reset.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: <stable@kernel.org>
LKML-Reference: <E1NBGB9-0005nU-Dp@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_uv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 503c1f2..af21e55 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -819,10 +819,8 @@ static int __init uv_init_blade(int blade)
 	 */
 	apicid = blade_to_first_apicid(blade);
 	pa = uv_read_global_mmr64(pnode, UVH_BAU_DATA_CONFIG);
-	if ((pa & 0xff) != UV_BAU_MESSAGE) {
-		uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
+	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
 				      ((apicid << 32) | UV_BAU_MESSAGE));
-	}
 	return 0;
 }
 
