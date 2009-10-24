Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZJXMVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZJXMVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 08:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZJXMVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 08:21:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58353 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZJXMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 08:20:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AE2F0F6.30909@s5r6.in-berlin.de>
Date: Sat, 24 Oct 2009 14:20:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091017 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
References: <20091022122042.e535d43c.sfr@canb.auug.org.au> <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu>
In-Reply-To: <20091024080326.GA7461@mit.edu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> I think we need to be a bit careful in this discussion.  There are two
> things that cause a particular git tree to be one which can't be used
> as a the basis for subtrees.  One is "rebasing", where a series of
> commits is dropped onto a new version, or base, hence "rebasing".  The
> other is where one or more commits are *modified* --- perhaps to add
> ack-ed by, or tested-by comment lines, or to improve comments, or to
> fix outright bugs in the the patch series.  Perhaps it's better to
> call this "rewinding", since in most cases this doesn't actually cause
> a change in the "base" of the patch series.

That's helpful terminology.

> The reason why it's important to make this distinction is that some of
> the arguments about why constantly changing the base of a patch series
> don't apply when we are just fixing up patches in the patch series or
> git tree.
> 
> So given that, why do I think "rewinding" has a place as a development
> methodology for patch sources that feed into linux-next.

Though per definition of what is expected to be submitted into
linux-next, both rebasing and rewinding should occur rather rarely.

Instead of a process rule that for-next branches should not be rebased/
rewound, I would suggest that
    If a for-next branch is rarely rewound, let alone rebased, it is an
    indicator that development and maintenance of a tree are going well.
    And vice versa.
stands as a /rule of thumb/.  Actually, that's all very obvious because
a for-next branch is pretty much a /release/ branch.

> 1) Linux-next is by definition a constantly rewinding branch.  It is
> thrown away and recreated every day, based on the tip of Linus's

[It is not entirely thrown away, see
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=tags. But
it is indeed recreated daily, i.e. next-N does not include the end
result of next-N-1.]

> mainline tree, and so the date of the merge commits means that you can
> never base anything on top of linux-next.  This has always been the
> case, and so trying to impose a straightjacket on all of the sources
> of linux-next doesn't actually buy anything as far as the properties
> of linux-next.
> 
> 2) There are many legitimate reasons for "rewinding".  In addition to
> being able to add credit for tested-by and acked-by lines, sometimes

Per linux-next submission rules, all /essential/ credits are already
present.  But I agree that it is worth rewinding a for-next branch in
order to add (non-essential) credits later.  linux-next's exact history
is of interest for days or months at most, while mainline's history is
of interest for many years to come.

> patches are subtle.  More than once, patches have been sitting in the
> ext4 tree that have passed the XFSQA test, and thus have been "unit
> tested", but they still have bugs; in some cases, subtle bugs.  In
> some cases, bugs that cause data corruption.  In the case where the
> patches have hit linux-next, but the merge window hasn't opened yet, I
> prefer to fix the patch by mutating it, and rewinding the ext4 tree,
> instead of adding a fix later.  It makes it easier to cherry pick
> patches to the stable tree later, and it keeps the ext4 tree clean,
> and it has no downside in terms of linux-next --- see (1) above.
> 
> 3) I don't have the same access to vast amounts of hardware and
> platforms that Ingo does.  As a result, while I make a practice of
> testing every single patch against the XFS test suite (yes, it's slow
> and painful, but I think it's worth it; I'm very paranoid about patch
> quality), every once in a while the patch has warnings or doesn't
> compile on some platform for which I don't have build/test machines.
> Today, this gets tested in linux-next, and when it does, if it the
> merge window hasn't opened yet, I will fix it the patch instead of
> creating an extra patch.  This helps git bisectability for platforms I
> don't have access to.

We should rely less on linux-next as a cross-compile farm; that's not
its purpose.  We can cross-compile ourselves.  I think the documentation
and toolchain can be found somewhere.  In fact, we are supposed to do so
per item 3 in Documentation/SubmitChecklist.  This text was added about
two years before linux-next opened for business.

That said, I admit that I don't test more than x86-64 myself (x86-32
too, but decreasingly frequently now).  But that's mostly because I only
deal with code where the danger of architecture-dependent build breakage
is very low.  (drivers/ieee1394 is frozen, and drivers/firewire is
small, modern, sparse-clean, and uses clean interfaces to the rest of
the kernel.  There is some more danger of /runtime/ regression of these
drivers on other architectures, but those would only be exposed in
mainline or distributions, not in linux-next already.)  I guess on the
unlikely day that I get notice of a linux-next build bug due to my tree
on one of those platforms, I will reorder my never ending to-do list and
set up local cross compilation.
-- 
Stefan Richter
-=====-==--= =-=- ==---
http://arcgraph.de/sr/
