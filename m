Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYIDNw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYIDNw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYIDNwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:52:20 -0400
Received: from stargate.synerway.com ([84.14.10.249]:34343 "EHLO
	kamino.synerway.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbYIDNwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:52:19 -0400
Date: Thu, 4 Sep 2008 15:52:16 +0200
From: Pascal GREGIS <pgs@synerway.com>
To: linux-kernel@vger.kernel.org
Subject: Re: SCSI or libata problem with an RDX removable disk
Message-ID: <20080904135216.GF2814@venus.synerway.com>
References: <20080904095447.GE2814@venus.synerway.com> <20080904123418.4fab9ea3@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080904123418.4fab9ea3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
X-OriginalArrivalTime: 04 Sep 2008 13:52:16.0344 (UTC) FILETIME=[70E06580:01C90E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox a écrit, le jeu 04 sep 2008 à 12:34:18 :
> > Looking to /var/log/messages I have the following logs :
> 
> I need the logs where it fails not afterwards - the ones showing the
> drive error and where the fs gives up. Without that it is hard to see
> what happened.
Sorry, you're right, I didn't see these logs :
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

What is strange is that before this, I have logs looking like :

Sep  4 07:27:32 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:27:32 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:27:32 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:27:32 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:27:32 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:27:32 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:28:20 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:28:20 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:28:20 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:28:20 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:28:20 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:28:20 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:28:52 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:28:52 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:28:52 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:28:52 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:28:52 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:28:52 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:36:19 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:36:19 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:36:19 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:36:20 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:36:20 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:36:20 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:37:01 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:37:01 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:37:01 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:37:01 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:37:01 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:37:01 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:38:12 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:38:12 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:38:12 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Sep  4 07:38:12 devsni1 kernel: kjournald starting.  Commit interval 5 seconds
Sep  4 07:38:12 devsni1 kernel: EXT3 FS on sdb, internal journal
Sep  4 07:38:12 devsni1 kernel: EXT3-fs: mounted filesystem with ordered data mode.

and all my /var/log/messages is polluted with such logs way before 07:28 until the error happens.
Maybe this is due to commands automatically executed by our softwares running on this machine, do you know if it is normal?

> 
> > My system is :
> > linux kernel 2.6.21.1 with some patches :
> > - libata-start_stop_management (http://bugs.gentoo.org/attachment.cgi?id=118829)
> 
> It would be useful to know if a 2.6.25/2.6.26 kernel without other
> patches does the same thing.
Yes, but this is not so easy to do, we haven't currently a clear status on the frequence of reproduction of the bug.
I'll see what I can do.

> > 
> > compiled with libata.
> > 
> > Motherboard ICH6 family (id 2651)
> > ...

Regards

Pascal
