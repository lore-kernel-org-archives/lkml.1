Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbXJVWwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbXJVWwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXJVWwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:52:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64340 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbXJVWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:52:29 -0400
Date: Mon, 22 Oct 2007 09:11:13 -0400
From: Chris Mason <chris.mason@oracle.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH] rd: Use a private inode for backing storage
Message-ID: <20071022091113.0343602a@think.oraclecorp.com>
In-Reply-To: <m1d4v8b9ct.fsf@ebiederm.dsl.xmission.com>
References: <200710151028.34407.borntraeger@de.ibm.com>
	<200710210928.58265.borntraeger@de.ibm.com>
	<m1zlycc1ut.fsf@ebiederm.dsl.xmission.com>
	<200710211956.50624.nickpiggin@yahoo.com.au>
	<m1d4v8b9ct.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 12:39:30 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> 
> > On Sunday 21 October 2007 18:23, Eric W. Biederman wrote:
> >> Christian Borntraeger <borntraeger@de.ibm.com> writes:
> >
> >> Let me put it another way.  Looking at /proc/slabinfo I can get
> >> 37 buffer_heads per page.  I can allocate 10% of memory in
> >> buffer_heads before we start to reclaim them.  So it requires just
> >> over 3.7 buffer_heads on very page of low memory to even trigger
> >> this case.  That is a large 1k filesystem or a weird sized
> >> partition, that we have written to directly.
> >
> > On a highmem machine it it could be relatively common.
> 
> Possibly.  But the same proportions still hold.  1k filesystems
> are not the default these days and ramdisks are relatively uncommon.
> The memory quantities involved are all low mem.

It is definitely common during run time.  It was seen in practice enough
to be reproducible and get fixed for the non-ramdisk case.

The big underlying question is how which ramdisk usage case are we
shooting for. Keeping the ram disk pages off the LRU can certainly help
the VM if larger ramdisks used at runtime are very common.

Otherwise, I'd say to keep it as simple as possible and use Eric's
patch.  By simple I'm not counting lines of code, I'm counting overall
readability between something everyone knows (page cache usage) and
something specific to ramdisks (Nick's patch).

-chris
