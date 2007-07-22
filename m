Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXGVIvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXGVIvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXGVIvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:51:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59090 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329AbXGVIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:51:05 -0400
Date: Sun, 22 Jul 2007 10:52:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070722085217.GA27849@uranus.ravnborg.org>
References: <20070721203819.GA10706@mail.linbit.com> <p73hcnxuxji.fsf@bingen.suse.de> <20070722060925.GD18326@mail.linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722060925.GD18326@mail.linbit.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> there is just one logical piece, the drbd module...
> it is all in its own subdirectory.

For review purposes the split is often file based.
Something along the lines of:

Makefile + Kconfig
include/linux/drdb*   <= why 5 files for one module?
drdb_main.c
drdb_req.{c+h}
etc..

So essentially smaller pieces that can be revied but when ready for inclusion
it should go in as _one_ commit to avoid breaking bisect.

But please finish off all the CodingStyle issue before submission so the
review can concentrate on the actual content.

Quickly browsing drdb_int.h shows that there are a few issues yet to sort out.
typedef usage, funny macros, volatile etc.

	Sam
