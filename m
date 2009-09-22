Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZIVAB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZIVAB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZIVAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:01:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:36135 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZIVAB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:01:26 -0400
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 10:00:03 +1000
Message-Id: <1253577603.7103.174.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 17:10 +0100, Mel Gorman wrote:
> 
> It needs signed-off from the powerpc side because it's now allocating
> more
> memory potentially (Ben?). An alternative to this patch is in V1 that
> statically declares the per-node structures but this is potentially
> sub-optimal but from a performance and memory utilisation perspective.

So if I understand correctly, we have a problem with both cpu-less and
memory-less nodes. Interesting setups :-)

I have no strong objection on the allocating of the per-cpu data for
the cpu-less nodes. However, I wonder if we should do that a bit more
nicely, maybe with some kind of "adjusted" cpu_possible_mask() (could be
something like cpu_node_valid_mask or similar) to be used by percpu.

Mostly because it would be nice to have built-in debug features in
per-cpu and in that case, it would need some way to know a valid
number from an invalid one). Either that or just keep track of the
mask of cpus that had percpu data allocated to them

Cheers,
Ben.


