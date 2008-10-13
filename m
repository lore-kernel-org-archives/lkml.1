Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYJMMQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYJMMQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbYJMMQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:16:26 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:43033 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYJMMQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:16:26 -0400
Date: Mon, 13 Oct 2008 17:44:41 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jgarzik@redhat.com, apw@shadowen.org, scofeldm@cisco.com,
       ron.mercer@qlogic.com, cooldavid@cooldavid.org
Subject: [PATCH] 2.6.27-git2 - fix build error at csum_ipv6_magic()
Message-ID: <20081013121441.GB14372@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  2.6.27-git2 kernel build fails with allyesconfig on powerpc with 
build error 

<introduced by commit 01f2e4ead2c51226ed1283ef6a8388ca6f4cff8f> 

CC    drivers/net/enic/enic_main.o
drivers/net/enic/enic_main.c: In function ‘enic_queue_wq_skb_tso’:
drivers/net/enic/enic_main.c:576: error: implicit declaration of function ‘csum_ipv6_magic’
make[3]: *** [drivers/net/enic/enic_main.o] Error 1

<introduced by commit c4e84bde1d595d857d3c74b49b9c45cc770df792>

drivers/net/qlge/qlge_main.c: In function ‘ql_tso’:
drivers/net/qlge/qlge_main.c:1862: error: implicit declaration of function ‘csum_ipv6_magic’
make[3]: *** [drivers/net/qlge/qlge_main.o] Error 1
  
<introduced by commit 95252236e73e789dd186ce796a2abc60b3a61ebe>

drivers/net/jme.c: In function ‘jme_tx_tso’:
drivers/net/jme.c:1784: error: implicit declaration of function ‘csum_ipv6_magic’
make[2]: *** [drivers/net/jme.o] Error 1

The patch is build tested only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 drivers/net/enic/enic_main.c |    1 +
 drivers/net/jme.c            |    1 +
 drivers/net/qlge/qlge_main.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/enic/enic_main.c b/drivers/net/enic/enic_main.c
index f3a47a8..180e968 100644
--- a/drivers/net/enic/enic_main.c
+++ b/drivers/net/enic/enic_main.c
@@ -34,6 +34,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
+#include <net/ip6_checksum.h>
 
 #include "cq_enet_desc.h"
 #include "vnic_dev.h"
diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index 5f9a131..d86e809 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -38,6 +38,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/if_vlan.h>
+#include <net/ip6_checksum.h>
 #include "jme.h"
 
 static int force_pseudohp = -1;
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 3af822b..6675723 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -40,6 +40,7 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <net/ip6_checksum.h>
 
 #include "qlge.h"
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
