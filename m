Return-Path: <linux-kernel-owner+w=401wt.eu-S937398AbYEUV4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937398AbYEUV4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbYEUV4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:56:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47239 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbYEUV4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:56:23 -0400
Date: Wed, 21 May 2008 14:55:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>, mingo <mingo@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] netfilter: conntrack_helper needs to include rculist.h
Message-Id: <20080521145532.8e779533.randy.dunlap@oracle.com>
In-Reply-To: <20080521.144550.151762863.davem@davemloft.net>
References: <20080521142139.f0bc5698.randy.dunlap@oracle.com>
	<20080521.144550.151762863.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Wed, 21 May 2008 14:45:50 -0700 (PDT) David Miller wrote:

> This needs to go in via whatever tree adds the linux/rculist.h header file,
> which isn't net-next-2.6 as far as I can tell. :-)

Sure, makes sense.

Looks like it's some sched/auto-sched tree/branch if I'm reading
correctly.

Ingo, is there a sched tree that add rculist.h file?
If so, one of its users needs to #include it.  Patch below.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

nf_conntrack_helper users rcu hlist functions so it needs to #include
rculist.h.

linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: implicit declaration of function 'hlist_for_each_entry_rcu'
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: 'hnode' undeclared (first use in this function)
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: (Each undeclared identifier is reported only once
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: for each function it appears in.)
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: expected ';' before '{' token
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:50: warning: unused variable 'mask'
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:74: error: 'hnode' undeclared (first use in this function)
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:74: error: expected ';' before '{' token
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:117: error: implicit declaration of function 'hlist_add_head_rcu'
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:133: error: implicit declaration of function 'hlist_del_rcu'
filter/nf_conntrack_helper.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/netfilter/nf_conntrack_helper.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20080521.orig/net/netfilter/nf_conntrack_helper.c
+++ linux-next-20080521/net/netfilter/nf_conntrack_helper.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/rculist.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>

