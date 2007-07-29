Return-Path: <linux-kernel-owner+w=401wt.eu-S933687AbXG2SEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbXG2SEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764184AbXG2SEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:04:42 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:6154 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbXG2SE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sYle4MqJQbJ/SUu7ykg24zzUkT+4xwPmbv3IplrIlOU3S7wnz4tHO3T1oQZR6slJiZWztX0KzVDdg3vTEEYLnzwygEXUcQs0voAcyhqhL58QUehb9S6pJZmhZk3ReAQqDi65k7zZ8ZqBgoKk4yXCdMXxuc+d3OvxmUCUWKNMwW8=
Message-ID: <8b67d60707291104k64ba6e0dpf86a7604ce63ae8e@mail.gmail.com>
Date: Sun, 29 Jul 2007 19:04:25 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: lethal@linux-sh.org
Subject: [PATCH] Reboot Dreamcast under software control
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the light of more up to date technical information I have
discovered there is a register at physical address 0x005F6890 on the
Dreamcast that if written a magic number (0x00007611) will force a
reboot under software control.

Presumably a better option than the current catch-all mechanism.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
index 6334a4c..6f5e9e4 100644
--- a/arch/sh/kernel/process.c
+++ b/arch/sh/kernel/process.c
@@ -97,6 +97,11 @@ void cpu_idle(void)

 void machine_restart(char * __unused)
 {
+
+#ifdef CONFIG_SH_DREAMCAST
+       /*reboot the Dreamcast under software control*/
+       writel(0x00007611, 0xA05F6890);
+#endif
        /* SR.BL=1 and invoke address error to let CPU reset (manual reset) */
        asm volatile("ldc %0, sr\n\t"
                     "mov.l @%1, %0" : : "r" (0x10000000), "r" (0x80000001));
