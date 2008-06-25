Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbYFYQTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbYFYQTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYFYQS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:18:56 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56851 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbYFYQSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:18:54 -0400
Date: Wed, 25 Jun 2008 20:18:02 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Message-ID: <20080625161802.GA20236@2ka.mipt.ru>
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <20080625131117.GA28136@2ka.mipt.ru> <E1KBV7H-0005nv-Gl@pomaz-ex.szeredi.hu> <20080625141654.GA4803@2ka.mipt.ru> <E1KBWBK-0006Lp-03@pomaz-ex.szeredi.hu> <20080625153025.GB21579@2ka.mipt.ru> <E1KBXOs-00074q-NU@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KBXOs-00074q-NU@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 05:59:14PM +0200, Miklos Szeredi (miklos@szeredi.hu) wrote:
> > Page is locked of course, but invalidated, removed from all trees and
> > caches, i.e. grab, lock, check, unlock... invalidate, write into that
> > page should fail, but it will not, since page is uptodate and
> > prepare_write does not check mapping at all.
> 
> But callers do check after having locked the page.

Yes, it is possible to check mapping, but it does not exist and it is
correct, that there is no mapping - we are just writing into page in
ram, kind of loop device, but without binding page into mapping.
And mapping itself is used just for its operations.

> > > > Instead of returning error when reading from invalid page, now you
> > > > return old content of it?
> > > 
> > > No, instead of returning a short count, it is now returning old
> > > content.
> > 
> > Or instead of returning error or zero and relookup page eventually,
> > which can already contain new data, we get old data.
> 
> Umm, it doesn't make any sense to try to always get fresh data.  If
> you do read() on a file, the data may become old and invalid a
> millisecond after the read finished.  We can't and needn't do anything
> about this.

Page reading from disk is atomic in respect that page is always locked,
now readpage(s) may not be called in some cases...

-- 
	Evgeniy Polyakov
