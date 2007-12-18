Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbXLRLut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbXLRLut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXLRLum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:50:42 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50992 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751149AbXLRLul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:50:41 -0500
Message-ID: <397978643.20708@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 18 Dec 2007 19:50:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] readahead: clean up and simplify the code for
	filemap page fault readahead
References: <20071216115927.986126305@mail.ustc.edu.cn> <20071216120417.748714367@mail.ustc.edu.cn> <20071218081907.GB32114@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218081907.GB32114@wotan.suse.de>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J4ay1-0000ak-3e@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 09:19:07AM +0100, Nick Piggin wrote:
> On Sun, Dec 16, 2007 at 07:59:30PM +0800, Fengguang Wu wrote:

> > +	read_lock_irq(&mapping->tree_lock);
> > +	page = radix_tree_lookup(&mapping->page_tree, offset);
> > +	if (likely(page)) {
> > +		int got_lock, uptodate;
> > +		page_cache_get(page);
> > +
> > +		got_lock = !TestSetPageLocked(page);
> > +		uptodate = PageUptodate(page);
> > +		read_unlock_irq(&mapping->tree_lock);
> 
> If we could avoid open coding tree_lock here (and expanding its coverage
> to PageUptodate), that would be nice. I don't think it gains us too much.

To use find_get_page()? That would be nice to me, too.

