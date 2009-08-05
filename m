Return-Path: <linux-kernel-owner+w=401wt.eu-S934632AbZHEQU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632AbZHEQU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934023AbZHEQU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:20:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933961AbZHEQU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:20:26 -0400
Date: Wed, 5 Aug 2009 18:19:49 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
Cc: Avi Kivity <avi@redhat.com>, "Wu, Fengguang" <fengguang.wu@intel.com>,
       Rik van Riel <riel@redhat.com>, "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090805161949.GE23385@random.random>
References: <20090805024058.GA8886@localhost>
 <4A793B92.9040204@redhat.com>
 <20090805160504.GD23385@random.random>
 <9EECC02A4CC333418C00A85D21E89326B651C0BD@azsmsx502.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9EECC02A4CC333418C00A85D21E89326B651C0BD@azsmsx502.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 09:12:39AM -0700, Dike, Jeffrey G wrote:
> Sounds like there's some terminology confusion.  A refault is a page
> being discarded due to memory pressure and subsequently being
> faulted back in.  I was counting the number of faults between the
> discard and faulting back in for each affected page.  For a large
> number of predominately stack pages, that number was very small.

Hmm ok, but if it's anonymous pages we're talking about here (I see
KVM in the equation so it has to be!) normally we call that thing
swapin to imply I/O is involved, not refault...  Refault to me sounds
minor fault from swapcache (clean or dirty) and that's about it...

Anon page becomes swapcache, it is unmapped if young bit permits, and
then it's collected from lru eventually, if it is collected I/O will
be generated as swapin during the next page fault.

If it's too much swapin, then yes, it could be that patch that
prevents young bit to keep the anon pages in active list. But fix is
to remove the whole check, not just to enable list_add for anon pages.
