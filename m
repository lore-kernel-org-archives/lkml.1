Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZGKII6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZGKII6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZGKIIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:08:44 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:43581 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZGKIIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:08:42 -0400
Date: Sat, 11 Jul 2009 10:06:48 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: fubar@us.ibm.com, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/bonding: Adjust constant name
Message-ID: <Pine.LNX.4.64.0907111006090.29592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

AD_SHORT_TIMEOUT and AD_STATE_LACP_ACTIVITY have the same value, but
AD_STATE_LACP_ACTIVITY better reflects the intended semantics.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct port_params p;
@@
* p.port_state |= AD_SHORT_TIMEOUT
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/bonding/bond_3ad.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index d4b5708..88a1446 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1109,7 +1109,8 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
 			//mux machine in case of EXPIRED even if LINK_DOWN didn't arrive for the port.
 			port->partner_oper.port_state &= ~AD_STATE_SYNCHRONIZATION;
 			port->sm_vars &= ~AD_PORT_MATCHED;
-			port->partner_oper.port_state |= AD_SHORT_TIMEOUT;
+			port->partner_oper.port_state |=
+				AD_STATE_LACP_ACTIVITY;
 			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(AD_SHORT_TIMEOUT));
 			port->actor_oper_port_state |= AD_STATE_EXPIRED;
 			break;
