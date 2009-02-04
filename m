Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZBDAAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZBDAAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBDAAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:00:41 -0500
Received: from gw.goop.org ([64.81.55.164]:51399 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZBDAAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:00:41 -0500
Message-ID: <4988DAA6.7000102@goop.org>
Date: Tue, 03 Feb 2009 16:00:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH] x86/paravirt: return full 64-bit result
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A hunk went missing in the original patch, and callee-save callsites were
not marked as returning the upper 32-bit of result, causing Badness.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -522,7 +522,7 @@
 					"=c" (__ecx)
 #define PVOP_CALL_CLOBBERS		PVOP_VCALL_CLOBBERS
 
-#define PVOP_VCALLEE_CLOBBERS		"=a" (__eax)
+#define PVOP_VCALLEE_CLOBBERS		"=a" (__eax), "=d" (__edx)
 #define PVOP_CALLEE_CLOBBERS		PVOP_VCALLEE_CLOBBERS
 
 #define EXTRA_CLOBBERS


