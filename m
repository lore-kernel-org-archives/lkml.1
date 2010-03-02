Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab0CBFVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 00:21:46 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58432 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab0CBFVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 00:21:45 -0500
Date: Mon, 1 Mar 2010 21:21:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Cloos <cloos@jhcloos.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in
	git tree
Message-ID: <20100302052142.GA6821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301042249.GA12289@linux.vnet.ibm.com> <alpine.LFD.2.00.1003010812410.3616@localhost.localdomain> <20100301164800.GC6758@linux.vnet.ibm.com> <m3r5o34vnp.fsf@lugabout.jhcloos.org> <20100302012055.GK6758@linux.vnet.ibm.com> <m3d3zn4hg8.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3d3zn4hg8.fsf@lugabout.jhcloos.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 08:53:19PM -0500, James Cloos wrote:
> >>>>> "Paul" == Paul E McKenney <paulmck@linux.vnet.ibm.com> writes:
> 
> Paul> Agreed!  The "-dirty" modifier for the case of changes not yet
> Paul> checked into git looks especially helpful.
> 
> JimC> Except that the script calls »git update-index --refresh --unmerged«
> JimC> and »git diff-index --name-only HEAD«, both of which are painfully
> JimC> slow and resource intensive.
> 
> JimC> I'd hate to have that run every time I make a kernel.
> 
> Paul> Good point...  Should we have an environment variable that controls
> Paul> this behavior?
> 
> I wouldn't mind the intial idea: just the abbreviated top of three hash.
> 
> I was, next, going to write that CONFIG_LOCALVERSION_AUTO already exists
> for that, but LOCALVERSION_AUTO calls scripts/setlocalversion these days
> and that is what I'd prefer to avoid.  [SIGH]
> 
> Shows how long it has been since I last used it.  I stopped using it
> when I was maintaining my .config in git.  Now I maintain .config in a
> separate git repo, for the express purpose of avoiding a merge (rather
> than a fast forward) when I run git pull.  Something that a local edit
> of scripts/setlocalversion will, of course, prevent.
> 
> Anyone up for a CONFIG_LOCALVERSION_AUTO_DO_NOT_BOTHER_WITH_DIRTY? ☺

It looks like it would be pretty easy to make make scripts/setlocalversion
look at an environment variable to decide whether or not to do the index
update and the check for uncommitted changes.  Default would seem to
need to be to do it the slow way.

Or would that cause other problems?

							Thanx, Paul
