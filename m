Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZBUVtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZBUVtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 16:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZBUVtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 16:49:16 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:42241 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZBUVtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 16:49:16 -0500
Date: Sat, 21 Feb 2009 22:51:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       zippel@linux-m68k.org
Subject: Re: [PATCH v2] kconfig: check for select dependency errors on config load
Message-ID: <20090221215104.GA2030@uranus.ravnborg.org>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <alpine.DEB.2.00.0902210008580.30069@gandalf.stny.rr.com> <20090220220810.6f4360f0.akpm@linux-foundation.org> <499F9D25.8010300@oracle.com> <alpine.DEB.2.00.0902211504200.30069@gandalf.stny.rr.com> <alpine.DEB.2.00.0902211535440.18221@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902211535440.18221@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 03:46:29PM -0500, Steven Rostedt wrote:
> 
> On Sat, 21 Feb 2009, Steven Rostedt wrote:
> > On Fri, 20 Feb 2009, Randy Dunlap wrote:
> > > EMBEDDED is misnamed.  It means "those who think that they know enough
> > > to use all of the power of kconfig."
> > > Some people spell that EXPERT etc.
> > > Or it means "let me shoot myself in the foot."
> 
> > 
> > Anyway, to avoid having these spit out all the time, I'll see if I can 
> > make it not warn if the dependency was on EMBEDDED/EXPERT. I'll try to 
> > work on it when I have time.
> 
> That was easier than I expected. Here's an updated version of the patch.
> 
> It now finds the symbol EMBEDDED, saves its state. Updates its state to 
> 'yes', runs the tests, resets its state back to what it was.

We do not want to have such hardcoded information
about the Kconfig structure in the backend.
Rather we should fix the configuration once and for all so EMBEDDED
get split into the sensible options is actually is.

Options that come to my mind is:
OPTIMIZE_FOR_TEXT_SIZE
OPTIMIZE_FOR_DATA_SIZE
KERNEL_EXPERT

And we should them make their use of select conform
like the rest of the kernel configuration.

So the first version of your patch is IMO better - but
it could use some comments so others better follows what is
going on. The current level of comments in the kconfig
source base is not an example to follw

	Sam
