Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYGUQ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYGUQ4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYGUQzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:55:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:18054 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYGUQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=FHoXYZQQ6nFmsbhbrd1gfKLl4xza8sAS00Pv1FSMMvuBBebYKdd6cWebxM7boD4BCR
         nMckoLtUiGaFOuj3woKPLJtQ6uoH1I2VyMKtlAuOksGd3+9CqMttjTP/iCcvk/bq55Ho
         seRBMKNUlKRx8zWn8Xym6mDv0Rvkidez0/cQc=
Date: Mon, 21 Jul 2008 17:54:09 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: [Patch] um: fix a build error
Message-ID: <20080721165409.GA9023@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed this build error:

/home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c: In function
‘line_write_interrupt’:
/home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:366: error:
‘struct tty_ldisc’ has no member named ‘write_wakeup’
/home/wangcong/Projects/linux-2.6/arch/um/drivers/line.c:367: error:
‘struct tty_ldisc’ has no member named ‘write_wakeup’
make[2]: *** [arch/um/drivers/line.o] Error 1
make[1]: *** [arch/um/drivers] Error 2
make: *** [sub-make] Error 2

Sigend-off-by: WANG Cong <wangcong@zeuux.org>
Cc: jdike@addtoit.com

---
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 5047490..c872dad 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -363,8 +363,8 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 		return IRQ_NONE;
 
 	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
-	   (tty->ldisc.write_wakeup != NULL))
-		(tty->ldisc.write_wakeup)(tty);
+	   (tty->ldisc.ops->write_wakeup != NULL))
+		(tty->ldisc.ops->write_wakeup)(tty);
 
 	/*
 	 * BLOCKING mode
