Return-Path: <linux-kernel-owner+w=401wt.eu-S1752333AbZHHQWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbZHHQWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZHHQWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:22:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:53430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZHHQWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:22:11 -0400
Date: Sat, 8 Aug 2009 16:21:37 GMT
From: tip-bot for Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, hpa@zytor.com,
       mingo@redhat.com, bzolnier@gmail.com, eteo@redhat.com, corbet@lwn.net,
       error27@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com, eteo@redhat.com,
       corbet@lwn.net, error27@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200908062146.03638.bzolnier@gmail.com>
References: <200908062146.03638.bzolnier@gmail.com>
Subject: [tip:irq/core] irq: Remove superfluous NULL pointer check in check_irq_resend()
Message-ID: <tip-139183d579d6097cdbbd64825bbac54d8481a144@git.kernel.org>
Git-Commit-ID: 139183d579d6097cdbbd64825bbac54d8481a144
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 16:21:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  139183d579d6097cdbbd64825bbac54d8481a144
Gitweb:     http://git.kernel.org/tip/139183d579d6097cdbbd64825bbac54d8481a144
Author:     Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
AuthorDate: Thu, 6 Aug 2009 21:46:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 18:18:05 +0200

irq: Remove superfluous NULL pointer check in check_irq_resend()

This takes care of the following entry from Dan's list:

kernel/irq/resend.c +73 check_irq_resend(17) warning: variable derefenced before check 'desc->chip'

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Julia Lawall <julia@diku.dk>
LKML-Reference: <200908062146.03638.bzolnier@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/resend.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 89c7117..090c376 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -70,8 +70,7 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip || !desc->chip->retrigger ||
-					!desc->chip->retrigger(irq)) {
+		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
