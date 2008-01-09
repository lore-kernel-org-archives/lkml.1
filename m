Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbYAIXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbYAIXVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYAIXV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:21:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:51323 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753212AbYAIXVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:21:25 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/MgG5zrhXMGBE4XkBJxT8JvTAJnVNuqgj89zJGAp
	Sy2yNZSvg+yW2m
Date: Thu, 10 Jan 2008 00:21:22 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109232122.GA8969@atjola.homenet>
References: <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org> <20080109152208.GA21280@elte.hu> <20080109155124.GB12923@one.firstfloor.org> <20080109163017.GG17739@elte.hu> <20080109174800.GA15346@one.firstfloor.org> <20080109220948.GA2218@atjola.homenet> <20080109222804.GF15612@one.firstfloor.org> <1199918155.6424.71.camel@brick> <20080109224142.GB18480@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080109224142.GB18480@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.01.09 23:41:42 +0100, Andi Kleen wrote:
> On Wed, Jan 09, 2008 at 02:35:55PM -0800, Harvey Harrison wrote:
> > On Wed, 2008-01-09 at 23:28 +0100, Andi Kleen wrote:
> > 
> > > Do you have a simple recipe to just update from the the remote branch,
> > > assuming there are no local changes or local branches? 
> > > 
> > > -Andi
> > 
> > For staying up to date I use the following:
> > 
> > # Add Linus's tree as a remote
> > git remote --add linus
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > 
> > # Add Ingo's tree as a remote
> > git remote --add x86
> > git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> > 
> > # With that setup, just run the following to get any changes you
> > # don't have.  It will also notice any new branches Ingo/Linus
> > # add to their repo.  Look in .git/config afterwards, the format
> > # to add new remotes is easy to figure out.
> > git remote update
> 
> I'm already cloning the branches; the problem is not getting conflicts etc.
> when updating.

I guess you're using "git pull" to update a local branch? That will try
to merge the new state of x86/mm into your local branch, and that
breaks. If you just want to have a local branch that gives you a "fixed"
state of x86/mm regardless of whether or not you already fetched newer
ones, you can do:

git branch myThing x86/mm # create the branch

work/test/whatever

To fetch a new "state" from the remote:
git fetch x86/mm # or git remote update, or whatever

To update your branch to point to the new state:
git branch - f myThing x86/mm

That basically replaces it with a new branch of the same name, but
pointing to the new x86/mm.

Or if you want to get your working tree to that state at the same time,
you can also do:
git checkout myThing
git reset --hard x86/mm

Björn
