Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbXHOUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbXHOUcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXHOUcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:32:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33565 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751433AbXHOUcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:32:04 -0400
Date: Wed, 15 Aug 2007 13:32:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <1187186120.6114.56.camel@twins>
Message-ID: <Pine.LNX.4.64.0708151330180.7326@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com>  <20070815122253.GA15268@wotan.suse.de>
 <1187183526.6114.45.camel@twins>  <p731we43muw.fsf@bingen.suse.de>
 <1187186120.6114.56.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Peter Zijlstra wrote:

> The thing I strongly objected to was the 20%.

Well then set it to 10%. We have min_free_kbytes now and so we are used
to these limits.

> Also his approach misses the threshold - the extra condition needed to
> break out of the various network deadlocks. There is no point that says
> - ok, and now we're in trouble, drop anything non-critical. Without that
> you'll always run into a wall.

Networking?

> That is his second patch-set, and I do worry about the irq latency that
> that will introduce. It very much has the potential to ruin everything
> that cares about interactiveness or latency.

Where is the patchset introducing additional latencies? Most of the time 
it only saves and restores flags. We already enable and disable interrupts 
in the reclaim path but we assume that interupts are always enabled when 
we enter reclaim.

