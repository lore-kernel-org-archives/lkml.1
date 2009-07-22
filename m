Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZGVNGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZGVNGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZGVNGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:06:07 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:37754 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608AbZGVNGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:06:06 -0400
X-Trace: 233670711/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.68.55/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.68.55
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuAEACCrZkpPRUQ3/2dsb2JhbACBUc9WhA4F
X-IronPort-AV: E=Sophos;i="4.43,247,1246834800"; 
   d="scan'208";a="233670711"
Date: Wed, 22 Jul 2009 14:05:55 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       chrisw@redhat.com, avi@redhat.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] ksm resend
In-Reply-To: <20090721175909.GF2239@random.random>
Message-ID: <Pine.LNX.4.64.0907221359010.2482@sister.anvils>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <20090721175909.GF2239@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Andrea Arcangeli wrote:
> On Fri, Jul 17, 2009 at 08:30:40PM +0300, Izik Eidus wrote:
> > The code still need to get Andrea Arcangeli acks.
> > (he was busy and will ack it later).
> 
> Ack it all except that detail in 6/10

Thanks a lot, Andrea.

> as I'm unconvinced about ksm
> pages having to return 1 on PageAnon check. I believe they deserve a
> different bitflag in the mapping pointer. The smallest possible
> alignment for mapping pointer is 4 on 32bit archs so there is space
> for it

Yes, I believe they'll deserve that too, but set in addition to
PAGE_MAPPING_ANON.  And perhaps you or someone else will then have
another use for the new bit when PAGE_MAPPING_ANON is not set.

> and later it can be renamed EXTERNAL to generalize. We shall
> make good use of that bitflag as it's quite precious to introduce
> non-linearity in linear vmas, and not wire it to KSM only.

You have something in mind here...

> But in
> meantime we'll get better testing coverage by not having that PageKsm
> == PageAnon invariant I think that I doubt we're going to retain (at
> least with this implementation of PageKsm).

PageKsm subset of PageAnon: I expect to retain that.

Hugh
