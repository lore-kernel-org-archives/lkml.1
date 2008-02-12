Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYBLQAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYBLQAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYBLQAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:00:12 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39075 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740AbYBLQAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:00:10 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <47B1BC2A.6040506@panasas.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	 <20080212042133.GA4625@kroah.com>
	 <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080212055312.GA5631@kroah.com>
	 <1202828848.3137.4.camel@localhost.localdomain>
	 <47B1BC2A.6040506@panasas.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 10:00:03 -0600
Message-Id: <1202832003.3137.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 17:32 +0200, Benny Halevy wrote:
> On Feb. 12, 2008, 17:07 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Mon, 2008-02-11 at 21:53 -0800, Greg KH wrote:
> >>> this is why you need specific trees for just the API change, and these
> >>> need to EXPLICITLY go first before EVERYTHING ELSE. Yes this needs a
> >>> bit of coordination, but it's the only way.
> >> Even then, it will not work.
> >>
> >> Again, Roland isn't going to want to always pull in my driver tree just
> >> to build his tree.  He wants to, and needs to do his own development
> >> effort.
> >>
> >> But when we merge them together, there would be problems.
> >>
> >> So, you can't just "drop" the IB tree.
> >> You can't just "drip" my tree.
> >>
> >> Where do you "fix this up" at?  I can send a patch for the IB tree, but
> >> Roland can't put it in his tree, and I can't put it in my tree, it needs
> >> to go _after_ both of our trees.
> > 
> > Actually, we had exactly this issue with the SCSI bidirectional patches:
> > They depended on the sg_table patches in block.  The solution I adopted
> > was two merge trees:  One to go in immediately with no dependencies
> > (scsi-misc-2.6) and the other based on the pieces of block (so it would
> > compile and apply) to go in mid way through the merge round after block
> > (scsi-bidi-2.6).  What I did was keep rebasing the bidi tree until I
> > could see there was nothing other than a plane base before merging it.
> 
> My take on this, in retrospect, is that the code should probably have been
> developed in one branch off of one of the trees, or maybe even better in a
> third tree.

For your development, possibly, but not for my merge ... there were a
lot of other patches besides yours in the bidi tree (it was, in fact,
misnamed, but I thought at the time I created it it would only contain
the bidi patches).

> The point is that the structure of git trees followed the organizational
> structure rather than the problem at hand and if contributions coming
> from different trees depend on each other, staging branches should be created
> in the integration tree for working out the conflicts and when ready,
> the integrated branches should be pushed towards the tree's trunk.

Actually, I think you'll find the problem is that we can't build an
integration tree that's both stable and long lived, and hence you can't
base anything off it that requires a long lived base.

So, the way I worked for your patches was to use the -mc tree to
identify my conflicts, and only include the actual conflicting branches
as a basis for the scsi-bidi tree beofre fixing up the patches.  I then
actually used the -mc tree as a canary to tell me when to rebase.

James


