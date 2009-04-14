Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZDNSQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZDNSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZDNSQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:16:45 -0400
Received: from THUNK.ORG ([69.25.196.29]:57349 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZDNSQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:16:44 -0400
Date: Tue, 14 Apr 2009 14:16:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Message-ID: <20090414181632.GI955@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>,
	linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
References: <200904141636.26557.knikanth@novell.com> <20090414111838.GG5178@kernel.dk> <200904141711.20378.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904141711.20378.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:11:19PM +0530, Nikanth Karthikesan wrote:
> On Tuesday 14 April 2009 16:48:38 Jens Axboe wrote:
> >
> > It will not fail as long as __GFP_WAIT is set, which it is for all 6 of
> > your patches.

Um, before we take out the checks, can we please make sure this is a
guaranteed, documented behaviour?  In include/linux/page_alloc.h,
__GFP_NOFAIL is documented as "will never fail", but it says
absolutely nothing about __GFP_WAIT.

Some day, someone will create a static checker that will flag warnings
when people fail to check for allocation failures, and it would be
good if the formal semantics for __GFP_WAIT, and hence for GFP_NOFS,
GFP_KERNEL, and GFP_USER, et. al. are defined.

We have code in fs/jbd2/transaction.c that calls kzalloc with
GFP_NOFS|__GFP_NOFAIL, since I and many other people had the
assumption that without __GFP_NOFAIL, an GFP_NOFS allocation could
very well fail.

Or is this special-case behaviour which bio_alloc() guarantees, but
not necessarily any other allocation function?

					- Ted
