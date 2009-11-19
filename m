Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZKSUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZKSUF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZKSUFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:05:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:40181 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZKSUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i/yiXYqDAeyygsF1fsoV93/aaaSIv46ndSoZAdzcfYR9liw9TS7MGqxaW3vrnE/2CP
         NXXnd4lKLmD0Ax1ipbEnce7anylYhlDkxAY3DYm/SviHU06NR4zmJjd0GRBfJbtTUEIQ
         cr45xElbInM27A8CIzC2F0xtZIMV+t+5LpjPs=
Date: Thu, 19 Nov 2009 21:05:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kai Tietz <ktietz70@googlemail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
Message-ID: <20091119200524.GF4967@nowhere>
References: <1258653562.22249.682.camel@gandalf.stny.rr.com> <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com> <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain> <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain> <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain> <4B05982B.6060200@caviumnetworks.com> <1258658886.22249.874.camel@gandalf.stny.rr.com> <20091119194625.GE4967@nowhere> <90baa01f0911191154x2ab208cbp2b094c91bbd144ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90baa01f0911191154x2ab208cbp2b094c91bbd144ca@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 08:54:56PM +0100, Kai Tietz wrote:
> 2009/11/19 Frederic Weisbecker <fweisbec@gmail.com>:
> > I would really like this. So that we can forget about other possible
> > further suprises due to sophisticated function prologues beeing before
> > the mcount call.
> >
> > And I guess that would fix it in every archs.
> 
> My 5 cent for this, too.
> 
> > That said, Linus had a good point about the fact there might other uses
> > of mcount even more tricky than what does the function graph tracer,
> > outside the kernel, and those may depend on the strict ABI assumption
> > that 4(ebp) is always the _real_ return address, and that through all
> > the previous stack call. This is even a concern that extrapolates the
> > single mcount case.
> >
> > So I wonder that actually the real problem is the lack of something that
> > could provide this guarantee. We may need a -real-ra-before-fp (yeah
> > I suck in naming).
> 
> There are, especially in windows world. We noticed that for example
> the Sun's JDK (which is compiled by VC) can be used in gcc compiled
> code only by -fno-omit-frame-pointer, as otherwise it fails badly
> reasoned by wrong ebp accesses.


Yeah but what we need is not only to ensure ebp is used as the frame
pointer but also that ebp + 4 is really the address that will be used
to return to the caller, and not a copy of the return value.

