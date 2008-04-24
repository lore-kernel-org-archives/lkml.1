Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYDXBfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYDXBfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYDXBfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:35:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35214
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbYDXBfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:35:24 -0400
Date: Wed, 23 Apr 2008 18:35:23 -0700 (PDT)
Message-Id: <20080423.183523.149346715.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       linville@tuxdriver.com, sri@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH] list_for_each_rcu must die: networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080424013208.GA26526@linux.vnet.ibm.com>
References: <20080424013208.GA26526@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 23 Apr 2008 18:32:08 -0700

> diff -urpNa -X dontdiff linux-2.6.25/net/ipv4/af_inet.c linux-2.6.25-lfer-net/net/ipv4/af_inet.c
> --- linux-2.6.25/net/ipv4/af_inet.c	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-lfer-net/net/ipv4/af_inet.c	2008-04-23 16:56:03.000000000 -0700
> @@ -274,8 +274,7 @@ static int inet_create(struct net *net, 
>  lookup_protocol:
>  	err = -ESOCKTNOSUPPORT;
>  	rcu_read_lock();
> -	list_for_each_rcu(p, &inetsw[sock->type]) {
> -		answer = list_entry(p, struct inet_protosw, list);
> +	list_for_each_entry_rcu(answer, &inetsw[sock->type], list) {
>  
>  		/* Check the non-wild match. */
>  		if (protocol == answer->protocol) {

Local variable 'p' is unused after this change, please delete
it.

> diff -urpNa -X dontdiff linux-2.6.25/net/ipv6/af_inet6.c linux-2.6.25-lfer-net/net/ipv6/af_inet6.c
> --- linux-2.6.25/net/ipv6/af_inet6.c	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.25-lfer-net/net/ipv6/af_inet6.c	2008-04-23 16:55:51.000000000 -0700
> @@ -105,8 +105,7 @@ static int inet6_create(struct net *net,
>  lookup_protocol:
>  	err = -ESOCKTNOSUPPORT;
>  	rcu_read_lock();
> -	list_for_each_rcu(p, &inetsw6[sock->type]) {
> -		answer = list_entry(p, struct inet_protosw, list);
> +	list_for_each_entry_rcu(answer, &inetsw6[sock->type], list) {
>  
>  		/* Check the non-wild match. */
>  		if (protocol == answer->protocol) {

Same here.

With those fixes:

Acked-by: David S. Miller <davem@davemloft.net>

Feel free to submit these yourself, together with your other
list RCU changes.

Thanks!
