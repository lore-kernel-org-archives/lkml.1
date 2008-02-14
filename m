Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYBNVqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYBNVqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYBNVp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:45:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53604 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYBNVp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:45:57 -0500
Message-ID: <47B4B68D.7080805@garzik.org>
Date: Thu, 14 Feb 2008 16:45:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: first tree
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>	 <47B4AC97.3040001@garzik.org> <1203024381.3158.26.camel@localhost.localdomain>
In-Reply-To: <1203024381.3158.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> So does this indicate the meaning of upstream and upstream-fixes is
> still the same?  I always took upstream-fixes to be bug fixes for this
> -rc and upstream as queued for the next merge window, in which case NEXT
> would be the union of those two sets?


In practice, #upstream-fixes isn't very useful, because I send its 
contents to Linus very very rapidly once they are committed to that 
branch.  I then locally delete that branch once Linus merges it, and 
re-create it [again, locally] the next time I have some bug fixes to apply.

So it is a "somewhat throwaway" branch.

The main utility of #upstream-fixes is so that I can do
	git branch upstream-linus upstream-fixes
and then continue making commits in parallel with a Linus pull+push cycle.

The #upstream branch is much more useful, because that is where things 
for the next kernel are stored, during a bug-fix-only cycle.  This is 
largely equivalent to NEXT, though I plan to be more stringent in my 
requirements for NEXT commits than #upstream commits.

One thing to note is that "pure" rebases are somewhat rare; I much 
prefer to wait until the batch of commits lands in 
torvalds/linux-2.6.git, before I blow away and recreate (with a new 
torvalds HEAD) the branch in question.


So, to answer your question...  Fixes should go upstream fast enough 
that they should hit NEXT implicitly via a Linus pull+push.  It should 
be the union of two sets, yes, if a Linus cycle takes a long time.  When 
both #upstream and #upstream-fixes are active, I tend to always branch 
#upstream off of #upstream-fixes and/or do a "git pull . upstream-fixes" 
when updating #upstream.

	Jeff



