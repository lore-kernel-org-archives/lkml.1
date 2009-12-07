Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbZLGJDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbZLGJDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbZLGJDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:03:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55522 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902AbZLGJDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:03:13 -0500
Date: Mon, 7 Dec 2009 20:03:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
       Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: net/kbuild trees build failure
Message-Id: <20091207200317.57820f0a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next build (powerpc allyesconfig) failed like this:

In file included from drivers/net/wireless/iwlwifi/iwl3945-base.c:57:
drivers/net/wireless/iwlwifi/iwl-core.h:66:30: error: linux/utsrelease.h: No such file or directory

Caused by commit 250cce26d5d03337aec4ff8405121f026adb4a89 ("iwlwifi:
driver version track kernel version") from the net tree interacting with
commit 8e5c76aace9705b6983cfbf5eb2f2e869dab6738 ("kbuild: move
utsrelease.h to include/generated") from the kbuild tree.

I applied this patch for today (and will carry it as necessary):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Dec 2009 19:56:42 +1100
Subject: [PATCH] net: fix for utsrelease.h moving to generated

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 675b7df..27ca859 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -63,7 +63,7 @@
 #ifndef __iwl_core_h__
 #define __iwl_core_h__
 
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 
 /************************
  * forward declarations *
-- 
1.6.5.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
