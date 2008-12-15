Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYLOO5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYLOO5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYLOOzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:55:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:26559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbYLOOzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:55:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,224,1228118400"; 
   d="scan'208";a="370995506"
From: Patrick Ohly <patrick.ohly@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       John Stultz <johnstul@us.ibm.com>, linux-api@vger.kernel.org,
       Patrick Ohly <patrick.ohly@intel.com>
Subject: [RFC PATCH 07/12] net: pass new SIOCSHWTSTAMP through to device drivers
Date: Mon, 15 Dec 2008 15:54:54 +0100
Message-Id: <1229352899-31330-8-git-send-email-patrick.ohly@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229352899-31330-7-git-send-email-patrick.ohly@intel.com>
References: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-2-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-3-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-4-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-5-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-6-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-7-git-send-email-patrick.ohly@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Patrick Ohly <patrick.ohly@intel.com>
---
 fs/compat_ioctl.c |    1 +
 net/core/dev.c    |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5235c67..a5001a6 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2555,6 +2555,7 @@ HANDLE_IOCTL(SIOCSIFMAP, dev_ifsioc)
 HANDLE_IOCTL(SIOCGIFADDR, dev_ifsioc)
 HANDLE_IOCTL(SIOCSIFADDR, dev_ifsioc)
 HANDLE_IOCTL(SIOCSIFHWBROADCAST, dev_ifsioc)
+HANDLE_IOCTL(SIOCSHWTSTAMP, dev_ifsioc)
 
 /* ioctls used by appletalk ddp.c */
 HANDLE_IOCTL(SIOCATALKDIFADDR, dev_ifsioc)
diff --git a/net/core/dev.c b/net/core/dev.c
index 94d95a8..dc7b4fc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3675,6 +3675,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 			    cmd == SIOCSMIIREG ||
 			    cmd == SIOCBRADDIF ||
 			    cmd == SIOCBRDELIF ||
+			    cmd == SIOCSHWTSTAMP ||
 			    cmd == SIOCWANDEV) {
 				err = -EOPNOTSUPP;
 				if (ops->ndo_do_ioctl) {
@@ -3829,6 +3830,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 		case SIOCBONDCHANGEACTIVE:
 		case SIOCBRADDIF:
 		case SIOCBRDELIF:
+		case SIOCSHWTSTAMP:
 			if (!capable(CAP_NET_ADMIN))
 				return -EPERM;
 			/* fall through */
-- 
1.5.5.3

