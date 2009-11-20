Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZKTAh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZKTAh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbZKTAh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:37:56 -0500
Received: from www.tglx.de ([62.245.132.106]:41907 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061AbZKTAh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:37:56 -0500
Date: Fri, 20 Nov 2009 01:36:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Law <law@redhat.com>
cc: rostedt@goodmis.org, "H. Peter Anvin" <hpa@zytor.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <4B05DBBF.5000804@redhat.com>
Message-ID: <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>   <4B05B7AD.20500@redhat.com> <1258670580.22249.1002.camel@gandalf.stny.rr.com> <4B05DBBF.5000804@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Jeff Law wrote:
> On 11/19/09 15:43, Steven Rostedt wrote:
> > On Thu, 2009-11-19 at 14:25 -0700, Jeff Law wrote:
> > 
> >    
> > > Having said all that, I don't expect to personally be looking at the
> > > problem, given the list of other codegen issues that need to be looked
> > > at (reload in particular), profiling/stack interactions would be around
> > > 87 millionth on my list.
> > >      
> > Is there someone else that can look at it?
> > 
> >    
> Unsure at the moment...  Like everyone else, GCC developers are busy and this
> probably isn't going to be a high priority item for anyone.
> 
> 
> > Or at the very least, could you point us to where that code is, and one
> > of us tracing folks could take a crack at switching hats to be a
> > compiler writer (with the obvious prerequisite of drinking a lot of beer
> > first, or is there a better drug to cope with the pain of writing gcc?).
> >    
> It _might_ be as easy as defining PROFILE_BEFORE_PROLOGUE in
> gcc-<someversion>gcc/config/i386/linux.h & rebuilding GCC.
> 
> Based on comments elsewhere, the sun386i support may have used
> PROFILE_BEFORE_PROLOGUE in the past and thus the x86 backend may not need
> further adjustment.  That is obviously the ideal case.
> 
> If that appears to work for your needs, I'll volunteer to test it more
> thoroughly and assuming those tests look good shepherd it into the source
> tree.

We definitely want to see that ASAP.

While testing various kernel configs we found out that the problem
comes and goes. Finally I started to compare the gcc command line
options and after some fiddling it turned out that the following
minimal deltas change the code generator behaviour:

Bad:  -march=pentium-mmx                -Wa,-mtune=generic32
Good: -march=i686        -mtune=generic -Wa,-mtune=generic32
Good: -march=pentium-mmx -mtune-generic -Wa,-mtune=generic32

I'm not supposed to understand the logic behind that, right ?

Thanks,

	tglx
