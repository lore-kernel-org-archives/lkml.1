Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbYBLPj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbYBLPj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760827AbYBLPjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:39:44 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:45795 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbYBLPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:39:41 -0500
Message-ID: <47B1BC2A.6040506@panasas.com>
Date: Tue, 12 Feb 2008 17:32:58 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>	 <20080212042133.GA4625@kroah.com>	 <20080211203146.3d28d1a0@laptopd505.fenrus.org>	 <20080212044314.GA4888@kroah.com>	 <20080211211751.3e265754@laptopd505.fenrus.org>	 <20080212055312.GA5631@kroah.com> <1202828848.3137.4.camel@localhost.localdomain>
In-Reply-To: <1202828848.3137.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 12, 2008, 17:07 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-02-11 at 21:53 -0800, Greg KH wrote:
>>> this is why you need specific trees for just the API change, and these
>>> need to EXPLICITLY go first before EVERYTHING ELSE. Yes this needs a
>>> bit of coordination, but it's the only way.
>> Even then, it will not work.
>>
>> Again, Roland isn't going to want to always pull in my driver tree just
>> to build his tree.  He wants to, and needs to do his own development
>> effort.
>>
>> But when we merge them together, there would be problems.
>>
>> So, you can't just "drop" the IB tree.
>> You can't just "drip" my tree.
>>
>> Where do you "fix this up" at?  I can send a patch for the IB tree, but
>> Roland can't put it in his tree, and I can't put it in my tree, it needs
>> to go _after_ both of our trees.
> 
> Actually, we had exactly this issue with the SCSI bidirectional patches:
> They depended on the sg_table patches in block.  The solution I adopted
> was two merge trees:  One to go in immediately with no dependencies
> (scsi-misc-2.6) and the other based on the pieces of block (so it would
> compile and apply) to go in mid way through the merge round after block
> (scsi-bidi-2.6).  What I did was keep rebasing the bidi tree until I
> could see there was nothing other than a plane base before merging it.

My take on this, in retrospect, is that the code should probably have been
developed in one branch off of one of the trees, or maybe even better in a
third tree.

The point is that the structure of git trees followed the organizational
structure rather than the problem at hand and if contributions coming
from different trees depend on each other, staging branches should be created
in the integration tree for working out the conflicts and when ready,
the integrated branches should be pushed towards the tree's trunk.

> 
> Of course, this only worked because Jens has a git tree ... it would
> have been a lot harder (but not impossible) if I'd had entangled patches
> from a quilt tree.
> 
> So I've already proven that the split tree solution is viable, if not
> pretty.  The bidi tree had to be rebased an awful lot as the block trees
> changed and rebased.  Unfortunately, git isn't very good at this, I
> eventually had to keep a base and a top reference and just try to cherry
> pick this series into the new constructed block tree.  But it can be
> done...


I developed git-rebase-tree (http://git.bhalevy.com/git/gitweb.cgi?p=git-tools.git;a=blob_plain;f=git-rebase-tree;hb=HEAD)
for exactly this reason - frequently rebasing sub-branches in the linux-pnfs tree
and my experience so far is that it really speeds things up for me and Boaz.
Please feel invited to try it out, I think it's very to close to be mature enough
for general availability (I know, I know, it'd be perfect if this functionality
would be merged into git-rebase :)

> 
>> That's what -mm has been able to handle so far, and that needs to also
>> work with -next.
> 
> Actually, we never successfully got block and bidi via -mm.
> 
> James
> 
> 

