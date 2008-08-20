Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYHTUTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYHTUTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYHTUSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:18:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176AbYHTUSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:18:50 -0400
Date: Wed, 20 Aug 2008 13:18:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anemo@mba.ocn.ne.jp, viro@ZenIV.linux.org.uk,
       djohnson@sw.starentnetworks.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org
Subject: Re: cramfs and named-pipe
Message-Id: <20080820131817.1a8006aa.akpm@linux-foundation.org>
In-Reply-To: <20080815155220.91ec8201.akpm@linux-foundation.org>
References: <20080804.182143.218269280.nemoto@toshiba-tops.co.jp>
	<20080804100347.GU28946@ZenIV.linux.org.uk>
	<20080805.120909.139657748.nemoto@toshiba-tops.co.jp>
	<20080815155220.91ec8201.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 15:52:20 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 05 Aug 2008 12:09:09 +0900 (JST)
> Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> 
> > On Mon, 4 Aug 2008 11:03:47 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > > Eeek...  I'd rather not play these games with directories and devices nodes
> > > as well.  Rationale for the original patch simply doesn't apply for those.
> > > 
> > > IOW, I think it would be much saner if we did the following: make ..._test()
> > > refuse to merge inodes with ->i_ino == 1, take inode setup back to
> > > get_cramfs_inode() and make ->drop_inode() evict ones with ->i_ino == 1
> > > immediately.  Comments?
> > > 
> > > Patch below is completely untested; it builds, but that's it.
> > 
> > Thanks, your patch works well for me.  But it looks a bit large for
> > stable tree (100 line rule).
> > 
> > With current code, I think no problem on empty directories and device
> > nodes.  So how about fixing only FIFO case first (and send it to
> > stable tree) and then go to your patch?
> > 
> 
> Nothing seems to have happened.  Al, do you think your (now tested) patch
> is good for 2.6.27 and 2.6.26.x?  And, it seems, 2.6.25.x.  (All the way
> down to 2.6.14.x!)

<crickets chirping>

Oh well, I'll send it in.
