Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYJTVdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYJTVdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYJTVdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:33:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:17226 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYJTVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:33:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=q5N5ftMEWK7wPPvUTqZ1G4dmAMHEohnEzv2srTQY5lhaeCRDlxkGZJjVzYJDdg4Ed4
         sG8gNa7uCqSBY+FM+sC2htLAFqfNei7PjCtCgfk67K7f91+2AWcjsIR1o+PWWQWGtvWF
         bimFbRYbvs4W0vZsdaKzNX+DTdfwmEgykJLm0=
Message-ID: <6e4284620810201431g699c705yf5157a96e3fa4b25@mail.gmail.com>
Date: Mon, 20 Oct 2008 23:31:49 +0200
From: "Vlada Peric" <vlada.peric@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] io_apic_32.c: fix compile warning on printk type
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9KLXLdq017708

Please CC me directly, as I'm not subscribed to the list. I'm not sureif Gmail won't mangle the patch, but I've been unable to find a guideonline on how to send one. I also might've sent the message more thanonce, for which I sincerely apologize.
This patch fixes the following warnings by casting to u32:
arch/x86/kernel/io_apic_32.c: In function 'print_local_APIC':arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type'unsigned int', but argument 2 has type 'u64'arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type'unsigned int', but argument 2 has type 'u64'
Signed-off-by: Vlada Periæ <vlada.peric <at> gmail.com>--- arch/x86/kernel/io_apic_32.c |    4 ++-- 1 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.cindex e710289..64f0953 100644--- a/arch/x86/kernel/io_apic_32.c+++ b/arch/x86/kernel/io_apic_32.c@@ -1536,8 +1536,8 @@ __apicdebuginit(void) print_local_APIC(void *dummy)       }
       icr = apic_icr_read();-       printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);-       printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);+       printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);+       printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
       v = apic_read(APIC_LVTT);       printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);--1.6.0.2
--Vlada Periæÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
