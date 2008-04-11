Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYDKLcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYDKLcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYDKLc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:32:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:31717 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760490AbYDKLc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=riSQing92gYDcISgh3+I0jnIKkdfPPPHZi0ZZsQQA1ghZf6oEDPPYwgcQHNNZF4hqN95l0gLnKmUtITXZQKvjH6fAdu/e8z9IPXjt6/sKWPmqQ5h246kYE9NgfDC6Hzo/yTMoXdQrGhvpjf8xHNSqWYK+5rZxxOn8ee/MKU3R2M=
Message-ID: <47FF4B71.4040603@gmail.com>
Date: Fri, 11 Apr 2008 13:28:49 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH 2/3] x86: Section mismatch fixes
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes section mismatch warnings in smpboot_setup_io_apic().

WARNING: arch/x86/kernel/built-in.o(.text+0x11781): Section mismatch in reference from the function smpboot_setup_io_apic()
to the function .init.text:setup_IO_APIC()
The function smpboot_setup_io_apic() references
the function __init setup_IO_APIC().
This is often because smpboot_setup_io_apic lacks a __init
annotation or the annotation of setup_IO_APIC is wrong.  

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 smpboot_hooks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/mach-default/smpboot_hooks.h b/include/asm-x86/mach-default/smpboot_hooks.h
index 3ff2c5b..56d0e1f 100644
--- a/include/asm-x86/mach-default/smpboot_hooks.h
+++ b/include/asm-x86/mach-default/smpboot_hooks.h
@@ -33,7 +33,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	*((volatile long *) phys_to_virt(0x467)) = 0;
 }
 
-static inline void smpboot_setup_io_apic(void)
+static inline void __init smpboot_setup_io_apic(void)
 {
 	/*
 	 * Here we can be sure that there is an IO-APIC in the system. Let's
