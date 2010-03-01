Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab0CAQsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:48:07 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56070 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0CAQsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:48:04 -0500
Date: Mon, 1 Mar 2010 08:48:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in
	git tree
Message-ID: <20100301164800.GC6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301042249.GA12289@linux.vnet.ibm.com> <alpine.LFD.2.00.1003010812410.3616@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003010812410.3616@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 08:22:15AM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 28 Feb 2010, Paul E. McKenney wrote:
> >
> > Uses "git log" to print the hash.
> 
> Please don't use "git log" for something like this.
> 
> Sure, it works, but it's kind of silly to say "I want a log, except I want 
> only a single entry, and btw, I don't actually even want the log entry for 
> that single entry at all, just the hash".
> 
> It boils down to "I want a log, except with none of the log part". It 
> should make you go "Do I really want a log"?
> 
> If you really want the hash, maybe just using "git rev-parse HEAD" would 
> do it.
> 
> However, in this case I think _any_ of those would be wrong. Wouldn't it 
> make sense to use the same thing that we already compute for 'uname' 
> (scripts/setlocalversion)? Especially as that one already knows how to 
> handle other SCM's too (ie the whole hg/svn parts).
> 
> That script also ends up using a nicer format, ie it uses "git describe" 
> to give a better idea of where it all is.

Agreed!  The "-dirty" modifier for the case of changes not yet
checked into git looks especially helpful.  Geert Uytterhoeven already
straightened me out on this one, and I posted an updated patch that
uses scripts/setlocalversion (as a reply to his email).

Still learning about git, and I suspect that I always will be in that
state.  ;-)

							Thanx, Paul
