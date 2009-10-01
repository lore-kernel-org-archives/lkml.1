Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZJAXiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZJAXiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbZJAXiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:23 -0400
Received: from kroah.org ([198.145.64.141]:42062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZJAXiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:22 2009
Message-Id: <20091001233321.895031689@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: [patch 21/30] netfilter: bridge: refcount fix
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-bridge-refcount-fix.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

netfilter: bridge: refcount fix

Upstream commit f3abc9b9:

commit f216f082b2b37c4943f1e7c393e2786648d48f6f
([NETFILTER]: bridge netfilter: deal with martians correctly)
added a refcount leak on in_dev.

Instead of using in_dev_get(), we can use __in_dev_get_rcu(),
as netfilter hooks are running under rcu_read_lock(), as pointed
by Patrick.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_netfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -357,7 +357,7 @@ static int br_nf_pre_routing_finish(stru
 				},
 				.proto = 0,
 			};
-			struct in_device *in_dev = in_dev_get(dev);
+			struct in_device *in_dev = __in_dev_get_rcu(dev);
 
 			/* If err equals -EHOSTUNREACH the error is due to a
 			 * martian destination or due to the fact that


