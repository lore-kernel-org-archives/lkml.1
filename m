Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZISVoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZISVoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZISVoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:09 -0400
Received: from kroah.org ([198.145.64.141]:40555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZISVoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 66/79] tty: riscom8, fix tty refcnt
Date: Sat, 19 Sep 2009 14:37:11 -0700
Message-Id: <1253396244-7885-66-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a tty refcnt leak on one fail path in rc_transmit.
Fix that by jumping to the 'out' label.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/riscom8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 3c7cf2c..3cfa22d 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -467,7 +467,7 @@ static void rc_transmit(struct riscom_board const *bp)
 			rc_out(bp, CD180_CCR, CCR_CORCHG2);
 			port->break_length = 0;
 		}
-		return;
+		goto out;
 	}
 
 	count = CD180_NFIFO;
-- 
1.6.4.2

