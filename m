Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbXGQVZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbXGQVZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbXGQVZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:25:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbXGQVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:25:23 -0400
Date: Tue, 17 Jul 2007 14:24:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
In-Reply-To: <200707172320.12141.bzolnier@gmail.com>
Message-ID: <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org>
References: <469D1D5E.8050609@cateee.net>
 <200707172320.12141.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> ide-disk driver and type 2 (REQ_TYPE_BLOCK_PC) requests don't mix well
> 
> Probably some dumb application is sending packet commands without
> checking the device type...

Ok, we should definitely try to just translate the things, and instead of 
having user apps that have to know about the (generally not very 
interesting) differences between IDE and SCSI command set, and when the 
IDE driver gets a SCSI request (whether from the new generic SG layer or 
obviously the older SCSI-ioctl layer) it should "just work".

So I object to that "dumb application" statement. It's the kernel that has 
traditionally been dumb in not smoothing over the differences between 
devices well enough.

We shouldn't _need_ to have applications care. They should be able to just 
use regular SCSI commands, and if the device cannot handle a 10-byte read 
command, the kernel should have translated that into a 6-byte one (for 
example) rather than the application having to know about idiotic small 
differences like that.

That said, I dunno how to fix this particular one, and the IDE driver is 
singularly unhelpful in actually talking about *what* the command tried to 
be.

			Linus
