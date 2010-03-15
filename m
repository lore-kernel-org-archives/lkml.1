Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab0CODRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:17:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64172 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759600Ab0CODRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:17:14 -0400
Message-ID: <4B9DA6F5.3070606@cn.fujitsu.com>
Date: Mon, 15 Mar 2010 11:18:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: [PATCH] block: make CONFIG_BLK_CGROUP visible
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the config visible, so we can choose from CONFIG_BLK_CGROUP=y
and CONFIG_BLK_CGROUP=m when CONFIG_IOSCHED_CFQ=m.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 62a5921..906950c 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -78,8 +78,9 @@ config BLK_DEV_INTEGRITY
 	Protection.  If in doubt, say N.
 
 config BLK_CGROUP
-	tristate
+	tristate "Block cgroup support"
 	depends on CGROUPS
+	depends on CFQ_GROUP_IOSCHED
 	default n
 	---help---
 	Generic block IO controller cgroup interface. This is the common
@@ -91,7 +92,7 @@ config BLK_CGROUP
 	to such task groups.
 
 config DEBUG_BLK_CGROUP
-	bool
+	bool "Block cgroup debugging help"
 	depends on BLK_CGROUP
 	default n
 	---help---
-- 
1.6.3

