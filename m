Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYDJO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYDJO1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYDJO1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:27:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYDJO1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:27:01 -0400
Date: Thu, 10 Apr 2008 16:27:00 +0200
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410142700.GC6725@atrey.karlin.mff.cuni.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 10 Apr 2008, Michal Hocko wrote:
> 
> > > Jeff Robertson analyzes the behaviour of different operating systems'
> > > 64-bit file offset implementation and concludes that on 32-bit
> > > machines, Linux and Solaris lack any locking to keep the two 32-bit
> > > halves in sync and this could cause rare file offset corruption.
> > > http://jeffr-tech.livejournal.com/21014.html
> > AFAICS, this race is theoretically possible, but it is very hard (almost 
> > impossible) to trigger with a sane file usage pattern. Note that you 
> > have to access shared struct file (same file descriptor) in different 
> > threads which should be synchronized by caller anyway (*).
> 
> ... but not in cases the caller is an intentionally evil code, right? :)
  Yes.

> > I also don't see any security implications from this race, but maybe 
> > someone with more knowlage about fs can see (f_pos is used at many 
> > places in the kernel code).
> 
> The f_pos races are in fact exploitable, we've already been there. See 
> for example http://www.isec.pl/vulnerabilities/isec-0016-procleaks.txt
  Well, this race is more subtle - the window is just one instruction
wide (stores to f_pos from CPU2 must come between the store of lower and
upper 32-bits of f_pos on CPU1). And the only result is that f_pos has
32-bits from one file pointer and 32-bits from the other one. So I can
hardly imagine this would be exploitable...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
