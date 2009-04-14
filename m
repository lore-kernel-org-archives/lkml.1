Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbZDNP5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbZDNP5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZDNPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:54:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41146 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbZDNPyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:54:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix velocity_intr() in the VIA Velocity driver to have the
	right return type
To: romieu@fr.zoreil.com, netdev@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 16:53:25 +0100
Message-ID: <20090414155325.27548.90325.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix velocity_intr() in the VIA Velocity driver to have the right return type.
As it stands, it returns the right values, but as type int, not type
irqreturn_t.  This leads to the following compiler warning:

  CC      drivers/net/via-velocity.o
drivers/net/via-velocity.c: In function 'velocity_open':
drivers/net/via-velocity.c:1924: warning: passing argument 2 of 'request_irq' from incompatible pointer type

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/net/via-velocity.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index fb53ef8..754a4b1 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -377,7 +377,7 @@ static void velocity_print_info(struct velocity_info *vptr);
 static int velocity_open(struct net_device *dev);
 static int velocity_change_mtu(struct net_device *dev, int mtu);
 static int velocity_xmit(struct sk_buff *skb, struct net_device *dev);
-static int velocity_intr(int irq, void *dev_instance);
+static irqreturn_t velocity_intr(int irq, void *dev_instance);
 static void velocity_set_multi(struct net_device *dev);
 static struct net_device_stats *velocity_get_stats(struct net_device *dev);
 static int velocity_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
@@ -2215,7 +2215,7 @@ out:
  *	efficiently as possible.
  */
 
-static int velocity_intr(int irq, void *dev_instance)
+static irqreturn_t velocity_intr(int irq, void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct velocity_info *vptr = netdev_priv(dev);

