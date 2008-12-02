Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYLBUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYLBUdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYLBUdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:33:22 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37728 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751018AbYLBUdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:33:21 -0500
Date: Tue, 2 Dec 2008 15:33:15 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andres Freund <andres@anarazel.de>
Cc: Andreas Dilger <adilger@sun.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20081202203315.GA20858@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andres Freund <andres@anarazel.de>,
	Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812021847.35771.andres@anarazel.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 06:47:24PM +0100, Andres Freund wrote:
> 
> I think that I have seen the problem on metadata only changes (find
> /tmp -type f|xargs touch) as well, but sometimes metadata changes
> were possible while file creation was not.

Hmm...  really?  Was the error message ENOSPC, or something else?

The only way I can see that it might be ENOSPC would be if we got an
error in the jbd2 layer, in start_this_handle(), but that would have
resulted in a kernel printk:

	if (nblocks > journal->j_max_transaction_buffers) {
		printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
		       current->comm, nblocks,
		       journal->j_max_transaction_buffers);
		ret = -ENOSPC;
		goto out;
	}


If that wasn't too long ago, you might want to search your old system
log files in /var/log for any "JBD" or "ext4" messages.  That might be
an important clue, although that seems rather unlikely to me.  Or in
the case where metadata changes were failing, perhaps they were doing
so with some other error that ENOSPC?

   	   					- Ted
