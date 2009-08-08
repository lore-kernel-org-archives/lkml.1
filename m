Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZHHC1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZHHC1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZHHC0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:26:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:39815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZHHC0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Js9288atAxSiE+SiZg+kjSqRReLC0I3yCFU2aEsfUzFZ0T/PkH/X09YogND1+Rw31m
         TrorkYOavbEDJo1/sM8azspY/luL7JDhbCeVhQbOT0BfjYZL4tnIuLXtjbLmdkdK8CuC
         vdJAhJkAbp/dakNQrkik56oIZajtKIn7YK36k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 2/4] perf tools: callchain: Ignore empty callchains
Date: Sat,  8 Aug 2009 04:26:36 +0200
Message-Id: <1249698400-5441-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
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

