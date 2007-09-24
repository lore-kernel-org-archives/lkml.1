Return-Path: <linux-kernel-owner+w=401wt.eu-S1763058AbXIXQlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763058AbXIXQlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbXIXQ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:13 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58079 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759667AbXIXQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:11 -0400
Date: Mon, 24 Sep 2007 09:22:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [41/50] : Fix IPV6 DAD handling
Message-ID: <20070924162223.GP13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipv6-dad-handling.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis V. Lunev <den@openvz.org>

commit 9e3be4b34364a670bd6e57d2e8c3caabdd8d89f8 in mainline

addrconf_dad_failure calls addrconf_dad_stop which takes referenced address
and drops the count. So, in6_ifa_put perrformed at out: is extra. This
results in message: "Freeing alive inet6 address" and not released dst entries.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ndisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -736,7 +736,7 @@ static void ndisc_recv_ns(struct sk_buff
 				 * so fail our DAD process
 				 */
 				addrconf_dad_failure(ifp);
-				goto out;
+				return;
 			} else {
 				/*
 				 * This is not a dad solicitation.

-- 
