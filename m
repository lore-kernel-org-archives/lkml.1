Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYAIWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYAIWER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYAIWEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:04:06 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:60959 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYAIWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:04:05 -0500
Date: Wed, 9 Jan 2008 23:04:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, jason.wessel@windriver.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: 67a385d9ac12e5940989362333b8fa8511e2ec37 in git-x86
Message-ID: <20080109220403.GA18304@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Jan 2008 21:57:54.0666 (UTC) FILETIME=[AFF13CA0:01C8530A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ommit 67a385d9ac12e5940989362333b8fa8511e2ec37
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jan 9 13:31:08 2008 +0100

    x86: fix up merge conflict
    
    fix up kgdb merge conflict.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index d3c225b..72bbaff 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -63,7 +63,9 @@ extern struct task_struct *FASTCALL(__switch_to(struct task_struct *prev,
 
 /* Save restore flags to clear handle leaking NT */
 #define switch_to(prev, next, last) \
-       asm volatile(SAVE_CONTEXT                                                   \
+       asm volatile(".globl __switch_to_begin\n\t"                     \
+            "__switch_to_begin:\n\t"                           \
+            SAVE_CONTEXT                                       \
             "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save


AK: 

Can't remember how often I reject similar patches. They usually point
to someone implementing backtraces wrong.

Anyways, the label seems to be completely unused in the current kgdb
code the change can just go completely:

% grep -r switch_to_begin *
include/asm-x86/system.h:       asm volatile(".globl __switch_to_begin\n\t"                     \
include/asm-x86/system.h:            "__switch_to_begin:\n\t"                  

-Andi
