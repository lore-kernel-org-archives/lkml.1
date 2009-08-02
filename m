Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZHBTl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZHBTl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZHBTl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:41:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:32998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbZHBTlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:41:55 -0400
Date: Sun, 2 Aug 2009 19:41:08 GMT
From: tip-bot for Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, hpa@zytor.com,
       mingo@redhat.com, bzolnier@gmail.com, eteo@redhat.com, corbet@lwn.net,
       error27@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com, eteo@redhat.com,
       corbet@lwn.net, error27@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200907302321.19086.bzolnier@gmail.com>
References: <200907302321.19086.bzolnier@gmail.com>
Subject: [tip:x86/apic] x86: Remove superfluous NULL pointer check in destroy_irq()
Message-ID: <tip-25f6e89bedd29cc49bfa0d55497e91a671b9ae6e@git.kernel.org>
Git-Commit-ID: 25f6e89bedd29cc49bfa0d55497e91a671b9ae6e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 19:41:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25f6e89bedd29cc49bfa0d55497e91a671b9ae6e
Gitweb:     http://git.kernel.org/tip/25f6e89bedd29cc49bfa0d55497e91a671b9ae6e
Author:     Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
AuthorDate: Thu, 30 Jul 2009 23:21:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 21:37:00 +0200

x86: Remove superfluous NULL pointer check in destroy_irq()

This takes care of the following entry from Dan's list:

  arch/x86/kernel/apic/io_apic.c +3241 destroy_irq(11) warning: variable derefenced before check 'desc'

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Julia Lawall <julia@diku.dk>
LKML-Reference: <200907302321.19086.bzolnier@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index cf51b0b..7e92a92 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3185,8 +3185,7 @@ void destroy_irq(unsigned int irq)
 	cfg = desc->chip_data;
 	dynamic_irq_cleanup(irq);
 	/* connect back irq_cfg */
-	if (desc)
-		desc->chip_data = cfg;
+	desc->chip_data = cfg;
 
 	free_irte(irq);
 	spin_lock_irqsave(&vector_lock, flags);
