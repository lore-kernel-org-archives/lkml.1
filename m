Return-Path: <linux-kernel-owner+w=401wt.eu-S932368Ab0ANVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0ANVxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320Ab0ANVxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:53:39 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:43935 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0ANVxg (ORCPT
	<rfc822;groupwise-PMullaney@novell.com:0:0>);
	Thu, 14 Jan 2010 16:53:36 -0500
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH 3/3] macvlan: use rtnl_link_ops->dellink during unregister
	notications
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, kaber@trash.net, arnd@arndb.de,
       netdev@vger.kernel.org
Date: Thu, 14 Jan 2010 16:53:18 -0500
Message-ID: <20100114215318.4958.97684.stgit@mimic.site>
In-Reply-To: <20100114215058.4958.87746.stgit@mimic.site>
References: <20100114215058.4958.87746.stgit@mimic.site>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different macvlan device types will need to release resources in
their own type specific dellink operation. This change ensures they
will for unregister notifications on the lower level device.

Signed-off-by: Patrick Mullaney <pmullaney@novell.com>
---

 drivers/net/macvlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 94bb135..a57faaa 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -570,7 +570,7 @@ static int macvlan_device_event(struct notifier_block *unused,
 		break;
 	case NETDEV_UNREGISTER:
 		list_for_each_entry_safe(vlan, next, &port->vlans, list)
-			macvlan_dellink(vlan->dev);
+			vlan->dev->rtnl_link_ops->dellink(vlan->dev);
 		break;
 	}
 	return NOTIFY_DONE;

