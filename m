Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbYGQVQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbYGQVQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbYGQVQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:16:35 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60374 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814AbYGQVQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:16:34 -0400
Date: Thu, 17 Jul 2008 17:15:34 -0400
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
Message-ID: <20080717211534.GB19066@fieldses.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <487EE940.1050007@firstfloor.org> <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org> <alpine.LFD.1.10.0807171402110.2965@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807171402110.2965@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:49:04PM -0400, Len Brown wrote:
> One thing I wish I had in git is a way to make this sequence easier...

Linus's answer (with rebase -i) is probably better, but my habit is to
do what you describe, with some minor shortcuts:

> Say I have a big topic branch with 30 patches in it.
> The 3rd patch turns out to have a bug in it, but the
> rest of the series is okay.  Today I invoke gitk on
> the branch and keep that open.
> Then I create a new topic branch at the broken patch.
> 
> I always consult ~/src/git/Documentation/git-reset.txt
> so I can remember the following sequence...
> 
> $ git reset --soft HEAD^
> $ edit
> $ git commit -a -c ORIG_HEAD

Instead of the above three steps, you can do just:

  $ edit
  $ git commit -a --amend

> Now I've got the fixed 3rd patch checked in,
> but 27 patches in the original branch are hanging
> off the original broken 3rd patch.
> So I git-cherry-pick 27 patches
> I hope I get them in the right order and don't miss any...
> 
> It would be nice if we could somehow git rebase those
> 27 patches in a single command, but if we do,
> that pulls with it the broken 3rd patch.

At this point I do

	git rebase --onto HEAD old-sha1 name-of-branch-to-rebase

(where old-sha1 is the name of the commit we just replaced, which I
usually cut-n-paste out of gitk).  That rebases the commits in the range
old-sha1...name-of-branch-to-rebase onto the new HEAD commit that you
just created, and replaces the named branch with the result.

> come to think of it, I can probably export 4..27 as
> an mbox and then import it on top of the new 3,
> maybe that is what others do.

That works too.

--b.
