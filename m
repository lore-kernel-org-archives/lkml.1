Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZBHTZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZBHTZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZBHTYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:24:53 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:64080 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZBHTYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:24:52 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH] kernel/irq: fix sparse warning: make symbol static
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 08 Feb 2009 20:24:47 +0100
Message-ID: <20090208192405.8084.89231.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While being at it make every occurrence of 'do_irq_select_affinity'
have the same signature in terms of signedness of the first argument.

Fix this sparse warning:
  kernel/irq/manage.c:112:5: warning: symbol 'do_irq_select_affinity' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 kernel/irq/manage.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a3a5dc9..1bdcb59 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -109,7 +109,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 /*
  * Generic version of the affinity autoselector.
  */
-int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
+static int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	if (!irq_can_set_affinity(irq))
 		return 0;
@@ -156,7 +156,7 @@ int irq_select_affinity_usr(unsigned int irq)
 }
 
 #else
-static inline int do_irq_select_affinity(int irq, struct irq_desc *desc)
+static inline int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	return 0;
 }

