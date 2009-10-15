Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbZJOMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbZJOMCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762628AbZJOMCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:02:50 -0400
Received: from smtpd3.aruba.it ([62.149.128.208]:49700 "HELO smtp4.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758158AbZJOMCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:02:49 -0400
Date: Thu, 15 Oct 2009 14:04:08 +0200
From: Daniele Calore <orkaan@orkaan.org>
To: rth@twiddle.net, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru
Cc: orkaan@orkaan.org
Subject: [PATCH 2.6.32-rc4] alpha: fix build after vmlinux.lds.S cleanup
 (really)
Message-ID: <20091015140408.21e901b1@buddha>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Rating: smtp4.aruba.it 1.6.2 0/1000/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Build error on alpha:
arch/alpha/kernel/vmlinux.lds:235: undefined symbol `THREAD_SIZE' referenced in expression
make: *** [.tmp_vmlinux1] Error 1

THREAD_SIZE is defined under: "asm/thread_info.h", but
inside an "#ifndef __ASSEMBLY__" directive.
To solve the build, just move the define outside the #ifndef.

Signed-off-by: Daniele Calore <orkaan@orkaan.org>

---
diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 5076a88..e7a07f6 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -50,12 +50,12 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("$8");
 #define current_thread_info()  __current_thread_info
 
+#endif /* !__ASSEMBLY__ */
+
 /* Thread information allocation.  */
 #define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
 
-#endif /* __ASSEMBLY__ */
-
 #define PREEMPT_ACTIVE		0x40000000
 
 /*

