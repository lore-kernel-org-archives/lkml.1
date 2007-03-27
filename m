Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbXC0OHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbXC0OHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXC0OHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:07:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbXC0OHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:07:24 -0400
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	<20070323101452.GA15144@infradead.org>
	<20070324014024.GL17334@kvack.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2007 17:05:55 +0200
In-Reply-To: <20070324014024.GL17334@kvack.org>
Message-ID: <p733b3q6818.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> On Fri, Mar 23, 2007 at 10:14:52AM +0000, Christoph Hellwig wrote:
> > I think you're fixing the symptom here and not the cause.  If calculating
> > the virtual address of a page is so expensive on your setup it should
> > define WANT_PAGE_VIRTUAL and we should always cache the virtual address
> > in struct page.  There's a lot more code, epecially in filesystems that's
> > rather upset about a slow page_address.
> 
> Andi shot that down when I brought it up a while ago, as it does show 
> up in profiles for networking and other code paths.  His argument is that 
> the loss of memory is excessive.  Personally, I think the benefits of a 
> 64 byte struct page on x86-64 outweigh the memory loss, as it means page 
> index to address translations are a simple shift.

At some point I had plans to make virt_to_page() etc. faster
by using multiple look up tables that precompute some of the computation
depending on the caller. But it might possibly cause more cache misses
and the function didn't seem that time critical back then.

But if you can really measure it so clearly it might be worth revisiting
that. 

-Andi
