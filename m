Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbXKNOvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbXKNOvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbXKNOvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:51:31 -0500
Received: from v32413.1blu.de ([88.84.155.73]:47829 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbXKNOva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:51:30 -0500
From: Frank Lichtenheld <frank@lichtenheld.de>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org, Frank Lichtenheld <frank@lichtenheld.de>
Subject: [PATCH] [ISDN] sc: Fix sndpkt to have the correct number of arguments
Date: Wed, 14 Nov 2007 15:46:21 +0100
Message-Id: <1195051581-15842-2-git-send-email-frank@lichtenheld.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195051581-15842-1-git-send-email-frank@lichtenheld.de>
References: <1195051581-15842-1-git-send-email-frank@lichtenheld.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

isdn_if.writebuf_skb has an additional ack flag argument which
was missing from sndpkt leading to the following warning:
  CC [M]  drivers/isdn/sc/init.o
drivers/isdn/sc/init.c: In function ‘sc_init’:
drivers/isdn/sc/init.c:281: warning: assignment from incompatible pointer type

Note that this doesn't actually do anything with the flag, it
just fixes the warning (and probably accessing the last argument).

Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 drivers/isdn/sc/card.h   |    2 +-
 drivers/isdn/sc/packet.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/sc/card.h b/drivers/isdn/sc/card.h
index 5992f63..0120bcf 100644
--- a/drivers/isdn/sc/card.h
+++ b/drivers/isdn/sc/card.h
@@ -109,7 +109,7 @@ void memcpy_fromshmem(int card, void *dest, const void *src, size_t n);
 int get_card_from_id(int driver);
 int indicate_status(int card, int event, ulong Channel, char *Data);
 irqreturn_t interrupt_handler(int interrupt, void *cardptr);
-int sndpkt(int devId, int channel, struct sk_buff *data);
+int sndpkt(int devId, int channel, int ack, struct sk_buff *data);
 void rcvpkt(int card, RspMessage *rcvmsg);
 int command(isdn_ctrl *cmd);
 int reset(int card);
diff --git a/drivers/isdn/sc/packet.c b/drivers/isdn/sc/packet.c
index 92016a2..5ff6ae8 100644
--- a/drivers/isdn/sc/packet.c
+++ b/drivers/isdn/sc/packet.c
@@ -20,7 +20,7 @@
 #include "message.h"
 #include "card.h"
 
-int sndpkt(int devId, int channel, struct sk_buff *data)
+int sndpkt(int devId, int channel, int ack, struct sk_buff *data)
 {
 	LLData	ReqLnkWrite;
 	int status;
-- 
1.5.3.4

