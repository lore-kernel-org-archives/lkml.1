Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbYEXBOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbYEXBOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYEXBOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:14:33 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:14594 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYEXBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:14:32 -0400
Date: Fri, 23 May 2008 21:14:20 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: floppy question of the hour
To: linux-kernel@vger.kernel.org
Message-id: <200805232114.20937.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

Who is the maintainer of drivers/block/floppy.c and associated files?

I ask because there are a few of us still using it, in particular with what some 
may call oddball disk formats & I'm up to here with doing such as this:

[root@coyote coco3]# setfdprm /dev/fd0 COCO7203.5
[root@coyote coco3]# getfdprm /dev/fd0
get geometry parameters: No such device

Or: Assuming the above took,
[root@coyote coco3]# dd if=/dev/fd0 of=test.dsk
dd: reading `/dev/fd0': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 25.5495 s, 0.0 kB/s

/var/log/messages is full of these now:
May 23 21:02:07 coyote kernel: [20603.055178] floppy0: probe failed...
May 23 21:02:07 coyote kernel: [20603.455755] floppy0: unexpected interrupt
May 23 21:02:07 coyote kernel: [20603.455827] floppy0: sensei repl[0]=80
May 23 21:02:07 coyote kernel: [20603.456135] floppy0: -- FDC reply 
errorfloppy0: probe failed...
May 23 21:02:08 coyote kernel: [20604.257007] floppy0: probe failed...
May 23 21:02:08 coyote kernel: [20604.658234] floppy0: probe failed...
May 23 21:02:08 coyote kernel: [20604.658546] end_request: I/O error, dev fd0, 
sector 0
May 23 21:02:08 coyote kernel: [20604.658552] Buffer I/O error on device fd0, 
logical block 0
May 23 21:02:15 coyote kernel: [20611.468471] floppy0: probe failed...
May 23 21:02:16 coyote kernel: [20612.269749] floppy0: probe failed...
May 23 21:02:16 coyote kernel: [20612.670448] floppy0: probe failed...
May 23 21:02:17 coyote kernel: [20613.071326] floppy0: probe failed...
May 23 21:02:17 coyote kernel: [20613.471699] floppy0: probe failed...
May 23 21:02:17 coyote kernel: [20613.872260] floppy0: probe failed...
May 23 21:02:18 coyote kernel: [20614.272896] floppy0: probe failed...
May 23 21:02:18 coyote kernel: [20614.673525] floppy0: probe failed...
May 23 21:02:19 coyote kernel: [20615.474809] floppy0: probe failed...
May 23 21:02:19 coyote kernel: [20615.879286] floppy0: probe failed...
May 23 21:02:20 coyote kernel: [20616.276125] floppy0: probe failed...
May 23 21:02:20 coyote kernel: [20616.676819] floppy0: probe failed...
May 23 21:02:21 coyote kernel: [20617.077384] floppy0: probe failed...
May 23 21:02:21 coyote kernel: [20617.478006] floppy0: probe failed...
May 23 21:02:21 coyote kernel: [20617.478326] end_request: I/O error, dev fd0, 
sector 0
May 23 21:02:21 coyote kernel: [20617.478333] Buffer I/O error on device fd0, 
logical block 0

The drive led is on and the disk is turning during that 25 seconds.
This is booted to 2.6.26-rc2, with the floppy driver built in.

2.6.26-rc1 worked flawlessly yesterday, for both writing, then reading back for 
a cmp session, twice each way, until it(2.6.26-rc1) went away after about 3 
hours uptime, the 5th time -rc1 had done this to me without a single footprint 
in the logs.  -rc2 is doing better, uptime is 5:45 so far.

It may be old technology, but really guys, we need a _working_ floppy driver. 
100% of the time.

I did not build it in when I built 2.6.26-rc1, so I'm going to reboot to it for 
long enough to see if it works when built as a module.
-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"They that can give up essential liberty to obtain a little temporary
safety deserve neither liberty nor safety."
		-- Benjamin Franklin, 1759
