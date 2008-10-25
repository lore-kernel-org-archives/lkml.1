Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYJYDeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYJYDeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYJYDbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:31:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:50166 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYJYDaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fJf5kmELyfXGQxhb+60Z9Z3TkuFdySzFIoUcPfIUom2+v9dAe83chS1BSsgJWVQK63
         PBp5E+SYBCBUabqKyYnMNSd3JHAMBpCh6f+ncK3oiPr4N/zJqUiozs79eLU5N7XU8/sa
         U//kss0owdEESjV4PJntXHKXCvsFfUlg5cx0Y=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 05/12] x86: Refactor pack_gate for gate_desc
Date: Fri, 24 Oct 2008 20:15:25 -0700
Message-Id: <a4c806abcf7a46c78aaff4e338fdbc1a06a56c88.1224903712.git.ice799@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <a9cabc5cabdb5a10631e2a6dc330c54826f2b210.1224903712.git.ice799@gmail.com>
References: <>
 <1224904532-9586-1-git-send-email-ice799@gmail.com>
 <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
 <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
 <4810cc08c12cd78612b53f9b52d7ba93a9b03fd0.1224903712.git.ice799@gmail.com>
 <a9cabc5cabdb5a10631e2a6dc330c54826f2b210.1224903712.git.ice799@gmail.com>
In-Reply-To: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
References: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite pack_gate to use the newly add struct fields instead of bitmasks.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 include/asm-x86/desc.h |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index f06adac..6b4f3e6 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -66,9 +66,14 @@ static inline void pack_gate(gate_desc *gate, unsigned char type,
 			     unsigned long base, unsigned dpl, unsigned flags,
 			     unsigned short seg)
 {
-	gate->a = (seg << 16) | (base & 0xffff);
-	gate->b = (base & 0xffff0000) |
-		  (((0x80 | type | (dpl << 5)) & 0xff) << 8);
+	gate->base0 = base & 0xffff;
+	gate->seg_sel = seg;
+	gate->reserved = 0;
+	gate->type = type;
+	gate->zero = 0;
+	gate->dpl = dpl;
+	gate->p = 1;
+	gate->base1 = (base >> 16) & 0xffff;
 }
 
 #endif
-- 
1.5.4.3

