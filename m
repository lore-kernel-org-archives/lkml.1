Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbXHQHWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbXHQHWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbXHQHWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:22:03 -0400
Received: from ns.suse.de ([195.135.220.2]:37931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbXHQHWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:22:01 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 17 Aug 2007 17:21:54 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18117.19602.616561.525863@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 000 of 6] A few block-layer tidy-up patches.
In-Reply-To: message from Jens Axboe on Friday August 17
References: <20070816211551.11839.patches@notabene>
	<20070816113638.GX23758@kernel.dk>
	<18116.61035.621593.588647@notabene.brown>
	<20070817061733.GD23758@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday August 17, jens.axboe@oracle.com wrote:
> > > Please inspect the #block-2.6.24 branch to see the result.
> > 
> > I don't know where to look for this.  I checked
> >   http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git
> > but they don't seem to be there.
> > ??
> 
> That's where it is, but the kernel.org mirroring is just horrible slow.
> Just checked now and it's there.

I discovered I was looking in the wrong place - not being very
familiar with git terminology.
I found them and it looks right.

I had a bit of a look at removing bio_data and ->buffer ...  the
usages outside of drivers/ide are fairly easy to deal with - I might
send a patch for that.  The drivers/ide stuff looks like a fairly
substantial rewrite is in order.
e.g.  idefloppy_packet_command_s seems to duplicate a lot of 
  fields from 'struct request', and it should probably use the request
  struct directly.

But a number of times ->buffer points to ->cmd, and there is no bio.
I guess we should use bio_map_kern to make a bio?

I'll see if I can come up with something.... testing it might be
awkward.  I have an ide cdrom I can test on.  Maybe an ide disk,, but
not an ide floppy :-)

NeilBrown
