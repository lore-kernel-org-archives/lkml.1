Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYAHBXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYAHBXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYAHBXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:23:25 -0500
Received: from gw.goop.org ([64.81.55.164]:56294 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbYAHBXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:23:25 -0500
Message-ID: <4782CFFD.3040902@goop.org>
Date: Mon, 07 Jan 2008 17:21:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: export native_read_tsc
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

native_read_tsc is needed by modules, so it should be exported.

make -C /home/jeremy/hg/xen/paravirt/linux O=/home/jeremy/hg/xen/paravirt/linux-x86_64 
  Using /home/jeremy/hg/xen/paravirt/linux as source for kernel
  GEN     /home/jeremy/hg/xen/paravirt/linux-x86_64/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    /home/jeremy/hg/xen/paravirt/linux/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
Kernel: arch/x86/boot/bzImage is ready  (#49)
  Building modules, stage 2.
  MODPOST 257 modules
ERROR: "native_read_tsc" [drivers/input/gameport/gameport.ko] undefined!

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>

---
 arch/x86/kernel/rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -204,4 +204,4 @@ unsigned long long native_read_tsc(void)
 
 	return EAX_EDX_VAL(val, low, high);
 }
-
+EXPORT_SYMBOL(native_read_tsc);


