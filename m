Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbZCXOGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbZCXOGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbZCXOC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:02:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48946 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758075AbZCXOCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:02:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/30] blackfin: Explain why we cannot cpu_relax() in early
	serial code
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:03:16 +0000
Message-ID: <20090324140313.12735.24344.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/bfin_5xx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index d46d764..c7c0c1b 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1127,6 +1127,10 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
 	unsigned timeout = 0xffff;
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 
+	/* We cannot cpu_relax() here as doing so on the BF561 relies
+	 * on the per-cpu region being setup, and since this is early
+	 * serial code, it may not yet be usable ...
+	 */
 	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
 		barrier();
 

