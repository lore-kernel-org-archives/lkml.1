Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbXCUSZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbXCUSZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbXCUSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:25:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53275 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbXCUSZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:25:07 -0400
Date: Wed, 21 Mar 2007 11:22:31 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       Oleg Nesterov <oleg@tv-sign.ru>, serue@us.ibm.com, haveblue@us.ibm.com,
       clg@fr.ibm.com
Subject: [PATCH] Don't init pgrp and __session in INIT_SIGNALS
Message-ID: <20070321182231.GA28645@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH] Don't init pgrp and __session in INIT_SIGNALS

Remove initialization of pgrp and __session in INIT_SIGNALS,
as these are later set by the call to __set_special_pids()
in init/main.c by the patch:

	explicitly-set-pgid-and-sid-of-init-process.patch

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

---
 include/linux/init_task.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: lx26-21-rc3-mm2/include/linux/init_task.h
===================================================================
--- lx26-21-rc3-mm2.orig/include/linux/init_task.h	2007-03-20 17:54:18.000000000 -0700
+++ lx26-21-rc3-mm2/include/linux/init_task.h	2007-03-20 18:32:03.000000000 -0700
@@ -65,9 +65,9 @@
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
-	.pgrp		= 1,						\
+	.pgrp		= 0,						\
 	.tty_old_pgrp   = NULL,						\
-	{ .__session      = 1},						\
+	{ .__session      = 0},						\
 }
 
 extern struct nsproxy init_nsproxy;
