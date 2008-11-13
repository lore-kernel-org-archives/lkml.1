Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYKMTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYKMTnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYKMTe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:28 -0500
Received: from gw.goop.org ([64.81.55.164]:34391 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYKMTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 31 of 38] xen: set irq_chip disable
X-Mercurial-Node: fc0596c078eb24bd81f41ea084df42f6047ceb4b
Message-Id: <fc0596c078eb24bd81f4.1226603429@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, the irq_chip.disable operation is a no-op.  Explicitly set
it to disable the Xen event channel.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -806,8 +806,11 @@
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.name		= "xen-dyn",
+
+	.disable	= disable_dynirq,
 	.mask		= disable_dynirq,
 	.unmask		= enable_dynirq,
+
 	.ack		= ack_dynirq,
 	.set_affinity	= set_affinity_irq,
 	.retrigger	= retrigger_dynirq,


