Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbYDJOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYDJOs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYDJOsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:48:46 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56566 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYDJOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:48:45 -0400
Date: Thu, 10 Apr 2008 08:48:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410144839.GQ11962@parisc-linux.org>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz> <20080410142700.GC6725@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 04:31:09PM +0200, Jiri Kosina wrote:
> >   Well, this race is more subtle - the window is just one instruction
> > wide (stores to f_pos from CPU2 must come between the store of lower and
> > upper 32-bits of f_pos on CPU1). And the only result is that f_pos has
> > 32-bits from one file pointer and 32-bits from the other one. So I can
> > hardly imagine this would be exploitable...
> 
> Supposing you are not holding any spinlock and are running with 
> preemptible kernel (pretty common scenario nowadays), there is nothing 
> that would prevent kernel from rescheduling between the two instructions, 
> enlarging the race window to be more comfortable for attacker, right?
> 
> I think this is worth fixing.

Seems a lot like reading jiffies to me.  Is the seqlock the right
solution to use for fixing this?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
