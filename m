Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbXDDSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbXDDSu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXDDSuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:50:25 -0400
Received: from ozlabs.org ([203.10.76.45]:53775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbXDDSuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:50:23 -0400
Date: Wed, 4 Apr 2007 13:49:33 -0500
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-ID: <20070404184933.GA29184@kryten>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403135154.61e1b5f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Oh.  I was assuming that we'd want to unmap these pages from pagetables and
> mark then super-easily-reclaimable.  So a later touch would incur a minor
> fault.
> 
> But you think that we should leave them mapped into pagetables so no such
> fault occurs.

That would be very nice. The issues are not limited to threaded apps,
we have seen performance problems with single threaded HPC applications
that do a lot of large malloc/frees. It turns out the continual set up
and tear down of pagetables when malloc uses mmap/free is a problem. At
the moment the workaround is:

export MALLOC_MMAP_MAX_=0 MALLOC_TRIM_THRESHOLD_=-1

which forces glibc malloc to use brk instead of mmap/free. Of course brk
is good for keeping pagetables around but bad for keeping memory usage
down.

Anton
