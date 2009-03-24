Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbZCXUbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbZCXUbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbZCXUas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:30:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:13057 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019AbZCXUar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kisIFTla8OyVqRRAAYQZnwZ4lZ2wpB12BIP9UEuzezUDVOMZaipWIue8RWL7NNlMNQ
         5ZYOoRlwGZWoMFf6CkchqdbA0xKbr+gPVZ0RQcmcfIztVwMZiquCJSOSuRXdPJip6/aD
         2OVrILowuVVTttDHTo1AWRBWesDOjZYXMARO0=
Date: Tue, 24 Mar 2009 23:38:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org
Subject: [PATCH] i386: remove struct thread_struct::fs
Message-ID: <20090324203805.GA24382@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 464d1a78fbf8cf6c7fd970e7b3e2db50a320ce28 aka
"[PATCH] i386: Convert i386 PDA code to use %fs"
%fs saved during context switch moved from thread_struct to pt_regs.

Ifdef it on i386.

I don't understand why .fs (OK, .gs first) initializer was added, kernel
clearly stopped touching it after the patch.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/include/asm/processor.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -403,7 +403,9 @@ struct thread_struct {
 	unsigned short		gsindex;
 #endif
 	unsigned long		ip;
+#ifdef CONFIG_X86_64
 	unsigned long		fs;
+#endif
 	unsigned long		gs;
 	/* Hardware debugging registers: */
 	unsigned long		debugreg0;
@@ -847,7 +849,6 @@ static inline void spin_lock_prefetch(const void *x)
 	.vm86_info		= NULL,					  \
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
-	.fs			= __KERNEL_PERCPU,			  \
 }
 
 /*
