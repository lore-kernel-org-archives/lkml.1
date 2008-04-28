Return-Path: <linux-kernel-owner+w=401wt.eu-S933951AbYD1M5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbYD1M5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765910AbYD1M4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:56:55 -0400
Received: from styx.suse.cz ([82.119.242.94]:40586 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765802AbYD1M4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:56:54 -0400
Date: Mon, 28 Apr 2008 14:56:53 +0200
From: Jan Kara <jack@suse.cz>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ./fs/partitions/check.c: off-by-one error ?
Message-ID: <20080428125652.GD17054@duck.suse.cz>
References: <200804201235.46552.toralf.foerster@gmx.de> <20080422103829.GC21922@atrey.karlin.mff.cuni.cz> <200804231843.00379.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804231843.00379.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-04-08 18:42:57, Toralf Förster wrote:
> At Tuesday 22 April 2008 12:38:29 Jan Kara wrote :
> >   This looks more like a strange interaction of your device size (it
> > claims to have 3902463 sectors) and your partitioning programs which
> > create partition ending at sector 3902464. Can you send the partition
> > table you have on the device? E.g:
> >   fdisk /dev/sda
> >   x
> >   p
> > 
> >   will print detailed information about the partition table.
> > 
> 
> n22 ~ # fdisk /dev/sda
> 
> The number of cylinders for this disk is set to 1267.
> There is nothing wrong with that, but this is larger than 1024,
> and could in certain setups cause problems with:
> 1) software that runs at boot time (e.g., old versions of LILO)
> 2) booting and partitioning software from other OSs
>    (e.g., DOS FDISK, OS/2 FDISK)
> 
> Command (m for help): x
> 
> Expert command (m for help): p
> 
> Disk /dev/sda: 56 heads, 55 sectors, 1267 cylinders
> 
> Nr AF  Hd Sec  Cyl  Hd Sec  Cyl     Start      Size ID
>  1 00   2   4    0  55  55  967        129    3902335 06
>  2 00   0   0    0   0   0    0          0          0 00
>  3 00   0   0    0   0   0    0          0          0 00
>  4 00   0   0    0   0   0    0          0          0 00
> 
> Expert command (m for help): q
> 
> n22 ~ # fdisk -l /dev/sda
> 
> Disk /dev/sda: 1998 MB, 1998061056 bytes
> 56 heads, 55 sectors/track, 1267 cylinders
> Units = cylinders of 3080 * 512 = 1576960 bytes
> Disk identifier: 0x00000000
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1        1268     1951167+   6  FAT16
> 
> I deleted +created the partition both manually and by the digikam
> but w/o success...
  Hmm, ok. This doesn't look like a kernel bug. At least if you created the
partition table in linux by fdisk (or some other partitioning program), it
should have created the partition one sector shorter. So please report this
as a bug of the partitioning program. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
