Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbXLRXye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbXLRXye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXLRXy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:54:26 -0500
Received: from mx1.suse.de ([195.135.220.2]:51130 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbXLRXyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:54:25 -0500
Date: Wed, 19 Dec 2007 00:54:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] readahead: clean up and simplify the code for filemap page fault readahead
Message-ID: <20071218235423.GB20838@wotan.suse.de>
References: <20071216115927.986126305@mail.ustc.edu.cn> <20071216120417.748714367@mail.ustc.edu.cn> <20071218081907.GB32114@wotan.suse.de> <E1J4ay1-0000ak-3e@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J4ay1-0000ak-3e@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 07:50:33PM +0800, Fengguang Wu wrote:
> On Tue, Dec 18, 2007 at 09:19:07AM +0100, Nick Piggin wrote:
> > On Sun, Dec 16, 2007 at 07:59:30PM +0800, Fengguang Wu wrote:
> 
> > > +	read_lock_irq(&mapping->tree_lock);
> > > +	page = radix_tree_lookup(&mapping->page_tree, offset);
> > > +	if (likely(page)) {
> > > +		int got_lock, uptodate;
> > > +		page_cache_get(page);
> > > +
> > > +		got_lock = !TestSetPageLocked(page);
> > > +		uptodate = PageUptodate(page);
> > > +		read_unlock_irq(&mapping->tree_lock);
> > 
> > If we could avoid open coding tree_lock here (and expanding its coverage
> > to PageUptodate), that would be nice. I don't think it gains us too much.
> 
> To use find_get_page()? That would be nice to me, too.

Exactly.
