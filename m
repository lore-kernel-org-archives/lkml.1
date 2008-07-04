Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYGDXu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYGDXu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYGDXuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:50:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:9552 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYGDXuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QRCN+EdAzyH2oskh99bcZDhCCFcwiCFh3P7PrxgYL6ubRvcZv9DRlnMa/9NUMR2uVH
         WEEeFhTKNePth3NUgtHLdhBAM/IZl4ZLUp4Rs+Npnur3Ly74LrJciKo/iU9hnGMjrw2V
         DaHQGqy+3blI05uV4P1pXFh++Zom9e0wrbndg=
Subject: [PATCH] markers: fix sparse integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 16:50:13 -0700
Message-Id: <1215215413.27271.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/trace/trace_sysprof.c:164:20: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/trace/trace_sysprof.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 2301e1e..bb948e5 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -161,7 +161,7 @@ static void timer_notify(struct pt_regs *regs, int cpu)
 		__trace_special(tr, data, 2, regs->ip, 0);
 
 		while (i < sample_max_depth) {
-			frame.next_fp = 0;
+			frame.next_fp = NULL;
 			frame.return_address = 0;
 			if (!copy_stack_frame(fp, &frame))
 				break;
-- 
1.5.6.1.322.ge904b



