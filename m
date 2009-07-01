Return-Path: <linux-kernel-owner+w=401wt.eu-S1764350AbZGAAye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764350AbZGAAye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbZGAAef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:35 -0400
Received: from kroah.org ([198.145.64.141]:60225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761409AbZGAAec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:21 2009
Message-Id: <20090701002421.050263995@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [patch 028/108] rocket: fix test_bit parameters
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=rocket-fix-test_bit-parameters.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit a391ad0f09014856bbc4eeea309593eba977b3b0 upstream.

Switch from ASYNC_* to ASYNCB_*, because {test,set}_bit expect
bit number, not mask.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/rocket.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -934,7 +934,7 @@ static int rp_open(struct tty_struct *tt
 	/*
 	 * Info->count is now 1; so it's safe to sleep now.
 	 */
-	if (!test_bit(ASYNC_INITIALIZED, &port->flags)) {
+	if (!test_bit(ASYNCB_INITIALIZED, &port->flags)) {
 		cp = &info->channel;
 		sSetRxTrigger(cp, TRIG_1);
 		if (sGetChanStatus(cp) & CD_ACT)
@@ -958,7 +958,7 @@ static int rp_open(struct tty_struct *tt
 		sEnRxFIFO(cp);
 		sEnTransmit(cp);
 
-		set_bit(ASYNC_INITIALIZED, &info->port.flags);
+		set_bit(ASYNCB_INITIALIZED, &info->port.flags);
 
 		/*
 		 * Set up the tty->alt_speed kludge
@@ -1641,7 +1641,7 @@ static int rp_write(struct tty_struct *t
 	/*  Write remaining data into the port's xmit_buf */
 	while (1) {
 		/* Hung up ? */
-		if (!test_bit(ASYNC_NORMAL_ACTIVE, &info->port.flags))
+		if (!test_bit(ASYNCB_NORMAL_ACTIVE, &info->port.flags))
 			goto end;
 		c = min(count, XMIT_BUF_SIZE - info->xmit_cnt - 1);
 		c = min(c, XMIT_BUF_SIZE - info->xmit_head);


