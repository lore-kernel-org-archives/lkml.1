Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbXG2SZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbXG2SZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765196AbXG2SZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:25:23 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:23450 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764965AbXG2SZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nwF2/5bV5VA43BEr7SAakwpEVs8hkVteYZffw6N5G3SSUrnFY/m0y7Kpa97KG/4wEsXo6Rrbuebda7F8fgqc+5UkLyZs174MdNvdhYG2gGyzEBqk1p1May6HZEoWVwNmw486PaHv5IYYEsa26hougyMXexyqQ085ACFuWCdlzBQ=
Message-ID: <8b67d60707291125o5c78d87dq59c842a9dac3e521@mail.gmail.com>
Date: Sun, 29 Jul 2007 19:25:21 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Fwd: [PATCH] Reboot Dreamcast under software control
In-Reply-To: <8b67d60707291104k64ba6e0dpf86a7604ce63ae8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60707291104k64ba6e0dpf86a7604ce63ae8e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies. I meant to cc: this to the lists first time round and
appear to have bcc'ed it instead.

---------- Forwarded message ----------
From: Adrian McMenamin <lkmladrian@gmail.com>
Date: 29-Jul-2007 19:04
Subject: [PATCH] Reboot Dreamcast under software control
To: lethal@linux-sh.org


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
