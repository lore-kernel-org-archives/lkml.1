Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbXIUWvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbXIUWvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764214AbXIUWcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:57135 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764164AbXIUWcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:50 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: major@openvz.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [48/50] x86_64: return correct error code from child_rip in x86_64 entry.S
Message-Id: <20070921223248.EA24D13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrey Mirkin <major@openvz.org>

Right now register edi is just cleared before calling do_exit.
That is wrong because correct return value will be ignored.
Value from rax should be copied to rdi instead of clearing edi.

AK: changed to 32bit move because it's strictly an int

Signed-off-by: Andrey Mirkin <major@openvz.org>
Signed-off-by: Andi Kleen <ak@suse.de>

-----

---
 arch/x86_64/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/entry.S
===================================================================
--- linux.orig/arch/x86_64/kernel/entry.S
+++ linux/arch/x86_64/kernel/entry.S
@@ -989,7 +989,7 @@ child_rip:
 	movq %rsi, %rdi
 	call *%rax
 	# exit
-	xorl %edi, %edi
+	mov %eax, %edi
 	call do_exit
 	CFI_ENDPROC
 ENDPROC(child_rip)
