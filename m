Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbXISMpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbXISMpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXISMpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:45:20 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38578 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbXISMpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:45:19 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 19 Sep 2007 08:43:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: hskinnemoen@atmel.com
Subject: [PATCH] AVR32:  Drop support for redundant "keepinitrd" boot-time
 parm.
Message-ID: <Pine.LNX.4.64.0709190840020.20641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Given the existing "retain_initrd" boot-time parameter defined in
init/initramfs.c, there appears to be no need for the equivalent
"keepinitrd" parameter.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not compile-tested, so i'll leave it with haavard to make the final
call.

  the arm architecture also defines that same parm, and it may very
well be redundant, too.

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index 82cf708..480760b 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -224,19 +224,9 @@ void free_initmem(void)

 #ifdef CONFIG_BLK_DEV_INITRD

-static int keep_initrd;
-
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd)
-		free_area(start, end, "initrd");
-}
-
-static int __init keepinitrd_setup(char *__unused)
-{
-	keep_initrd = 1;
-	return 1;
+	free_area(start, end, "initrd");
 }

-__setup("keepinitrd", keepinitrd_setup);
 #endif
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
