Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZHHAQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZHHAQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZHHAQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:16:36 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:53240 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbZHHAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qC94KL2UpQTApxdJn9rTCHATt4hU15ajuBkqAqRcBOfX4o16uB2rE0sO0fJ2uDOUPZ
         t49Rba3vJujLzjKP9tUrWQmj1Xg2TWZ6yDmA9rzmuGD2poRPcUoyfFwf+0nblDsXzopd
         0awmWWmi/Uzl1Qf4UoKBiPJPN9rv/TEou4IS4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 2/4] perf tools: callchain: Ignore empty callchains
Date: Sat,  8 Aug 2009 02:16:23 +0200
Message-Id: <1249690585-9145-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249690585-9145-1-git-send-email-fweisbec@gmail.com>
References: <1249690585-9145-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the callchain tree comes to insert an empty backtrace, it raises
a spurious warning about the fact we are inserting an empty.
This is spurious because the radix tree assumes it did something
wrong to reach this state. But it didn't, we just met an empty
callchain that has to be ignored.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/util/callchain.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ce0c6d4..4c09b25 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -337,5 +337,7 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms)
 {
+	if (!chain->nr)
+		return;
 	__append_chain_children(root, chain, syms, 0);
 }
-- 
1.6.2.3

