Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYAIWJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYAIWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYAIWJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:09:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:50847 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753730AbYAIWJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:09:51 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/A2+AusNHA24jFwCxbzKzDV7Ln8MJ56wijsb2xg0
	1I5F8ctu0KWFWx
Date: Wed, 9 Jan 2008 23:09:48 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109220948.GA2218@atjola.homenet>
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org> <20080109152208.GA21280@elte.hu> <20080109155124.GB12923@one.firstfloor.org> <20080109163017.GG17739@elte.hu> <20080109174800.GA15346@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080109174800.GA15346@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.01.09 18:48:00 +0100, Andi Kleen wrote:
> On Wed, Jan 09, 2008 at 05:30:18PM +0100, Ingo Molnar wrote:
> > then you have a truly ancient x86.git repository ;-)
> 
> I update only infrequently because frankly git's remote branch tracking
> is a mess. At least it doesn't really work for x86#mm here. 
> 
> I usually have to blow away the repository and reclone
> to get back to a sane state.

Someone in #git had a similar problem today. Conclusion was that x86/mm
is not "stable" in the sense that commits are only added, instead
history gets rewritten. That breaks pull/merge/"basic rebase".

Basically, you'll want to "rebase --onto", taking your local commits
from the old branch history to the new branch history. One way to make
that bearable is to have two branches (or a branch and a tag). One
branch is used to keep your work, the other branch (or tag) is used to
"mark" where the old upstream ended and your work started.

Assuming that your remote is called "x86", this could look like this:

git branch myStuff x86/mm
git branch myStuff_start x86/mm

work work work commit commit commit

git fetch x86 mm

git rebase --onto x86/mm myStuff_start myStuff
git branch -f myStuff_start x86/mm


The rebase will take all of the commits that you added to myStuff, on
top of the old x86/mm (referred to by myStuff_start) and try to apply
them on top of the new x86/mm, updating myStuff to point to the rebased
commits afterwards.

Then myStuff_start is updated to point to the now current start of your
stuff, so that you can do the rebase again later.

That's not actually a problem of git's tracking branches, because
they're not made for that style of work at all. For such stuff, rebase
is the only useful option AFAIK.

HTH,
Björn
