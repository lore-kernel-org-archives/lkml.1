Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbXIDUpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbXIDUpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbXIDUpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:45:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44853 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753474AbXIDUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:45:32 -0400
Date: Tue, 4 Sep 2007 13:45:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] slub - Use local_t protection
In-Reply-To: <20070904200429.GD8157@Krystal>
Message-ID: <Pine.LNX.4.64.0709041344040.6376@schroedinger.engr.sgi.com>
References: <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
 <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
 <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com>
 <20070827213845.GB9748@Krystal> <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com>
 <20070827222715.GA16982@Krystal> <Pine.LNX.4.64.0708271811200.10344@schroedinger.engr.sgi.com>
 <20070904200429.GD8157@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007, Mathieu Desnoyers wrote:

> @@ -1566,12 +1565,13 @@ redo:
>  		object[c->offset]) != object))
>  			goto redo;
>  
> -	put_cpu();
> +	local_exit(flags);
>  	if (unlikely((gfpflags & __GFP_ZERO)))
>  		memset(object, 0, c->objsize);
>  
>  	return object;
>  slow:
> +	local_exit(flags);

Here we can be rescheduled to another processors.

>  	return __slab_alloc(s, gfpflags, node, addr, c)

c may point to the wrong processor.
