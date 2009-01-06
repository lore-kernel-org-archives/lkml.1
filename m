Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZAFCHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZAFCHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZAFCHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:07:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51947 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbZAFCHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:07:08 -0500
Date: Mon, 5 Jan 2009 21:07:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
In-Reply-To: <20090105231136.GA5073@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.1.10.0901052104400.16409@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <20090105195415.GA6204@uranus.ravnborg.org> <alpine.DEB.1.10.0901051458460.25066@gandalf.stny.rr.com> <20090105213107.GA27293@uranus.ravnborg.org>
 <alpine.DEB.1.10.0901051649240.25066@gandalf.stny.rr.com> <20090105220156.GC8592@uranus.ravnborg.org> <alpine.DEB.1.10.0901051710450.25066@gandalf.stny.rr.com> <20090105231136.GA5073@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 6 Jan 2009, Heiko Carstens wrote:

> On Mon, Jan 05, 2009 at 05:14:22PM -0500, Steven Rostedt wrote:
> > 
> > On Mon, 5 Jan 2009, Sam Ravnborg wrote:
> > 
> > > > Is this all sparc cross compiler?  I'm trying to reproduce it on x86 with 
> > > > no avail :-(
> > > > 
> > > > I would like to test other ways to change the macro, but to do so, I need 
> > > > to get a compiler that will produce the warnings that you see. What 
> > > > version of gcc are you using?
> > > 
> > > I used crosstool to build a 3.4.5 gcc:
> > 
> > Hmm, that's a pretty old compiler. I wonder if it wouldn't just help
> > if we just make the branch tracer dependent on the compiler used. That is.
> > 
> > #if defined(CONFIG_PROFILE_ALL_BRANCHES) && (__GNUC__ >= 4)
> > #define if(cond) ...
> > 
> > Or something :-/
> 
> FWIW, on s390 with gcc 4.3.2 and an allyesconfig I get these:
> 
>   CC      arch/s390/mm/extmem.o
> arch/s390/mm/extmem.c: In function 'segment_modify_shared':
> arch/s390/mm/extmem.c:572: warning: 'end_addr' may be used uninitialized in this function
> arch/s390/mm/extmem.c:572: warning: 'start_addr' may be used uninitialized in this function
> arch/s390/mm/extmem.c: In function 'query_segment_type':
> arch/s390/mm/extmem.c:259: warning: 'vmrc' may be used uninitialized in this function
> 
> Switching off PROFILE_ALL_BRANCHES makes the warnings go away again.

Now that is really interesting. Because end_addr and start_addr are 
initialized via functions:

	if (x)
		init_me(a, &y);
	else
		init_me(b, &y);

Which actually does not make sense why turning off PROFILE_ALL_BRANCHES 
would affect this :-/

-- Steve

