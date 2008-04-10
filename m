Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYDJPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYDJPhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYDJPhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:37:20 -0400
Received: from styx.suse.cz ([82.119.242.94]:54724 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756973AbYDJPhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:37:19 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Jan Kara <jack@suse.cz>
Subject: Re: file offset corruption on 32-bit machines?
Date: Thu, 10 Apr 2008 17:37:16 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Kosina <jkosina@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz> <20080410151945.GE6725@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080410151945.GE6725@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101737.16825.mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2008 05:19:45 pm Jan Kara wrote:
> > On Thu, 10 Apr 2008, Jan Kara wrote:
> > > > The f_pos races are in fact exploitable, we've already been there.
> > > > See for example
> > > > http://www.isec.pl/vulnerabilities/isec-0016-procleaks.txt
> > >
> > >   Well, this race is more subtle - the window is just one instruction
> > > wide (stores to f_pos from CPU2 must come between the store of lower
> > > and upper 32-bits of f_pos on CPU1). And the only result is that f_pos
> > > has 32-bits from one file pointer and 32-bits from the other one. So I
> > > can hardly imagine this would be exploitable...
> >
> > Supposing you are not holding any spinlock and are running with
> > preemptible kernel (pretty common scenario nowadays), there is nothing
> > that would prevent kernel from rescheduling between the two instructions,
> > enlarging the race window to be more comfortable for attacker, right?
>
>   Yes, this is theoretically possible.
>
> > I think this is worth fixing.
>
>   Hmm, maybe it is, although I still don't see how to exploit it :).

Maybe (just guess) some high priority malicious process could try to preempt 
reading thread to always in the bad moment (when the half of the f_pos is 
written) and thus forcing it to read bad data (you usually don't check that 
file position is growing after each read and you wait only for end of the 
file). 
But do agree, I still don't see something with really security implications 
(privileged processes usually don't work with such a big files).

>
> 									Honza


Best regards
-- 
Michal Hocko
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic 
