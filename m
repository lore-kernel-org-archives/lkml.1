Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYDLPo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYDLPo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYDLPov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:44:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9264 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYDLPou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=u1WJydSm/yvohsekDAkLov1EDBSnywS8j175R4Pywd2yFXhI1jKvCcmkt/wguUKyv4COTb1016sg2ldJJZsBD1MaBngJ1CfMBgFBulsgZrFsg24yPyrAgvHdDKhwam0NyZZOrcDs7sAo3ZN1e/k+hPed+p6Vvz+PbOG/QpsvOfk=
Message-ID: <4800D818.5070901@gmail.com>
Date: Sat, 12 Apr 2008 17:41:12 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: [PATCH 3/3] x86: unlock_ExtINT_logic() - fix section mismatch warnings
References: <4800D743.3000405@gmail.com>
In-Reply-To: <4800D743.3000405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: arch/x86/kernel/built-in.o(.text+0x12cc9): Section mismatch in reference from the function unlock_ExtINT_logic()

unlock_ExtINT_logic() is only used by __init check_timer(). Annotate unlock_ExtINT_logic() witch __init.

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 io_apic_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 2e2f420..696b8e4 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -2068,7 +2068,7 @@ static void __init setup_nmi(void)
  * cycles as some i82489DX-based boards have glue logic that keeps the
  * 8259A interrupt line asserted until INTA.  --macro
  */
-static inline void unlock_ExtINT_logic(void)
+static inline void __init unlock_ExtINT_logic(void)
 {
 	int apic, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
