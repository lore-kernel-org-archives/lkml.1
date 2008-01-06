Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYAFA5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYAFA5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYAFA5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:57:15 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55562 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYAFA5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:57:14 -0500
Date: Sun, 6 Jan 2008 01:57:13 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Al Viro <viro@ZenIV.linux.org.uk>, m.kozlowski@tuxland.pl,
       davem@davemloft.net, sparclinux@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sparc oops in ip_fast_csum
In-Reply-To: <E1JBJHA-0000hy-00@gondolin.me.apana.org.au>
Message-ID: <Pine.LNX.4.64.0801060156410.14194@fbirervta.pbzchgretzou.qr>
References: <E1JBJHA-0000hy-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 6 2008 11:22, Herbert Xu wrote:
>@@ -271,6 +271,7 @@ static int raw_send_hdrinc(struct sock *sk, void *from, size_t length,
> 	int hh_len;
> 	struct iphdr *iph;
> 	struct sk_buff *skb;
>+	unsigned int iphlen;
> 	int err;
> 
> 	if (length > rt->u.dst.dev->mtu) {
>@@ -304,7 +305,8 @@ static int raw_send_hdrinc(struct sock *sk, void *from, size_t length,
> 		goto error_fault;
> 
> 	/* We don't modify invalid header */
>-	if (length >= sizeof(*iph) && iph->ihl * 4U <= length) {
>+	iphlen = iph->ihl * 4;
>+	if (iphlen >= sizeof(*iph) && iphlen <= length) {

Humm, this could use ip_hdrlen(skb) :-)
