Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYJDVwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYJDVwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYJDVvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:51:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:27229 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbYJDVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OTLqYNsKrqLniLfJI7MSFy4xSYpV2kKbnIhHPgCd0L4ypfTcmEfvdLdIFMjFrivHF9
         jfJeavePflxCp8Xyk8fRz1IppFFMHAXbhQjNDIstGU5KJQXmPB90GC3kVkoudu75/bvw
         SoMkkZNlJZuSXgmO/U/UnEjM997TeiJGjOKkk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/3] x86: mtrr_cleanup: treat WRPROT as UNCACHEABLE
Date: Sat,  4 Oct 2008 14:50:33 -0700
Message-Id: <1223157033-30217-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -759,7 +759,8 @@ x86_get_mtrr_mem_range(struct res_range
 	/* take out UC ranges */
 	for (i = 0; i < num_var_ranges; i++) {
 		type = range_state[i].type;
-		if (type != MTRR_TYPE_UNCACHABLE)
+		if (type != MTRR_TYPE_UNCACHABLE &&
+		    type != MTRR_TYPE_WRPROT)
 			continue;
 		size = range_state[i].size_pfn;
 		if (!size)
@@ -1248,6 +1249,8 @@ static int __init mtrr_cleanup(unsigned
 			continue;
 		if (!size)
 			type = MTRR_NUM_TYPES;
+		if (type == MTRR_TYPE_WRPROT)
+			type = MTRR_TYPE_UNCACHABLE;
 		num[type]++;
 	}
 
