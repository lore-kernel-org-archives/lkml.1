Return-Path: <linux-kernel-owner+w=401wt.eu-S1031220AbXDSMYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031220AbXDSMYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031221AbXDSMYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:24:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:64300 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031220AbXDSMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:reply-to:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=SlhlqQkCcgAvJt4pIRKSmlZOtJqy8Hf4YRLqTdsb23RgcONJVXxSSO+xoTy0Q4Cl+eE0mseHoLWXVNni6keDwyhIY/lCKZdH/7EmP9pQLRdnYTEGAPIUHmKVskPLKEeKWjgewWvZmvLNOox2N3YkoLLPxVWDChbUowjGoOXQFoU=
Message-ID: <46275F9D.4040408@innova-card.com>
Date: Thu, 19 Apr 2007 14:25:01 +0200
Reply-To: Franck <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: linux-mips <linux-mips@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] Don't force frame pointers for lockdep on MIPS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Stacktrace support on MIPS doesn't use frame pointers. Since this
option considerably increases the size of the kernel code, force
lockdep to not use it.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3f3e740..79afd00 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -261,7 +261,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86
+	select FRAME_POINTER if !X86 && !MIPS
 	select KALLSYMS
 	select KALLSYMS_ALL
 
-- 
1.5.1.1

