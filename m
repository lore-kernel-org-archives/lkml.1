Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYLHO4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYLHO4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYLHO4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:56:40 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:61067 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYLHO4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:56:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KfIWfYXsFAN/CWw7ypV6kfELQyE5XybuskdtZqCitDPnYEeJwegP5URm7WOVoTSsKv
         rsBsqxf/EqtUKljlya8/vwvo0rEZeX0IArcsXnzAs966WctTLtoI3p/DI1EgiglKRJVJ
         gPA85vGKXqp2aJqM6vLPBGmK82Ktt+0rFrE8Y=
Message-ID: <b9df5fa10812080656l21385db3ob08fc4f9ad3f1f76@mail.gmail.com>
Date: Mon, 8 Dec 2008 20:56:38 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH ] x86 : Fix compilation warning on paravirt-spinlocks.c
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Fix compilation warning.

 CC      arch/x86/kernel/paravirt-spinlocks.o
arch/x86/kernel/paravirt-spinlocks.c: In function `default_spin_lock_flags':
arch/x86/kernel/paravirt-spinlocks.c:12: warning: passing arg 1 of
`__raw_spin_lock' from incompatible pointer type

This patch fixes the above warning.  __raw_spin_lock(lock) is declared
when CONFIG_SMP is defined. Thus, a call to __raw_spin_lock requires
checking CONFIG_SMP is defined or not.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/arch/x86/kernel/paravirt-spinlocks.c	2008-12-05
19:53:15.000000000 +0600
+++ linux-2.6/arch/x86/kernel/paravirt-spinlocks.c	2008-12-07
23:52:59.000000000 +0600
@@ -9,7 +9,9 @@

 static void default_spin_lock_flags(struct raw_spinlock *lock,
unsigned long flags)
 {
+#ifdef	CONFIG_SMP
 	__raw_spin_lock(lock);
+#endif
 }

 struct pv_lock_ops pv_lock_ops = {
