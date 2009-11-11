Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZKKUBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZKKUBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZKKUBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:01:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbZKKUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:01:03 -0500
Date: Wed, 11 Nov 2009 12:00:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
In-Reply-To: <1257965424.11985.9.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain>
References: <20091110034831.GB26809@elte.hu>  <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site>  <20091110193747.GB12686@suse.de> <1257965424.11985.9.camel@mulgrave.site>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Nov 2009, James Bottomley wrote:
> 
> The slight problem is that further down, to generate the patch the
> script uses git format-patch -k --stdout commit^..commit.  For a merge
> commit, this will generate a patch equivalent to the entire branch that
> was merged, even though the commit message will only pick out some of
> these ... is this OK?

Don't do that.

Since you want to show a single commit, not a commit range, don't use 
format-patch, use something like

	git show --pretty=email -M --cc --stat $commit

instead. That will not show the difference between a commit and its 
first parent (which for a merge diff is more than one commit, and can be 
absolutely _huge_), but will show just the named commit (which for a merge 
commit will usually be an empty diff, but will show how conflicts were 
resolved if they weren't just taken from one or the other side).

(Of course, maybe you'll want to change the exact flags in question. For 
example, '--stat' for merge commits is often useful, but only if the merge 
was done by an upper-level maintainer. Anybody who does reverse merges 
will just get totally meaningless diffstats, since the diffstat is always 
done against the first parent, so anybody who does back-merges will see 
the stat of everthing _I_ have merged in the meantime, which is generally 
not useful)

		Linus
