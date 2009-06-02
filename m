Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZFBHMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZFBHMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbZFBHLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:45 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46603 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbZFBHLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 02/11] Blackfin SPORT UART: fix data misses while using transmit frame sync
Date: Tue,  2 Jun 2009 03:11:31 -0400
Message-Id: <1243926700-30485-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

SPORT transmit frame sync (TFS) isn't used as an electrical signal during
normal SPORT UART emulation.  However, it is useful in EIA RS-485
emulation as RS-485 Transceiver Driver Enable DE strobe.

This patch configures:
TFS to be active high in order to drive an DE strobe of
an eventually connected RS-485 Transceiver.

Late frame sync mode (LATFS) gating the entire TX shift cycle.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_sport_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index fd5cb95..6687ccd 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -149,7 +149,7 @@ static int sport_uart_setup(struct sport_uart_port *up, int sclk, int baud_rate)
 	int tclkdiv, tfsdiv, rclkdiv;
 
 	/* Set TCR1 and TCR2 */
-	SPORT_PUT_TCR1(up, (LTFS | ITFS | TFSR | TLSBIT | ITCLK));
+	SPORT_PUT_TCR1(up, (LATFS | ITFS | TFSR | TLSBIT | ITCLK));
 	SPORT_PUT_TCR2(up, 10);
 	pr_debug("%s TCR1:%x, TCR2:%x\n", __func__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
 
-- 
1.6.3.1

