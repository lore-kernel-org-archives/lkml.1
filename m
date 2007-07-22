Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXGVRAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXGVRAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbXGVRAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:00:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28906 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbXGVRAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=ePqy+sdIiyQrkJmfAD4ICbwcQGlpSo8sAWRzbJ5/TFtDB/JEjyZr5NUPkTCFWWZt+JSfdC8LqXizZt/8q+PrkzR2limOcCqAuL37AYd6QPQZvuZzke0nktfUam5BIL7OVnKdvwnm41qU4IhsDILvIx81fAvZ06Pdl2C8otP9SdY=
Message-ID: <46A38CA3.9010302@googlemail.com>
Date: Sun, 22 Jul 2007 18:58:11 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Dag Brattli <dagb@cs.uit.no>, netdev@vger.kernel.org
Subject: [PATCH] Fix irlan_eth.c - unused variable 'in_dev' warning
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this warning on current git:

...

net/irda/irlan/irlan_eth.c: In function 'irlan_eth_send_gratuitous_arp':
net/irda/irlan/irlan_eth.c:301: warning: unused variable 'in_dev'

...

This is because CONFIG_INET is not set in my config.


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/net/irda/irlan/irlan_eth.c b/net/irda/irlan/irlan_eth.c
index c421521..ea0b21a 100644
--- a/net/irda/irlan/irlan_eth.c
+++ b/net/irda/irlan/irlan_eth.c
@@ -298,6 +298,7 @@ void irlan_eth_flow_indication(void *instance, void *sap, LOCAL_FLOW flow)
  */
 void irlan_eth_send_gratuitous_arp(struct net_device *dev)
 {
+#ifdef CONFIG_INET
 	struct in_device *in_dev;
 
 	/*
@@ -305,7 +306,6 @@ void irlan_eth_send_gratuitous_arp(struct net_device *dev)
 	 * is useful if we have changed access points on the same
 	 * subnet.
 	 */
-#ifdef CONFIG_INET
 	IRDA_DEBUG(4, "IrLAN: Sending gratuitous ARP\n");
 	rcu_read_lock();
 	in_dev = __in_dev_get_rcu(dev);
