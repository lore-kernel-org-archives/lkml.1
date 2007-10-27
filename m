Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXJ0Dmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXJ0Dmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ0Dml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:42:41 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37794 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbXJ0Dml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:42:41 -0400
Date: Fri, 26 Oct 2007 23:42:40 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tcp v6: fix softnet build breakage
Message-ID: <20071027034240.GA13016@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


net/ipv6/tcp_ipv6.c: In function 'tcp_v6_rcv':
net/ipv6/tcp_ipv6.c:1736: error: implicit declaration of function
'get_softnet_dma'
net/ipv6/tcp_ipv6.c:1736: warning: assignment makes pointer from integer
without a cast

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 06fa4ba..8520802 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -59,6 +59,7 @@
 #include <net/snmp.h>
 #include <net/dsfield.h>
 #include <net/timewait_sock.h>
+#include <net/netdma.h>
 
 #include <asm/uaccess.h>
 
