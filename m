Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZGEFkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZGEFkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 01:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZGEFjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 01:39:32 -0400
Received: from ey-out-1920.google.com ([74.125.78.146]:37585 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZGEFjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 01:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OFxosBcs/YcEaWelWXGAP2AvPaLrzx9g3YwEsSQvpPEUzGsa+khtYiyiC2v/hnv76n
         MHVbhblC0Ih3yMTCsTUTPJnIgKvvA+fADUfBL12Q9x/AEk7CKSwwQ7/CcYucK0G2dLtj
         M5xQli5SuJehrLhtCR75HSFc4IQ9kW32vUtMY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] perf report: Change default callchain parameters
Date: Sun,  5 Jul 2009 07:39:19 +0200
Message-Id: <1246772361-9960-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default callchain parameters are set to use the flat mode and never
filter any overhead threshold of backtrace.

But flat mode is boring compared to graph mode.
Also the number of callchains may be very high if none is
filtered.

Let's change this to set the graph view and a minimum overhead of 0.5%
as default parameters.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-report.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3db99fd..8bd5865 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -59,10 +59,10 @@ static regex_t		parent_regex;
 
 static int		exclude_other = 1;
 
-static char		callchain_default_opt[] = "flat,0";
+static char		callchain_default_opt[] = "graph,0.5";
 static int		callchain;
 static enum chain_mode	callchain_mode;
-static double		callchain_min_percent = 0.0;
+static double		callchain_min_percent = 0.5;
 
 static u64		sample_type;
 
-- 
1.6.2.3

