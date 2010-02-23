Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0BWDXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 22:23:37 -0500
Received: from thunk.org ([69.25.196.29]:53534 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0BWDXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 22:23:36 -0500
Date: Mon, 22 Feb 2010 22:23:17 -0500
From: tytso@mit.edu
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100223032317.GG23832@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
	stable@kernel.org, gregkh@suse.de
References: <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
 <20100216230017.GJ3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161524210.4141@localhost.localdomain>
 <20100217013336.GK3153@quack.suse.cz>
 <alpine.LFD.2.00.1002161848370.4141@localhost.localdomain>
 <20100217043009.GZ5337@thunk.org>
 <alpine.LFD.2.00.1002162052230.4141@localhost.localdomain>
 <20100222172938.GA2601@quack.suse.cz>
 <20100222210112.GE23832@thunk.org>
 <20100223025350.GC22370@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223025350.GC22370@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 01:53:50PM +1100, Dave Chinner wrote:
> 
> Ignoring nr_to_write completely can lead to issues like we used to
> have with XFS - it would write an entire extent (8GB) at a time and
> starve all other writeback. Those starvation problems - which were
> very obvious on NFS servers - went away when we trimmed back the
> amount to write in a single pass to saner amounts...

How do you determine what a "sane amount" is?  Is it something that is
determined dynamically, or is it a hard-coded or manually tuned value?

> As to a generic solution, why do you think I've been advocating
> separate per-sb data sync and inode writeback methods that separate
> data writeback from inode writeback for so long? ;)

Heh.

> > This is done to avoid a lock inversion, and so this is an
> > ext4-specific thing (at least I don't think XFS's delayed allocation
> > has this misfeature).
> 
> Not that I know of, but then again I don't know what inversion ext4
> is trying to avoid. Can you describe the inversion, Ted?

The locking order is journal_start_handle (starting a micro
transaction in jbd) -> lock_page.  A more detailed description of why
this locking order is non-trivial for us to fix in ext4 can be found
in the description of commit f0e6c985.

Regards,

							- Ted
