Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbXKPPvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbXKPPvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXKPPvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:51:45 -0500
Received: from [198.99.130.12] ([198.99.130.12]:58210 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbXKPPvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:51:44 -0500
Date: Fri, 16 Nov 2007 10:51:08 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Greg KH <greg@kroah.com>
Cc: Rob Landley <rob@landley.net>, WANG Cong <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken in 2.6.23.1)
Message-ID: <20071116155108.GA5453@c2.user-mode-linux.org>
References: <200711032351.52977.rob@landley.net> <20071115210608.GA12213@kroah.com> <20071116030832.GB2563@hacking> <200711152301.44040.rob@landley.net> <20071116071527.GE31582@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116071527.GE31582@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 11:15:27PM -0800, Greg KH wrote:
> Rob, I'll queue this up for the next cycle, now that you've verified
> that it was not fixed already, thanks for testing.

I wouldn't.

sparc includes swap.h in its pgtable.h.  Adding pagemap.h to swap.h
completes an include loop on sparc which blows up its build.

I have a set of patches to fix this in a different way, which I sent
out for comments a few weeks ago.  They
	add uaccess.h to various futexes.h because these will start
failing to build when the next patch is applied
	break the recursion by removing highmem.h from pagemap.h,
which needs nothing related to highmem, and sprinkle includes of
highmem.h in all the files which formerly got it through pagemap.h
	now, pagemap.h can be added to swap.h without blowing up sparc
	also, the other arches can include swap.h in their pgtables.h,
which they probably should since they define operations on
swp_entry_t, which is defined in swap.h.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

