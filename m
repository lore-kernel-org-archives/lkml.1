Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbZANUm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbZANUm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbZANUmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:42:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:62706 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbZANUmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=DNYc3gjzBm/NUKx9llVI1J411XkRAkFvLTIm91EFZUv1oh2gYJ+1mSyGwB2Di5OmJl
         TLnExyFV4BT8K9/ejXnxB/r6CsZ2mTLaiu/aaLGjilZmSg8xDOZTCeHA/WGBooRUSZZc
         CnnUYCyFt7GrNs5gSiCvQc8Yq6HVXuzAqU/RA=
References: <20090114203745.285473388@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 23:37:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, sam@ravnborg.org, jaswinderrajput@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/5] x86: headers cleanup - ptrace-abi.h
Content-Disposition: inline; filename=x86-header-ptrace-abi-h
Message-ID: <496e4e23.0c07560a.5e4e.529c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

'make headers_check' warn us about leaking of kernel private
(mostly compile time vars) data to userspace in headers. Fix it.

ptrace_bts_config struct is wrapped by __KERNEL__ --
not sure if it was ever proposed for userland. On the
other hand branch tracing is really anxious for userland
developers.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/ptrace-abi.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/ptrace-abi.h
+++ linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
@@ -50,7 +50,7 @@
 #define RSP 152
 #define SS 160
 #define ARGOFFSET R11
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ || __FRAME_OFFSETS */
 
 /* top of stack page */
 #define FRAME_SIZE 168
@@ -80,6 +80,7 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
+#ifdef __KERNEL__
 #ifdef CONFIG_X86_PTRACE_BTS
 
 #ifndef __ASSEMBLY__
@@ -141,5 +142,6 @@ struct ptrace_bts_config {
    Returns number of BTS records drained.
 */
 #endif /* CONFIG_X86_PTRACE_BTS */
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PTRACE_ABI_H */

-- 
