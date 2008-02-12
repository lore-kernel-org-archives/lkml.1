Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYBLESM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYBLESM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 23:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYBLERo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 23:17:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYBLERk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 23:17:40 -0500
Date: Mon, 11 Feb 2008 20:21:33 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080212042133.GA4625@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212120208.f7168a91.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:02:08PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Andrew was looking for someone to run a linux-next tree that just
> contained the subsystem git and quilt trees for 2.6.x+1 and I (in a
> moment of madness) volunteered.  So, this is to announce the creating of
> such a tree (it doesn't exist yet) which will require some (hopefully)
> small amount of work on the part of subsystem maintainers.
> 
> Those interested in discussion about this are encouraged to join the
> linux-next@vger.kernel.org mailing list.
> 
> The first things I need from the subsystem maintainers (you know who you
> are) are a contact address (a list address is fine) and at least one git
> branch or quilt series that contains all the things you want to see go
> into 2.6.26.

Note that a lot of these are already in the MAINTAINERS file.

But for the record, here's mine, in the order they need to be pulled
from.
  Driver core:
	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/
  PCI:
	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-pci/
  USB:
	kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb/

These are all quilt trees, with the series file in the directory for the
order of the patches, and a README saying what kernel version they have
been rebased against.

> I am happy for there to be multiple branches/series (in
> fact there probably will need to be in some cases where there are
> dependencies on others work).
> 
> The tree will be based on the current version of Linus' tree but you may
> specify an earlier branch point if you need to (hopefully not - but more
> likely for quilters, I guess).
> 
> I hope to recreate this tree every day automatically.  In order to do
> this, any tree that has a conflict will be dropped from that days tree.

Oh oh oh, I get merged first!  me me me!

> The maintainer will be notified.  I hope to provide some clue as to what
> the conflict is with, but probably not initially.
> 
> I will attempt to build the tree between each merge (and a failed build
> will again cause the offending tree to be dropped).

This is going to get really interesting, especially when (not if) we do
more global api changes.  Look at the last round of kobject changes.
That touched a lot of different places, and other trees ended up not
building because of it, because I changed apis and they had added new
code based on the old apis.

I think the only way to fix this is not going to just "drop the tree"
like you are suggesting, but to let both people know (the person who
caused the change, and the person who's tree broke after the merge), and
then either add a "fixup patch" for the build like Andrew has been
doing, or disabling something from the build section.

As I know I'm going to be changing more driver core apis[1] this week,
I'm sure we will get a very good set of examples of this for you to see
in action :)

Good luck,

greg k-h

[1] Hopefully the "multiple drivers for a single device" feature people
have been asking for for years will be landing soon, of course the
number of odd places in the kernel that made the assumption that we
could only have one driver per device is causing lots of fun...
