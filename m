Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYJNHy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYJNHy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYJNHyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:54:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60186 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbYJNHyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:54:50 -0400
Date: Tue, 14 Oct 2008 09:54:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: QUEUE_FLAG_NONROT and merges
Message-ID: <20081014075407.GU19428@kernel.dk>
References: <20081014095017.265faf37@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014095017.265faf37@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14 2008, Pierre Ossman wrote:
> Hi Jeff,
> 
> I noticed you've added a new flag to indicate that the drive has no
> seek costs and I figured it would be a good idea to use that on the
> MMC/SD cards.

That was me, actually...

> Since the name isn't entirely clear in what is implied, I just wanted
> to check that there are no plans to assume that there is negligable
> request overhead for queues with this flag. I.e. the flag should
> indicate that the elevator doesn't have to care about seeks, but it
> should still try to merge requests to reduce the transaction overhead.

Sounds about right. The flag is just meant to indicate zero-seek cost,
as devices will still have per-command overheads, merging is still
applicable.

So yes, you want to set that flag for mmc/sd cards, definitely.

-- 
Jens Axboe

