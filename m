Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbXKAM5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbXKAM5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXKAM5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:57:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47613 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753263AbXKAM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:57:14 -0400
Date: Thu, 1 Nov 2007 05:57:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <47297DA6.5070904@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711010555390.27666@schroedinger.engr.sgi.com>
References: <20071101000211.970501947@sgi.com> <47297DA6.5070904@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Eric Dumazet wrote:

> I think this question already came in the past and Linus already answered it,
> but I again ask it. What about VM games with modern cpus (64 bits arches)
> 
> Say we reserve on x86_64 a really huge (2^32 bytes) area, and change VM layout
> so that each cpu maps its own per_cpu area on this area, so that the local
> per_cpu data sits in the same virtual address on each cpu. Then we dont need a
> segment prefix nor adding a 'per_cpu offset'. No need to write special asm
> functions to read/write/increment a per_cpu data and gcc could use normal
> rules for optimizations.
> 
> We only would need adding "per_cpu offset" to get data for a given cpu.

That is basically what IA64 is doing but it not usable because you would 
have addresses that mean different things on different cpus. List head
for example require back pointers. If you put a listhead into such a per 
cpu area then you may corrupt another cpus per cpu area.
 
