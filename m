Return-Path: <linux-kernel-owner+w=401wt.eu-S1765200AbXHFRUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765200AbXHFRUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbXHFRTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:19:52 -0400
Received: from waste.org ([66.93.16.53]:56111 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291AbXHFRTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:19:51 -0400
Date: Mon, 6 Aug 2007 12:20:03 -0500
From: Matt Mackall <mpm@selenic.com>
To: Lindsay Roberts <lindsay.roberts.os@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
Subject: Re: [PATCH] fs: Add romfs version 2
Message-ID: <20070806172002.GW11115@waste.org>
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com> <20070717013635.d6d0b124.akpm@linux-foundation.org> <20070717192100.GE11166@waste.org> <8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com> <20070725184005.GD8225@ucw.cz> <8734b7880708060043i125419e0w3db5d4431496985f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734b7880708060043i125419e0w3db5d4431496985f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 05:43:54PM +1000, Lindsay Roberts wrote:
> On 7/26/07, Pavel Machek <pavel@ucw.cz> wrote:
> > If the fs is read-only.. can we do some tail packing and get _both_
> > speed and space efficiency?
> 
> You mean don't block align files of size less than 1k, and
> intelligently pack them into the gaps left by files that are aligned?
> Does seem that most noticeable performance issues occur on sequential
> reads of large files, this sounds like a good idea, but I would
> welcome comments on this.
> 
> Also I assume romfs currently has a small hidden benefit as a result
> of it storing its file data serially after the inode: the initial read
> of the inode reads and therefore caches the block containing the
> (initial) file data. Obviously with block aligned file data this only
> applies if sequential prefetching is performed. I'd be interested to
> know if this is an issue worth regarding.

It seems to me that the initial design goals of romfs were:

a) space efficiency
b) simplicity

..with performance basically ignored. On an actual ROM-backed
filesystem, alignment doesn't help you until it becomes large enough
that you can execute pages in place.

And I don't think your reproduceability concern was even on the radar.
So naming a new filesystem romfs which has the priorities:

a) performance
b) reproduceability

seems like it's going to disappoint and confuse people who were
aligned with the original goals.

-- 
Mathematics is the supreme nostalgia of our time.
