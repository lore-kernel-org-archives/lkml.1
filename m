Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZDEMkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZDEMkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 08:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZDEMkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 08:40:40 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60651 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZDEMkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 08:40:39 -0400
Message-ID: <49D8A6BB.5000700@cosmosbay.com>
Date: Sun, 05 Apr 2009 14:40:27 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Graham Murray <graham@gmurray.org.uk>,
       "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: ip6tables fix
References: <20090329234702.4988017f@desktop.r000n.info>	<8763hja8cy.fsf@newton.gmurray.org.uk>	<20090405.012237.198610462.davem@davemloft.net>	<49D88162.5040809@cosmosbay.com> <87ws9z8l4c.fsf@newton.gmurray.org.uk> <49D88839.4090902@cosmosbay.com> <49D8A445.4060201@cosmosbay.com>
In-Reply-To: <49D8A445.4060201@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 05 Apr 2009 14:40:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> Graham Murray a écrit :
>>> iptables gives me no problems at all, it is just ip6tables that
>>> fails. The first indication of this is during the init scripts when
>>> ip6tables-restore fails.
>> I see, its a plain bug in net/ipv6/netfilter/ip6_tables.c
>> function alloc_counters() always returns -ENOMEM
>>
>> Unfortunatly , its Sunday here and I have to run for lunch time with family :)
>>
>> If nobody beats me, I will do the fix in a couple of hours...
> 
> Here is the fix, thanks Graham for the report !
> 
> [PATCH] netfilter: ip6tables fix
> 
> ip6_tables.c	 alloc_counters() misses a return statement, making
> ip6tables -N always failing and leaking memory.

Oh well, this ChangeLog is not correct :(

Here is an updated patch with correct ChangeLog, sorry David.
(-L instead of -N, and there was no memory leak involved)

[PATCH] netfilter: ip6tables fix

ip6_tables.c alloc_counters() misses a return statement, making
ip6tables -L always failing.

Reported-by: Graham Murray <graham@gmurray.org.uk>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index dfed176..800ae85 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1033,6 +1033,8 @@ static struct xt_counters *alloc_counters(struct xt_table *table)
 
 	xt_free_table_info(info);
 
+	return counters;
+
  free_counters:
 	vfree(counters);
  nomem:


