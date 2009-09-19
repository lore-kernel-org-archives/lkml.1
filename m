Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZISTtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZISTtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 15:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZISTtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 15:49:46 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:38802 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbZISTtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 15:49:45 -0400
Date: Sat, 19 Sep 2009 21:49:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jdike@addtoit.com, user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] arch/um: remove duplicate structure field initialization
Message-ID: <Pine.LNX.4.64.0909192149250.27171@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The definition of uml_netdev_ops has initializations of a local function
and eth_mac_addr for its ndo_set_mac_address field.  This change uses only
the local function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)!=int(pr[0].line) or int(ps[0].column)!=int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/um/drivers/net_kern.c          |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index a74245a..d17a623 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -379,7 +379,6 @@ static const struct net_device_ops uml_netdev_ops = {
 	.ndo_tx_timeout 	= uml_net_tx_timeout,
 	.ndo_set_mac_address	= uml_net_set_mac,
 	.ndo_change_mtu 	= uml_net_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
