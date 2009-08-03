Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZHCRfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZHCRfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZHCRfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:35:08 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:20651 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZHCRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:35:07 -0400
X-Trace: 240668101/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.36.44/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.36.44
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEACy8dkpPRSQs/2dsb2JhbACBUtFGhBgF
X-IronPort-AV: E=Sophos;i="4.43,315,1246834800"; 
   d="scan'208";a="240668101"
Date: Mon, 3 Aug 2009 18:34:57 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/12] ksm: move pages_sharing updates
In-Reply-To: <20090803165315.GH23385@random.random>
Message-ID: <Pine.LNX.4.64.0908031821040.6178@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031310060.16754@sister.anvils> <20090803165315.GH23385@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, Andrea Arcangeli wrote:
> 
> If we stick to the subtraction semantics (that I think for users is
> less intuitive as they need to understand more of the ksm code to
> figure out what it means) sure ack...
> 
> I don't see the big deal of just printing total number of ksm pages in
> stable tree, and the actual _total_ number of userland mappings that
> are mapping those. The subtraction to see the actual sharing that is
> the difference between the two numbers, can be done by the user
> itself.

Yes, I know just what you mean.  When I first came to this, I rather
disliked that subtraction (though with this patch we have no actual
subtraction - but as you indicate, yes, that's an accident of the
internal implementation).  And it gets in the way of calculating
the ratio of ptes serviced to pages used.

But something I always find bothersome with /proc/meminfo is the
uncertainty about which numbers are included in which other numbers,
and which are exclusive.

So once I'd come to add the pages_unshared and pages_volatile,
I was really appreciating that these numbers are all simply
exclusive.

> 
> But then I'm fine if we stick to the substraction logic, this is a
> minor detail, I just usually prefer "raw" values. (if removing the
> inc/dec is beneficial at runtime as it seems then doing an addition
> will provide the info I would find more intuitive in  a more efficient
> way than before)

If you're also okay to stick with the subtraction logic, I think
let's continue to stick with it; but certainly it's something we
can easily change before 2.6.32, if people keep questioning it.

(I've tried to make it clear in ksm.txt, but people are likely
to question which way it is, whichever way it is - but it's
easier to say "they're all exclusive" than "this includes that,
but the others are exclusive").

> 
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks,
Hugh
