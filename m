Return-Path: <linux-kernel-owner+w=401wt.eu-S2992475AbXDCWwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992475AbXDCWwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992476AbXDCWwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:52:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56507 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992475AbXDCWv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:51:59 -0400
Date: Wed, 4 Apr 2007 00:51:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-ID: <20070403225155.GA26567@one.firstfloor.org>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org> <4612C059.8070702@redhat.com> <4612C2B6.3010302@cosmosbay.com> <4612CB21.9020005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4612CB21.9020005@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 02:46:09PM -0700, Ulrich Drepper wrote:
> Eric Dumazet wrote:
> > A page fault is not that expensive. But clearing N*PAGE_SIZE bytes is,
> > because it potentially evicts a large part of CPU cache.
> 
> *A* page fault is not that expensive.  The problem is that you get a
> page fault for every single page.  For 200k allocated you get 50 page
> faults.  It quickly adds up.

If you know in advance you need them it might be possible to 
batch that. e.g. MADV_WILLNEED could be extended to
work on anonymous memory and establish the mappings in the syscall. 
Would that be useful? 

-Andi
