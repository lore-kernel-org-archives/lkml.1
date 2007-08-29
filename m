Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbXH2Nf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbXH2Nf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbXH2NfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:35:15 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:45292 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbXH2NfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:35:14 -0400
Message-ID: <46D57508.9040401@openvz.org>
Date: Wed, 29 Aug 2007 17:30:48 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: [PATCH] Use task_pid_nr() in ip_vs_sync.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sync_master_pid and sync_backup_pid are set in set_sync_pid()
and are used later for set/not-set checks and in printk. So it
is safe to use the global pid value in this case.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/net/ipv4/ipvs/ip_vs_sync.c b/net/ipv4/ipvs/ip_vs_sync.c
index 959c08d..d0798a5 100644
--- a/net/ipv4/ipvs/ip_vs_sync.c
+++ b/net/ipv4/ipvs/ip_vs_sync.c
@@ -794,7 +794,7 @@ static int sync_thread(void *startup)
 
 	add_wait_queue(&sync_wait, &wait);
 
-	set_sync_pid(state, current->pid);
+	set_sync_pid(state, task_pid_nr(current));
 	complete(tinfo->startup);
 
 	/*
