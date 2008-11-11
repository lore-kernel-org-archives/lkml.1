Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYKKEP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYKKEP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYKKEPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:15:41 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:53861 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbYKKEPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:15:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=k8zJPHCD9A0nFQxztxfEHHfI6D2FubhM+/LHXKCwwF5pTi8q291nl64HuR4yp62jcB
         ob50v3m/GxToHa+F3SWDKtU/2SRlw56byi7+rhZ2xxTeyjA1TSS03E4t1ev81YKuuqNx
         iX6bE1dFXG9o2tC7wTkT27vNJm6kt9CmTWe4g=
Message-ID: <b9df5fa10811102015r21017451w43755bf0d97a9db4@mail.gmail.com>
Date: Tue, 11 Nov 2008 10:15:38 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: Fixing improper annotation.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       tglx@linutronix.de, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After using __cpuinit in function 'init_thread_xstate(void)', the
following warning was generated.

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x29c): Section
mismatch in reference from the function init_thread_xstate() to the
function .init.text:xsave_cntxt_init()
The function __cpuinit init_thread_xstate() references
a function __init xsave_cntxt_init().
If xsave_cntxt_init is only used by init_thread_xstate then
annotate xsave_cntxt_init with a matching annotation.

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x233d): Section
mismatch in reference from the function cpu_init() to the function
.init.text:xsave_init()
The function __cpuinit cpu_init() references
a function __init xsave_init().
If xsave_init is only used by cpu_init then
annotate xsave_init with a matching annotation.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/arch/x86/kernel/xsave.c	2008-11-10 13:28:18.000000000 +0600
+++ linux-2.6/arch/x86/kernel/xsave.c	2008-11-11 00:31:42.000000000 +0600
@@ -301,7 +301,7 @@ void __cpuinit xsave_init(void)
 /*
  * setup the xstate image representing the init state
  */
-static void __init setup_xstate_init(void)
+static void __cpuinit setup_xstate_init(void)
 {
 	init_xstate_buf = alloc_bootmem(xstate_size);
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
@@ -310,7 +310,7 @@ static void __init setup_xstate_init(voi
 /*
  * Enable and initialize the xsave feature.
  */
-void __init xsave_cntxt_init(void)
+void __cpuinit xsave_cntxt_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
