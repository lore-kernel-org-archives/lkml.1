Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbYBPBBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbYBPBBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbYBPBBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:01:16 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62632 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbYBPBBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:01:02 -0500
Date: Fri, 15 Feb 2008 20:00:30 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, miklos@szeredi.hu, akpm@osdl.org
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
Message-ID: <20080216010030.GC26734@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	hch@lst.de, miklos@szeredi.hu, akpm@osdl.org
References: <20080215223721.9E0A088A@kernel> <20080215223730.90A85F4A@kernel> <20080216003219.GA26734@mit.edu> <1203122979.13230.3.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203122979.13230.3.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 04:49:39PM -0800, Dave Hansen wrote:
> On Fri, 2008-02-15 at 19:32 -0500, Theodore Tso wrote:
> > On Fri, Feb 15, 2008 at 02:37:30PM -0800, Dave Hansen wrote:
> > > 
> > > This patch adds two function mnt_want_write() and mnt_drop_write().
> > > These are used like a lock pair around and fs operations that might
> > > cause a write to the filesystem.
> > 
> > Argh, is there some reason why this couldn't have gotten merged in
> > -rc1, ahead of the rest of the patch series?  This one is going to
> > cause more cross-tree merge pain with any filesystem tree that have
> > changes to fs/*/ioctl.c.
> 
> I wasn't meaning for this to hit the 2.6.25-rc series.  We had some
> review comments just when the merge window opened, and I was expecting
> them to get stuck back in -mm for another round.

Yeah, but it means that I need one set of patches for -mm, and another
set of patches for Linus's mainline.  I notice that your patchset is
currently missing changes for fs/ext4/ioctl.c --- I think because you
dropped them when Mingming picked them up, and then I dropped them
when I was trying to prepare the set of patches to push to Linus.

No problem, I'm sure I can ressurect them, but it's still the same
basic problem that when there are patchsets such as yours which touch
multiple trees in -mm, there are almost inevitably patch conflicts.

It would be nice if an initial patch which introduces the new
functionality you need for r/o bind mounts could get introduced into
mainline *first*, and then people could add patches that call
mnt_want_write(), et. al into their trees gradually.

As it is, I can't see a way around this other than maintaining two
separate patch sets, one that works with r/o bind mounts, and one for
mainline, since otherwise akpm gets grumpy and starts dropping either
your patchset or the ext4 patchset because *he* has to manually fix up
the patch conflicts.  (So instead I have to deal with it by hand, and
then *I* get grumpy.  :-/)

						- Ted
