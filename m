Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbXE1IlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbXE1IlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759798AbXE1Igu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:50 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:4651 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862AbXE1Igh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:37 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069469:sNHT19845784"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 15/20] Blackfin serial driver: hook up our UARTs STP bit with userspaces CMSPAR
Date: Mon, 28 May 2007 16:37:50 +0800
Message-Id: <11803414801291-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

so we can now do spaced/marked parity

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 787dc71..aeb3cc2 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -629,6 +629,8 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 		lcr |= PEN;
 		if (!(termios->c_cflag & PARODD))
 			lcr |= EPS;
+		if (termios->c_cflag & CMSPAR)
+			lcr |= STP;
 	}
 
 	port->read_status_mask = OE;
-- 
1.5.2
