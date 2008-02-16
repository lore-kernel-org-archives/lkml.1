Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbYBPBMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbYBPBMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYBPBMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:12:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222AbYBPBMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:12:13 -0500
Date: Fri, 15 Feb 2008 17:11:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: haveblue@us.ibm.com, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
Message-Id: <20080215171119.578bd302.akpm@linux-foundation.org>
In-Reply-To: <20080216010030.GC26734@mit.edu>
References: <20080215223721.9E0A088A@kernel>
	<20080215223730.90A85F4A@kernel>
	<20080216003219.GA26734@mit.edu>
	<1203122979.13230.3.camel@nimitz.home.sr71.net>
	<20080216010030.GC26734@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 20:00:30 -0500
Theodore Tso <tytso@MIT.EDU> wrote:

> On Fri, Feb 15, 2008 at 04:49:39PM -0800, Dave Hansen wrote:
> > On Fri, 2008-02-15 at 19:32 -0500, Theodore Tso wrote:
> > > On Fri, Feb 15, 2008 at 02:37:30PM -0800, Dave Hansen wrote:
> > > > 
> > > > This patch adds two function mnt_want_write() and mnt_drop_write().
> > > > These are used like a lock pair around and fs operations that might
> > > > cause a write to the filesystem.
> > > 
> > > Argh, is there some reason why this couldn't have gotten merged in
> > > -rc1, ahead of the rest of the patch series?  This one is going to
> > > cause more cross-tree merge pain with any filesystem tree that have
> > > changes to fs/*/ioctl.c.
> > 
> > I wasn't meaning for this to hit the 2.6.25-rc series.  We had some
> > review comments just when the merge window opened, and I was expecting
> > them to get stuck back in -mm for another round.
> 
> Yeah, but it means that I need one set of patches for -mm, and another
> set of patches for Linus's mainline.  I notice that your patchset is
> currently missing changes for fs/ext4/ioctl.c --- I think because you
> dropped them when Mingming picked them up, and then I dropped them
> when I was trying to prepare the set of patches to push to Linus.
> 
> No problem, I'm sure I can ressurect them, but it's still the same
> basic problem that when there are patchsets such as yours which touch
> multiple trees in -mm, there are almost inevitably patch conflicts.
> 
> It would be nice if an initial patch which introduces the new
> functionality you need for r/o bind mounts could get introduced into
> mainline *first*, and then people could add patches that call
> mnt_want_write(), et. al into their trees gradually.

Yes, I expect that merging a handful of do-nothing mnt_foo_write()
functions into mainline right now would ease life.

> otherwise akpm gets grumpy

itym "less than usually cheery"
