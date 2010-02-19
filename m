Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0BSWxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 17:53:45 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:55038 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0BSWxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 17:53:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 1/1] PM / Hibernate: remove swsusp.c
Date: Fri, 19 Feb 2010 23:53:37 +0100
Message-Id: <1266620017-11061-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its contents and entry in Makefile were already removed in
8e60c6a1348e17e68ad73589a52a03876e7059be
(Shift remaining code from swsusp.c to hibernate.c)
but somehow it remained in-place.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/swsusp.c |   58 -------------------------------------------------
 1 files changed, 0 insertions(+), 58 deletions(-)
 delete mode 100644 kernel/power/swsusp.c

diff --git a/kernel/power/swsusp.c b/kernel/power/swsusp.c
deleted file mode 100644
index 5b3601b..0000000
--- a/kernel/power/swsusp.c
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * linux/kernel/power/swsusp.c
- *
- * This file provides code to write suspend image to swap and read it back.
- *
- * Copyright (C) 1998-2001 Gabor Kuti <seasons@fornax.hu>
- * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
- *
- * This file is released under the GPLv2.
- *
- * I'd like to thank the following people for their work:
- *
- * Pavel Machek <pavel@ucw.cz>:
- * Modifications, defectiveness pointing, being with me at the very beginning,
- * suspend to swap space, stop all tasks. Port to 2.4.18-ac and 2.5.17.
- *
- * Steve Doddi <dirk@loth.demon.co.uk>:
- * Support the possibility of hardware state restoring.
- *
- * Raph <grey.havens@earthling.net>:
- * Support for preserving states of network devices and virtual console
- * (including X and svgatextmode)
- *
- * Kurt Garloff <garloff@suse.de>:
- * Straightened the critical function in order to prevent compilers from
- * playing tricks with local variables.
- *
- * Andreas Mohr <a.mohr@mailto.de>
- *
- * Alex Badea <vampire@go.ro>:
- * Fixed runaway init
- *
- * Rafael J. Wysocki <rjw@sisk.pl>
- * Reworked the freeing of memory and the handling of swap
- *
- * More state savers are welcome. Especially for the scsi layer...
- *
- * For TODOs,FIXMEs also look in Documentation/power/swsusp.txt
- */
-
-#include <linux/mm.h>
-#include <linux/suspend.h>
-#include <linux/spinlock.h>
-#include <linux/kernel.h>
-#include <linux/major.h>
-#include <linux/swap.h>
-#include <linux/pm.h>
-#include <linux/swapops.h>
-#include <linux/bootmem.h>
-#include <linux/syscalls.h>
-#include <linux/highmem.h>
-#include <linux/time.h>
-#include <linux/rbtree.h>
-#include <linux/io.h>
-
-#include "power.h"
-
-int in_suspend __nosavedata = 0;
-- 
1.7.0

