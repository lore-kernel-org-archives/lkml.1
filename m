Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbYLPIcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbYLPIcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYLPIcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:32:24 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYLPIcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:32:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=X4T8L3/9tRnM0k+hPNqtAegOlKiH6cHxMhNu/28T1L1qIPsOQ9+Jh2ltHXkbScTFM
	hR5mXZJ/3ZBETZ+fuibFg==
MIME-Version: 1.0
Date: Tue, 16 Dec 2008 00:32:21 -0800
Message-ID: <b040c32a0812160032pf681f13s9e5e86c4b5448012@mail.gmail.com>
Subject: [patch] x86: convert rdtscll() to use __native_read_tsc
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason why x86 rdtscll have to use the out of line
function instead of inline __native_read_tsc()?  native_read_tsc and
__native_read_tsc is essentially the same functions.

Patch to let x86 rdtscll() to use the inline version of read_tsc.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index c2a812e..42f639b 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -181,10 +181,10 @@ static inline int rdmsrl_amd_safe
 }

 #define rdtscl(low)						\
-	((low) = (u32)native_read_tsc())
+	((low) = (u32)__native_read_tsc())

 #define rdtscll(val)						\
-	((val) = native_read_tsc())
+	((val) = __native_read_tsc())

 #define rdpmc(counter, low, high)			\
 do {							\
