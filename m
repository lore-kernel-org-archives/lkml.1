Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbXAWBKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbXAWBKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXAWBKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:10:17 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:40270 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438AbXAWBKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:10:15 -0500
Date: Tue, 23 Jan 2007 10:10:11 +0900 (JST)
Message-Id: <20070123.101011.25910575.nemoto@toshiba-tops.co.jp>
To: david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, akpm@osdl.org
Subject: Re: [PATCH 2.6.20-rc5] SPI: alternative fix for
 spi_busnum_to_master
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200701221412.02452.david-b@pacbell.net>
References: <20070118.202849.70477632.nemoto@toshiba-tops.co.jp>
	<20070122.112509.55511116.nemoto@toshiba-tops.co.jp>
	<200701221412.02452.david-b@pacbell.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007 14:12:02 -0800, David Brownell <david-b@pacbell.net> wrote:
> > Here is a revised version.  The children list of spi_master_class
> > contains only spi_master class so we can just compare bus_num member
> > instead of class_id string.
> 
> Looks just a bit iffy ... though, thanks for helping to finally
> sort this out!

Well, so previous patch (which was checking class_id string) would be
preferred?

> > +		cdev = class_device_get(cdev);
> > +		if (!cdev)
> > +			continue;
> 
> That "continue" case doesn't seem like it should be possible... but
> at any rate, the "get" can be deferred until the relevent class
> device is known, since that _valid_ handle can't disappear so long
> as that semaphore is held.  And if you find the right device but
> can't get a reference ... no point in continuing!
> 
> Something like a class_find_device() would be the best way to solve
> this sort of problem, IMO.  But we don't have one of those.  :(

Indeed the check can be omitted.  Should I send a new patch just
moving class_device_get() into "if (master->bus_num == bus_num)"
block?

The crashing with udev is 2.6.20 regression so I wish this fixed very
soon.  Thank you for review.

---
Atsushi Nemoto
