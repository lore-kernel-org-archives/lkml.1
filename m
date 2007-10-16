Return-Path: <linux-kernel-owner+w=401wt.eu-S1763770AbXJPQsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763770AbXJPQsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758845AbXJPQsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:48:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:41370 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754036AbXJPQsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:48:30 -0400
X-Authenticated: #3169751
X-Provags-ID: V01U2FsdGVkX1+S9WQM6x+SMWu8pqBP9jp4Q9MDvB6xNG2c552mAW
	RTnna/IwSznBuS
From: Matthias Dellweg <2500@gmx.de>
To: David Miller <davem@davemloft.net>
Subject: Re: PATCH: tcp rfc 2385 security/bugfix for sparc64
Date: Tue, 16 Oct 2007 18:47:56 +0200
User-Agent: KMail/1.9.7
Cc: Peter Lieven <pl@dlh.net>, sparclinux@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161848.18443.2500@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
while reviewing the tcp_md5-related code further i came across with another
two of these casts which you probably have missed. I don't actually think
that they impose a problem by now, but as you said we should remove them.
Matthias


--- linux-2.6.23.1.orig/net/ipv4/tcp_ipv4.c     2007-10-16 17:25:05.000000000 +0200
+++ linux-2.6.23.1/net/ipv4/tcp_ipv4.c  2007-10-16 17:50:05.000000000 +0200
@@ -857,16 +857,16 @@ int tcp_v4_md5_do_add(struct sock *sk, _
                      u8 *newkey, u8 newkeylen)
 {
        /* Add Key to the list */
-       struct tcp4_md5sig_key *key;
+       struct tcp_md5sig_key *key;
        struct tcp_sock *tp = tcp_sk(sk);
        struct tcp4_md5sig_key *keys;

-       key = (struct tcp4_md5sig_key *)tcp_v4_md5_do_lookup(sk, addr);
+       key = tcp_v4_md5_do_lookup(sk, addr);
        if (key) {
                /* Pre-existing entry - just update that one. */
-               kfree(key->base.key);
-               key->base.key = newkey;
-               key->base.keylen = newkeylen;
+               kfree(key->key);
+               key->key = newkey;
+               key->keylen = newkeylen;
        } else {
                struct tcp_md5sig_info *md5sig;

--- linux-2.6.23.1.orig/net/ipv6/tcp_ipv6.c     2007-10-16 17:47:57.000000000 +0200
+++ linux-2.6.23.1/net/ipv6/tcp_ipv6.c  2007-10-16 17:49:25.000000000 +0200
@@ -560,16 +560,16 @@ static int tcp_v6_md5_do_add(struct sock
                             char *newkey, u8 newkeylen)
 {
        /* Add key to the list */
-       struct tcp6_md5sig_key *key;
+       struct tcp_md5sig_key *key;
        struct tcp_sock *tp = tcp_sk(sk);
        struct tcp6_md5sig_key *keys;

-       key = (struct tcp6_md5sig_key*) tcp_v6_md5_do_lookup(sk, peer);
+       key = tcp_v6_md5_do_lookup(sk, peer);
        if (key) {
                /* modify existing entry - just update that one */
-               kfree(key->base.key);
-               key->base.key = newkey;
-               key->base.keylen = newkeylen;
+               kfree(key->key);
+               key->key = newkey;
+               key->keylen = newkeylen;
        } else {
                /* reallocate new list if current one is full. */
                if (!tp->md5sig_info) {


Signed-off-by: Matthias M. Dellweg <2500@gmx.de>
