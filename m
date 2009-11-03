Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZKCTB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZKCTB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZKCTBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:01:55 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:19603 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZKCTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:01:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JMIj4VDeK0xfAA1ql4ikID5CV0c/u/D3LczpMPmgLFPSPULUhQfvCCNLiW2dAMOq9K
         00PKiM14No3+nIupj9OQG31dHGO2xW7crZrOpBLJnz/7IrajQ4BJYj6yz0UhK+IZ19jl
         GtTyA4N3J0hd3nS2vSYnknfm+EDo6E8gtssNc=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, 64-bit: Fix bstep_iret jump
Date: Tue,  3 Nov 2009 14:02:05 -0500
Message-Id: <1257274925-15713-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091103181014.GA19715@elte.hu>
References: <20091103181014.GA19715@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This jump should be unconditional.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index af0f4b2..1579a6c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1501,7 +1501,7 @@ error_kernelspace:
 bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
-	je error_swapgs
+	jmp error_swapgs
 END(error_entry)
 
 
-- 
1.6.2.5

