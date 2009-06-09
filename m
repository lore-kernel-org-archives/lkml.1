Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbZFIMsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbZFIMsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZFIMsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:48:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:60363 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbZFIMsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:48:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,331,1241420400"; 
   d="scan'208";a="152242825"
Date: Tue, 9 Jun 2009 20:47:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Nai Xia <nai.xia@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
	in  the VM v3
Message-ID: <20090609124755.GA6583@localhost>
References: <20090528145021.GA5503@localhost> <ab418ea90906032325m302afbb6w6fa68f6b57f53e49@mail.gmail.com> <20090607160225.GA24315@localhost> <ab418ea90906080406y34981329y27d360624aa22f7c@mail.gmail.com> <20090608123133.GA7944@localhost> <ab418ea90906080746m6d1d59d8m395ab76585575db1@mail.gmail.com> <20090609064855.GB5490@localhost> <20090609104825.GJ14820@wotan.suse.de> <20090609121510.GB5589@localhost> <20090609121722.GC9158@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609121722.GC9158@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 08:17:22PM +0800, Nick Piggin wrote:
> On Tue, Jun 09, 2009 at 08:15:10PM +0800, Wu Fengguang wrote:
> > On Tue, Jun 09, 2009 at 06:48:25PM +0800, Nick Piggin wrote:
> > > On Tue, Jun 09, 2009 at 02:48:55PM +0800, Wu Fengguang wrote:
> > > > On Mon, Jun 08, 2009 at 10:46:53PM +0800, Nai Xia wrote:
> > > > > I meant PG_writeback stops writers to index---->struct page mapping.
> > > > 
> > > > It's protected by the radix tree RCU locks. Period.
> > > > 
> > > > If you are referring to the reverse mapping: page->mapping is procted
> > > > by PG_lock. No one should make assumption that it won't change under
> > > > page writeback.
> > > 
> > > Well... I think probably PG_writeback should be enough. Phrased another
> > > way: I think it is a very bad idea to truncate PG_writeback pages out of
> > > pagecache. Does anything actually do that?
> > 
> > There shall be no one. OK I will follow that convention.. 
> > 
> > But as I stated it is only safe do rely on the fact "no one truncates
> > PG_writeback pages" in end_writeback_io handlers. And I suspect if
> > there does exist such a handler, it could be trivially converted to
> > take the page lock.
> 
> Well, the writeback submitter first sets writeback, then unlocks
> the page. I don't think he wants a truncate coming in at that point.

OK. I think we've mostly agreed on the consequences of PG_writeback vs
truncation. I'll follow the least surprise principle and stop here, hehe.

Thanks,
Fengguang
