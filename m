Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbXCFJGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbXCFJGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXCFJGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:06:45 -0500
Received: from smtp.ono.com ([62.42.230.12]:57971 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933122AbXCFJGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:06:37 -0500
Date: Tue, 6 Mar 2007 10:06:23 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-ID: <20070306100623.770b9dc9@werewolf-wl>
In-Reply-To: <20070306004408.d3f6434d.akpm@linux-foundation.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.0cvs15 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 00:44:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> 

Does this include a fix for the NFS problem ?

BTW, I have in my kernel a patch like this below, isn't it needed ?
Original thread:

http://marc.theaimsgroup.com/?l=linux-kernel&m=117189051227292&w=2

--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2919,14 +2919,14 @@ static int __make_request(request_queue_
 	 */
 	blk_queue_bounce(q, &bio);
 
+	spin_lock_irq(q->queue_lock);
 	/*
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
 	if (!check_plug_merge(q, ioc, bio))
-		goto out;
+		goto out_unlock;
 
-	spin_lock_irq(q->queue_lock);
 	el_ret = elv_merge(q, &req, bio);
 	if (el_ret == ELEVATOR_BACK_MERGE) {
 		if (bio_attempt_back_merge(q, req, bio)) {
@@ -2984,7 +2984,6 @@ out_unlock:
 		list_add_tail(&req->queuelist, &ioc->plugged_list);
 	}
 
-out:
 	return 0;
 
 end_io_eopnotsupp:

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam01 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
