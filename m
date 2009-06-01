Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbZFAMrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbZFAMrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZFAMrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:47:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:14535 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZFAMrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,284,1241420400"; 
   d="scan'208";a="149204295"
Date: Mon, 1 Jun 2009 20:46:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
	in the VM v4
Message-ID: <20090601124657.GA30813@localhost>
References: <200905291135.124267638@firstfloor.org> <20090529213539.4FACC1D0296@basil.firstfloor.org> <20090601111641.GA5018@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601111641.GA5018@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 07:16:41PM +0800, Nick Piggin wrote:
> On Fri, May 29, 2009 at 11:35:39PM +0200, Andi Kleen wrote:
> > +	mapping = page_mapping(p);
> > +	if (!PageDirty(p) && !PageWriteback(p) &&
> > +	    !PageAnon(p) && !PageSwapBacked(p) &&
> > +	    mapping && mapping_cap_account_dirty(mapping)) {
> 
> Haven't had another good look at this yet, but if you hold the
> page locked, and have done a wait_on_page_writeback, then
> PageWriteback == true is a kernel bug.

Right, we can eliminate the PageWriteback() test when there is a
wait_on_page_writeback().
