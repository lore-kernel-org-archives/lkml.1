Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZKSTGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZKSTGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZKSTGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:06:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59085 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZKSTGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:06:49 -0500
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <20091119184716.GA25458@elte.hu>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
	 <1258653562.22249.682.camel@gandalf.stny.rr.com>
	 <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
	 <alpine.LFD.2.00.0911191026420.2793@localhost.localdomain>
	 <20091119184716.GA25458@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 19 Nov 2009 14:06:54 -0500
Message-Id: <1258657614.22249.824.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 19:47 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Admittedly, anybody who compiles with -pg probably doesn't care deeply 
> > about smaller and more efficient code, since the mcount call overhead 
> > tends to make the thing moot anyway, but it really looks like a 
> > win-win situation to just fix the mcount call sequence regardless.
> 
> Just a sidenote: due to dyn-ftrace, which patches out all mcounts during 
> bootup to be NOPs (and opt-in patches them in again if someone runs the 
> function tracer), the cost is not as large as one would have it with say 
> -pg based user-space profiling.
> 
> It's not completely zero-cost as the pure NOPs balloon the i$ footprint 
> a bit and GCC generates different code too in some cases. But it's 
> certainly good enough that it's generally pretty hard to prove overhead 
> via micro or macro benchmarks that the patched out mcounts call sites 
> are there.

And frame pointers do add a little overhead as well. Too bad the mcount
ABI wasn't something like this:


	<function>:
		call	mcount
		[...]

This way, the function address for mcount would have been (%esp) and the
parent address would be 4(%esp). Mcount would work without frame
pointers and this whole mess would also become moot.

-- Steve


