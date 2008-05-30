Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYE3Ld2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYE3Ld2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYE3LdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:33:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39611 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYE3LdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:33:17 -0400
Date: Fri, 30 May 2008 05:32:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Message-ID: <20080530113259.GE22636@parisc-linux.org>
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org> <Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com> <20080529222143.5d7aa1e5.akpm@linux-foundation.org> <483F981E.3040004@cosmosbay.com> <20080529231618.56e4028b.akpm@linux-foundation.org> <Pine.LNX.4.64.0805292321240.12457@schroedinger.engr.sgi.com> <20080529233758.7bd2c977.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529233758.7bd2c977.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:37:58PM -0700, Andrew Morton wrote:
> And struct nfs_iostats is 264 bytes and nfs does an alloc_percpu() of
> one of those per server and mounting thousands of servers per client
> is, I believe, a real-world operation.

Another example, not as extreme, there's an alloc_percpu(struct
disk_stats) [80 bytes on 64-bit machines] for every disk and every
partition in the machine.  The TPC system has 3000 disks, each with 14
partitions on it.  That's 15 * 80 * 3000 = 3,600,000 bytes.

Even if you're only putting a pointer to each allocation in the percpu
area, that's still 360,000 bytes, 12x as much as you think is sufficient
for the entire system.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
