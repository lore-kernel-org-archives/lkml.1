Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZKTTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZKTTqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZKTTqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:46:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZKTTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:46:44 -0500
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect 
 GCC messing with mcount prologue
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Haley <aph@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, jakub@redhat.com,
       gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B06EF6F.2050507@redhat.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <1258694593.22249.1012.camel@gandalf.stny.rr.com>
	 <1258736456.22249.1032.camel@gandalf.stny.rr.com>
	 <4B06EF6F.2050507@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 20 Nov 2009 14:46:46 -0500
Message-Id: <1258746406.22249.1035.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 19:35 +0000, Andrew Haley wrote:
> Steven Rostedt wrote:
> > Ingo, Thomas and Linus,
> > 
> > I know Thomas did a patch to force the -mtune=generic, but just in case
> > gcc decides to do something crazy again, this patch will catch it.
> > 
> > Should we try to get this in now?
> 
> I'm sure this makes sense, but a gcc test case would be even better.
> If this can be detected in the gcc test suite it'll be found and
> fixed long before y'all in kernel land get to see it.  That's the
> only way to guarantee this never bothers you again.
> 
> H.J., who wrote the code in question, is hopefully looking at why
> this odd code is being generated.  Once he's done I can put a
> suitable test case in the gcc test suite.

Yes a gcc test suite will help new instances of gcc. But we need to
worry about the instances of gcc that people have on their desktops now.
This test case will catch the discrepancy between gcc and the function
graph tracer. I'm not 100% convince that just adding -mtune=generic will
help in all cases. If we miss another instance, then the function graph
tracer may crash someone's kernel.

-- Steve


