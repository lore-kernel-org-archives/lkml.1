Return-Path: <linux-kernel-owner+w=401wt.eu-S935154AbZLGQNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935154AbZLGQNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933585AbZLGQNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:13:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320AbZLGQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:13:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] don't include asm/hw_breakpoint.h in user space
Date: Mon, 7 Dec 2009 17:12:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
References: <10f740e80912061149w277105e2l31e9fef13221fee1@mail.gmail.com>
In-Reply-To: <10f740e80912061149w277105e2l31e9fef13221fee1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071712.58650.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ykVCuFDnzlC092fsKU6BQE0XElOOuumI9apS
 DaI4lm1ahCDTRYHtYAr5BXAZIUZV1Tp+db9XNFYNBLLUU/fEUp
 I9qydzycBJl8rXQG0LYTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/hw_breakpoint.h is evidently a kernel internal file and should
not be included globally, not even under an #ifdef.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Sunday 06 December 2009, Geert Uytterhoeven wrote:
> `make headers_check' now complains:
> 
> usr/include/linux/perf_event.h:22: included file
> 'asm-m68k/hw_breakpoint.h' is not exported
> 
> although CONFIG_HAVE_HW_BREAKPOINT is not set.
> 
> As <asm/hw_breakpoint.h> exists for x86 only, I guess every one else
> is suffering from this.

Even on x86, that header is not exported.

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -18,10 +18,6 @@
 #include <linux/ioctl.h>
 #include <asm/byteorder.h>
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-#include <asm/hw_breakpoint.h>
-#endif
-
 /*
  * User-space ABI bits:
  */
@@ -451,6 +447,10 @@ enum perf_callchain_context {
 # include <asm/perf_event.h>
 #endif
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#include <asm/hw_breakpoint.h>
+#endif
+
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rculist.h>
