Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZCIX1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZCIX1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZCIX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:26:53 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64685 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZCIX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:26:52 -0400
Date: Mon, 9 Mar 2009 16:27:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, inaky.perez-gonzalez@intel.com
Subject: [PATCH -mmotm] wimax: fix i2400m printk formats
Message-Id: <20090309162718.e38a7299.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49B5A592.004D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/net/wimax/i2400m/netdev.c:523: warning: format '%zu' expects type 'size_t', but argument 7 has type 'unsigned int'
drivers/net/wimax/i2400m/netdev.c:548: warning: format '%zu' expects type 'size_t', but argument 7 has type 'unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wimax/i2400m/netdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2009-0306-1659.orig/drivers/net/wimax/i2400m/netdev.c
+++ mmotm-2009-0306-1659/drivers/net/wimax/i2400m/netdev.c
@@ -520,7 +520,7 @@ void i2400m_net_erx(struct i2400m *i2400
 	struct device *dev = i2400m_dev(i2400m);
 	int protocol;
 
-	d_fnstart(2, dev, "(i2400m %p skb %p [%zu] cs %d)\n",
+	d_fnstart(2, dev, "(i2400m %p skb %p [%u] cs %d)\n",
 		  i2400m, skb, skb->len, cs);
 	switch(cs) {
 	case I2400M_CS_IPV4_0:
@@ -545,7 +545,7 @@ void i2400m_net_erx(struct i2400m *i2400
 	d_dump(4, dev, skb->data, skb->len);
 	netif_rx_ni(skb);	/* see notes in function header */
 error:
-	d_fnend(2, dev, "(i2400m %p skb %p [%zu] cs %d) = void\n",
+	d_fnend(2, dev, "(i2400m %p skb %p [%u] cs %d) = void\n",
 		i2400m, skb, skb->len, cs);
 }
 
