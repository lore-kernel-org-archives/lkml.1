Return-Path: <linux-kernel-owner+w=401wt.eu-S1763184AbXIXQlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763184AbXIXQlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761132AbXIXQ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58093 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761118AbXIXQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:24 -0400
Date: Mon, 24 Sep 2007 09:22:27 -0700
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
       Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [42/50] Fix ipv6 source address handling.
Message-ID: <20070924162227.GQ13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipv6-source-address-handling.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 6ae5f983cf8de769214d2d9e8a783c881eccd4cd in mainline

The commit 95c385 broke proper source address selection for cases in which
there is a address which is makred 'deprecated'. The commit mistakenly
changed ifa->flags to ifa_result->flags (probably copy/paste error from a
few lines above) in the 'Rule 3' address selection code.

The patch restores the previous RFC-compliant behavior.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/addrconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1021,7 +1021,7 @@ int ipv6_dev_get_saddr(struct net_device
 				hiscore.rule++;
 			}
 			if (ipv6_saddr_preferred(score.addr_type) ||
-			   (((ifa_result->flags &
+			   (((ifa->flags &
 			    (IFA_F_DEPRECATED|IFA_F_OPTIMISTIC)) == 0))) {
 				score.attrs |= IPV6_SADDR_SCORE_PREFERRED;
 				if (!(hiscore.attrs & IPV6_SADDR_SCORE_PREFERRED)) {

-- 
