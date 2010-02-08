Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0BHUQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:16:42 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:53945 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0BHUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:13:14 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 31/41] CAPI: Drop handle_minor_recv from capinc_tty_write
Date: Mon,  8 Feb 2010 21:12:35 +0100
Message-Id: <b261bd6997f28ec6391c04bc0ec6fef668a92e63.1265659936.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1+UEWkmewE18RmcZAe0GxnWCiRcv4sQ6OEZ9KlF
	x1jd9t/8ri6zhxxqCSzgTCzwAGGA1WgZZJRAH1qb6YWSSbgOXB
	9NssXyKlI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending a message down the CAPI stack may trigger the reception of an
answer, but this will go through capi_recv_message and call
handle_minor_recv from there. There is no need to walk the receive queue
on capinc_tty_write.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 867589a..554fa1b 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1104,7 +1104,6 @@ static int capinc_tty_write(struct tty_struct *tty,
 	skb_queue_tail(&mp->outqueue, skb);
 	mp->outbytes += skb->len;
 	(void)handle_minor_send(mp);
-	(void)handle_minor_recv(mp);
 	spin_unlock_irqrestore(&workaround_lock, flags);
 	return count;
 }
-- 
1.6.0.2

