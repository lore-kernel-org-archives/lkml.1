Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164Ab0AENil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0AENil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539Ab0AENil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:38:41 -0500
Received: from www84.your-server.de ([213.133.104.84]:53289 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0AENik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:38:40 -0500
Subject: [tip:urgent] fix kfifo_out_locked race bug
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
References: <20100104174352.GA26606@localhost>
	 <1262632804.4814.17.camel@wall-e> <20100105004344.082bb69f@redhat.com>
	 <20100105110418.GA10442@localhost> <1262689759.21020.2.camel@wall-e>
	 <20100105111401.GB10442@localhost> <1262690734.22009.3.camel@wall-e>
	 <20100105113525.GA19371@localhost> <1262692881.23577.15.camel@wall-e>
In-Reply-To: <1262692881.23577.15.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jan 2010 14:38:35 +0100
Message-ID: <1262698715.4532.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a wrong optimization in include/linux/kfifo.h which could
cause a race in kfifo_out_locked.

Please apply it to the 2.6.33-rc* tree.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 kfifo.h |    7 -------
 1 file changed, 7 deletions(-)

--- linux-2.6.33-rc2.orig/include/linux/kfifo.h	2009-12-27
23:37:04.921185257 +0100
+++ kfifo.h	2010-01-05 14:32:31.414316321 +0100
@@ -228,13 +228,6 @@ static inline __must_check unsigned int 
 
 	ret = kfifo_out(fifo, to, n);
 
-	/*
-	 * optimization: if the FIFO is empty, set the indices to 0
-	 * so we don't wrap the next time
-	 */
-	if (kfifo_is_empty(fifo))
-		kfifo_reset(fifo);
-
 	spin_unlock_irqrestore(lock, flags);
 
 	return ret;


