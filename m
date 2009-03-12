Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZCLMKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZCLMKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZCLMIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:08:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:45097 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbZCLMI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mV88xWRk/TEHcFFv1/hVhKGvLXmaX4uF0Ml5Wz3TsE9K23Ak0/wwcAMPRjod1fFK/u
         UHlu/HbiC1n5R0oyDQnjA7nz02O8SVl0SuO/NZbmnvnPL7lMf3c72Empx4eoVAc25WhV
         UfB/pFcdPnH3XsRxKJapO4mJgsCfirzt9hq0o=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de, mingo@elte.hu
Date: Thu, 12 Mar 2009 21:05:59 +0900
Message-Id: <20090312120559.2926.82371.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090312120534.2926.78511.sendpatchset@rx1.opensource.se>
References: <20090312120534.2926.78511.sendpatchset@rx1.opensource.se>
Subject: [PATCH 03/03] Export remove_irq() and setup_irq() symbols
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Export the setup_irq() and remove_irq() symbols.

I'd like to export these functions since I have timer
code that needs to use setup_irq() early on (too early
for request_irq()), and the same code can also be
compiled as a module.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 kernel/irq/manage.c |    2 ++
 1 file changed, 2 insertions(+)

--- 0003/kernel/irq/manage.c
+++ work/kernel/irq/manage.c	2009-03-12 18:49:09.000000000 +0900
@@ -549,6 +549,7 @@ int setup_irq(unsigned int irq, struct i
 
 	return __setup_irq(irq, desc, act);
 }
+EXPORT_SYMBOL(setup_irq);
 
 /*
  * Internal function to unregister an irqaction - used to free
@@ -640,6 +641,7 @@ void remove_irq(unsigned int irq, struct
 {
 	__free_irq(irq, act->dev_id);
 }
+EXPORT_SYMBOL(remove_irq);
 
 /**
  *	free_irq - free an interrupt allocated with request_irq
