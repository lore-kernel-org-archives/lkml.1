Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYCYRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYCYRua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbYCYRuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:50:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34010 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755195AbYCYRuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:50:11 -0400
Date: Tue, 25 Mar 2008 10:48:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
In-Reply-To: <20080324.144356.104645106.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0803251045510.16206@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
 <20080324.133722.38645342.davem@davemloft.net>
 <Pine.LNX.4.64.0803241402060.7762@schroedinger.engr.sgi.com>
 <20080324.144356.104645106.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, David Miller wrote:

> We should fix the underlying problems.
> 
> I'm hitting issues on 128 cpu Niagara2 boxes, and it's all fundamental
> stuff like contention on the per-zone page allocator locks.
> 
> Which is very fixable, without going to larger pages.

No its not fixable. You are doing linear optimizations to a slowdown that 
grows exponentially. Going just one order up for page size reduces the
necessary locks and handling of the kernel by 50%.
 
> > powerpc also runs HPC codes. They certainly see the same results
> > that we see.
> 
> There are ways to get large pages into the process address space for
> compute bound tasks, without suffering the well known negative side
> effects of using larger pages for everything.

These hacks have limitations. F.e. they do not deal with I/O and 
require application changes.
 
