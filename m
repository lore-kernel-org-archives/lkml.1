Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbYDKLdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbYDKLdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760643AbYDKLco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:32:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42726 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703AbYDKLcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=jWG0IMhIlPOmez/8USL2RPFk8X5bF8mxwwuUPZYK/IoNo/5kgr6VVINsXhx16HQ4fIRb/hbcplhN43NvngY5pRKvEFWJzttZGBxhhTZT/zAR0Yub8HfjsRDm2cZtjVNdddR+0t9er/rX78YnFTStRG/QXTsXb77kalp0zrAUysQ=
Message-ID: <47FF4B80.2060400@gmail.com>
Date: Fri, 11 Apr 2008 13:29:04 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH 3/3] x86: Section mismatch fixes
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes section mismatch warnings in unlock_ExtINT_logic().

WARNING: arch/x86/kernel/built-in.o(.text+0x14a92): Section mismatch in reference from the function unlock_ExtINT_logic()
to the function .init.text:find_isa_irq_pin()
The function unlock_ExtINT_logic() references
the function __init find_isa_irq_pin().
This is often because unlock_ExtINT_logic lacks a __init
annotation or the annotation of find_isa_irq_pin is wrong. 

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 io_apic_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 9ba11d0..ef1a8df 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1599,7 +1599,7 @@ static void __init setup_nmi(void)
  * cycles as some i82489DX-based boards have glue logic that keeps the
  * 8259A interrupt line asserted until INTA.  --macro
  */
-static inline void unlock_ExtINT_logic(void)
+static inline void __init unlock_ExtINT_logic(void)
 {
 	int apic, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
