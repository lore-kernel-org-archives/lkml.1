Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZHFKQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZHFKQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZHFKQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:16:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59550 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbZHFKQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:16:31 -0400
Date: Thu, 6 Aug 2009 12:15:53 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090806101553.GP23385@random.random>
References: <20090805024058.GA8886@localhost>
 <20090805155805.GC23385@random.random>
 <4A79C486.1010809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A79C486.1010809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 01:42:30PM -0400, Rik van Riel wrote:
> Andrea Arcangeli wrote:
> > On Wed, Aug 05, 2009 at 10:40:58AM +0800, Wu Fengguang wrote:
> >>  			 */
> >> -			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
> >> +			if ((vm_flags & VM_EXEC) || PageAnon(page)) {
> >>  				list_add(&page->lru, &l_active);
> >>  				continue;
> >>  			}
> >>
> > 
> > Please nuke the whole check and do an unconditional list_add;
> > continue; there.
> 
> <riel> aa: so you're saying we should _never_ add pages to the active 
> list at this point in the code
> <aa> right
> <riel> aa: and remove the list_add and continue completely
> <aa> yes
> <riel> aa: your email says the opposite :)

Posted more meaningful explanation in self-reply to the email that
said the opposite, which tries to explains why I changed my mind (well
my focus really was on VM_EXEC and I didn't change my mind about yet
but then I'm flexible so I'm listening if somebody thinks it's good
thing to keep it). The irc quote was greatly out of context and it
missed all the previous conversation... I hope my mail explains my
point in more detail than the above.
