Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbXFTQ26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbXFTQ26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXFTQ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:28:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60436 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXFTQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:28:48 -0400
Date: Wed, 20 Jun 2007 11:28:45 -0500
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stuart_Hayes@dell.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070620162845.GY5836@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com> <4677FFF1.2010308@ru.mvista.com> <20070619164854.GR5836@austin.ibm.com> <200706192043.40298.bzolnier@gmail.com> <46783777.10607@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46783777.10607@ru.mvista.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 12:07:19AM +0400, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> [...frmware...]

Google seems to show that there is no publically available 
firmware updates for Maxtor disks.

> >It would be useful to see hdparm --Istdout output for *both* disks.

Lets do one at a time. Appended below is the one for the 
older, "known good" disk.

> >Sergei, do you think that testing the drive with DMA disabled may
> >tell us something new?

FWIW, the "buggy" disk seems to work fine with DMA turned off (with
hdparm). I just copied 60GB from it; although this did take about 16
hours at high cpu usage.... There were maybe a a dozen DriveReady
SeekComplete Timeout errors clustered a few minutes apart.  

----
Re: The libata problem. This is a hang during the read of the 
partition table during boot, of the "known good" disk.  I turned
on scsi and libata debugging, reproduced the hang, dilligently
copied to a piece of paper, but then left the darned piece of 
paper at home. 

>From what I remember, the ata command was translated to scsi,
by ata_queuecommand, and then handed off to the scsi subsystem. 
Presumably, its sent to the drive, but the drive does not respond.

30 seconds later, the scsi eh runs, and ands the error back to 
libata, which takes a few ineffectual shots at recovery, and 
then hangs. 

I'll try to get the details later.

Is there a way of viewing the contents of he command queue on
the hard drive, to see if the command actually made it across?

--linas

/dev/hda:
 multcount    = 16 (on)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 24792/255/63, sectors = 398297088, start = 0
0040 3fff c837 0010 0000 0000 003f 0000
0000 0000 5936 3130 4d45 4345 2020 2020
2020 2020 2020 2020 0003 3e00 0039 5941
5234 3142 5730 4d61 7874 6f72 2036 5932
3030 5030 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 8010
0000 2f00 4000 0200 0000 0007 ffff 0001
003f ffc1 003e 0110 ffff 0fff 0000 0007
0003 0078 0078 0078 0078 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
00fe 001e 7c6b 7f09 4003 7c69 3e01 4003
107f 0000 0000 0000 fffe 600d c0fe 0000
0000 0000 0000 0000 8800 17bd 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0001 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0001 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 60a5

