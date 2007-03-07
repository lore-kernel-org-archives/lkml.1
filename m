Return-Path: <linux-kernel-owner+w=401wt.eu-S1422874AbXCGRaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422874AbXCGRaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422858AbXCGRRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:11 -0500
Received: from mail.suse.de ([195.135.220.2]:44152 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422877AbXCGRQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:56 -0500
Message-Id: <20070307171519.186461943@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 070/101] Fix anycast procfs device leak
Content-Disposition: inline; filename=fix-anycast-procfs-device-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Stevens <dlstevens@us.ibm.com>

[IPV6]: /proc/net/anycast6 unbalanced inet6_dev refcnt

From: David Stevens <dlstevens@us.ibm.com>

Reading /proc/net/anycast6 when there is no anycast address
on an interface results in an ever-increasing inet6_dev reference
count, as well as a reference to the netdevice you can't get rid of.

From: David Stevens <dlstevens@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/anycast.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.20.1.orig/net/ipv6/anycast.c
+++ linux-2.6.20.1/net/ipv6/anycast.c
@@ -462,6 +462,7 @@ static inline struct ifacaddr6 *ac6_get_
 			break;
 		}
 		read_unlock_bh(&idev->lock);
+		in6_dev_put(idev);
 	}
 	return im;
 }

--
