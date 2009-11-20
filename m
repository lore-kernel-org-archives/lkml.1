Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZKTCQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZKTCQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 21:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZKTCQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 21:16:49 -0500
Received: from www.tglx.de ([62.245.132.106]:45600 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224AbZKTCQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:16:49 -0500
Date: Fri, 20 Nov 2009 03:14:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jeff Law <law@redhat.com>, rostedt@goodmis.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       David Daney <ddaney@caviumnetworks.com>, Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <alpine.LFD.2.00.0911200206570.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911200307190.24119@localhost.localdomain>
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>   <4B05B7AD.20500@redhat.com> <1258670580.22249.1002.camel@gandalf.stny.rr.com> <4B05DBBF.5000804@redhat.com> <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain> <alpine.LFD.2.00.0911200206570.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009, Thomas Gleixner wrote:

> On Thu, 19 Nov 2009, Linus Torvalds wrote:
> > On Fri, 20 Nov 2009, Thomas Gleixner wrote:
> > > 
> > > While testing various kernel configs we found out that the problem
> > > comes and goes. Finally I started to compare the gcc command line
> > > options and after some fiddling it turned out that the following
> > > minimal deltas change the code generator behaviour:
> > > 
> > > Bad:  -march=pentium-mmx                -Wa,-mtune=generic32
> > > Good: -march=i686        -mtune=generic -Wa,-mtune=generic32
> > > Good: -march=pentium-mmx -mtune-generic -Wa,-mtune=generic32

Found some more:

Bad:  -march=k6                   -Wa,-mtune=generic32
Bad:  -march=geode                -Wa,-mtune=generic32
Bad:  -march=c3                   -Wa,-mtune=generic32

That seems every thing which has MMX support but no SSE and is somehow
compatible to the pentium-mmx.

Looks like the code generator optimization for those was done after
consuming the secret gcc-shrooms.

Thanks,

	tglx
