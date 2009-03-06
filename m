Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZCFGml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZCFGml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZCFGk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:40:58 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50912 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZCFGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:56 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883649"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 06/18] Blackfin Serial Driver: explain why we cannot cpu_relax() in early serial code
Date: Fri,  6 Mar 2009 14:42:48 +0800
Message-Id: <1236321780-28718-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 5a163f6..de8709d 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1190,6 +1190,10 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
 	unsigned timeout = 0xffff;
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 
+	/* We cannot cpu_relax() here as doing so on the BF561 relies
+	 * on the per-cpu region being setup, and since this is early
+	 * serial code, it may not yet be usable ...
+	 */
 	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
 		barrier();
 
-- 
1.5.6.3
