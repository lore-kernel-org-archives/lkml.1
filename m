Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbYLDRQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbYLDRQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYLDRQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:16:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:25267 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbYLDRQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wj6rgNat/D1qHkCu4RNJxgc0tiCjGEvZUWGh/yW4QzIslQa+PmZBoZhY3m/r1Y7Kyq
         ZLSEOVIdYCRre+XfdSCYlHn8cuPjqtZig4q0k0nHQY475N2z8uAMX/cWNiTV0CqrmpTg
         BOsKoXZn+evD9tHmBC2G3iGhGCqsoWCTzN2hs=
Date: Thu, 4 Dec 2008 20:16:17 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fix for tty-serial-move-port
Message-ID: <20081204171617.GA17913@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan

next-20081204 crashes with the following message:

BUG: unable to handle kernel paging request at ffff88007d320248
IP: [<ffffffff803de934>] uart_remove_one_port+0xef/0x111
                kfree(info);
     393:       49 8d 7d 10             lea    0x10(%r13),%rdi
     397:       e8 00 00 00 00          callq  39c <uart_remove_one_port+0xef>

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/serial/serial_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index e99a269..4fc25e4 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2530,10 +2530,8 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
 	/*
 	 * Kill the tasklet, and free resources.
 	 */
-	if (info) {
+	if (info)
 		tasklet_kill(&info->tlet);
-		kfree(info);
-	}
 
 	state->port = NULL;
 	mutex_unlock(&port_mutex);
