Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYDRO5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYDRO5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYDRO5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:57:17 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:29280 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYDRO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:57:16 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-mm1: not looking good
Date: Fri, 18 Apr 2008 10:57:12 -0400
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, penberg@cs.helsinki.fi,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jmorris@namei.org, sds@tycho.nsa.gov
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <200804171955.46600.paul.moore@hp.com> <20080417183538.d88feff5.akpm@linux-foundation.org>
In-Reply-To: <20080417183538.d88feff5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804181057.12246.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008 9:35:38 pm Andrew Morton wrote:
> I dropped git-selinux and that crash seems to have gone away.  It
> took about five minutes before, but would presumably have happened
> earlier if I'd reduced the cache size.
>
> btw, wouldn't this
>
> --- a/security/selinux/netnode.c~a
> +++ a/security/selinux/netnode.c
> @@ -190,7 +190,7 @@ static int sel_netnode_insert(struct sel
>  	if (sel_netnode_hash[idx].size == SEL_NETNODE_HASH_BKT_LIMIT) {
>  		struct sel_netnode *tail;
>  		tail = list_entry(node->list.prev, struct sel_netnode, list);
> -		list_del_rcu(node->list.prev);
> +		list_del_rcu(&tail->list);
>  		call_rcu(&tail->rcu, sel_netnode_free);
>  	} else
>  		sel_netnode_hash[idx].size++;
> _
>
> be a bit clearer?  If it's correct - I didn't try too hard :)

Looks good to me, although before I fix this let me try and figure out 
why this code is causing the machine to puke all over itself.  
Priorities you know :)

-- 
paul moore
linux @ hp
