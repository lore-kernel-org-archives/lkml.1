Return-Path: <linux-kernel-owner+w=401wt.eu-S1764294AbZAUKNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764294AbZAUKNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbZAUKKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:10:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:48383 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029AbZAUKKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:10:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,299,1231142400"; 
   d="scan'208";a="380250418"
From: Patrick Ohly <patrick.ohly@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       linux-api@vger.kernel.org, Patrick Ohly <patrick.ohly@intel.com>
Subject: [PATCH NET-NEXT 07/12] net: pass new SIOCSHWTSTAMP through to device drivers
Date: Wed, 21 Jan 2009 11:10:07 +0100
Message-Id: <1232532612-10382-7-git-send-email-patrick.ohly@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1232532612-10382-6-git-send-email-patrick.ohly@intel.com>
References: <1232532457.7829.19.camel@ecld0pohly>
 <1232532612-10382-1-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-2-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-3-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-4-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-5-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-6-git-send-email-patrick.ohly@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 93b2ac9..370c9f1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3864,6 +3864,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 			    cmd == SIOCSMIIREG ||
 			    cmd == SIOCBRADDIF ||
 			    cmd == SIOCBRDELIF ||
+			    cmd == SIOCSHWTSTAMP ||
 			    cmd == SIOCWANDEV) {
 				err = -EOPNOTSUPP;
 				if (ops->ndo_do_ioctl) {
@@ -4018,6 +4019,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 		case SIOCBONDCHANGEACTIVE:
 		case SIOCBRADDIF:
 		case SIOCBRDELIF:
+		case SIOCSHWTSTAMP:
 			if (!capable(CAP_NET_ADMIN))
 				return -EPERM;
 			/* fall through */
-- 
1.5.5.3

