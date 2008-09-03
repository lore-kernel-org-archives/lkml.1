Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYICVrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYICVrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYICVrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:47:16 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:55856 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYICVrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SHR2BDmTrtz1S35p+VeDhY97pR6nbjjPWwzN6/QuhDCvkJgyfidRoTXWX7RVv1wM28
         7+LnLAJJt5l3wd2ZCSBUzYE5BLfcXChnvHEBgltjd35vfL15exIHiGj/5PJJH5kHxdyq
         w8yZtAWooagXlw3eZx1uzZ3MwogljHvN38zzQ=
Date: Wed, 3 Sep 2008 23:46:47 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: slab error in verify_redzone_free (2.6.27-rc5)
Message-ID: <20080903214642.GA9938@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sep  1 20:22:07 [kernel] [ 8541.403598] slab error in verify_redzone_free(): cache `ext3_inode_cache': memory outside object was overwritten
Sep  1 20:22:07 [kernel] [ 8541.403613] Pid: 206, comm: kswapd0 Not tainted 2.6.27-rc5 #362
Sep  1 20:22:07 [kernel] [ 8541.403620]
Sep  1 20:22:07 [kernel] [ 8541.403621] Call Trace:
Sep  1 20:22:07 [kernel] [ 8541.403635]  [<ffffffff8028c034>] __slab_error+0x26/0x28
Sep  1 20:22:07 [kernel] [ 8541.403640]  [<ffffffff8028c84d>] cache_free_debugcheck+0x13a/0x1fc
Sep  1 20:22:07 [kernel] [ 8541.403646]  [<ffffffff802e966d>] ? ext3_destroy_inode+0x80/0x87
Sep  1 20:22:07 [kernel] [ 8541.403649]  [<ffffffff8028cb53>] kmem_cache_free+0x4e/0xad
Sep  1 20:22:07 [kernel] [ 8541.403653]  [<ffffffff802e966d>] ext3_destroy_inode+0x80/0x87
Sep  1 20:22:07 [kernel] [ 8541.403657]  [<ffffffff802a45e5>] destroy_inode+0x37/0x4c
Sep  1 20:22:07 [kernel] [ 8541.403661]  [<ffffffff802a4fdc>] dispose_list+0xcf/0x103
Sep  1 20:22:07 [kernel] [ 8541.403664]  [<ffffffff802a51e6>] shrink_icache_memory+0x1d6/0x208
Sep  1 20:22:07 [kernel] [ 8541.403669]  [<ffffffff802747ba>] shrink_slab+0xeb/0x181
Sep  1 20:22:07 [kernel] [ 8541.403673]  [<ffffffff80274f60>] kswapd+0x317/0x4b4
Sep  1 20:22:07 [kernel] [ 8541.403677]  [<ffffffff80273610>] ? isolate_pages_global+0x0/0x39
Sep  1 20:22:07 [kernel] [ 8541.403684]  [<ffffffff80241394>] ? autoremove_wake_function+0x0/0x3d
Sep  1 20:22:07 [kernel] [ 8541.403688]  [<ffffffff80274c49>] ? kswapd+0x0/0x4b4
Sep  1 20:22:07 [kernel] [ 8541.403692]  [<ffffffff8024127f>] kthread+0x4e/0x7b
Sep  1 20:22:07 [kernel] [ 8541.403696]  [<ffffffff8020c039>] child_rip+0xa/0x11
Sep  1 20:22:07 [kernel] [ 8541.403701]  [<ffffffff80228a10>] ? finish_task_switch+0x5f/0xa5
Sep  1 20:22:07 [kernel] [ 8541.403705]  [<ffffffff802289b1>] ? finish_task_switch+0x0/0xa5
Sep  1 20:22:07 [kernel] [ 8541.403708]  [<ffffffff8020bb83>] ? restore_args+0x0/0x30
Sep  1 20:22:07 [kernel] [ 8541.403713]  [<ffffffff80241231>] ? kthread+0x0/0x7b
Sep  1 20:22:07 [kernel] [ 8541.403716]  [<ffffffff8020c02f>] ? child_rip+0x0/0x11
Sep  1 20:22:07 [kernel] [ 8541.403718]
Sep  1 20:22:07 [kernel] [ 8541.403721] ffff88000000f9d8: redzone 1:0xd84156c5635688c0, redzone 2:0x43220000ff3e0001.

Full log and .config is here: http://www.kadu.net/~joi/kernel/2008.09.03/
I don't remember what I was doing while this happened - I noticed this error today...

Marcin
