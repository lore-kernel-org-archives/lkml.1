Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZI2XkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZI2XkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZI2XkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:40:08 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:48173 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752830AbZI2XkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:40:08 -0400
Date: Wed, 30 Sep 2009 09:39:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <chris.mason@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090929233936.GG9464@discord.disaster>
References: <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928142524.GC6405@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928142524.GC6405@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 10:25:24AM -0400, Chris Mason wrote:
> On Mon, Sep 28, 2009 at 11:07:00AM +1000, Dave Chinner wrote:
> > In the context of the setup I was talking about, I meant is that sync
> > IO _should_ be unthrottled because it is self-throttling by it's
> > very nature. The current code makes no differentiation between the
> > two.
> 
> This isn't entirely true anymore.  WB_SYNC_ALL is turned into a sync
> bio, which is sent down with higher priority.  There may be a few spots
> that still need to be changed for it, but it is much better than it was.

Oh, I didn't realise that had changed - when did WRITE_SYNC_PLUG get
introduced? FWIW, I notice that __block_write_full_page(), gfs2, btrfs
and jdb use WRITE_SYNC_PLUG to implement this, but it appears that
filesystems that have their own writeback code (e.g. XFS) have not
been converted (gfs2 and btrfs being the exceptions).

Oh well, something else that needs tweaking in XFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
