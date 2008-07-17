Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbYGQJfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbYGQJfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYGQJey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:34:54 -0400
Received: from mail.atmel.fr ([81.80.104.162]:43580 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbYGQJex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:34:53 -0400
Message-ID: <487F123A.4050502@atmel.com>
Date: Thu, 17 Jul 2008 11:34:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] at91_mci: Do a reset after each request
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjala <syrjala@sci.fi>

Reset the controller after each transfer since we're violating the
spec sometimes. This is very cheap, so we don't try to be clever.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Comment stolen from atmel_mci log.

We noticed that AT91SAM9260 board + Marvell 8686 SDIO WLAN adater
are not happy without applying the MCI reset trick.

drivers/mmc/host/at91_mci.c |    5 ++---
1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index f3d725e..4e3edf3 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -670,11 +670,10 @@ static void at91_mci_process_next(struct 
at91mci_host *host)
		at91_mci_send_command(host, host->request->stop);
	} else {
		del_timer(&host->timer);
-		/* the at91rm9200 mci controller hangs after some transfers,
+		/* the mci controller hangs after some transfers,
		 * and the workaround is to reset it after each transfer.
		 */
-		if (cpu_is_at91rm9200())
-			at91_reset_host(host);
+		at91_reset_host(host);
		mmc_request_done(host->mmc, host->request);
	}
}
-- 
1.5.3.7





