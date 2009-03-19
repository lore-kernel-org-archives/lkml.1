Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZCSPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZCSPc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZCSPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:32:45 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:45994 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbZCSPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:32:44 -0400
Subject: [PATCH] ipv6: reorder struct inet6_ifaddr to remove padding on 64
 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: yoshfuji@linux-ipv6.org, pekkas@netcore.fi
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 15:32:40 +0000
Message-Id: <1237476760.3266.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder struct inet6_ifaddr to remove padding on 64 bit builds
    
remove 8 bytes of padding so inet6_ifaddr becomes 192 bytes & fits into
a smaller slab.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
patch against v2.6.29-rc8

I've compiled & booted with this patch, modules ipv6 & ip6_tables load
successfully, but I've not run any other tests.

regards
Richard
 



diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index c8effa4..38b7813 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -39,8 +39,6 @@ struct inet6_ifaddr
 	
 	__u32			valid_lft;
 	__u32			prefered_lft;
-	unsigned long		cstamp;	/* created timestamp */
-	unsigned long		tstamp; /* updated timestamp */
 	atomic_t		refcnt;
 	spinlock_t		lock;
 
@@ -49,6 +47,9 @@ struct inet6_ifaddr
 
 	__u16			scope;
 
+	unsigned long		cstamp;	/* created timestamp */
+	unsigned long		tstamp; /* updated timestamp */
+
 	struct timer_list	timer;
 
 	struct inet6_dev	*idev;


