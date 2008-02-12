Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbYBLGHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbYBLGHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYBLGG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:06:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57393
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYBLGGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:06:55 -0500
Date: Mon, 11 Feb 2008 22:07:26 -0800 (PST)
Message-Id: <20080211.220726.157328337.davem@davemloft.net>
To: greg@kroah.com
Cc: arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212055312.GA5631@kroah.com>
References: <20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
	<20080212055312.GA5631@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Mon, 11 Feb 2008 21:53:12 -0800

> Where do you "fix this up" at?  I can send a patch for the IB tree, but
> Roland can't put it in his tree, and I can't put it in my tree, it needs
> to go _after_ both of our trees.

Totally agreed.

The fact is there are interdependencies, especially in driver
land and you have to either:

1) Make the driver folks work on top of Greg's tree.

2) Constantly rebase the -next tree to deal with the
   conflicts.

There are some other issues related to this which haven't
be touched upon greatly yet.

I rebase my tree all the time, at least once or twice per
week.  Why?

Firstly, to remove crap.  When you have "great idea A" then "oh shit A
won't work, revert that" there is zero sense in keeping both
changesets around.

Secondly, I want to fix up the rejects caused by conflicts with
upstream bug fixes and the like (and there are tons when the tree gets
to 1500 or so patches like the networking did).  I don't want git to
merge the thing by hand, I want to see what the conflict is and make
sure the "obvious" resolution is OK and the most efficient way I know
how to do that is to suck my tree apart as patches, then suck them
back into a fresh tree.

It therefore might make sense to the linux-next tree to do something
similar, constantly rebasing so that all the conflicts and reverted
shit changes can be sorted out without having an incredibly ugly
GIT history.
