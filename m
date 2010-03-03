Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0CCCQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:16:28 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34464 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0CCCQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:16:26 -0500
Date: Tue, 2 Mar 2010 18:16:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl,
       cloos@jhcloos.com
Subject: Re: [PATCH] kconfig: place git SHA1 in .config output if in SCM
Message-ID: <20100303021624.GE6786@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100303011858.GA17651@linux.vnet.ibm.com> <alpine.LFD.2.00.1003021725170.3616@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003021725170.3616@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 05:29:50PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 2 Mar 2010, Paul E. McKenney wrote:
> > +		env = getenv(SRCTREE);
> > +		if (env) {
> > +			sprintf(cmdline,
> > +				"%s/scripts/setlocalversion %s 2> /dev/null",
> > +				env, env);
> > +			slv = popen(cmdline, "r");
> 
> I suspect this does various bad things if there are spaces or special 
> characters in $SRCTREE.
> 
> It would be a lot safer to uses fork/execve rather than something 
> that interprets a shell command line.
> 
> Of course, I didn't check that all our old users of SRCTREE are safe 
> either, but at least docproc.c (the one I _did_ check) uses 'execvp()' and 
> 'fopen()' that both take real filenames, not a shell string.

Well, we certainly don't want or need bash's "$", "``", and other
interpretations in this case.  I will update and send out a new patch.

Hmmm...  It has been one good long time since I have used pipe(), dup2(),
exec*(), and friends.  In happy contrast to last time, some of the man
pages now seem to have nice examples.  ;-)

							Thanx, Paul
