Return-Path: <linux-kernel-owner+w=401wt.eu-S2992948AbXDDP0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992948AbXDDP0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992949AbXDDPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:25:52 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35079 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992947AbXDDPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:25:30 -0400
X-AuditID: d80ac287-976cabb000000c42-86-4613c36992c9 
Date: Wed, 4 Apr 2007 16:25:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: missing madvise functionality
In-Reply-To: <4613BC5D.2070404@redhat.com>
Message-ID: <Pine.LNX.4.64.0704041610320.19450@blonde.wat.veritas.com>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de>
 <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org>
 <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com>
 <20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org>
 <20070403160231.33aa862d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com> <4613BC5D.2070404@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 Apr 2007 15:25:28.0945 (UTC) FILETIME=[79EF5610:01C776CD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Rik van Riel wrote:
> Hugh Dickins wrote:
> 
> > (I didn't understand how Rik would achieve his point 5, _no_ lock
> > contention while repeatedly re-marking these pages, but never mind.)
> 
> The CPU marks them accessed&dirty when they are reused.
> 
> The VM only moves the reused pages back to the active list
> on memory pressure.  This means that when the system is
> not under memory pressure, the same page can simply stay
> PG_lazyfree for multiple malloc/free rounds.

Sure, there's no need for repetitious locking at the LRU end of it;
but you said "if the system has lots of free memory, pages can go
through multiple free/malloc cycles while sitting on the dontneed
list, very lazily with no lock contention".  I took that to mean,
with userspace repeatedly madvising on the ranges they fall in,
which will involve mmap_sem and ptl each time - just in order
to check that no LRU movement is required each time.

(Of course, there's also the problem that we don't leave our
systems with lots of free memory: some LRU balancing decisions.)

Hugh
