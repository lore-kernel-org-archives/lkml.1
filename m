Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXKLIqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXKLIqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 03:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbXKLIp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 03:45:59 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43184 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbXKLIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 03:45:58 -0500
Subject: Re: dio_get_page() lockdep complaints
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-aio@kvack.org, Chris Mason <chris.mason@oracle.com>,
       linux-mm <linux-mm@kvack.org>, Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1194810546.6098.6.camel@lappy>
References: <20070419073828.GB20928@kernel.dk>
	 <1194627742.6289.175.camel@twins>  <4734992C.7000408@oracle.com>
	 <1194630300.7459.65.camel@heimdal.trondhjem.org>
	 <1194810546.6098.6.camel@lappy>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 12 Nov 2007 09:45:52 +0100
Message-Id: <1194857152.972.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-11-11 at 20:49 +0100, Peter Zijlstra wrote:
> Right, which gets us into all kinds of trouble because some sites need
> mmap_sem to resolve some races, notably s390 31-bit and shm.

You are refering to the mmap_sem use in compat_linux.c:do_mmap2, aren't
you? That check for adresses > 2GB after the call to do_mmap_pgoff can
be removed since arch_get_unmapped_area already checks against
TASK_SIZE. The result of the do_mmap_pgoff call will never be out of
range. This check is a left-over from the early days of the s390 compat
code.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


