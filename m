Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbXFNRWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbXFNRWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbXFNRWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:22:38 -0400
Received: from mail.screens.ru ([213.234.233.54]:55339 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXFNRWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:22:37 -0400
Date: Thu, 14 Jun 2007 21:23:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Osterlund <petero2@telia.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kcdrwd: remove unneeded flush_signals() call
Message-ID: <20070614172304.GA2453@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kcdrwd() is a kernel thread, all signals are ignored.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- sig/drivers/block/pktcdvd.c~2_pktcdvd	2007-05-21 13:42:39.000000000 +0400
+++ sig/drivers/block/pktcdvd.c	2007-06-14 20:21:35.000000000 +0400
@@ -1653,9 +1653,6 @@ static int kcdrwd(void *foobar)
 				}
 			}
 
-			if (signal_pending(current)) {
-				flush_signals(current);
-			}
 			if (kthread_should_stop())
 				break;
 		}

