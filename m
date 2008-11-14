Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYKNV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYKNV2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYKNV2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:28:06 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:46055 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYKNV2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:28:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
	b=ge7A0rvwwRmPDU2Dt78M3fZwVFbcxsnxmLiKi1V8yk9F4pNno/onAGtKPjR9Fgw+DA1TOyJgdeqQISagzxagwO6zKT9DEXazyE1J9xMN58SWMfCdEXZl1k8u5byYce5G;
Message-ID: <491DED60.1060509@simon.arlott.org.uk>
Date: Fri, 14 Nov 2008 21:28:00 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080928)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: fix sparse warnings in ptrace.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/ptrace.c:634:32: error: incompatible types for operation (*)
arch/x86/kernel/ptrace.c:634:32:    left side has type unsigned char static [unsigned] [toplevel] sizeof_field
arch/x86/kernel/ptrace.c:634:32:    right side has type bad type enum bts_field field
arch/x86/kernel/ptrace.c:634:7: error: invalid assignment

arch/x86/kernel/ptrace.c:640:32: error: incompatible types for operation (*)
arch/x86/kernel/ptrace.c:640:32:    left side has type unsigned char static [unsigned] [toplevel] sizeof_field
arch/x86/kernel/ptrace.c:640:32:    right side has type bad type enum bts_field field
arch/x86/kernel/ptrace.c:640:7: error: invalid assignment

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/x86/kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a6d8c1..662a400 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -631,13 +631,13 @@ enum bts_field {
 
 static inline unsigned long bts_get(const char *base, enum bts_field field)
 {
-	base += (bts_cfg.sizeof_field * field);
+	base += (bts_cfg.sizeof_field * (unsigned char)field);
 	return *(unsigned long *)base;
 }
 
 static inline void bts_set(char *base, enum bts_field field, unsigned long val)
 {
-	base += (bts_cfg.sizeof_field * field);;
+	base += (bts_cfg.sizeof_field * (unsigned char)field);
 	(*(unsigned long *)base) = val;
 }
 
-- 
1.6.0.3

-- 
Simon Arlott
