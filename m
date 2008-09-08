Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbYIHIUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbYIHIUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 04:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYIHIT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 04:19:57 -0400
Received: from stargate.synerway.com ([84.14.10.249]:30663 "EHLO
	kamino.synerway.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751945AbYIHIT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 04:19:56 -0400
Date: Mon, 8 Sep 2008 10:19:54 +0200
From: Pascal GREGIS <pgs@synerway.com>
To: linux-kernel@vger.kernel.org
Subject: Re: SCSI or libata problem with an RDX removable disk
Message-ID: <20080908081954.GA2849@venus.synerway.com>
References: <20080904095447.GE2814@venus.synerway.com> <20080904123418.4fab9ea3@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904123418.4fab9ea3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
X-OriginalArrivalTime: 08 Sep 2008 08:19:53.0807 (UTC) FILETIME=[ABD9BDF0:01C9118B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I posted this problem last week on this mailing list, I got an answer from Alan Cox requiring more informations.
Then when I gave those informations, I didn't get any other answer.
So I try another time to get help from some of you.

Here is my problem :
I have a Linux box with an RDX removable disk in SATA. A software uses regularly this RDX, mounts it, reads and/or writes to it and unmounts it.
But after a certain time or a certain number of uses (not clearly identified), the device fails to respond, mount displaying something like :
"There is no filesystem on this device"

In /var/log/messages I have :
Sep  4 08:03:01 devsni1 kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sep  4 08:03:01 devsni1 kernel: ata4.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x2a data 131072 out
Sep  4 08:03:01 devsni1 kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep  4 08:03:08 devsni1 kernel: ata4: port is slow to respond, please be patient (Status 0xd0)
Sep  4 08:03:31 devsni1 kernel: ata4: port failed to respond (30 secs, Status 0xd0)
Sep  4 08:03:31 devsni1 kernel: ata4: soft resetting port
Sep  4 08:03:32 devsni1 kernel: ATA: abnormal status 0xD0 on port 0x0001d807
Sep  4 08:03:32 devsni1 last message repeated 4 times
Sep  4 08:06:14 devsni1 kernel: 
Sep  4 08:06:14 devsni1 kernel: sd 3:0:0:0: SCSI error: return code = 0x00040000
Sep  4 08:06:14 devsni1 kernel: end_request: I/O error, dev sdb, sector 37700080
Sep  4 08:06:14 devsni1 kernel: sd 3:0:0:0: SCSI error: return code = 0x00040000
Sep  4 08:06:14 devsni1 kernel: end_request: I/O error, dev sdb, sector 37700336
Sep  4 08:06:14 devsni1 kernel: sd 3:0:0:0: SCSI error: return code = 0x00040000
Sep  4 08:06:14 devsni1 kernel: end_request: I/O error, dev sdb, sector 37700592
Sep  4 08:06:14 devsni1 kernel: sd 3:0:0:0: SCSI error: return code = 0x00040000
Sep  4 08:06:14 devsni1 kernel: end_request: I/O error, dev sdb, sector 37700848
... and so on with always different sector numbers.

And then everytime I issue a mount, a parted, a dd or anything, I get the following logs :

Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] READ CAPACITY failed
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Sense not available.
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Write Protect is off
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 00 00 00
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Asking for cache data failed
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Assuming drive cache: write through
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] READ CAPACITY failed
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Sense not available.
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Write Protect is off
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 00 00 00
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Asking for cache data failed
Sep  4 08:55:54 testrdx kernel: sd 0:0:1:0: [sdb] Assuming drive cache: write through

Does anyone know to what are referring the rrors seen in the logs, or if there is a known bug on this point or anything that could help me? 

My system is :
linux kernel 2.6.21.1 with some patches :
- libata-start_stop_management (http://bugs.gentoo.org/attachment.cgi?id=118829)

compiled with libata.
Motherboard ICH6 family (id 2651)
...

Alan Cox suggested me to test with a 2.6.25/2.6.26 kernel without other
patches, but this is not so easy to do, I haven't currently a clear status on the frequence of reproduction of the bug.
I'll see what I can do.

Regards

Pascal
