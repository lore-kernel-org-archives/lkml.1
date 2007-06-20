Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbXFTJOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbXFTJOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbXFTJOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:14:44 -0400
Received: from brick.kernel.dk ([80.160.20.94]:26689 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbXFTJOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:14:44 -0400
Date: Wed, 20 Jun 2007 11:14:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, davej@redhat.com,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Change in default vm_dirty_ratio
Message-ID: <20070620091404.GO18863@kernel.dk>
References: <1182201271.4883.22.camel@localhost.localdomain> <20070618164711.9de1c38e.akpm@linux-foundation.org> <20070620042434.GC12096@redhat.com> <20070619214407.dfff0ca6.akpm@linux-foundation.org> <1182328536.21117.24.camel@twins> <20070620015826.03f1d71a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620015826.03f1d71a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20 2007, Andrew Morton wrote:
> Perhaps our queues are too long - if the VFS _does_ back off, it'll take
> some time for that to have an effect.
> 
> Perhaps the fact that the queue size knows nothing about the _size_ of the
> requests in the queue is a problem.

It's complicated, the size may not matter a lot. 128 sequential 512kb IO
may complete faster than 128 random 4kb IO's.

> Back away even further here.
> 
> What user-visible problem(s) are we attemping to fix?

I'd like innocent-app-doing-little-write-or-fsync not being stalled by
big-bad-app-doing-lots-of-dirtying.

-- 
Jens Axboe

