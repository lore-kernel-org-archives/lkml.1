Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbXKDN0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbXKDN0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbXKDN0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:26:25 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbXKDN0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:26:25 -0500
Date: Sun, 4 Nov 2007 14:26:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to  boot: kernel BUG at include/linux/scatterlist.h:49!
Message-ID: <20071104132621.GM28340@kernel.dk>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com> <472BA567.8040301@s5r6.in-berlin.de> <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com> <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk> <20071104084456.GJ28340@kernel.dk> <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com> <20071104130315.GL28340@kernel.dk> <472DC6DE.6050402@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472DC6DE.6050402@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04 2007, Stefan Richter wrote:
> Jens Axboe wrote:
> > Chained sg lists will only be feed to a scsi host controller that
> > enables chaining in its host template.
> > 
> > The fix looks fine though, it's just not a requirement or bug fix :-)
> 
> Good, then the sbp2 and fw-sbp2 patches can wait for 2.6.25.
> 
> Which criteria decide whether a SCSI low-level driver should enable
> chained s/g lists?  The SBP-2 protocol supports s/g lists with up to
> 65535 entries.  The sbp2 and fw-sbp2 driver limit this currently to SG_ALL.

If the driver can benefit (or even requires) from more segments than you
can typically allocate in one piece, then it should enable chaining. In
general, all drivers must be transitioned to using the sg accessor
helpers, so we can eventually kill the sg chaining enable parameter in
the host template and just make it the default. The parameter is only
there as a transition help.

-- 
Jens Axboe

