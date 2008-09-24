Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYIXXc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYIXXc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYIXXcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:32:19 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56446 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbYIXXcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:32:18 -0400
Subject: [PATCH] x86: Fix 32 bit compile failure in process_32.c
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 16:32:00 -0700
Message-Id: <1222299120.18916.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:

commit 4faac97d44ac27bdbb010a9c3597401a8f89341f
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Sep 22 18:54:29 2008 +0200

    x86: prevent stale state of c1e_mask across CPU offline/online

Introduced a compile failure into the 32 bit x86 path:

arch/x86/kernel/process_32.c: In function 'cpu_exit_clear':
arch/x86/kernel/process_32.c:91: error: implicit declaration of function
'c1e_remove_cpu'
make[1]: *** [arch/x86/kernel/process_32.o] Error 1

because the prototype for c1e_remove_cpu() gets put into asm/idle.h but
this isn't directly included in process_32.c

Fix by making this a direct include.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4b3cfdf..260a96f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -42,6 +42,7 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/io.h>
+#include <asm/idle.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/i387.h>



