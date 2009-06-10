Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZFJMJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZFJMJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZFJMIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:38 -0400
Received: from mx1.emlix.com ([193.175.82.87]:46815 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZFJMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:37 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oskar Schirmer <os@emlix.com>,
       Fabian Godehardt <fg@emlix.com>
Subject: [PATCH 3/9 -v2] imx: serial: notify higher layers in case xmit IRQ was not called
Date: Wed, 10 Jun 2009 14:08:30 +0200
Message-Id: <1244635716-23315-4-git-send-email-os@emlix.com>
In-Reply-To: <1244635716-23315-1-git-send-email-os@emlix.com>
References: <1244635716-23315-1-git-send-email-os@emlix.com>
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

