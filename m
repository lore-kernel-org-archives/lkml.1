Return-Path: <linux-kernel-owner+w=401wt.eu-S936204AbXGQTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936204AbXGQTxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936085AbXGQTw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:52:56 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:48552 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936158AbXGQTwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:52:54 -0400
Subject: Re: block/bsg.c
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20070717124810.cdf54572.akpm@linux-foundation.org>
References: <20070717065940.GZ5195@kernel.dk>
	 <20070717160816K.fujita.tomonori@lab.ntt.co.jp>
	 <20070717071045.GD5195@kernel.dk>
	 <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	 <20070717101928.GK5195@kernel.dk>
	 <1184698434.3378.15.camel@localhost.localdomain>
	 <20070717124810.cdf54572.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 14:52:52 -0500
Message-Id: <1184701972.3378.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 12:48 -0700, Andrew Morton wrote:
> On Tue, 17 Jul 2007 13:53:54 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Tue, 2007-07-17 at 12:19 +0200, Jens Axboe wrote:
> > > > > Since Linus is happily snoring by now, could you test and see if the
> > > > > tree works for you?
> > > > 
> > > > It works for me. I'll submit some minor patches against your bsg
> > > > branch to scsi-ml. Can you push them together?
> > > 
> > > Certainly, I'll pull them into the bsg branch.
> > 
> > While you're at it, here's a patch to separate BSG and SCSI again (so
> > SCSI can be built modular).  The way I did it was simply to move the
> > SCSI specific logic into SCSI.  When you come up with a generic way to
> > register the bsg requiring drivers, then we can move it out again.
> 
> I note that block/scsi_ioctl.c is geting compiled with CONFIG_SCSI=n. 
> Seems odd.

No, that's fine ... the reason scsi_ioctl.c moved to block was precisely
so that non SCSI devices could use the ioctls, thus it should be there
even if SCSI is not.

> (Actually, it's failing to compile (in the middle of the bsg series) so I need
> to fix it by hand somehow to continue this bisect)

I generally use quilt to help with this (just quilt up the fix and apply
and remove it around the bisects).  I seem to get tons of trees with
unrelated breakage right around where the voyager failures are.

James


