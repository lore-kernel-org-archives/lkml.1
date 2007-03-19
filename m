Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXCSVj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXCSVj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbXCSVjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:39:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:59092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbXCSVjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:39:17 -0400
Date: Mon, 19 Mar 2007 14:37:29 -0700
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
       Chris Wright <chrisw@sous-sol.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/31] Fix user copy length in ipv6_sockglue.c
Message-ID: <20070319213729.GE9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-user-copy-length-in-ipv6_sockglue.c.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

[IPV6] fix ipv6_getsockopt_sticky copy_to_user leak

User supplied len < 0 can cause leak of kernel memory.
Use unsigned compare instead.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ipv6_sockglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -805,7 +805,7 @@ static int ipv6_getsockopt_sticky(struct
 		return 0;
 	hdr = opt->hopopt;
 
-	len = min_t(int, len, ipv6_optlen(hdr));
+	len = min_t(unsigned int, len, ipv6_optlen(hdr));
 	if (copy_to_user(optval, hdr, ipv6_optlen(hdr)))
 		return -EFAULT;
 	return len;

-- 
