Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbXHWWew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbXHWWew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXHWW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33119 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765797AbXHWW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:04 -0400
Date: Thu, 23 Aug 2007 15:27:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/28] NET: Fix missing rcu unlock in __sock_create()
Message-ID: <20070823222702.GO18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-missing-rcu-unlock-in-__sock_create.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[NET]: Fix unbalanced rcu_read_unlock in __sock_create

The recent RCU work created an unbalanced rcu_read_unlock
in __sock_create.  This patch fixes that.  Reported by
oleg 123.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1169,7 +1169,7 @@ static int __sock_create(int family, int
 	module_put(pf->owner);
 	err = security_socket_post_create(sock, family, type, protocol, kern);
 	if (err)
-		goto out_release;
+		goto out_sock_release;
 	*res = sock;
 
 	return 0;

-- 
