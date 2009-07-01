Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbZGADfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbZGADfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbZGADfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:35:18 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:36998 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZGADfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ugCfSdXBwRwbxT8Diq5MSa2v5C6nE+21hy8otGDx6VxJ4lsaw+XSXrpns5sHb6lZAj
         BPbgVhTMcvASF4BhThDZ3683IpmAd9SEzpILlSvGqnNi9ZkpMwlf9s2MEC8nKvclg57O
         n+PXqr6BKweLoecyPFNqnkocgmHVhNyL53r5w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] perfcounter: Fix storage size allocation of callchain list
Date: Wed,  1 Jul 2009 05:35:13 +0200
Message-Id: <1246419315-9968-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246419315-9968-1-git-send-email-fweisbec@gmail.com>
References: <1246419315-9968-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a confusion while giving the size of a callchain list during
its allocation. We are using the wrong structure size.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/callchain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ad3c285..bbf7813 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -74,7 +74,7 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain, int start)
 	for (i = start; i < chain->nr; i++) {
 		struct callchain_list *call;
 
-		call = malloc(sizeof(*chain));
+		call = malloc(sizeof(*call));
 		if (!call) {
 			perror("not enough memory for the code path tree");
 			return;
-- 
1.6.2.3

