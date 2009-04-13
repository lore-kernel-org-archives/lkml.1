Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZDMIY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZDMIY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZDMIYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:24:15 -0400
Received: from sh.osrg.net ([192.16.179.4]:37093 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZDMIYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:24:14 -0400
Date: Mon, 13 Apr 2009 17:22:01 +0900
To: jeff@garzik.org
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, tj@kernel.org,
       petkovbb@gmail.com, bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc
	cleanups
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49E2EFBE.5000709@garzik.org>
References: <49D214E7.2040908@panasas.com>
	<20090413163957P.fujita.tomonori@lab.ntt.co.jp>
	<49E2EFBE.5000709@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090413172143B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Apr 2009 17:22:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 03:54:38 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 31 Mar 2009 16:04:39 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >>> I
> >>> just don't think bvec should be used outside of block/fs interface.
> >>> As I wrote before, non-FS users have no reason to worry about bio.
> >>> All it should think about is the requst it needs to issue and the
> >>> memory area it's gonna use as in/out buffers.  bio just doesn't have a
> >>> place there.
> >>>
> >> I don't understand what happens to all the people that start to work on the block
> >> layer, they start getting defensive about bio being private to the request
> >> level. But the Genie is out of the bag already (I know cats and bottles).
> >> bio is already heavily used above the block layer from directly inside filesystems
> >> to all kind of raid engines, DM MD managers, multi paths, integrity information ...
> >>
> >> Because bio is exactly that Ideal page carrier you are talking about.
> > 
> > Wrong. multi path doesn't use bio. md accesses to the bio internal
> > (it's not nice) and has the own way to carry pages. dm has the own
> > mechanism on the top of bio. And bio doesn't work nicely for file
> > systems such as btrfs, which handle multiple devices.
> > 
> > Please stop your wrong argument 'bio is the ideal page carrier'.
> 
> What is the multi-device problem with bio?

Well, if it works nicely, I guess that we don't have something like
drivers/dm/{dm-bio-record.h, dm-bio-list.h}, btrfs_multi_bio struct,
or md's own page carrier?


> The idea behind bio is to be the ideal page carrier :)  It sounds like 
> bio needs revision, not abandonment.

I think that bio was designed to be an ideal page carrier for file
systems. But it's ideal not for everyone. I don't think that Boaz's
argument to use bio everywhere such as under drivers/scsi is a good
idea.

Yeah, a structure for page carrier needs revision anyway. At least, we
need to unify the way (or code) to handle multiple devices.
