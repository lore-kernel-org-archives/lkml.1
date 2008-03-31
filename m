Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYCaWGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYCaWGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYCaWG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:06:29 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:55185 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYCaWG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:06:29 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] [MIPS] malta_int.c: make 4 variables static
Date: Tue,  1 Apr 2008 02:03:25 +0400
Message-Id: <1207001005-2633-7-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following variables defined in arch/mips/mips-boards/malta/malta_int.c
can become static: msc_irqmap[], msc_nr_irqs, msc_eicirqmap[], and
msc_nr_eicirqs. This patch makes them static.

Successfully build-tested using default configs for Malta, Atlas
and SEAD boards.

Runtime test successfully performed by booting the Malta 4Kc board
up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index dbe60eb..b51a70b 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -273,13 +273,13 @@ static struct irqaction corehi_irqaction = {
 	.name = "CoreHi"
 };
 
-msc_irqmap_t __initdata msc_irqmap[] = {
+static msc_irqmap_t __initdata msc_irqmap[] = {
 	{MSC01C_INT_TMR,		MSC01_IRQ_EDGE, 0},
 	{MSC01C_INT_PCI,		MSC01_IRQ_LEVEL, 0},
 };
-int __initdata msc_nr_irqs = ARRAY_SIZE(msc_irqmap);
+static int __initdata msc_nr_irqs = ARRAY_SIZE(msc_irqmap);
 
-msc_irqmap_t __initdata msc_eicirqmap[] = {
+static msc_irqmap_t __initdata msc_eicirqmap[] = {
 	{MSC01E_INT_SW0,		MSC01_IRQ_LEVEL, 0},
 	{MSC01E_INT_SW1,		MSC01_IRQ_LEVEL, 0},
 	{MSC01E_INT_I8259A,		MSC01_IRQ_LEVEL, 0},
@@ -291,7 +291,7 @@ msc_irqmap_t __initdata msc_eicirqmap[] = {
 	{MSC01E_INT_PERFCTR,		MSC01_IRQ_LEVEL, 0},
 	{MSC01E_INT_CPUCTR,		MSC01_IRQ_LEVEL, 0}
 };
-int __initdata msc_nr_eicirqs = ARRAY_SIZE(msc_eicirqmap);
+static int __initdata msc_nr_eicirqs = ARRAY_SIZE(msc_eicirqmap);
 
 void __init arch_init_irq(void)
 {
-- 
1.5.3

