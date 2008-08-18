Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbYHRS4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbYHRS4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761081AbYHRSzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:55:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:42697 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761064AbYHRSy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:54:59 -0400
Date: Mon, 18 Aug 2008 11:43:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Florian Westphal <fw@strlen.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 25/60] syncookies: Make sure ECN is disabled
Message-ID: <20080818184324.GZ29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="syncookies-make-sure-ecn-is-disabled.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Florian Westphal <fw@strlen.de>

[ Upstream commit 16df845f4566bc252f3e09db12f5c2f22cb44226 ]

ecn_ok is not initialized when a connection is established by cookies.
The cookie syn-ack never sets ECN, so ecn_ok must be set to 0.

Spotted using ns-3/network simulation cradle simulator and valgrind.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/syncookies.c |    1 +
 net/ipv6/syncookies.c |    1 +
 2 files changed, 2 insertions(+)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -301,6 +301,7 @@ struct sock *cookie_v4_check(struct sock
 	ireq->rmt_port		= th->source;
 	ireq->loc_addr		= ip_hdr(skb)->daddr;
 	ireq->rmt_addr		= ip_hdr(skb)->saddr;
+	ireq->ecn_ok		= 0;
 	ireq->snd_wscale	= tcp_opt.snd_wscale;
 	ireq->rcv_wscale	= tcp_opt.rcv_wscale;
 	ireq->sack_ok		= tcp_opt.sack_ok;
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -223,6 +223,7 @@ struct sock *cookie_v6_check(struct sock
 
 	req->expires = 0UL;
 	req->retrans = 0;
+	ireq->ecn_ok		= 0;
 	ireq->snd_wscale	= tcp_opt.snd_wscale;
 	ireq->rcv_wscale	= tcp_opt.rcv_wscale;
 	ireq->sack_ok		= tcp_opt.sack_ok;

-- 
