Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZKLEvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZKLEvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbZKLEvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:51:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbZKLEvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:51:51 -0500
Date: Wed, 11 Nov 2009 20:41:42 -0800
From: Greg KH <gregkh@suse.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091112044142.GA27714@suse.de>
References: <20091110034831.GB26809@elte.hu> <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site> <20091110193747.GB12686@suse.de> <1257965424.11985.9.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257965424.11985.9.camel@mulgrave.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 12:50:24PM -0600, James Bottomley wrote:
> On Tue, 2009-11-10 at 11:37 -0800, Greg KH wrote:
> > On Tue, Nov 10, 2009 at 09:29:48AM -0500, James Bottomley wrote:
> > > On Mon, 2009-11-09 at 20:14 -0800, Greg KH wrote:
> > > > > A further question is, i can see using this tagging scheme in the future 
> > > > > in merge commits log messages too - will your scripts notice that too?
> > > > 
> > > > Hm, I don't think we look at merges as there's nothing there to actually
> > > > commit.
> > > > 
> > > > > For example if there's a few commits left in tip:*/urgent branches 
> > > > > (tip:sched/urgent, tip:core/urgent, tip:x86/urgent, etc.) by the time 
> > > > > v2.6.32 is released, i will then merge them into tip:sched/core, 
> > > > > tip:core/core, tip:x86/core, etc. - and i could use the merge commit as 
> > > > > a notification area to 'activate' them for -stable backporting via a 
> > > > > merge commit.
> > > > > 
> > > > > This is how such merge commits would look like:
> > > > > 
> > > > >   Merge branch 'core/urgent' into core/rcu
> > > > > 
> > > > >   Merge reason: Pick up urgent fixes that did not make it into .32.0
> > > > > 
> > > > >   Cc: <stable@kernel.org> # .32.x: 83f5b01: rcu: Fix long-grace-period race
> > > > >   Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > > 
> > > > > This is not so rare of a situation as it might seem - for the trees i 
> > > > > maintain it happens in almost every release cycle - i typically skip 
> > > > > urgent branch merges after -rc8/-rc9, unless they are very-very-urgent 
> > > > > fixes - but they'd still be eligible for -stable.
> > > > 
> > > > Ok, that would be good and fine with me.
> > > > 
> > > > James, would your script pick this up, or does it need to also pay
> > > > attention to merge commits?
> > > 
> > > No ... because merge commits should effectively be empty (and when
> > > they're not you can't generate an applyable diff).  If I understand the
> > > workflow, the desire is to have the whole branch sent to stable by
> > > tagging the merge commit.  That's possible ... it's exactly the same
> > > logic I use in the commit scripts for the SCSI tree, so it should be
> > > possible to extract the logic.
> > > 
> > > By the looks of the above it's only a few commits, or is it the entire
> > > branch?
> > 
> > I'm thinking the commit would be the merge, right Ingo?  So it would
> > just be a single commit that has the marker in it.
> 
> OK, so I can make it send you this just by removing the --no-merge flag
> from the git rev-list the script uses to sift through what changed
> (which I've already done).
> 
> The slight problem is that further down, to generate the patch the
> script uses git format-patch -k --stdout commit^..commit.  For a merge
> commit, this will generate a patch equivalent to the entire branch that
> was merged, even though the commit message will only pick out some of
> these ... is this OK?
> 
> If not, I can look at using git show instead to generate the patches (it
> will effectively generate null diffs for merge points with the stable
> tag, which is closer to what you want).
> 
> Alternatively, if you pick up the commits from Linus' tree anyway, I
> could just stop producing diffs, which will save email bandwidth and
> then be automatically correct whether the commit is a merge or not.

No, I'd like to keep diffs, and use Linus's suggestion to get the
correct diff, I have had that same bug in some scripts I have written as
well.

thanks,

greg k-h
