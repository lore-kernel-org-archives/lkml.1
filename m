Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbZJKGNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbZJKGNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 02:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZJKGNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 02:13:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54444 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZJKGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 02:13:46 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] panic.c: export panic_on_oops
Date: Sun, 11 Oct 2009 09:10:58 +0300
Message-Id: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
X-OriginalArrivalTime: 11 Oct 2009 06:11:54.0886 (UTC) FILETIME=[BB43E260:01CA4A39]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

We use the mtdoops module which stores oopses on the Flash partition,
in order to make it possible to analyze them later. And mtdoops needs
to know whether 'panic_on_oops' is on or off. Thus, we need this
variable to be exported.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-mtd <linux-mtd@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
---
 kernel/panic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index bcdef26..6d29be3 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -24,6 +24,8 @@
 #include <linux/dmi.h>
 
 int panic_on_oops;
+EXPORT_SYMBOL_GPL(panic_on_oops);
+
 static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
-- 
1.6.2.5

