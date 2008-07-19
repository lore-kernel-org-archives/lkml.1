Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbYGSASs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbYGSASs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYGSASj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:18:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34982 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYGSASi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:18:38 -0400
Date: Fri, 18 Jul 2008 17:18:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH -next] net namespace: build when SYSCTL=n
Message-Id: <20080718171812.8dfc9767.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_SYSCTL=n, build fails with:

linux-next-20080718/include/net/net_namespace.h:40: error: field 'sysctls' has incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/net_namespace.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20080718.orig/include/net/net_namespace.h
+++ linux-next-20080718/include/net/net_namespace.h
@@ -37,7 +37,9 @@ struct net {
 	struct proc_dir_entry 	*proc_net;
 	struct proc_dir_entry 	*proc_net_stat;
 
+#ifdef CONFIG_SYSCTL
 	struct ctl_table_set	sysctls;
+#endif
 
 	struct net_device       *loopback_dev;          /* The loopback */
 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
