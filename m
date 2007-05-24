Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXEXJ3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXEXJ3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXEXJ2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:28:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64075 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbXEXJ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:28:52 -0400
Date: Thu, 24 May 2007 11:27:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?Ren=E9?= Peters <ice.face@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SCSI drives, audio CDs and temporary system freeze with AIC7xxx
Message-ID: <20070524092755.GO5722@kernel.dk>
References: <200705241112.55901.ice.face@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705241112.55901.ice.face@gmx.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24 2007, René Peters wrote:
> Hello!
> 
> Inserting of audio CDs causes my system to hang with high I/O-load while 
> kded's mediamanagement is running.
> Long time later (round about 10-20 minutes) the system comes back again and 
> i'm able to play the audio CD. The issue is reproduceable with the following 
> drive:
> ->CD-R   PX-W1210S
> Data CD's don't show this behavior.
> No system freeze or any other bad behavior with audio CDs after stopping 
> kded's mediamanagement by hand. Maybe it is a kernel bug, maybe a bug in 
> kded.

My guess would be that the program is issuing some command that craps
out the drive (or controller). It could be a wrong length, or some other
cdb field set incorrectly.

You should try and run blktrace on the device, so we can see which
command is wreaking havoc. In short steps:

- Download http://brick.kernel.dk/snaps/blktrace-git-latest.tar.gz,
  untar, make, make install.

- Make sure your config has blktrace support, it's
  CONFIG_BLK_DEV_IO_TRACE and is in the block layer menu.

Now you are ready to reproduce the problem.

- Run blktrace /dev/sr0 (I'm assuming you only have the one SCSI cd-rom).

- Insert an audio CD.

This should now cause the adaptec drive to go nuts like it usually does.
Once things have settled down and the freeze is over, ctrl-c blktrace.
Then do:

- blkparse sr0 -o sr0.log

and send sr0.log in a reply to this message.

-- 
Jens Axboe

