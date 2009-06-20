Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZFTKCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZFTKCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 06:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZFTKCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 06:02:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZFTKCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 06:02:13 -0400
Date: Sat, 20 Jun 2009 12:09:32 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] profile: Suppress warning about large allocations when
 profile=1 is specified
Message-ID: <20090620100932.GA5863@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
 <20090616223649.719ea378.akpm@linux-foundation.org>
 <20090617111800.GA15261@elte.hu>
 <20090617113120.GA5061@elte.hu>
 <20090617113534.GA21276@elte.hu>
 <20090617121913.GC28529@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617121913.GC28529@csn.ul.ie>
Organization: private site
X-PGP-Key-Id: 0x3FAF957D
User-Agent: Mutt/1.5.20+20090615 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX19jKFiBLNN+3aDSU5WGIqRRKwexAye+t46s1fU
 PHwHDDomVmDQ6DUF7NR2FtIPe7Gd1Rv6CqFmfUKc+6kOr4VQGh
 t2bfqfxqMf4zG4yrDVSH3YQ1Rshh2v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.06.2009, Mel Gorman wrote: 

> Patch as follows
[....]

With 2.6.30-git14, I get this early in the boot process. 
Don't know if it's related to this thread. In any case, your patch does not fix it:

[....]
WARNING: at mm/page_alloc.c:1744 level2_spare_pgt+0x8f70a/0x36c800()
Hardware name:  
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.30-git14 #1
Call Trace:
 [<ffffffff8109770a>] ? level2_spare_pgt+0x8f70a/0x36c800
 [<ffffffff8109770a>] ? level2_spare_pgt+0x8f70a/0x36c800
 [<ffffffff81044a19>] ? level2_spare_pgt+0x3ca19/0x36c800
 [<ffffffff8109770a>] ? level2_spare_pgt+0x8f70a/0x36c800
 [<ffffffff810463f2>] ? level2_spare_pgt+0x3e3f2/0x36c800
 [<ffffffff810bf8bb>] ? level2_spare_pgt+0xb78bb/0x36c800
 [<ffffffff81096829>] ? level2_spare_pgt+0x8e829/0x36c800
 [<ffffffff815281a2>] ? __smp_locks_end+0x33a4a/0x35773
 [<ffffffff815280b0>] ? __smp_locks_end+0x33958/0x35773
 [<ffffffff8100904b>] ? level2_spare_pgt+0x104b/0x36c800
 [<ffffffff81119808>] ? level2_spare_pgt+0x111808/0x36c800
 [<ffffffff81084df1>] ? level2_spare_pgt+0x7cdf1/0x36c800
 [<ffffffff814f5665>] ? __smp_locks_end+0xf0d/0x35773
 [<ffffffff8100ce0a>] ? level2_spare_pgt+0x4e0a/0x36c800
 [<ffffffff814f54e9>] ? __smp_locks_end+0xd91/0x35773
 [<ffffffff8100ce00>] ? level2_spare_pgt+0x4e00/0x36c800
---[ end trace 692ffa03e0502250 ]---
CCID: Activated CCID 2 (TCP-like)
registered taskstats version 1
Freeing unused kernel memory: 572k freed
[....]

Regards,
Heinz.
