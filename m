Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYAIWZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYAIWZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYAIWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:25:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56862 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYAIWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:25:31 -0500
Date: Wed, 9 Jan 2008 23:28:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109222804.GF15612@one.firstfloor.org>
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org> <20080109152208.GA21280@elte.hu> <20080109155124.GB12923@one.firstfloor.org> <20080109163017.GG17739@elte.hu> <20080109174800.GA15346@one.firstfloor.org> <20080109220948.GA2218@atjola.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080109220948.GA2218@atjola.homenet>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 11:09:48PM +0100, Björn Steinbrink wrote:
> On 2008.01.09 18:48:00 +0100, Andi Kleen wrote:
> > On Wed, Jan 09, 2008 at 05:30:18PM +0100, Ingo Molnar wrote:
> > > then you have a truly ancient x86.git repository ;-)
> > 
> > I update only infrequently because frankly git's remote branch tracking
> > is a mess. At least it doesn't really work for x86#mm here. 
> > 
> > I usually have to blow away the repository and reclone
> > to get back to a sane state.
> 
> Someone in #git had a similar problem today. Conclusion was that x86/mm
> is not "stable" in the sense that commits are only added, instead
> history gets rewritten. That breaks pull/merge/"basic rebase".
> 
> Basically, you'll want to "rebase --onto", taking your local commits

I don't really have any local commits. I just want to use read-only
git to generate a patch that I can then import using quilt and
only look at log files and use git show. The fanciest thing
I use is git bisect occasionally.

> that bearable is to have two branches (or a branch and a tag). One
> branch is used to keep your work, the other branch (or tag) is used to
> "mark" where the old upstream ended and your work started.
> 
> Assuming that your remote is called "x86", this could look like this:
> 
> git branch myStuff x86/mm
> git branch myStuff_start x86/mm
> 
> work work work commit commit commit
> 
> git fetch x86 mm
> 
> git rebase --onto x86/mm myStuff_start myStuff
> git branch -f myStuff_start x86/mm

Do you have a simple recipe to just update from the the remote branch,
assuming there are no local changes or local branches? 

-Andi
