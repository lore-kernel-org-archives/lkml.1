Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbZANUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbZANUny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZANUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:42:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50807 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbZANUmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=oK6AC7ofJIqcAu6AAhwYvmeLPQlHhtU8tW+w/W5W76wqVrlBU+re2l665ziW3dlo5J
         aqOQB562IostgGh79/fRDWac+9Qx05WMp/laCOYIe0spSwpv47d7JychUDMCpSgvkHJ/
         mlT6enR0Ya7sdtoBjkkdPk96wB8xdhlhYYjbU=
References: <20090114203745.285473388@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 23:37:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, sam@ravnborg.org, jaswinderrajput@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/5] x86: headers cleanup - prctl.h
Content-Disposition: inline; filename=x86-header-prctl-h
Message-ID: <496e4e23.0405560a.1bf4.ffff9a1a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

'make headers_check' warn us about leaking of kernel private
(mostly compile time vars) data to userspace in headers. Fix it.

sys_arch_prctl is completely removed from
header since frankly I don't even understand why we
describe it here. It is described like
__SYSCALL(__NR_arch_prctl, sys_arch_prctl) in unistd_64.h
and implemented in process_64.c. User-mode linux involved?
So this one in fact is suspicious.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/prctl.h |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/prctl.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/prctl.h
+++ linux-2.6.git/arch/x86/include/asm/prctl.h
@@ -6,8 +6,4 @@
 #define ARCH_GET_FS 0x1003
 #define ARCH_GET_GS 0x1004
 
-#ifdef CONFIG_X86_64
-extern long sys_arch_prctl(int, unsigned long);
-#endif /* CONFIG_X86_64 */
-
 #endif /* _ASM_X86_PRCTL_H */

-- 
