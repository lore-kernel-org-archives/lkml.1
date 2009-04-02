Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZDBOEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZDBOEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZDBOEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:04:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:55406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbZDBOEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:04:05 -0400
Date: Thu, 2 Apr 2009 14:03:30 GMT
From: Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       henrix@sapo.pt, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       henrix@sapo.pt, tglx@linutronix.de
In-Reply-To: <20090401170635.GA4392@hades.domain.com>
References: <20090401170635.GA4392@hades.domain.com>
Subject: [tip:irq/genirq] genirq: do not execute DEBUG_SHIRQ when irq setup failed
Message-ID: <tip-ba71604fad348656071a2a76eef9a67dab85a773@git.kernel.org>
Git-Commit-ID: ba71604fad348656071a2a76eef9a67dab85a773
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 14:03:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba71604fad348656071a2a76eef9a67dab85a773
Gitweb:     http://git.kernel.org/tip/ba71604fad348656071a2a76eef9a67dab85a773
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Wed, 1 Apr 2009 18:06:35 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 2 Apr 2009 16:02:39 +0200

genirq: do not execute DEBUG_SHIRQ when irq setup failed

When requesting an IRQ, the DEBUG_SHIRQ code executes a fake IRQ just to make
sure the driver is ready to receive an IRQ immediately.  The problem was that
this fake IRQ was being executed even if interrupt line failed to be allocated
by __setup_irq.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
LKML-Reference: <20090401170635.GA4392@hades.domain.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1516ab7..beeb7d1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -768,7 +768,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 		kfree(action);
 
 #ifdef CONFIG_DEBUG_SHIRQ
-	if (irqflags & IRQF_SHARED) {
+	if (!retval & (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
 		 * to happen immediately, so let's make sure....
