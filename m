Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbYBFX6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbYBFX6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764149AbYBFXya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:59942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764131AbYBFXy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:27 -0500
Date: Wed, 6 Feb 2008 15:51:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stable.org,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/73] VLAN: Lost rtnl_unlock() in vlan_ioctl()
Message-ID: <20080206235115.GK13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vlan-lost-rtnl_unlock-in-vlan_ioctl.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Pavel Emelyanov <xemul@openvz.org>

[VLAN]: Lost rtnl_unlock() in vlan_ioctl()

[ Upstream commit: e35de02615f97b785dc6f73cba421cea06bcbd10 ]

The SET_VLAN_NAME_TYPE_CMD command w/o CAP_NET_ADMIN capability
doesn't release the rtnl lock.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/8021q/vlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -768,7 +768,7 @@ static int vlan_ioctl_handler(void __use
 	case SET_VLAN_NAME_TYPE_CMD:
 		err = -EPERM;
 		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
+			break;
 		if ((args.u.name_type >= 0) &&
 		    (args.u.name_type < VLAN_NAME_TYPE_HIGHEST)) {
 			vlan_name_type = args.u.name_type;

-- 
