Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXKBA7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXKBA7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXKBA6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:58:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46262 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753678AbXKBA6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:58:52 -0400
Date: Thu, 1 Nov 2007 17:58:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <472A5A7A.6020508@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711011757440.24589@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711010601430.27666@schroedinger.engr.sgi.com>
 <20071101.142936.114015234.davem@davemloft.net>
 <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com>
 <20071101.153824.91808126.davem@davemloft.net>
 <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
 <472A5A7A.6020508@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007, Eric Dumazet wrote:

> > Na. Some reasonable upper limit needs to be set. If we set that to say
> > 32Megabytes and do the virtual mapping then we can just populate the first
> > 2M and only allocate the remainder if we need it. Then we need to rely on
> > Mel's defrag stuff though defrag memory if we need it.
> 
> If a 2MB page is not available, could we revert using 4KB pages ? (like
> vmalloc stuff), paying an extra runtime overhead of course.

Sure. Its going to be like vmemmap. There will be limited imposed though 
by the amount of virtual space available. Basically the dynamic per cpu 
area can be at maximum

available_virtual_space / NR_CPUS

