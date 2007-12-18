Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbXLROco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbXLROco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXLROcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:32:36 -0500
Received: from smtp-dmz-232-tuesday.dmz.nerim.net ([195.5.254.232]:53986 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751641AbXLROcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:32:35 -0500
From: Damien Wyart <damien.wyart@free.fr>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>,
       Peter Leckie <pleckie@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
References: <20071218112804.GA3069@localhost.localdomain>
	<20071218122445.GJ4396912@sgi.com>
Date: Tue, 18 Dec 2007 15:30:31 +0100
In-Reply-To: <20071218122445.GJ4396912@sgi.com> (David Chinner's message of
	"Tue, 18 Dec 2007 23:24:45 +1100")
Message-ID: <877ijckrco.fsf@free.fr>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Chinner <dgc@sgi.com> [071218 13:24]:
> Ok. I haven't noticed anything wrong with directories up to about
> 250,000 files in the last few days. The ls -l I just did on
> a directory with 15000 entries (btree format) used about 5MB of RAM.
> extent format directories appear to work fine as well (tested 500
> entries).

Ok, nice to know the problem is not so frequent.

> Can you:

> 	a) isolate the problem to one patch or the other. My guess
> 	   would be the directory mod, but.....

Yes, it is indeed the directory patch. But even if I still sometimes get
huge memory usage with ls (using the patched kernel), this is quite
rare, and the problem is now mainly getting entries in the listing
repeated, and the ls process taking longer than without the patch. But
this is mainly after booting. I guess the cache plays a role and even
using drop_caches, I can't reproduce the problem. Only on fresh reboot
do I get it systematically, but much less often the memory problem. And
as said earlier, after fresh boot on rc5-git5 without the directory
patch, the ls -l goes normal (no repeated entries).

> 	b) show your working ;)

Sorry, I forgot this part in my initial report.

> 		- what platform (i386, x86_64, etc)

i386.

> 		- what debug options

Nothing special, the kernel has 4K stacks, and xfs partitions are
mounted with noatime,nodiratime.

> 		- commands and output that shows the problem

It is mainly "ls -l" in a quite crowded directory.

> 		- strace of ls -l going bad
> 		- xfs_info from filesystem in question

I have put the files at http://damien.wyart.free.fr/xfs/

strace_xfs_problem.1.gz and strace_xfs_problem.2.gz have been created
with the problematic kernel, and are quite bigger than
strace_xfs_problem.normal.gz, which has been created with the vanilla
rc5-git5. There is also xfs_info.


I can provide further details if needed (maybe kernel config, but
nothing special on the xfs side), but I confirm the behavior is
different with and without the directory patch
(041388b54ed95cd169546bd83bacd08ee32bd7ea on oss.sgi), and doesn't look
normal with the patch.

-- 
Damien Wyart
