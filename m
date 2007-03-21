Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbXCUAOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbXCUAOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 20:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXCUAOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 20:14:37 -0400
Received: from smtp.ono.com ([62.42.230.12]:41454 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752093AbXCUAOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 20:14:36 -0400
Date: Wed, 21 Mar 2007 01:14:32 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070321011432.4c089dac@werewolf-wl>
In-Reply-To: <20070320173657.09a13940@werewolf-wl>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070320173657.09a13940@werewolf-wl>
X-Mailer: Claws Mail 2.8.1cvs22 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 17:36:57 +0100, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Mon, 19 Mar 2007 20:56:23 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> > 
> 
> (oops, I forgot LKML)
> 
> I have no udev events for my dvd-rw...
> When I insert a disc in the dvd reader:
> 
> werewolf:~# udevmonitor
> udevmonitor prints the received event from the kernel [UEVENT]
> and the event which udev sends out after rule processing [UDEV]
> 
> UEVENT[1174385162.607021] mount    /block/sr1 (block)
> UDEV  [1174385162.610056] mount    /block/sr1 (block)
> 
> If I insert it in the dvd-rw drive, nothing happens.
> 

I realized that my scsi devices were like this:

werewolf:~# lsscsi
[0:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL10  /dev/.tmp-11-0
[0:0:1:0]    disk    IOMEGA   ZIP 250          51.G  /dev/sda
[1:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sdb
[1:0:1:0]    cd/dvd  TOSHIBA  DVD-ROM SD-M1712 1004  /dev/.tmp-11-1
[2:0:0:0]    disk    ATA      ST3200822AS      3.01  /dev/sdc
[7:0:0:0]    disk    LG       USBDrive         1100  /dev/sdd

After a service udev force-reload:

werewolf:~# lsscsi
[0:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL10  /dev/sr0
[0:0:1:0]    disk    IOMEGA   ZIP 250          51.G  /dev/sda
[1:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sdb
[1:0:1:0]    cd/dvd  TOSHIBA  DVD-ROM SD-M1712 1004  /dev/sr1
[2:0:0:0]    disk    ATA      ST3200822AS      3.01  /dev/sdc
[7:0:0:0]    disk    LG       USBDrive         1100  /dev/sdd

If I insert a disc in /dev/sr1 and eject it:

werewolf:~# lsscsi
[0:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL10  /dev/sr0
[0:0:1:0]    disk    IOMEGA   ZIP 250          51.G  /dev/sda
[1:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sdb
[1:0:1:0]    cd/dvd  TOSHIBA  DVD-ROM SD-M1712 1004  /dev/.tmp-11-1
[2:0:0:0]    disk    ATA      ST3200822AS      3.01  /dev/sdc
[7:0:0:0]    disk    LG       USBDrive         1100  /dev/sdd

If I reload the disc in the TOSHIBA, it is automounted but the strange
device is still there.

Trying with /dev/sr0 still gives no events. What is happening here ?
It is the kernel or is udev setup ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
