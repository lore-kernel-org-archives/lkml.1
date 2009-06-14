Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZFNQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZFNQBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZFNQBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:01:10 -0400
Received: from waste.org ([66.93.16.53]:56528 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZFNQBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:01:09 -0400
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0906141119030.13473@sister.anvils>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org>
	 <Pine.LNX.4.64.0906131456090.5069@sister.anvils>
	 <20090614100110.GA19875@localhost>
	 <Pine.LNX.4.64.0906141119030.13473@sister.anvils>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 11:00:14 -0500
Message-Id: <1244995214.4496.234.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 11:39 +0100, Hugh Dickins wrote:
> On Sun, 14 Jun 2009, Wu Fengguang wrote:
> > On Sat, Jun 13, 2009 at 10:15:51PM +0800, Hugh Dickins wrote:
> > > On Sat, 13 Jun 2009, Mike Frysinger wrote:
> > > 
> > > > On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
> > > > fail when tmpfs options are used.  This is because tmpfs creates a small
> > > > wrapper around ramfs which rejects unknown options, and ramfs itself only
> > > > supports a tiny subset of what tmpfs supports.  This makes it pretty hard
> > > > to use the same userspace systems across different configuration systems.
> > > > As such, ramfs should ignore the tmpfs options when tmpfs is merely a
> > > > wrapper around ramfs.
> > > 
> > > Yes, indeed, thanks a lot for reporting this.
> > > 
> > > But I'm uneasy with making ramfs behaviour differ with CONFIG_SHMEM
> > > (perhaps that's silly: certainly tmpfs behaviour differs with it),
> > > and uneasy with coding a list of options we need to remember to keep
> > > in synch with mm/shmem.c.  It's easier to justify ignoring all options,
> > > than rejecting some while ignoring others yet not respecting them.
> > 
> > We can avoid the burden of syncing a list of options between
> > ramfs<>tmpfs by a slightly differently patch. Hopefully this makes
> > ramfs behave like other filesystems when used standalone.
> 
> We could do; but I'm still preferring not.  How about you, Matt?
> You decide, I think Andrew has chosen a different race track from
> "The Merge Window" this weekend.

I prefer the 'silently ignore' approach.

The only other approach that I think is reasonably clean is to
'subclass' ramfs by wrapping its init function with one that discards
mount args. Unfortunately that adds code and data in the 'I don't give a
damn, just keep it tiny' case, so that's a non-starter.

-- 
http://selenic.com : development and support for Mercurial and Linux


