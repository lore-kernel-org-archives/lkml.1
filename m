Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbZFINrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbZFINrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFINqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:55 -0400
Received: from mx1.emlix.com ([193.175.82.87]:33268 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZFINqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:53 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Fabian Godehardt <fg@emlix.com>,
       Oskar Schirmer <os@emlix.com>
Subject: [PATCH 3/8] imx: serial: notify higher layers in case xmit IRQ was not called
Date: Tue,  9 Jun 2009 15:46:46 +0200
Message-Id: <1244555211-15618-4-git-send-email-os@emlix.com>
In-Reply-To: <1244555211-15618-3-git-send-email-os@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
 <1244555211-15618-2-git-send-email-os@emlix.com>
 <1244555211-15618-3-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Godehardt <fg@emlix.com>

upper layers, namely line discipline, need to be notified
when transmission of more data is possible. For spurious
cases, where IRQ handling does not supply notification
for sure, it is given additionally here, when data has just
been transmitted and space in the buffer will most probably
be available.

Signed-off-by: Fabian Godehardt <fg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/serial/imx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 5ee325f..afcec9e 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -308,6 +308,9 @@ static inline void imx_transmit_buffer(struct imx_port *sport)
 			break;
 	}
 
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&sport->port);
+
 	if (uart_circ_empty(xmit))
 		imx_stop_tx(&sport->port);
 }
-- 
1.5.3.7

