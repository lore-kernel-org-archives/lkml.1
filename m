Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYBZIV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYBZIV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYBZIVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:21:19 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:57550 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbYBZIVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:21:18 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang 
In-reply-to: <200802241654.49150.bzolnier@gmail.com> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <200802240012.36571.bzolnier@gmail.com> <20080224082547.84F542DC002@tippex.mynet.homeunix.org> <200802241654.49150.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Sun, 24 Feb 2008 16:54:49 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 26 Feb 2008 09:20:56 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080226082056.7519C93C195@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JTv3p-0006zp-8h.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JTv3p-0006zp-8h 03ac202739f7ac9e011d9642536069e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> bzolnier@gmail.com said:
> > Could you try bisecting it down to the guilty commit using git-bisect?
> > [ the "old" stuff got few hundred commits in 2.6.25 ]
> > Thanks, Bart 

Ok, I got this:
852738f39258deafb3d89c187cb1a4050820d555 is first bad commit
commit 852738f39258deafb3d89c187cb1a4050820d555
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sat Jan 26 20:13:12 2008 +0100

    ide: convert "empty" REQ_TYPE_ATA_CMD requests to use REQ_TYPE_ATA_TASKFILE

    Based on the previous work by Tejun Heo.

    There should be no functionality changes caused by this patch.

    Cc: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

:040000 040000 e65605824ccc1c8bda2ab6f917b5457d36c5537e 5fb514a261b13494c5e9c035f9e7598276ce8839 M      drivers

I'll run with the last known good version for a while,so if there's any more 
testing needed let me know.

/A 

