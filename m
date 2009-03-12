Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZCLXIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZCLXIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbZCLXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:08:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467AbZCLXIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:08:12 -0400
Date: Thu, 12 Mar 2009 23:06:41 GMT
From: Magnus Damm <damm@igel.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       damm@igel.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       damm@igel.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090312120559.2926.82371.sendpatchset@rx1.opensource.se>
References: <20090312120559.2926.82371.sendpatchset@rx1.opensource.se>
Subject: [tip:irq/genirq] irq: export remove_irq() and setup_irq() symbols
Message-ID: <tip-eb53b4e8fef10ccccb49a6dbb5e19ca84ba5a305@git.kernel.org>
Git-Commit-ID: eb53b4e8fef10ccccb49a6dbb5e19ca84ba5a305
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 23:06:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb53b4e8fef10ccccb49a6dbb5e19ca84ba5a305
Gitweb:     http://git.kernel.org/tip/eb53b4e8fef10ccccb49a6dbb5e19ca84ba5a305
Author:     Magnus Damm <damm@igel.co.jp>
AuthorDate: Thu, 12 Mar 2009 21:05:59 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 13:16:33 +0100

irq: export remove_irq() and setup_irq() symbols

Export the setup_irq() and remove_irq() symbols.

I'd like to export these functions since I have timer
code that needs to use setup_irq() early on (too early
for request_irq()), and the same code can also be
compiled as a module.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
LKML-Reference: <20090312120559.2926.82371.sendpatchset@rx1.opensource.se>
[ changed to _GPL as these are special APIs deep inside the irq layer. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/manage.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fc16570..e28db0f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -549,6 +549,7 @@ int setup_irq(unsigned int irq, struct irqaction *act)
 
 	return __setup_irq(irq, desc, act);
 }
+EXPORT_SYMBOL_GPL(setup_irq);
 
  /*
  * Internal function to unregister an irqaction - used to free
@@ -640,6 +641,7 @@ void remove_irq(unsigned int irq, struct irqaction *act)
 {
 	__free_irq(irq, act->dev_id);
 }
+EXPORT_SYMBOL_GPL(remove_irq);
 
 /**
  *	free_irq - free an interrupt allocated with request_irq
