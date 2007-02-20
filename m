Return-Path: <linux-kernel-owner+w=401wt.eu-S965119AbXBTFF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119AbXBTFF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 00:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965130AbXBTFF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 00:05:29 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59425 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965119AbXBTFF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 00:05:29 -0500
Date: Mon, 19 Feb 2007 21:05:27 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mcr@sandelman.ca
Subject: Re: [PATCH] slab: ensure cache_alloc_refill terminates
In-Reply-To: <Pine.LNX.4.64.0702191020490.2085@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0702192102060.9934@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702191020490.2085@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Pekka J Enberg wrote:

> If slab->inuse is corrupted, cache_alloc_refill can enter an infinite
> loop as detailed by Michael Richardson in the following post:
> <http://lkml.org/lkml/2007/2/16/292>.

We have seen that corruption too.

>  		check_spinlock_acquired(cachep);
> +
> +		/*
> +		 * The slab was either on partial or free list so
> +		 * there must be at least one object available for
> +		 * allocation.
> +		 */
> +		BUG_ON(slabp->inuse >= cachep->num);

slabp->inuse is an integer and we have seen it become -1. The proposed 
test will not catch those cases.
