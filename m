Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXA3Fp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXA3Fp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 00:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932600AbXA3Fp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 00:45:57 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:58445 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932231AbXA3Fp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 00:45:56 -0500
Date: Mon, 29 Jan 2007 23:43:33 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@osdl.org>, prasanna@in.ibm.com, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] kprobes: Fix compiler warning
Message-ID: <Pine.LNX.4.64.0701292341070.32393@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On ppc the compiler gripes about:

kernel/kprobes.c: In function 'collect_garbage_slots':
kernel/kprobes.c:215: warning: comparison is always false due to limited range of data type

The compiler ends up optimizing away the test since char's are unsigned on ppc.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

---
commit 1ee2dc5300b1c454f92eeea82da300f72db1b26f
tree c73cdacb43e154292708d967e11b1cbf7ab4904f
parent c0d4d573feed199b16094c072e7cb07afb01c598
author Kumar Gala <galak@kernel.crashing.org> Mon, 29 Jan 2007 23:38:11 -0600
committer Kumar Gala <galak@kernel.crashing.org> Mon, 29 Jan 2007 23:38:11 -0600

  kernel/kprobes.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 17ec4af..514276f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -212,7 +212,7 @@ static int __kprobes collect_garbage_slots(void)
  			continue;
  		kip->ngarbage = 0;	/* we will collect all garbages */
  		for (i = 0; i < INSNS_PER_PAGE; i++) {
-			if (kip->slot_used[i] == -1 &&
+			if (kip->slot_used[i] == (char)-1 &&
  			    collect_one_slot(kip, i))
  				break;
  		}
