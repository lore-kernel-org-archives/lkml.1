Return-Path: <linux-kernel-owner+w=401wt.eu-S933694AbYEULcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbYEULcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760189AbYEULch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:32:37 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46745 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759660AbYEULcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:32:36 -0400
Date: Wed, 21 May 2008 17:02:30 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org, apw@shadowen.org
Subject: [PATCH] linux-next: Tree for May 21 - build failure with netfilter on __nf_ct_helper_find()
Message-ID: <20080521113230.GA10830@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080521155936.466bbe86.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080521155936.466bbe86.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The next-20080521 kernel build fails, on x86_64 machine 

CC net/netfilter/nf_conntrack_helper.o
net/netfilter/nf_conntrack_helper.c: In function ‘__nf_ct_helper_find’:
net/netfilter/nf_conntrack_helper.c:58: error: implicit declaration of function ‘hlist_for_each_entry_rcu’
net/netfilter/nf_conntrack_helper.c:58: error: ‘hnode’ undeclared (first use in this function)
net/netfilter/nf_conntrack_helper.c:58: error: (Each undeclared identifier is reported only once
net/netfilter/nf_conntrack_helper.c:58: error: for each function it appears in.)
net/netfilter/nf_conntrack_helper.c:58: error: expected ‘;’ before ‘{’ token
net/netfilter/nf_conntrack_helper.c:50: warning: unused variable ‘mask’
net/netfilter/nf_conntrack_helper.c: In function ‘__nf_conntrack_helper_find_byname’:
net/netfilter/nf_conntrack_helper.c:74: error: ‘hnode’ undeclared (first use in this function)
net/netfilter/nf_conntrack_helper.c:74: error: expected ‘;’ before ‘{’ token
net/netfilter/nf_conntrack_helper.c: In function ‘nf_conntrack_helper_register’:
net/netfilter/nf_conntrack_helper.c:117: error: implicit declaration of function ‘hlist_add_head_rcu’
net/netfilter/nf_conntrack_helper.c: In function ‘nf_conntrack_helper_unregister’:
net/netfilter/nf_conntrack_helper.c:133: error: implicit declaration of function ‘hlist_del_rcu’
make[2]: *** [net/netfilter/nf_conntrack_helper.o] Error 1
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2

This build error is because of the missing include file.I have tested
the patch for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.26-rc3/net/netfilter/nf_conntrack_helper.c	2008-05-20 20:24:14.000000000 +0530
+++ linux-2.6.26-rc3/net/netfilter/~nf_conntrack_helper.c	2008-05-22 00:17:32.000000000 +0530
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/rculist.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
