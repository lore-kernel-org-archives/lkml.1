Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYKDDjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYKDDjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 22:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYKDDjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 22:39:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:56458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYKDDjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 22:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v6nvlqV0MVKbNamqFwhMuHcO4Q6pOxjtoVe1Z2d5St4slEu+mFb6d4AWR6JfCjdaAJ
         7wXDGugKURVyoEw4LEkYDBA3AHAzAZu9ysmoUGXI9JO64JxllilhZ9BcKz1B3hcQxwOd
         nV0V+XhJx9Zr5nXWJ1aSHfAYLKY9EY6dTxxiE=
Date: Tue, 4 Nov 2008 06:42:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: cl@linux-foundation.org, rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Broken "cpualloc: the allocator" patch
Message-ID: <20081104034237.GA15227@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

next-20081103 fails to boot for me because of (1). Commit right before it
boot normally. It hangs right after "Booting the kernel" with the only message

	PANIC: early exception 06 rip 10:ffffffff80523801 error 0 cr2 0

x86_64, no debugging config (all debugging fails same way)
Core 2 Duo, NR_CPUS=2.

1.

192ed0da59d0a13f6db0d7924b1cb72ecadcd1e7 is first bad commit
commit 192ed0da59d0a13f6db0d7924b1cb72ecadcd1e7
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Mon Oct 27 14:45:46 2008 -0500

    cpualloc: the allocator
    
    The per cpu allocator allows dynamic allocation of memory on all
    processors simultaneously.  A bitmap is used to track used areas.  The
    allocator implements tight packing to reduce the cache footprint and
    increase speed since cacheline contention is typically not a concern for
    memory mainly used by a single cpu.  Small objects will fill up gaps left
    by larger allocations that required alignments.
    
    The size of the cpu_alloc area can be changed via the percpu=xxx kernel
    parameter.
    
    Acked-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

:040000 040000 68e7b2e64f11ae322c45caa3993bd6017eff1708 b38c34905a19ed702c797b697823107c2269ad1e M	include
:040000 040000 9d4981a79d91b917c43869ca59e16a45d77f4698 e59d5cf6ba16887485ff1d26f4552ce187e2ba66 M	init
:040000 040000 1f726d0030ec1ebf2f30768e88495dab74a56627 93d9b5f16b2cad3a435ae33f569ff7814070e58b M	mm
