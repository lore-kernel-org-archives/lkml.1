Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYCRN7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYCRN7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYCRN7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:59:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYCRN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:59:30 -0400
Subject: Re: [patch 4/8] mm: allow not updating BDI stats in
	end_page_writeback()
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <E1JbcKL-00060V-9N@pomaz-ex.szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191945.122011759@szeredi.hu> <1205840031.8514.346.camel@twins>
	 <E1JbaTH-0005jN-4r@pomaz-ex.szeredi.hu> <1205843375.8514.357.camel@twins>
	 <E1JbbHf-0005rm-R5@pomaz-ex.szeredi.hu> <1205845702.8514.365.camel@twins>
	 <E1JbcKL-00060V-9N@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 14:59:20 +0100
Message-Id: <1205848760.8514.366.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-18 at 14:58 +0100, Miklos Szeredi wrote:
> > > > So the thing that's in your way is that removing a page from the radix
> > > > tree doesn't imply its done writing. So perhaps we should make that
> > > > distinction instead?
> > > > 
> > > > So instead of conditionally do part of the accounting, never do it and
> > > > require something like: page_writeback_complete() to be called after a
> > > > successfull test_clear_page_writeback().
> > > 
> > > Yes, that's a possibility, but then normal filesystems miss out on the
> > > small optimization provided by doing the BDI accounting functions
> > > inside the same IRQ disabled region as the radix tree operation.
> > > Would that have any significant performance impact?
> > 
> > Yeah, realized that. Don't know, would have to measure it somehow...
> > some archs are rather slow with disabling IRQs, but we're talking about
> > writeout which should be dominated by the IO times.
> > 
> > Its just that your proposal exposes too much guts, I'd like the
> > interface to be a little higher level.
> 
> Well, but this is the kernel, you can't really make foolproof
> interfaces.  If we'll go with Andrew's suggestion, I'll add comments
> warning users about not touching those flags unless they know what
> they are doing, OK?

Yeah, I guess so :-)

