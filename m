Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbYDJPWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbYDJPWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbYDJPWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:22:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55923 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636AbYDJPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:22:13 -0400
Date: Thu, 10 Apr 2008 17:22:12 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410152212.GF6725@atrey.karlin.mff.cuni.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz> <20080410142700.GC6725@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz> <20080410144839.GQ11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410144839.GQ11962@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 10, 2008 at 04:31:09PM +0200, Jiri Kosina wrote:
> > >   Well, this race is more subtle - the window is just one instruction
> > > wide (stores to f_pos from CPU2 must come between the store of lower and
> > > upper 32-bits of f_pos on CPU1). And the only result is that f_pos has
> > > 32-bits from one file pointer and 32-bits from the other one. So I can
> > > hardly imagine this would be exploitable...
> > 
> > Supposing you are not holding any spinlock and are running with 
> > preemptible kernel (pretty common scenario nowadays), there is nothing 
> > that would prevent kernel from rescheduling between the two instructions, 
> > enlarging the race window to be more comfortable for attacker, right?
> > 
> > I think this is worth fixing.
> 
> Seems a lot like reading jiffies to me.  Is the seqlock the right
> solution to use for fixing this?
  You can get your inspiration in the implementation of i_size_read()
and i_size_write() functions :). They deal with exactly the same problem.
But in the case of f_pos, the number of readers and writers is balanced so
maybe a spinlock would be fine as well...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
