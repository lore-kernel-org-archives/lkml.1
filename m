Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYJDVvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYJDVvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYJDVvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:51:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:22430 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbYJDVvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gW4LC1IHJhoLAFDtI+jSZycKV89z+qmLPZeWYmsTjWR0BREUPzg8ZasVKYrSPfIH78
         NF6jlJYDqxYMK8l5jAMqjOKONSJRhtYB4wN/4lBX4GlLssjyQqhGhSSMJrd9QsXwzvU5
         HfETS6iHtyOOP/rknXgmTPK5ixVxepBz1XQyU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/3] x86: mtrr_cleanup: print out correct type
Date: Sat,  4 Oct 2008 14:50:31 -0700
Message-Id: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1273,12 +1273,14 @@ static int __init mtrr_cleanup(unsigned
 		size_base = to_size_factor(size_base, &size_factor),
 		start_base = range_state[i].base_pfn << (PAGE_SHIFT - 10);
 		start_base = to_size_factor(start_base, &start_factor),
+		type = range_state[i].type;
 
 		printk(KERN_DEBUG "reg %d, base: %ld%cB, range: %ld%cB, type %s\n",
 			i, start_base, start_factor,
 			size_base, size_factor,
 			(type == MTRR_TYPE_UNCACHABLE) ? "UC" :
-			    ((type == MTRR_TYPE_WRBACK) ? "WB" : "Other")
+			    ((type == MTRR_TYPE_WRPROT) ? "WPROT" :
+			     ((type == MTRR_TYPE_WRBACK) ? "WB" : "Other"))
 			);
 	}
 
