Return-Path: <linux-kernel-owner+w=401wt.eu-S1764647AbXJXQrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764647AbXJXQrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760117AbXJXQ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32772 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760112AbXJXQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:26:10 -0400
Date: Wed, 24 Oct 2007 18:26:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] input/serio/hp_sdc.c section fix
Message-ID: <20071024162640.GO30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hp_sdc_exit() mustn't be __exit since it's called from the
__init hp_sdc_register().

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux.o
...
WARNING: vmlinux.o(.init.text+0x1af68): Section mismatch: reference to .exit.text:hp_sdc_exit (between 'hp_sdc_register' and 'hp_sdc_mlc_init')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4022ed345d1b61dc5b6ac0fc35877656e444a11d 
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 6af1998..02b3ad8 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -944,11 +944,7 @@ static int __init hp_sdc_init_hppa(struct parisc_device *d)
 
 #endif /* __hppa__ */
 
-#if !defined(__mc68000__) /* Link error on m68k! */
-static void __exit hp_sdc_exit(void)
-#else
 static void hp_sdc_exit(void)
-#endif
 {
 	write_lock_irq(&hp_sdc.lock);
 

