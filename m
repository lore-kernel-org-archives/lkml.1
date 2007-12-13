Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbXLMT0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbXLMT0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXLMT0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:26:41 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24568 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595AbXLMT0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:26:40 -0500
Date: Thu, 13 Dec 2007 20:26:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Matthew Wilcox <matthew@wil.cx>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Message-ID: <20071213192633.GD10104@kernel.dk>
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca> <47617E72.6080504@rtr.ca> <20071213185326.GQ26334@parisc-linux.org> <4761821F.3050602@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4761821F.3050602@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13 2007, Mark Lord wrote:
> Matthew Wilcox wrote:
> >On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
> >>Problem confirmed.  2.6.23.8 regularly generates segments up to 64KB for 
> >>libata,
> >>but 2.6.24 uses only 4KB segments and a *few* 8KB segments.
> >
> >Just a suspicion ... could this be slab vs slub?  ie check your configs
> >are the same / similar between the two kernels.
> ..
> 
> Mmmm.. a good thought, that one.
> But I just rechecked, and both have CONFIG_SLAB=y
> 
> My guess is that something got changed around when Jens
> reworked the block layer for 2.6.24.
> I'm going to dig around in there now.

I didn't rework the block layer for 2.6.24 :-). The core block layer
changes since 2.6.23 are:

- Support for empty barriers. Not a likely candidate.
- Shared tag queue fixes. Totally unlikely.
- sg chaining support. Not likely.
- The bio changes from Neil. Of the bunch, the most likely suspects in
  this area, since it changes some of the code involved with merges and
  blk_rq_map_sg().
- Lots of simple stuff, again very unlikely.

Anyway, it sounds odd for this to be a block layer problem if you do see
occasional segments being merged. So it sounds more like the input data
having changed.

Why not just bisect it?

-- 
Jens Axboe

