Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZEQL0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZEQL0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZEQL0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:26:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:51516 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbZEQL0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:26:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,207,1241420400"; 
   d="scan'208";a="143712841"
Date: Sun, 17 May 2009 19:25:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC][PATCH] vmscan: report vm_flags in page_referenced()
Message-ID: <20090517112550.GA3254@localhost>
References: <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <1241709466.11251.164.camel@twins> <20090508041700.GC8892@localhost> <28c262360905080509q333ec8acv2d2be69d99e1dfa3@mail.gmail.com> <20090508121549.GA17077@localhost> <28c262360905080701h366e071cv1560b09126cbc78c@mail.gmail.com> <20090509065640.GA6487@localhost> <20090511084500.2fccdc73.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511084500.2fccdc73.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 07:45:00AM +0800, Minchan Kim wrote:
> Sorry for late. 
> 
> On Sat, 9 May 2009 14:56:40 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Hmm, this reminded me of the mlocked page protection logic in
> > page_referenced_one(). Why shall the "if (vma->vm_flags & VM_LOCKED)"
> > check be placed *after* the page_check_address() check? Is there a
> > case that an *existing* page frame is not mapped to the VM_LOCKED vma?
> > And why not to protect the page in such a case?
> 
> 
> I also have been having a question that routine.
> As annotation said, it seems to prevent increaseing referenced counter for mlocked page to move the page to unevictable list ASAP.
> Is right?

That's right. And it is only stopping the reference count for the
current VMA - if the reference count has already been elevated, the
mlocked page will continue to float in the [in]active lists.

> But now, page_referenced use refereced variable as just flag not count. 
> So, I think referecned variable counted is meaningless. 

Yes kind of, but anyway it costs nothing :-)

Thanks,
Fengguang

