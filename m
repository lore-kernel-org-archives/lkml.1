Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYEXJ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYEXJ2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 05:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYEXJ2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 05:28:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45115 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYEXJ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 05:28:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4837DFC6.9010202@s5r6.in-berlin.de>
Date: Sat, 24 May 2008 11:28:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: floppy question of the hour
References: <200805232114.20937.gene.heskett@gmail.com>
In-Reply-To: <200805232114.20937.gene.heskett@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Cc: block layer maintainer for no solid reason...)

Gene Heskett wrote:
> Who is the maintainer of drivers/block/floppy.c and associated files?
> 
> I ask because there are a few of us still using it, in particular with what some 
> may call oddball disk formats & I'm up to here with doing such as this:
> 
> [root@coyote coco3]# setfdprm /dev/fd0 COCO7203.5
> [root@coyote coco3]# getfdprm /dev/fd0
> get geometry parameters: No such device
> 
> Or: Assuming the above took,
> [root@coyote coco3]# dd if=/dev/fd0 of=test.dsk
> dd: reading `/dev/fd0': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 25.5495 s, 0.0 kB/s
> 
> /var/log/messages is full of these now:
> May 23 21:02:07 coyote kernel: [20603.055178] floppy0: probe failed...
> May 23 21:02:07 coyote kernel: [20603.455755] floppy0: unexpected interrupt
> May 23 21:02:07 coyote kernel: [20603.455827] floppy0: sensei repl[0]=80
> May 23 21:02:07 coyote kernel: [20603.456135] floppy0: -- FDC reply 
> errorfloppy0: probe failed...
[...]
> The drive led is on and the disk is turning during that 25 seconds.
> This is booted to 2.6.26-rc2, with the floppy driver built in.

There was only a single change to drivers/block/floppy.c after 2.6.25:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7afea3bcb1f87f3ddf34b38f202ad0d03f29e120

This looks OK to me; I suppose the problem comes from somewhere else.

> 2.6.26-rc1 worked flawlessly yesterday, for both writing, then reading back for 
> a cmp session, twice each way, until it(2.6.26-rc1) went away after about 3 
> hours uptime, the 5th time -rc1 had done this to me without a single footprint 
> in the logs.  -rc2 is doing better, uptime is 5:45 so far.
[...]

By "until it(2.6.26-rc1) went away" you mean a crash during writing to 
or reading from the FDD, or during general usage?
-- 
Stefan Richter
-=====-==--- -=-= ==---
http://arcgraph.de/sr/
