Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbYACB7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbYACB7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYACB7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:59:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbYACB7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:59:11 -0500
Date: Wed, 2 Jan 2008 17:58:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <1199316785.3258.85.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>  <1199292381.3258.32.camel@localhost.localdomain>  <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>  <20080102194030.GC11638@parisc-linux.org>  <1199304735.3258.53.camel@localhost.localdomain> 
 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, James Bottomley wrote:
> > 
> > To say that another way:
> > 
> >  "the code is functionally equivalent, EXCEPT IT ISN'T, and it's 
> >   known to be broken".
> > 
> > wouldn't you say my version is more honest and correct?
> 
> No.  Just because a bug appears when a particular piece of code is in
> and disappears when it is reverted doesn't automatically equate to the
> code in question being buggy.

But it *DOES* mean that it's not equivalent.

> Look at the taxonomy of the bug.  This is the form of the error:
> 
> buffer I/O error on device sr0, logical block 20304
> attempt to access beyond end of device
> sr0: rw=0, want=81224, limit=40944
> 
> The last limit is the most suggestive, that comes straight from
> bdev->bd_inode->i_size>>9 and is supposed to be the size of the block
> device in 512 byte blocks. For a 4.7GB DVD, it's a little small.
> Nothing in the sr code sets this directly (although it does come from
> get_blkdev() for the first opener).  pktcdvd does set it, though ... and
> probably wrongly if the drive in question isn't UDF formatted.

.. but you're ignoring the fact that if pktcdvd sets it wrong, then it 
should be visible with the pre-commit kernel *also*.

In other words, you continue to ignore the fact that BEHAVIOUR CHANGED.

Why?

		Linus
