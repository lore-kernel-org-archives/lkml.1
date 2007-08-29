Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbXH2VvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbXH2VvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbXH2Vu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:50:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43403 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbXH2Vu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:50:57 -0400
Date: Wed, 29 Aug 2007 14:50:55 -0700
From: sukadev@us.ibm.com
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] Use task_pid_nr() in ip_vs_sync.c
Message-ID: <20070829215055.GD18542@us.ibm.com>
References: <46D57508.9040401@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D57508.9040401@openvz.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov [xemul@openvz.org] wrote:
| The sync_master_pid and sync_backup_pid are set in set_sync_pid()
| and are used later for set/not-set checks and in printk. So it
| is safe to use the global pid value in this case.
| 
| Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
| 
| ---
| 
| diff --git a/net/ipv4/ipvs/ip_vs_sync.c b/net/ipv4/ipvs/ip_vs_sync.c
| index 959c08d..d0798a5 100644
| --- a/net/ipv4/ipvs/ip_vs_sync.c
| +++ b/net/ipv4/ipvs/ip_vs_sync.c
| @@ -794,7 +794,7 @@ static int sync_thread(void *startup)
| 
| 	add_wait_queue(&sync_wait, &wait);
| 
| -	set_sync_pid(state, current->pid);
| +	set_sync_pid(state, task_pid_nr(current));
| 	complete(tinfo->startup);
| 
| 	/*
