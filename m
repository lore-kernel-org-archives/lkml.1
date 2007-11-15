Return-Path: <linux-kernel-owner+w=401wt.eu-S1765892AbXKOG27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765892AbXKOG27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763354AbXKOGWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45980 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764685AbXKOGWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:16 -0500
Date: Wed, 14 Nov 2007 22:20:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/23] Fix SET_VLAN_INGRESS_PRIORITY_CMD error return.
Message-ID: <20071115062044.GN8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-set_vlan_ingress_priority_cmd-error-return.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

patch fffe470a803e7f7b74c016291e542a0162761209 in mainline.

[VLAN]: Fix SET_VLAN_INGRESS_PRIORITY_CMD ioctl

Based on report and patch by Doug Kehn <rdkehn@yahoo.com>:

vconfig returns the following error when attempting to execute the
set_ingress_map command:

vconfig: socket or ioctl error for set_ingress_map: Operation not permitted

In vlan.c, vlan_ioctl_handler for SET_VLAN_INGRESS_PRIORITY_CMD
sets err = -EPERM and calls vlan_dev_set_ingress_priority.
vlan_dev_set_ingress_priority is a void function so err remains
at -EPERM and results in the vconfig error (even though the ingress
map was set).

Fix by setting err = 0 after the vlan_dev_set_ingress_priority call.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/8021q/vlan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -744,6 +744,7 @@ static int vlan_ioctl_handler(void __use
 		vlan_dev_set_ingress_priority(dev,
 					      args.u.skb_priority,
 					      args.vlan_qos);
+		err = 0;
 		break;
 
 	case SET_VLAN_EGRESS_PRIORITY_CMD:

-- 
