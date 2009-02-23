Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbZBWKkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbZBWKkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZBWKkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:40:03 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:49451 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbZBWKkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:40:01 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 05:40:00 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18850.31567.212454.514549@cargo.ozlabs.ibm.com>
Date: Mon, 23 Feb 2009 21:32:47 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Sachin P. Sant" <sachinp@in.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linuxppc-dev@ozlabs.org, linux-ext4@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
In-Reply-To: <20090223021320.11019d64.akpm@linux-foundation.org>
References: <49A2705D.9030008@in.ibm.com>
	<20090223021320.11019d64.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> It looks like we died in ext3_xattr_block_get():
> 
> 		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
> 		       size);
> 
> Perhaps entry->e_value_offs is no good.  I wonder if the filesystem is
> corrupted and this snuck through the defenses.
> 
> I also wonder if there is enough info in that trace for a ppc person to
> be able to determine whether the faulting address is in the source or
> destination of the memcpy() (please)?

It appears to have faulted on a load, implicating the source.  The
address being referenced (0xc00000003f380000) doesn't look
outlandish.  I wonder if this kernel has CONFIG_DEBUG_PAGEALLOC turned
on, and what page size is selected?

Paul.
