Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbYDJTU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbYDJTU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYDJTUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:20:17 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:28323 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYDJTUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=o4xeNyL+HGLUF5lH4B/BpSUnT6D/GJ07zgx8BNRrydQhOCPgpYXWSFFqBd5pb7Jk/cB7AKHhIAxg16bCnGp1oyu9R/J5XE7TkhxVe5ZNzFfMn/SNoNaopCgNrzQxV29O1U38liOwioAQBCtMqJjpoFjCmk9lD4CFRSp10QFBRrw=
Message-ID: <47FE6799.9030606@gmail.com>
Date: Thu, 10 Apr 2008 21:16:41 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: [PATCH] x86: setup_trampoline() - fix section mismatch warning
Content-Type: multipart/mixed;
 boundary="------------090200030305010809090209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090200030305010809090209
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Hi Ingo,

this patch fixes section mismatch warnings (on x86_64 host) in setup_trampoline(),
which was referencing __initdata variables trampoline_data and trampoline_end.

Patch is against x86/latest.

Warning messages:
WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x2b6a): Section mismatch in reference from the function setup_trampoline()
to the variable .init.data:trampoline_data
The function __cpuinit setup_trampoline() references
a variable __initdata trampoline_data.
If trampoline_data is only used by setup_trampoline then
annotate trampoline_data with a matching annotation.

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x2b71): Section mismatch in reference from the function setup_trampoline()
to the variable .init.data:trampoline_end
The function __cpuinit setup_trampoline() references
a variable __initdata trampoline_end.
If trampoline_end is only used by setup_trampoline then
annotate trampoline_end with a matching annotation. 

-Jacek

PS: Hope that my email client won't break patch this time. In case it does - patch attached.

---

diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 4aedd0b..2a07e67 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -32,7 +32,7 @@
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
-.section .init.data, "aw", @progbits
+.section .cpuinit.data, "aw", @progbits
 #else
 .section .rodata, "a", @progbits
 #endif


--------------090200030305010809090209
Content-Type: text/plain;
 name="setup_trampoline-fix_section_mismatch.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="setup_trampoline-fix_section_mismatch.patch"

diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 4aedd0b..2a07e67 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -32,7 +32,7 @@
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
-.section .init.data, "aw", @progbits
+.section .cpuinit.data, "aw", @progbits
 #else
 .section .rodata, "a", @progbits
 #endif

--------------090200030305010809090209--
