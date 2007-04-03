Return-Path: <linux-kernel-owner+w=401wt.eu-S1945952AbXDCVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945952AbXDCVRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945953AbXDCVRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:17:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945952AbXDCVRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:17:19 -0400
Date: Tue, 3 Apr 2007 14:16:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-Id: <20070403141656.1e25b878.akpm@linux-foundation.org>
In-Reply-To: <4612C059.8070702@redhat.com>
References: <46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403135154.61e1b5f3.akpm@linux-foundation.org>
	<4612C059.8070702@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 17:00:09 -0400
Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> > Oh.  I was assuming that we'd want to unmap these pages from pagetables and
> > mark then super-easily-reclaimable.  So a later touch would incur a minor
> > fault.
> > 
> > But you think that we should leave them mapped into pagetables so no such
> > fault occurs.
> 
> > Leaving the pages mapped into pagetables means that they are considerably
> > less likely to be reclaimed.
> 
> If we move the pages to a place where they are very likely to be
> reclaimed quickly (end of the inactive list, or a separate
> reclaim list) and clear the dirty and referenced lists, we can
> both reclaim the page easily *and* avoid the page fault penalty.
> 

ah, yes, you're right.  That part should work nicely.
