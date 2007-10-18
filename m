Return-Path: <linux-kernel-owner+w=401wt.eu-S1764984AbXJRWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764984AbXJRWG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbXJRWGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:06:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbXJRWGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:06:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH -mm] Freezer: Do not allow freezing processes to clear TIF_SIGPENDING
Date: Fri, 19 Oct 2007 00:22:35 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710190022.36145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Do not allow processes to clear their TIF_SIGPENDING if TIF_FREEZE is set,
to prevent them from racing with the freezer (like mysqld does, for example).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/kernel/signal.c
===================================================================
--- linux-2.6.23-mm1.orig/kernel/signal.c
+++ linux-2.6.23-mm1/kernel/signal.c
@@ -124,7 +124,7 @@ void recalc_sigpending_and_wake(struct t
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current))
+	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
