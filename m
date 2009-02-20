Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZBTMFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZBTMFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZBTMFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:05:10 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48290 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZBTMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=DSzsm/j8SIrplcsjgZ0hiyaDIsqcLhNWjPWtyW88Hk9OMcMxqthenthz3vxoEwbFVk
         Ka59EzywnsTB3RejPvLj6jix6Lv8FvVUVU+BiZyrfHAEOAepA3IIvVM4BuzXJxSpbcV4
         PPNSkrtitRhuZsSDkSQdkcKxY5ko/JjWAeWKM=
Message-ID: <499E9C71.3050003@gmail.com>
Date: Fri, 20 Feb 2009 13:05:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: mingo@redhat.com
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] IA64: cast has a higher precedence than '?'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because of the ?: this is not strictly necessary, but I think the added
parentheses are nice here.

--------------------------->8-------------8<------------------------------
A cast has a higher precedence than '?'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d82f39b..b8a1933 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -61,7 +61,7 @@ static inline void syscall_set_return_value(struct task_struct *task,
 					    struct pt_regs *regs,
 					    int error, long val)
 {
-	regs->ax = (long) error ?: val;
+	regs->ax = (long) (error ?: val);
 }
 
 #ifdef CONFIG_X86_32
