Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbYDKT1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbYDKT1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761692AbYDKT1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:27:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4297 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761653AbYDKT1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:27:22 -0400
Date: Fri, 11 Apr 2008 21:26:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080411192656.GB4492@ucw.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz> <20080410142700.GC6725@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410142700.GC6725@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-04-10 16:27:00, Jan Kara wrote:
> > On Thu, 10 Apr 2008, Michal Hocko wrote:
> > 
> > > > Jeff Robertson analyzes the behaviour of different operating systems'
> > > > 64-bit file offset implementation and concludes that on 32-bit
> > > > machines, Linux and Solaris lack any locking to keep the two 32-bit
> > > > halves in sync and this could cause rare file offset corruption.
> > > > http://jeffr-tech.livejournal.com/21014.html
> > > AFAICS, this race is theoretically possible, but it is very hard (almost 
> > > impossible) to trigger with a sane file usage pattern. Note that you 
> > > have to access shared struct file (same file descriptor) in different 
> > > threads which should be synchronized by caller anyway (*).
> > 
> > ... but not in cases the caller is an intentionally evil code, right? :)
>   Yes.
> 
> > > I also don't see any security implications from this race, but maybe 
> > > someone with more knowlage about fs can see (f_pos is used at many 
> > > places in the kernel code).
> > 
> > The f_pos races are in fact exploitable, we've already been there. See 
> > for example http://www.isec.pl/vulnerabilities/isec-0016-procleaks.txt
>   Well, this race is more subtle - the window is just one instruction
> wide (stores to f_pos from CPU2 must come between the store of lower and
> upper 32-bits of f_pos on CPU1). And the only result is that f_pos has
> 32-bits from one file pointer and 32-bits from the other one. So I can
> hardly imagine this would be exploitable...

Don't we have rlimit on max file size? I'd guess this could work
around it?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
