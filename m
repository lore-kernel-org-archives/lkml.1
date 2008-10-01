Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYJAIrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYJAIrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYJAIrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:47:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:19264 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYJAIrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:47:14 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, alan@lxorguk.ukuu.org.uk,
       Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] drivers/serial/8250.c: 'i' may be used uninitialized
Date: Wed,  1 Oct 2008 01:47:07 -0700
Message-Id: <1222850827-30522-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <f488382f0810010136t6280c10dg80458e3e9f02f598@mail.gmail.com>
References: <f488382f0810010136t6280c10dg80458e3e9f02f598@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serial_unlink_irq_chain() does not initialize iterator 'i', and that is
correct logically because it is always initialized, either in the
hlist_for_each or in the conditional immediately after (which fires if
hlist_for_each comes up empty-handed). GCC does not realize this
connection and emits a false warning. Annotate it with uninitialized_var().

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 356c2a2..4950ee5 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1551,7 +1551,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 {
 	struct hlist_head *h;
 	struct hlist_node *n;
-	struct irq_info *i;
+	struct irq_info *uninitialized_var(i);
 	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 
 	mutex_lock(&hash_mutex);
-- 
1.6.0.2

