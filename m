Return-Path: <linux-kernel-owner+w=401wt.eu-S965035AbXHGUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035AbXHGUyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935448AbXHGUsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:48:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56125 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935446AbXHGUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:48:51 -0400
Date: Tue, 7 Aug 2007 13:44:34 -0700
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
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 19/84] Fix TCP IPV6 MD5 bug.
Message-ID: <20070807204434.GT23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tcp-ipv6-md5-bug.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

[TCPv6] MD5SIG: Ensure to reset allocation count to avoid panic.

After clearing all passwords for IPv6 peers, we need to
set allocation count to zero as well as we free the storage.
Otherwise, we panic when a user trys to (re)add a password.

Discovered and fixed by MIYAJIMA Mitsuharu <miyajima.mitsuharu@anchor.jp>.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/tcp_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -644,6 +644,7 @@ static int tcp_v6_md5_do_del(struct sock
 			if (tp->md5sig_info->entries6 == 0) {
 				kfree(tp->md5sig_info->keys6);
 				tp->md5sig_info->keys6 = NULL;
+				tp->md5sig_info->alloced6 = 0;
 
 				tcp_free_md5sig_pool();
 

-- 
