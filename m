Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYBTWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYBTWOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761457AbYBTWN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:13:59 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:3684 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761284AbYBTWN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GOsCxkTM5eimN+NopQhBTxbxWzT/ywfns+KV4jQUleHMVleu+DeebJQA0tg+nw3Jrt+G4X/FF5ViQg/6v2WS+wHQhb0TVT9cyod1H/vFREmbaIwtsrFZ188qa4Na7KOuaF4JLo2FqrqXbL89MSMjfYqCer8NG/frnBnCykOd/+8=
Subject: [PATCH 2/2] moxa: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 14:14:05 -0800
Message-Id: <1203545650.25307.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/moxa.c:873:26: warning: Using plain integer as NULL pointer
drivers/char/moxa.c:2037:49: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/moxa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 75c957f..d7e4aa7 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -870,7 +870,7 @@ static void moxa_poll(unsigned long ignored)
 			if (!(ch->statusflags & THROTTLE) &&
 			    (MoxaPortRxQueue(ch->port) > 0))
 				moxa_receive_data(ch);
-			if ((tp = ch->tty) == 0)
+			if ((tp = ch->tty) == NULL)
 				continue;
 			if (ch->statusflags & LOWWAIT) {
 				if (MoxaPortTxQueue(ch->port) <= WAKEUP_CHARS) {
@@ -2034,7 +2034,7 @@ static int MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud)
 	tcflag_t cflag;
 	tcflag_t mode = 0;
 
-	if (moxa_ports[port].chkPort == 0 || termio == 0)
+	if (moxa_ports[port].chkPort == 0 || termio == NULL)
 		return (-1);
 	ofsAddr = moxa_ports[port].tableAddr;
 	cflag = termio->c_cflag;	/* termio->c_cflag */
-- 
1.5.4.2.200.g99e75

