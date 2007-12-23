Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbXLWXBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbXLWXBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXLWXBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:01:34 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56071 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXLWXBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:01:33 -0500
Date: Mon, 24 Dec 2007 04:11:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Build breakage on powerpc with 2.6.24-rc6-mm1
Message-ID: <20071223224158.GA7975@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see the following error with the iseries_veth driver in 2.6.24-rc6-mm1

drivers/net/iseries_veth.c: In function ‘veth_init_connection’:
drivers/net/iseries_veth.c:818: warning: unused variable ‘rc’
drivers/net/iseries_veth.c: In function ‘veth_probe_one’:
drivers/net/iseries_veth.c:1086: error: ‘veth_port_ktypeq’ undeclared
(first use in this function)
drivers/net/iseries_veth.c:1086: error: (Each undeclared identifier is
reported only once
drivers/net/iseries_veth.c:1086: error: for each function it appears
in.)
make[2]: *** [drivers/net/iseries_veth.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Here's a patch, compile tested to fix the compilation problem


Remove unused variable rc and fix a typo, veth_port_type was called
veth_port_typeq

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 drivers/net/iseries_veth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/iseries_veth.c~fix-iseries-veth-driver drivers/net/iseries_veth.c
--- linux-2.6.24-rc6/drivers/net/iseries_veth.c~fix-iseries-veth-driver	2007-12-24 03:59:35.000000000 +0530
+++ linux-2.6.24-rc6-balbir/drivers/net/iseries_veth.c	2007-12-24 04:02:31.000000000 +0530
@@ -815,7 +815,7 @@ static int veth_init_connection(u8 rlp)
 {
 	struct veth_lpar_connection *cnx;
 	struct veth_msg *msgs;
-	int i, rc;
+	int i;
 
 	if ( (rlp == this_lp)
 	     || ! HvLpConfig_doLpsCommunicateOnVirtualLan(this_lp, rlp) )
@@ -1083,7 +1083,7 @@ static struct net_device * __init veth_p
 		return NULL;
 	}
 
-	kobject_init(&port->kobject, &veth_port_ktypeq);
+	kobject_init(&port->kobject, &veth_port_ktype);
 	if (0 != kobject_add(&port->kobject, &dev->dev.kobj, "veth_port"))
 		veth_error("Failed adding port for %s to sysfs.\n", dev->name);
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
