Return-Path: <linux-kernel-owner+w=401wt.eu-S966112AbXHGV30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966112AbXHGV30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965202AbXHGU5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:57:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60032 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbXHGU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:57:53 -0400
Date: Tue, 7 Aug 2007 13:49:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Marcus Meissner <meissner@suse.de>
Subject: [2.6.22.2 review 79/84] IPV6: /proc/net/anycast6 unbalanced
	inet6_dev refcnt
Message-ID: <20070807204929.GC23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="proc-net-anycast6-unbalanced-inet6_dev-refcnt.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Stevens <dlstevens@us.ibm.com>

Reading /proc/net/anycast6 when there is no anycast address
on an interface results in an ever-increasing inet6_dev reference
count, as well as a reference to the netdevice you can't get rid of.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Marcus Meissner <meissner@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/anycast.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -66,6 +66,7 @@ ip6_onlink(struct in6_addr *addr, struct
 				break;
 		}
 		read_unlock_bh(&idev->lock);
+		in6_dev_put(idev);
 	}
 	rcu_read_unlock();
 	return onlink;

-- 
