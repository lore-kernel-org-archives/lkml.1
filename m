Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYDJLok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYDJLok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 07:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYDJLob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 07:44:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:19314 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYDJLob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=NfXHO4rQIandJH9cMYt4MULNKW4e6oq9FPM4daqAS9srK19JQgjy8nvKdfUBpfl+/4hrlm3eCZJqRCzKewN1QTDZhnm+o7yO5Upn0HFw/uqHT55i6elLO2ywEvrsPQn9jVlQyaz7ZuUs1xuEg9ahXZJsrRmmDAKlNK68w0nHhM4=
Message-ID: <47FDFCC9.5070106@gmail.com>
Date: Thu, 10 Apr 2008 13:40:57 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, tglx@linutronix.de
Subject: [patch x86] e820_64: fix section mismatch warning
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

this patch (against x86/latest) fixes section mismatch warnings which occurs on my x86_64 box while compiling 
linux-next-20080410.

Warning messages:

WARNING: arch/x86/kernel/built-in.o(.text+0x7bc2): Section mismatch in reference from the function bad_addr() to the 
variable .init.data:early_res
The function bad_addr() references
the variable __initdata early_res.
This is often because bad_addr lacks a __initdata
annotation or the annotation of early_res is wrong.

WARNING: arch/x86/kernel/built-in.o(.text+0x7c3b): Section mismatch in reference from the function bad_addr_size() to 
the variable .init.data:early_res
The function bad_addr_size() references
the variable __initdata early_res.
This is often because bad_addr_size lacks a __initdata
annotation or the annotation of early_res is wrong.

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
  e820_64.c |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index 4f4b690..645ee5e 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -123,7 +123,7 @@ void __init early_res_to_bootmem(unsigned long start, unsigned long end)
  }

  /* Check for already reserved areas */
-static inline int
+static inline int __init
  bad_addr(unsigned long *addrp, unsigned long size, unsigned long align)
  {
  	int i;
@@ -143,7 +143,7 @@ again:
  }

  /* Check for already reserved areas */
-static inline int
+static inline int __init
  bad_addr_size(unsigned long *addrp, unsigned long *sizep, unsigned long align)
  {
  	int i;

