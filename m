Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYIXJiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYIXJiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYIXJiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:38:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:45696 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYIXJiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rPRV0oZz4+0luaKtCW4qne6EOfPWodJmkKaoi1DkrwG6PEtUKB6QagdbPhE/Op01rD
         y9FDXAs3igDvc8dyEvy7U/yGwy+nAOXW7YxqVRrNXEqdwODWHNkgIRuSMZNKNzAIOtPZ
         DcUKOKzANLnkWSS3S0Ea9Q8AsFcUSPMwIQsFU=
Date: Wed, 24 Sep 2008 13:40:26 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] i386: fix C1E induced compile breakage
Message-ID: <20080924094026.GA1066@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      arch/x86/kernel/process_32.o
arch/x86/kernel/process_32.c: In function `cpu_exit_clear':
arch/x86/kernel/process_32.c:91: error: implicit declaration of function `c1e_remove_cpu'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/kernel/process_32.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
+#include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
