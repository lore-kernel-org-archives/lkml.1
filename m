Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYBKKQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYBKKQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYBKKQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:16:44 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:35595 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYBKKQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:16:43 -0500
Date: Mon, 11 Feb 2008 13:15:30 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
Message-ID: <20080211101530.GA162@tv-sign.ru>
References: <20080130142014.GA2164@tv-sign.ru> <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu> <20080130172646.GA2355@tv-sign.ru> <20080203182952.GB5827@tv-sign.ru> <Pine.LNX.4.64.0802061957110.32204@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802061957110.32204@blonde.site>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay,

On 02/06, Hugh Dickins wrote:
> 
> On Sun, 3 Feb 2008, Oleg Nesterov wrote:
> > Off-topic question to all. sys_remap_file_pages() doesn't work with
> > shared readonly mappings, why?
> 
> Slight correction: it works with shared readonly mappings, doesn't
> it, so long as the mmap'ed file was opened for reading and writing?

Yes sure. I meant, if the file was opened without FMODE_WRITE, then
mmap(PROT_READ, MAP_SHARED) doesn't actually set VM_SHARED, it only
sets VM_MAYSHARE.

(this looks understandable, but means that !VM_SHARED doesn't necessary
 imply the possible cow).

> > IOW, why it checks VM_SHARED but not VM_MAYSHARE?
> 
> My guess has always been that it was just a misunderstanding of how
> those VM_ flags end up working: assume so unless Ingo corrects me.
> 
> By the time I realized that oddity, we'd been driven into several
> tiresome corners by the very existence of sys_remap_file_pages.
> So whereas my usual instinct would have been to relax the restriction
> and generalize, in its case I wanted to hold on to every restriction
> we had.

OK, thanks a lot. I was afraid I missed some "obvious" reason why we
can't do this.

Oleg.

