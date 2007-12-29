Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbXL2PVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbXL2PVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 10:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXL2PVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 10:21:01 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33453 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbXL2PVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 10:21:00 -0500
Subject: Re: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <E1J8UbJ-0007Be-E3@localhost>
References: <E1J8AC5-0002BE-RP@localhost> <1198841626.6821.92.camel@twins>
	 <1198859101.13075.10.camel@norville.austin.ibm.com>
	 <1198860794.13075.15.camel@norville.austin.ibm.com>
	 <E1J8RJw-0001ge-DP@localhost>
	 <1198903859.6353.7.camel@norville.austin.ibm.com>
	 <E1J8UbJ-0007Be-E3@localhost>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 09:20:37 -0600
Message-Id: <1198941637.8421.8.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 13:51 +0800, Fengguang Wu wrote:
> On Fri, Dec 28, 2007 at 10:50:59PM -0600, Dave Kleikamp wrote:
> > 
> > On Sat, 2007-12-29 at 10:21 +0800, Fengguang Wu wrote:

> > > This line should be moved below:
> > > > +	set_page_writeback(page);
> > 
> > No.  set_page_writeback() needs to be called before submit_bio() is
> > called.
> 
> Ah yes.
> 
> > I don't think there is any harm in calling set_page_writeback(),
> > redirty_page_for_writeback() and end_page_writeback() in the case where
> > there is no I/O to submit, and some dirty data cannot be written.  It is
> > consistent with what happens in __block_write_full_page().
> > 
> > It's also possible that some part of the page was written, and another
> > part cannot be, causing the page to be redirtied.
> 
> You are right. I revisited the code and there's nothing wrong with
> your patch :-)

Fengguang,

Thank you for all your help with this bug.  I've been on vacation and
hadn't had much time to look at it.  We'd probably still be scratching
our heads wondering where the problem was without your hard work.

Shaggy
> 
> Regards,
> Fengguang
> 
-- 
David Kleikamp
IBM Linux Technology Center

