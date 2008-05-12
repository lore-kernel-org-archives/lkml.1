Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYELSmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYELSmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 14:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYELSms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 14:42:48 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:24718 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756148AbYELSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 14:42:44 -0400
Subject: [PATCH] riscom8: remove redundant null pointer test
From: Chris Malley <mail@chrismalley.co.uk>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 May 2008 19:27:10 +0100
Message-Id: <1210616830.7454.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty has already been dereferenced at least twice in these functions,
so checking for null here seems a bit unnecessary.

Signed-off-by: Chris Malley <mail@chrismalley.co.uk>
---
 drivers/char/riscom8.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index f073c71..9643a49 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1108,7 +1108,7 @@ static int rc_write(struct tty_struct *tty,
 
 	bp = port_Board(port);
 
-	if (!tty || !port->xmit_buf)
+	if (!port->xmit_buf)
 		return 0;
 
 	while (1) {
@@ -1151,7 +1151,7 @@ static int rc_put_char(struct tty_struct *tty, unsigned char ch)
 	if (rc_paranoia_check(port, tty->name, "rc_put_char"))
 		return 0;
 
-	if (!tty || !port->xmit_buf)
+	if (!port->xmit_buf)
 		return 0;
 
 	spin_lock_irqsave(&riscom_lock, flags);
-- 



