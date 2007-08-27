Return-Path: <linux-kernel-owner+w=401wt.eu-S1764283AbXH0WMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764283AbXH0WMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbXH0WMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:12:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46229 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756973AbXH0WMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:12:20 -0400
Date: Mon, 27 Aug 2007 15:12:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070827213845.GB9748@Krystal>
Message-ID: <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com>
References: <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
 <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
 <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
 <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
 <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com>
 <20070827213845.GB9748@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> > The slow path would require disable preemption and two interrupt disables.
> If the slow path have to call new_slab, then yes. But it seems that not
> every slow path must call it, so for the other slow paths, only one
> interrupt disable would be required.

If we include new_slab then we get to 3 times:

1. In the cmpxchg_local emulation that fails

2. For the slow path

3. When calling the page allocator.

