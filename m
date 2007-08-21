Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbXHUXRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbXHUXRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbXHUXRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:17:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59801 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755213AbXHUXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:17:22 -0400
Date: Tue, 21 Aug 2007 16:17:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070821231216.GA29691@Krystal>
Message-ID: <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
References: <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
 <20070821231216.GA29691@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> SLUB Use cmpxchg() everywhere.
> 
> It applies to "SLUB: Single atomic instruction alloc/free using
> cmpxchg".

> +++ slab/mm/slub.c	2007-08-20 18:42:28.000000000 -0400
> @@ -1682,7 +1682,7 @@ redo:
>  
>  	object[c->offset] = freelist;
>  
> -	if (unlikely(cmpxchg_local(&c->freelist, freelist, object) != freelist))
> +	if (unlikely(cmpxchg(&c->freelist, freelist, object) != freelist))
>  		goto redo;
>  	return;
>  slow:

Ok so regular cmpxchg, no cmpxchg_local. cmpxchg_local does not bring 
anything more? My measurements did not show any difference. I measured on 
Athlon64. What processor is being used?

