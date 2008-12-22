Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYLVB4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYLVB4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 20:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYLVB4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 20:56:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:52057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbYLVB4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 20:56:23 -0500
Message-ID: <494EF3AA.9040100@kernel.org>
Date: Mon, 22 Dec 2008 10:55:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jens Axboe <jens.axboe@oracle.com>, Jerome Marchand <jmarchan@redhat.com>,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: per-cpu stats in block device: overkill?
References: <200812221049.43884.rusty@rustcorp.com.au>
In-Reply-To: <200812221049.43884.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Dec 2008 01:56:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
> Hi Jens, Tejun, Jerome,
> 
> I've been auditing alloc_per_cpu users, and got to genhd.  The code
> is fairly complex, but I can't help wondering if per-cpu counters
> are overkill.  After all, we have a single queue lock.

Yeah, maybe.

> The reason I care is that I'm changing alloc_per_cpu to use the
> static per-cpu area: at 40/80 bytes (32/64 bit) per stat, we'd be
> restricted to a few hundred disks unless the percpu area is enlarged
> (in current patches, a cmdline param).  Or, I can change genhd to
> use big_percpu_alloc which will use the current inefficient dynamic
> per-cpu system until we get dynamic per-cpu regions (if ever).

I'm working on local counter (local_t) allocator which is used to
replace percpu allocation in percpu_counter and used as basis for
percpu_ref which replaces module ref counting and will be used to
simplify block/char lifetime rules.

The local counter allocator allocates per-cpu pages and the space
overhead is minimal.  If per-cpu stats in genhd is necessary, I think
converting it to percpu local counter allocation should do it.

BTW, why make percpu area static?

Thanks.

-- 
tejun
