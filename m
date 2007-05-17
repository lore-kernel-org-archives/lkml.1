Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbXEQDCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbXEQDCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbXEQDCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:02:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42953 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758502AbXEQDCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:02:41 -0400
Date: Wed, 16 May 2007 20:02:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <20070514131904.440041502@chello.nl>
Message-ID: <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Peter Zijlstra wrote:

> 
> In the interest of creating a reserve based allocator; we need to make the slab
> allocator (*sigh*, all three) fair with respect to GFP flags.
> 
> That is, we need to protect memory from being used by easier gfp flags than it
> was allocated with. If our reserve is placed below GFP_ATOMIC, we do not want a
> GFP_KERNEL allocation to walk away with it - a scenario that is perfectly
> possible with the current allocators.

And the solution is to fail the allocation of the process which tries to 
walk away with it. The failing allocation will lead to the killing of the 
process right?

We already have an OOM killer which potentially kills random processes. We 
hate it.

Could you please modify the patchset to *avoid* failure conditions. This 
patchset here only manages failure conditions. The system should not get 
into the failure conditions in the first place! For that purpose you may 
want to put processes to sleep etc. But in order to do so you need to 
figure out which processes you need to make progress.



