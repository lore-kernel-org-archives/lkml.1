Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0BENxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:53:14 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:54230 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab0BENxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:53:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sRm/b4OUBt99Km2puJddehtaPglX6lztGCjg1D4OXSv3s0qj/gfyVJONEH5xgAIOy1
         J0PyjvfwLQ1Hkr8sDJxBqXMMicPvnreyCusxKGXX5OhUisHhEevjkY/p6M7u+kJxEZZ1
         2TjBwP0j8sqb95RHrU6SJ1QArJqCQ6qLKFnSI=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org
Subject: [PATCH 4/4] Staging: rt2860: correct onstack wait_queue_head declaration
Date: Fri,  5 Feb 2010 21:52:40 +0800
Message-Id: <f4b1988ebb2399d7410268529199f131e1edad9d.1265375697.git.yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <bc78da996dc04da174f51d2dbe1df4b084a07a3f.1265375697.git.yong.zhang0@gmail.com>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
 <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
 <b47c0527f1471857fec4662da1bfd0bb9e6071a7.1265375697.git.yong.zhang0@gmail.com>
 <bc78da996dc04da174f51d2dbe1df4b084a07a3f.1265375697.git.yong.zhang0@gmail.com>
In-Reply-To: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
References: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/rt2860/rt_main_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index c3d9280..fbddb00 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -216,7 +216,7 @@ int rt28xx_close(struct net_device *dev)
 	u32 i = 0;
 
 #ifdef RTMP_MAC_USB
-	DECLARE_WAIT_QUEUE_HEAD(unlink_wakeup);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
 	DECLARE_WAITQUEUE(wait, current);
 #endif /* RTMP_MAC_USB // */
 
-- 
1.6.3.3

