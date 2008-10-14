Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYJNK3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYJNK3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 06:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYJNK2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 06:28:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37326 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755240AbYJNK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 06:28:43 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] 8250: Fix lock warning
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 14 Oct 2008 11:28:39 +0100
Message-ID: <20081014102839.20626.41534.stgit@localhost.localdomain>
In-Reply-To: <20081014102821.20626.97298.stgit@localhost.localdomain>
References: <20081014102821.20626.97298.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Splitting the 8250 code back up to avoid a clash with the NR_IRQS removal
patch introduced a last minute bug. Put back the additional needed lines
for the old lock init
---

 drivers/serial/8250.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index d4104a3..d3ca7d3 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2969,6 +2969,9 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
+	for (i = 0; i < NR_IRQS; i++)
+		spin_lock_init(&irq_lists[i].lock);
+
 #ifdef CONFIG_SPARC
 	ret = sunserial_register_minors(&serial8250_reg, UART_NR);
 #else

