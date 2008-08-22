Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYHVUY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYHVUY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYHVUYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:24:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52680 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYHVUYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:24:50 -0400
Date: Fri, 22 Aug 2008 12:46:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ftraced and suspend to ram
Message-ID: <20080822104610.GA3482@elf.ucw.cz>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808211423410.678@gandalf.stny.rr.com> <200808212037.11775.rjw@sisk.pl> <200808212159.37678.rjw@sisk.pl> <20080822044649.GA356@elte.hu> <20080822072343.GA24173@atrey.karlin.mff.cuni.cz> <20080822103533.GA5425@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822103533.GA5425@joi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-08-22 12:35:39, Marcin Slusarz wrote:
> On Fri, Aug 22, 2008 at 09:23:43AM +0200, Pavel Machek wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > 
> > > > > > The code in question is the ftraced() function in 
> > > > > > kernel/trace/ftrace.c
> > > > > 
> > > > > Thanks, I'll have a look in a while.
> > > > 
> > > > Can you try the appended patch, please?
> > > 
> > > makes sense - i've applied it to tip/tracing/urgent, see the tidied up 
> > > commit below.
> > > 
> > > It should be no big issue not being able to trace across suspend+resume 
> > > - and that restriction will go away with Steve's build-time based mcount 
> > > patching mechanism in v2.6.28.
> > 
> > Patch looks okay to me, but I'm not sure if another issue is not
> > hiding under it. Did anyone actually test ftrace + suspend after
> > applying this?
> 
> I just tested this patch - it didn't help ;(

Does ftrace hook itself onto _all_ the functions? Or all .c functions?

I guess low-level suspend code needs to be exempt from
tracing. Certainly all the assembly functions.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
