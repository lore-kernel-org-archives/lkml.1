Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXFNVUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXFNVUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXFNVUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:20:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56619 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbXFNVUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:20:05 -0400
Date: Thu, 14 Jun 2007 14:20:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
In-Reply-To: <20070614130645.cabdff1b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Andrew Morton wrote:

> If we never inflict variable PAGE_CACHE_SIZE upon the kernel, these changes
> become pointless obfuscation.

But there is no such resonable scenario that I am aware of unless we 
continue to add workarounds for the issues covered here to the VM.

And it was pointed out to you that such approach can never stand in place 
of the different uses of having a larger page cache.

> I think the best way to proceed would be to investigate that _general_
> optimisation and then, based upon the results of that work, decide whether
> further _specialised_ changes such as variable PAGE_CACHE_SIZE are needed,
> and if so, what they should be.

As has been pointed out performance is only one beneficial issue of
having a higher page cache. It is doubtful in principle that the proposed 
alternative can work given that locking overhead and management overhead
by the VM are not minimized but made more complex by your envisioned 
solution.

The solution here significantly cleans up the page cache even if we never 
go to the variable page cache. If we do get there then numerous 
workarounds that we have in the tree because of not supporting larger I/O 
go away cleaning up the VM further. The large disk sizes can be handled in 
a reasonable way (f.e. fsck times would decrease) since we can handle
large contiguous chunks of memory. This is a necessary strategic move for 
the Linux kernel. It would also pave the way of managing large chunks
of contiguous memory for other ways and has the potential of getting rid
of such sore spots as the hugetlb filesystem.



