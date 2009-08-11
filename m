Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZHKM52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZHKM52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZHKM52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:57:28 -0400
Received: from server1.wserver.cz ([82.113.45.157]:47144 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZHKM51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:57:27 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 1/1] Power: fix suspend vt regression
Date: Tue, 11 Aug 2009 10:41:33 +0200
Message-Id: <1249980093-16319-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vt_waitactive no longer accepts console parameter as console-1
since commit "vt: add an event interface". It expects console
number directly (as viewed by userspace -- counting from 1).

Fix a deadlock suspend regression by redefining SUSPEND_CONSOLE
to be MAX_NR_CONSOLES, not MAX_NR_CONSOLES-1.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/console.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/console.c b/kernel/power/console.c
index 5187136..6592a57 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -11,7 +11,7 @@
 #include "power.h"
 
 #if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
-#define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
+#define SUSPEND_CONSOLE	MAX_NR_CONSOLES
 
 static int orig_fgconsole, orig_kmsg;
 
-- 
1.6.3.3

