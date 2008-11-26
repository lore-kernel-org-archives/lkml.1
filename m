Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYKZCoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYKZCoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYKZCoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:44:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:37055 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYKZCoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:44:46 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] ftrace: adding other non-leaving .text sections
Date: Wed, 26 Nov 2008 10:29:26 +0800
Message-Id: <1227666566-9044-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 26 Nov 2008 02:44:32.0783 (UTC) FILETIME=[E96B61F0:01C94F70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review this patch, and I don't know whether new sections will conflict 
with sched tracer or others. 
This patch is against Steven tree's tip/devel latest commit.

Impact: improve recordmcount.pl

Besides .text section, there are three .text sections that won't
be freed after kernel booting. They are: .sched.text, .spinlock.text
and .kprobes.text, which contain functions we can trace. But the last
section ".kprobes.text" is particular, which has been marked as "notrace",
we ignore it. Thus we add other two sections.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 scripts/recordmcount.pl |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 0197e2f..0b1dc9f 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -112,6 +112,8 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
 # Acceptable sections to record.
 my %text_sections = (
      ".text" => 1,
+     ".sched.text" => 1,
+     ".spinlock.text" => 1,
 );
 
 $objdump = "objdump" if ((length $objdump) == 0);
-- 
1.6.0.3

