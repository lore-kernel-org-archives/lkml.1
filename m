Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbYJMJko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbYJMJko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbYJMJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:35:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56162 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759034AbYJMJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:35:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 22/80] serial: Make uart_port's ioport "unsigned long".
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:35:23 +0100
Message-ID: <20081013093520.21645.13850.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

Otherwise the top 32-bits of the resource value get chopped
off on 64-bit systems, and the resulting I/O accesses go to
random places.

Thanks to testing and debugging by Josip Rodin, which helped
track this down.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 include/linux/serial_core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 3b2f6c0..e27f216 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -241,7 +241,7 @@ typedef unsigned int __bitwise__ upf_t;
 
 struct uart_port {
 	spinlock_t		lock;			/* port lock */
-	unsigned int		iobase;			/* in/out[bwl] */
+	unsigned long		iobase;			/* in/out[bwl] */
 	unsigned char __iomem	*membase;		/* read/write[bwl] */
 	unsigned int		irq;			/* irq number */
 	unsigned int		uartclk;		/* base uart clock */

