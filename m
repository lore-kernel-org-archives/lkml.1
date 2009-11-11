Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbZKKUGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbZKKUGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbZKKUGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:06:52 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52869 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208AbZKKUGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:06:50 -0500
Subject: Re: [RFC] new -stable tag variant, Git workflow question
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain>
References: <20091110034831.GB26809@elte.hu>
	 <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site>
	 <20091110193747.GB12686@suse.de> <1257965424.11985.9.camel@mulgrave.site>
	 <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 14:06:50 -0600
Message-Id: <1257970010.11985.17.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 12:00 -0800, Linus Torvalds wrote:
> 
> On Wed, 11 Nov 2009, James Bottomley wrote:
> > 
> > The slight problem is that further down, to generate the patch the
> > script uses git format-patch -k --stdout commit^..commit.  For a merge
> > commit, this will generate a patch equivalent to the entire branch that
> > was merged, even though the commit message will only pick out some of
> > these ... is this OK?
> 
> Don't do that.
> 
> Since you want to show a single commit, not a commit range, don't use 
> format-patch, use something like
> 
> 	git show --pretty=email -M --cc --stat $commit
> 
> instead. That will not show the difference between a commit and its 
> first parent (which for a merge diff is more than one commit, and can be 
> absolutely _huge_), but will show just the named commit (which for a merge 
> commit will usually be an empty diff, but will show how conflicts were 
> resolved if they weren't just taken from one or the other side).
> 
> (Of course, maybe you'll want to change the exact flags in question. For 
> example, '--stat' for merge commits is often useful, but only if the merge 
> was done by an upper-level maintainer. Anybody who does reverse merges 
> will just get totally meaningless diffstats, since the diffstat is always 
> done against the first parent, so anybody who does back-merges will see 
> the stat of everthing _I_ have merged in the meantime, which is generally 
> not useful)

Right ... that's why I was wondering if Greg still needs the diff.  If
not, I'll just send standard git log output with no diff.  If he does,
I'll use something like the above.

So, now that you're showing an interest in all of this, how about I send
you the final update hook to add to your tree?  It will produce less
latency than the cron job I run on kernel.org to pull your tree into one
I have here ever twenty minutes or so and run the hooks.

James


