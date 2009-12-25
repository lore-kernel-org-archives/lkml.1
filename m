Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZLYCkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZLYCkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 21:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZLYCkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 21:40:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZLYCkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 21:40:46 -0500
Date: Thu, 24 Dec 2009 21:40:32 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Message-Id: <20091225024340.4431.59297.sendpatchset@localhost.localdomain>
Subject: [Patch] console: limit the range of VGACON_SOFT_SCROLLBACK_SIZE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BuraphaLinux reported that we will trigger a mm warning when
we CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=65536, this is because
mm cann't allocate so many pages. We should limit the range
of CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, don't give a user
any chance to trigger that.

Reported-by: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>

---
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index fc7d9bb..8e8f18d 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -37,6 +37,7 @@ config VGACON_SOFT_SCROLLBACK
 config VGACON_SOFT_SCROLLBACK_SIZE
        int "Scrollback Buffer Size (in KB)"
        depends on VGACON_SOFT_SCROLLBACK
+       range 1 1024
        default "64"
        help
          Enter the amount of System RAM to allocate for the scrollback
