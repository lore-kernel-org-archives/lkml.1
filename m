Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXDUHhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXDUHhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964989AbXDUHhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:37:14 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:16089 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865AbXDUHhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:37:12 -0400
X-AuditID: d80ac287-a869fbb000005f82-7a-4629bf27d36b 
Date: Sat, 21 Apr 2007 08:37:03 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE 2/2
In-Reply-To: <a36005b50704201424q3c07d457m6b2c468ff8a826c7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704210830310.26485@blonde.wat.veritas.com>
References: <46247427.6000902@redhat.com> <4627DBF0.1080303@redhat.com> 
 <20070420140316.e0155e7d.akpm@linux-foundation.org>
 <a36005b50704201424q3c07d457m6b2c468ff8a826c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 Apr 2007 07:37:11.0233 (UTC) FILETIME=[DF6A7B10:01C783E7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Ulrich Drepper wrote:
> 
> Just for reference: the MADV_CURRENT behavior is to throw away data in
> the range.

Not exactly.  The Linux MADV_DONTNEED never throws away data from a
PROT_WRITE,MAP_SHARED mapping (or shm) - it propagates the dirty bit,
the page will eventually get written out to file, and can be retrieved
later by subsequent access.  But the Linux MADV_DONTNEED does throw away
data from a PROT_WRITE,MAP_PRIVATE mapping (or brk or stack) - those
changes are discarded, and a subsequent access will revert to zeroes
or the underlying mapped file.  Been like that since before 2.4.0.

> The POSIX_MADV_DONTNEED behavior is to never lose data.
> I.e., file backed data is written back, anon data is at most swapped
> out.
