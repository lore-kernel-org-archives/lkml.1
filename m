Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbXKAND6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbXKAND6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbXKANDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:03:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36768 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760693AbXKANDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:03:45 -0400
Date: Thu, 1 Nov 2007 06:03:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071101.021451.217578606.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711010601430.27666@schroedinger.engr.sgi.com>
References: <20071031.181335.207429553.davem@davemloft.net>
 <Pine.LNX.4.64.0710312115520.26072@schroedinger.engr.sgi.com>
 <20071101.000118.208338243.davem@davemloft.net> <20071101.021451.217578606.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, David Miller wrote:

> > This hunk helped the sparc64 looping OOPS I was getting, but cpus hang
> > in some other fashion soon afterwards.
> 
> And if I bump PER_CPU_ALLOC_SIZE up to 128K it seems to mostly work.

Good....

> You'll definitely need to make this work dynamically somehow.

Obviously. Any ideas how?

I can probably calculate the size based on the number of online nodes when 
the per cpu areas are setup. But the setup is done before we even parse 
command line arguments. That would still mean a fixed size after bootup.

In order to make it truly dynamic we would have to virtually map the area. 
vmap? But that reduces performance.

