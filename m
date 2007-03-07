Return-Path: <linux-kernel-owner+w=401wt.eu-S2992709AbXCGXOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992709AbXCGXOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992719AbXCGXOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:14:20 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46265 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992709AbXCGXOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:14:17 -0500
Date: Wed, 7 Mar 2007 15:12:05 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [patch 102/101] TCP: Fix minisock tcp_create_openreq_child() typo.
Message-ID: <20070307231205.GP10574@sequoia.sous-sol.org>
References: <20070307171035.150802805@mini.kroah.org> <20070307173420.GA24957@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307173420.GA24957@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

On 2/28/07, KOVACS Krisztian <hidden@balabit.hu> wrote:
>
>   Hi,
>
>   While reading TCP minisock code I've found this suspiciously looking
> code fragment:
>
> - 8< -
> struct sock *tcp_create_openreq_child(struct sock *sk, struct request_sock *req, struct sk_buff *skb)
> {
>         struct sock *newsk = inet_csk_clone(sk, req, GFP_ATOMIC);
>
>         if (newsk != NULL) {
>                 const struct inet_request_sock *ireq = inet_rsk(req);
>                 struct tcp_request_sock *treq = tcp_rsk(req);
>                 struct inet_connection_sock *newicsk = inet_csk(sk);
>                 struct tcp_sock *newtp;
> - 8< -
>
>   The above code initializes newicsk to inet_csk(sk), isn't that supposed
> to be inet_csk(newsk)?  As far as I can tell this might leave
> icsk_ack.last_seg_size zero even if we do have received data.

Good catch!

David, please apply the attached patch.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv4/tcp_minisocks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/net/ipv4/tcp_minisocks.c
+++ linux-2.6.20.1/net/ipv4/tcp_minisocks.c
@@ -381,7 +381,7 @@ struct sock *tcp_create_openreq_child(st
 	if (newsk != NULL) {
 		const struct inet_request_sock *ireq = inet_rsk(req);
 		struct tcp_request_sock *treq = tcp_rsk(req);
-		struct inet_connection_sock *newicsk = inet_csk(sk);
+		struct inet_connection_sock *newicsk = inet_csk(newsk);
 		struct tcp_sock *newtp;
 
 		/* Now setup tcp_sock */
