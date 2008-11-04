Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYKDWTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYKDWTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYKDWTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:19:36 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:50020 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbYKDWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:19:36 -0500
Date: Tue, 4 Nov 2008 16:17:52 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, rientjes@google.com,
       npiggin@suse.de, menage@google.com, dfults@sgi.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <20081104135004.f1717fcf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811041601100.5077@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
 <20081104124753.fb1dde5a.akpm@linux-foundation.org> <1225831988.7803.1939.camel@twins>
 <20081104131637.68fbe055.akpm@linux-foundation.org> <1225833710.7803.1993.camel@twins>
 <20081104135004.f1717fcf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Andrew Morton wrote:

> What are the alternatives here?  What do we need to do to make
> throttling a per-memcg thing?

Add statistics to the memcg lru and then you need some kind of sets of 
memcgs that are represented by bitmaps or so attached to an inode.

> The patchset is badly misnamed, btw.  It doesn't throttle writeback -
> in fact several people are working on IO bandwidth controllers and
> calling this thing "writeback throttling" risks confusion.

It is limiting dirty pages and throttling the dirty rate of applications 
in a  NUMA system (same procedure as we do in non NUMA). The excessive 
dirtying without this patchset can cause OOMs to occur on NUMA systems.

> What we're in fact throttling is rate-of-memory-dirtying.  The last
> thing we want to throttle is writeback - we want it to go as fast as
> possible!

We want to limit the amount of dirty pages such that I/O is progressing 
with optimal speeds for an application that significantly dirties memory. 
Other processes need to be still able to do their work without being 
swapped out because of excessive memory use for dirty pages by the first 
process.
