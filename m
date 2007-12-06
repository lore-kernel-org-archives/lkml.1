Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXLFWjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXLFWjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbXLFWig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:38:36 -0500
Received: from smtp121.plus.mail.mud.yahoo.com ([209.191.106.152]:21866 "HELO
	smtp121.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753790AbXLFWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:38:35 -0500
X-Greylist: delayed 2746 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2007 17:38:35 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=0FNby8JSFxTpzmVTWCks/aTdv2WoHlCmNJ7DuTrz+DkJKBIAabvpJhmdro9aU4OD+rWZKGTwuGK5C41Qk9VnFXawPE6o/QMBL6ThCxnWWrKMrRBf38W9C/ce6hRTaJEwWLhnEtePu9rm5Elz+4Dp8qyiUe2wNOd+kRLJ9Eb7dwE=  ;
X-YMail-OSG: 36WK0dMVM1ltCT5Xw8l3GzLJWt0fIdbeySl9MDBDObSVAVgrSd6.RYWSZmO1LdzvUmE.ta8xbw--
Message-ID: <4758589B.7090303@yahoo.fr>
Date: Thu, 06 Dec 2007 21:16:27 +0100
From: =?UTF-8?B?UsOpbWkgSMOpcmlsaWVy?= <rherilier@yahoo.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@mail.ru>
CC: linux-kernel@vger.kernel.org
Subject: PATCH] adding wistron_btns support for X86_64 systems.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello again.

To use my previous patch (wistron_btns support for fujitsu-siemens amilo pro edition v3505)
with my laptop, I need to make the wistron module compile for x86_64. It is based on Linux
2.4.24-rc4 too.

So, here it is:


Wistron button support for X86_64 systems.

Signed-off-by: Remi Herilier <rherilier@yahoo.fr>


diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 8f5c7b9..5bc8ce6 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -64,7 +64,7 @@ config INPUT_COBALT_BTNS
 
 config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
-	depends on X86 && !X86_64
+	depends on X86
 	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
index b438d99..9d8069b 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -74,10 +74,18 @@ static void call_bios(struct regs *regs)
 
 	preempt_disable();
 	local_irq_save(flags);
+#ifdef CONFIG_X86_64
+	asm volatile ("pushq %%rbp;"
+#else
 	asm volatile ("pushl %%ebp;"
+#endif
 		      "movl %7, %%ebp;"
 		      "call *%6;"
+#ifdef CONFIG_X86_64
+		      "popq %%rbp"
+#else
 		      "popl %%ebp"
+#endif 
 		      : "=a" (regs->eax), "=b" (regs->ebx), "=c" (regs->ecx)
 		      : "0" (regs->eax), "1" (regs->ebx), "2" (regs->ecx),
 			"m" (bios_entry_point), "m" (bios_data_map_base)

--
Best regards

Rémi Hérilier
