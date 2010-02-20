Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab0BTAFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:05:13 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50004 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab0BTAFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:05:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tmElzInZgCESW2j4II+qfuRdnxfWb+TdzZ0u5e+pQQCfGK/J0eGFPuYj8FW7bPDVUx
         SpGWeEav2vxj9ceS8p45LfPX2FF2gHKm4Za/4pF6N3wJ58O68bmXxm4/dQiUaGzWWJ+T
         Mjc1e2l5/rsYsX7W5ef3L+DgWJ98GqWaoeIlM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 22/24] Rename .data.lock_aligned to .data..lock_aligned.
Date: Sat, 20 Feb 2010 01:03:55 +0100
Message-Id: <1266624237-22372-23-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/parisc/include/asm/system.h |    2 +-
 arch/parisc/kernel/vmlinux.lds.S |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/system.h b/arch/parisc/include/asm/system.h
index d91357b..4bbb673 100644
--- a/arch/parisc/include/asm/system.h
+++ b/arch/parisc/include/asm/system.h
@@ -174,7 +174,7 @@ static inline void set_eiem(unsigned long val)
 })
 
 #ifdef CONFIG_SMP
-# define __lock_aligned __attribute__((__section__(".data.lock_aligned")))
+# define __lock_aligned __attribute__((__section__(".data..lock_aligned")))
 #endif
 
 #define arch_align_stack(x) (x)
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 33ec31d..d64a6bb 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -94,8 +94,8 @@ SECTIONS
 
 	/* PA-RISC locks requires 16-byte alignment */
 	. = ALIGN(16);
-	.data.lock_aligned : {
-		*(.data.lock_aligned)
+	.data..lock_aligned : {
+		*(.data..lock_aligned)
 	}
 
 	/* End of data section */
-- 
1.6.2.4

