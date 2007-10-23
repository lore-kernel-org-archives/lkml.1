Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXJWWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXJWWbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXJWWbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:31:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbXJWWbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:31:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Freezer: Do not allow freezing processes to clear TIF_SIGPENDING
Date: Wed, 24 Oct 2007 00:47:09 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710240047.09878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Please consider as 2.6.24 material.]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

Do not allow processes to clear their TIF_SIGPENDING if TIF_FREEZE is set,
so that they will not race with the freezer (like mysqld does, for example).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@suspend2.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/kernel/signal.c
===================================================================
--- linux-2.6.23.orig/kernel/signal.c
+++ linux-2.6.23/kernel/signal.c
@@ -124,7 +124,7 @@ void recalc_sigpending_and_wake(struct t
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current))
+	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
