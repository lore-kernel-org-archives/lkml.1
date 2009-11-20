Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZKTMeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZKTMeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZKTMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:34:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZKTMeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:34:15 -0500
Subject: Re: [PATCH] gcc mcount-nofp was Re: BUG: GCC-4.4.x changes the
 function frame on some functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Guenther <richard.guenther@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
In-Reply-To: <87iqd54iz5.fsf_-_@basil.nowhere.org>
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
	 <1258657614.22249.824.camel@gandalf.stny.rr.com>
	 <87iqd54iz5.fsf_-_@basil.nowhere.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 20 Nov 2009 07:34:19 -0500
Message-Id: <1258720459.22249.1018.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 10:57 +0100, Andi Kleen wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> >
> > And frame pointers do add a little overhead as well. Too bad the mcount
> > ABI wasn't something like this:
> >
> >
> > 	<function>:
> > 		call	mcount
> > 		[...]
> >
> > This way, the function address for mcount would have been (%esp) and the
> > parent address would be 4(%esp). Mcount would work without frame
> > pointers and this whole mess would also become moot.
> 
> I did a patch to do this in x86 gcc some time ago. The motivation
> was indeed the frame pointer overhead on Atom with tracing.
> 

Yes, I remember you talking about this but I don't remember how far it
went.



> Unfortunately it also requires glibc changes (I did those too). For
> compatibility and catching mistakes the new function was called
> __mcount_nofp.

Actually, could you change the name? I really hate the "mcount" name, it
is legacy and with a new feature, it should be abandoned. Something like
"__fentry__" would be nicer.

> 
> I haven't tried it with current gcc and last time I missed the 
> gcc feature merge window with this.
> 
> But perhaps you find it useful. Of course it would need more
> kernel changes to probe for the new option and handle it.
> 
> Here's the old patch. I haven't retested it with a current
> gcc version, but I think it still applies at least.
> 
> If there's interest I can polish it up and submit formally.

I would definitely be interested, and I would also be willing to test
it.

Thanks!

-- Steve



