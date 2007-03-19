Return-Path: <linux-kernel-owner+w=401wt.eu-S1030619AbXCSVpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619AbXCSVpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964815AbXCSVme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:42:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:59361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030630AbXCSVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:59 -0400
Date: Mon, 19 Mar 2007 14:40:04 -0700
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
       Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/31] Fix ipv6 flow label inheritance
Message-ID: <20070319214004.GV9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipv6-flow-label-inheritance.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>

[IPV6]: ipv6_fl_socklist is inadvertently shared.

The ipv6_fl_socklist from listening socket is inadvertently shared
with new socket created for connection.  This leads to a variety of
interesting, but fatal, bugs. For example, removing one of the
sockets may lead to the other socket's encountering a page fault
when the now freed list is referenced.

The fix is to not share the flow label list with the new socket.

Signed-off-by: Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/tcp_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1453,6 +1453,7 @@ static struct sock * tcp_v6_syn_recv_soc
 	   First: no IPv4 options.
 	 */
 	newinet->opt = NULL;
+	newnp->ipv6_fl_list = NULL;
 
 	/* Clone RX bits */
 	newnp->rxopt.all = np->rxopt.all;

-- 
