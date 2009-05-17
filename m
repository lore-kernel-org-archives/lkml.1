Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZEQUUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZEQUUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZEQUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:20:06 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:47557 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbZEQUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:20:04 -0400
Date: Sun, 17 May 2009 22:18:56 +0200
From: Martin Lottermoser <Martin.Lottermoser@t-online.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090517201856.GA1496@wanza.invalid>
References: <20090517091224.GA8280@wanza.invalid> <4A10509C.603@gmail.com> <200905172135.10136.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905172135.10136.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ID: r2+LJOZOZhIMG4l7y+08wCD7nNkPeRQxsDLOzNhvJ5JHl7bHH1NIZHawjNTtCj-gem
X-TOI-MSGID: 83d48128-4f07-4e8d-af63-37fcf77ee8d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 17, 2009 at 21:35:09 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > The error message with 2.6.23.14 was:
> > > 
> > >   hdc: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
> > >   hdc: drive_cmd: error=0x04 { AbortedCommand }
> > >   ide: failed opcode was: 0xec
> 
> This is more-or-less innocent -- some user-space utility wrongly uses
> ATA IDENTIFY command on ATAPI devices and it gets logged as an error...

thanks; that's a load off my mind :-).

> > > This is correct: the drive is only capable of Ultra DMA mode 2 33.3 MB/s
> > > (see manufacturer's documentation) and is attached with a standard 40-wire
> > > ATA cable (black connectors for master and slave).
> 
> Martin, this is one of ATAPI drives which support UDMA66 but have broken
> cable detection.

Are you sure? Compare this:

  http://downloadcenter.samsung.com/content/UM/200709/20070928095126750_SH-S202N_Eng.pdf

> Please:
> 
> * send 'hdparm --Istdout /dev/hdc' output

Here it is:

  /dev/hdc:
  85c0 0000 0000 0000 0000 0000 0000 0000
  0000 0000 2020 2020 2020 2020 2020 2020
  2020 2020 2020 2020 0000 0000 0000 5342
  3031 2020 2020 5453 5354 636f 7270 2043
  4444 5644 5720 5348 2d53 3230 324e 2020
  2020 2020 2020 2020 2020 2020 2020 0000
  0000 0b00 0000 0200 0200 0006 0000 0000
  0000 0000 0000 0000 0000 0000 0000 0007
  0003 0078 0078 017f 0078 0000 0000 0000
  0000 00f8 0210 0000 0000 0000 0000 0000
  00f8 0210 0210 0000 0000 0000 0000 0000
  041f 0000 8005 3200 005b 2000 0000 0000
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
  0000 0000 0000 0000 0000 0000 0000 0000
  0000 0000 0000 0000 0000 0000 0000 0000
  0000 0000 0000 0000 0000 0000 0000 0000
  0000 0000 0000 0000 0000 0000 0000 0000
  0000 0000 0000 0000 0000 0000 0000 0000
  0000 0000 0000 0000 0000 0000 0000 0000
  0000 0000 0000 0000 0000 0000 0000 0000
  0000 0000 0000 0000 0000 0000 0000 a3a5

> * try 2.6.30-rc6 (maybe 2.6.29.3 oops has been fixed already and we just
>   need to backport it)

That'll have to wait until tomorrow -- I have a low-bandwidth connection
here.

> also connecting the drive using 80-wires cable and getting another hdparm
> output (+ seeing if it helps the other problems) would be very useful.

I'll try that too, but that also will have to wait until tommorrow.

Thanks for the help,
Martin Lottermoser
-- 
Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
Greifswaldstrasse 28
38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
Germany
