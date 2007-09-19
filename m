Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbXISO0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbXISO0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXISO0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:26:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3147 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbXISO0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:26:35 -0400
From: Andrey Mirkin <major@openvz.org>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>, devel@openvz.org
Subject: [PATCH] return correct error code from child_rip in x86_64 entry.S
Date: Wed, 19 Sep 2007 18:26:25 +0400
User-Agent: KMail/1.8.2
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191826.27764.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Mirkin <major@openvz.org>

Right now register edi is just cleared before calling do_exit.
That is wrong because correct return value will be ignored.
Value from rax should be copied to rdi instead of clearing edi.

Signed-off-by: Andrey Mirkin <major@openvz.org>

-----

diff --git a/arch/x86_64/kernel/entry.S b/arch/x86_64/kernel/entry.S
index 1d232e5..ac6400e 100644
--- a/arch/x86_64/kernel/entry.S
+++ b/arch/x86_64/kernel/entry.S
@@ -989,7 +989,7 @@ child_rip:
 	movq %rsi, %rdi
 	call *%rax
 	# exit
-	xorl %edi, %edi
+	movq %rax, %rdi
 	call do_exit
 	CFI_ENDPROC
 ENDPROC(child_rip)
