Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYELWKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYELWKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYELWKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:10:35 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1425 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbYELWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:10:34 -0400
Subject: [PATCH] drivers/net/ehea - remove unnecessary memset after kzalloc
From: Joe Perches <joe@perches.com>
To: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>
Cc: linux <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Christophe Jaillet <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20080512213601.626C91C0008F@mwinf2103.orange.fr>
References: <20080512213601.626C91C0008F@mwinf2103.orange.fr>
Content-Type: text/plain
Date: Mon, 12 May 2008 14:38:17 -0700
Message-Id: <1210628297.14967.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

---

 drivers/net/ehea/ehea_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index f9bc21c..fd4be0d 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2207,18 +2207,16 @@ static void ehea_vlan_rx_register(struct net_device *dev,
 	port->vgrp = grp;
 
 	cb1 = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!cb1) {
 		ehea_error("no mem for cb1");
 		goto out;
 	}
 
-	memset(cb1->vlan_filter, 0, sizeof(cb1->vlan_filter));
-
 	hret = ehea_h_modify_ehea_port(adapter->handle, port->logical_port_id,
 				       H_PORT_CB1, H_PORT_CB1_ALL, cb1);
 	if (hret != H_SUCCESS)
 		ehea_error("modify_ehea_port failed");
 
 	kfree(cb1);
 out:
 	return;


