Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbYHAJmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbYHAJmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYHAJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:51 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:16382 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbYHAJit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t9AwSwEcS4gJfzlx/yEJxkS0ffhLsvmSmiMSEN0agmfoO3gUj+u5swp09dh5WoWVhp
         vnFqcpSSl06/ASQYQ+wjn0xg81DktNCY5Ix3oyYnHDhElEovHuG6Aw12hF7q++0aZR1j
         ODoMzy3GAZ/Z4bM5LMj3k9X9DF/vqqOhkTLsU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 12/16] x86: make 32bit use dyn_array
Date: Fri,  1 Aug 2008 02:37:40 -0700
Message-Id: <1217583464-28494-13-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-12-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-9-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-10-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-11-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-12-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/Kconfig                 |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -33,7 +33,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-	select HAVE_DYN_ARRAY if X86_64
+	select HAVE_DYN_ARRAY
 
 config ARCH_DEFCONFIG
 	string
Index: linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
@@ -145,6 +145,7 @@ SECTIONS
 	*(.x86cpuvendor.init)
 	__x86cpuvendor_end = .;
   }
+  DYN_ARRAY_INIT(8)
   SECURITY_INIT
   . = ALIGN(4);
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
