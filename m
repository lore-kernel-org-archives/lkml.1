Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXKZOZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXKZOZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbXKZOZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:25:30 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:52207 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbXKZOZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:25:29 -0500
Date: Mon, 26 Nov 2007 17:25:56 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH? 3/3] move daemonized kernel threads into the swapper's session
Message-ID: <20071126142556.GA16531@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any reason why daemonized kthread still uses 1,1 special pids? This patch
sets 0,0 pids, this matches kthread_create'ed threads.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~3_daemonize_swapper	2007-11-26 16:47:35.000000000 +0300
+++ PT/kernel/exit.c	2007-11-26 17:10:41.000000000 +0300
@@ -390,7 +390,7 @@ void daemonize(const char *name, ...)
 		get_nsproxy(&init_nsproxy);
 		switch_task_namespaces(current, &init_nsproxy);
 	}
-	set_special_pids(find_pid(1));
+	set_special_pids(&init_struct_pid);
 	proc_clear_tty(current);
 
 	/* Block and flush all signals */

