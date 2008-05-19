Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYESEfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYESEfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 00:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYESEev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 00:34:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:35864 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274AbYESEes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 00:34:48 -0400
Date: Sun, 18 May 2008 23:34:36 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: David Miller <davem@davemloft.net>
cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] lmb: Fix compile warning
In-Reply-To: <20080518.203116.199516667.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0805182333550.10619@blarg.am.freescale.net>
References: <1211136296-4572-1-git-send-email-galak@kernel.crashing.org>
 <1211136296-4572-2-git-send-email-galak@kernel.crashing.org>
 <20080518.203116.199516667.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/lmb.c: In function 'lmb_dump_all':
lib/lmb.c:51: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'u64'

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Cast so it works everywhere.

- k

 lib/lmb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index 867f7b5..5d7b928 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -48,7 +48,8 @@ void lmb_dump_all(void)
 	}

 	pr_info("    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
-	pr_info("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
+	pr_info("    reserved.size	  = 0x%llx\n",
+	    (unsigned long long)lmb.memory.size);
 	for (i=0; i < lmb.reserved.cnt ;i++) {
 		pr_info("    reserved.region[0x%lx].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.reserved.region[i].base);
-- 
1.5.4.5

