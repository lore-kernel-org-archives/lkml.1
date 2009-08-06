Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZHFTtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZHFTtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbZHFTtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:49:05 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63178 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbZHFTtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=Sy7Mij5elN19S8RXQ6JK/OuZDBMyz3cZiPBJErnY0GCtyzURLjbwAn0xdGyMUvAsH4
         HLRXmLdoi9QPnc6f4AsUEfvZLNAB1+Ch7wt3+tj0YihpY0P0NDqBkPZ98+0GHf8m+szW
         A3aftK8EAkuFbtrvvCJPHes52ueSO8J32GDcE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] irq: remove superfluous NULL pointer check in check_irq_resend()
Date: Thu, 6 Aug 2009 21:46:03 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-next-20090806; KDE/4.2.4; i686; ; )
Cc: Dan Carpenter <error27@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       Eugene Teo <eteo@redhat.com>, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908062146.03638.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] irq: remove superfluous NULL pointer check in check_irq_resend()

This takes care of the following entry from Dan's list:

kernel/irq/resend.c +73 check_irq_resend(17) warning: variable derefenced before check 'desc->chip'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 kernel/irq/resend.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/kernel/irq/resend.c
===================================================================
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -70,8 +70,7 @@ void check_irq_resend(struct irq_desc *d
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip || !desc->chip->retrigger ||
-					!desc->chip->retrigger(irq)) {
+		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
