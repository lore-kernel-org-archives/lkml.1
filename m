Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYGXFwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYGXFwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 01:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYGXFv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 01:51:58 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:51952 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYGXFv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 01:51:57 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-29.messagelabs.com!1216878716!17777080!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: Ingo Oeser <ioe-lkml@rameria.de>
Subject: [PATCH] make set_irq_wake_real static
Date: Thu, 24 Jul 2008 07:51:53 +0200
Message-ID: <1216878713-9522-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2008 05:51:53.0611 (UTC) FILETIME=[5FD6DDB0:01C8ED51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_irq_wake_real was introduced in 2db873211ba47ef704c301f9ecf4a33413a0b649
and its only user is set_irq_wake.

Noticed-by: Ingo Oeser <ioe-lkml@rameria.de>
Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3cfc0fe..4476cd0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -217,7 +217,7 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
-int set_irq_wake_real(unsigned int irq, unsigned int on)
+static int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	int ret = -ENXIO;
-- 
1.5.6.3

