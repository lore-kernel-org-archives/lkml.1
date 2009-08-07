Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZHGMZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZHGMZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbZHGMZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:25:49 -0400
Received: from rood.intersec.com ([88.191.78.202]:33319 "EHLO mx2.intersec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbZHGMZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:25:47 -0400
X-Intersec-Trusted-Host: yes
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Pierre Habouzit <madcoder@debian.org>
Subject: [PATCH 1/2] perf util: do_read should fail on EOF instead of busy-looping.
Date: Fri,  7 Aug 2009 14:16:00 +0200
Message-Id: <1249647361-11582-2-git-send-email-pierre.habouzit@intersec.com>
X-Mailer: git-send-email 1.6.4.rc2.183.g9085a
In-Reply-To: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com>
References: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Habouzit <madcoder@debian.org>

Signed-off-by: Pierre Habouzit <madcoder@debian.org>
---
 tools/perf/util/header.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 450384b..531f2b9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -185,6 +185,8 @@ static void do_read(int fd, void *buf, size_t size)
 
 		if (ret < 0)
 			die("failed to read");
+		if (ret == 0)
+			die("failed to read: missing data");
 
 		size -= ret;
 		buf += ret;
-- 
1.6.4.rc2.183.g9085a

