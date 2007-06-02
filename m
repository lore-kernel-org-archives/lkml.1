Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXFBVx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXFBVx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759844AbXFBVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:53:19 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:41823 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759065AbXFBVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:53:18 -0400
Message-ID: <4661E6CA.1080203@dgreaves.com>
Date: Sat, 02 Jun 2007 22:53:14 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
References: <46609290.5030701@dgreaves.com> <46613C53.8010205@gmail.com>
In-Reply-To: <46613C53.8010205@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> David Greaves wrote:
>> I have 2 ide disks. If I enable SMART and hibernate/suspend2disk, SMART is
>> disabled when I resume.
>>
>> Same as in 2.6.21.1
> 
> According to the ATA standard, the device (drive) itself is responsible
> for preserving SMART enabled status over power cycles.  It seems your
> drive doesn't wanna do that.  I don't think mangling with SMART setup in
> the kernel is wise thing to do.  Bruce, any ideas?  Maybe hook smartd
> such that it gets suspend/resume events?

Sorry, FYI, I made the same mistake as when I reported the wol problem - I was
booting 2.6.21.1.

I am having problems with 2.6.22-rc3 but when it does suspend/resume I can
confirm that the problem is still there (of course).

However your comments still stand.

One unpleasant side effect is that I get

hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hda: drive_cmd: error=0x04 { DriveStatusError }
ide: failed opcode was: 0xb0
hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hda: drive_cmd: error=0x04 { DriveStatusError }
ide: failed opcode was: 0xb0
...
and
hdb: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hdb: drive_cmd: error=0x04 { DriveStatusError }
ide: failed opcode was: 0xb0
hdb: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hdb: drive_cmd: error=0x04 { DriveStatusError }
ide: failed opcode was: 0xb0
...

when the system comes back (induced from smartd I guess) until I do a:
 smartctl -son

David
