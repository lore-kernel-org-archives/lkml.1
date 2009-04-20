Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZDTIha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZDTIha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZDTIhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:37:12 -0400
Received: from ppp-110-120.adsl.restena.lu ([158.64.110.120]:55460 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZDTIhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:37:11 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 04:37:11 EDT
Date: Mon, 20 Apr 2009 10:28:26 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux IDE <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux SCSI <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] ide: Stop disks on reboot for laptop which cuts
 power
Message-ID: <20090420102826.5184f3fe@pluto.restena.lu>
In-Reply-To: <49EC299D.5020102@gmail.com>
References: <20090418124415.1dc82273@neptune.home>
	<20090418124558.0426f74c@neptune.home>
	<49EC299D.5020102@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 16:51:57 Tejun Heo <htejun@gmail.com> wrote:
> Bruno Prémont wrote:
> > My laptop (Acer Travelmate 660) always cuts the power when rebooting
> > which causes the disk to emergency-park it's head.
> > 
> > Add a dmi check to stop disk as for shutdown on this laptop.
> 
> Hmm... yeah, I also noticed this behavior on several machines I have
> here.  Most were beta BIOSen.
> 
> Maybe it's worth to shutdown drives on reboot on all machines?
> 
> Thanks.

I will check how my other machines behave but I don't remember such a
power-down behavior.
Except for a spin-down - spin-up cycle a generalization should not
cause troubles though. (I vaguely remember seeing different reboot
modes in kernel code - as in colder or hotter reboots - these might
also change BIOS behavior where the different modes are implemented
and thus cause disk stopping to be needed)

Possibly it depends very much how the power is connected, e.g. desktop
boxes with ATX power-supply probably never tell the power-supply to cut
the power but laptop may behave differently with regard to their
built-in DC-DC converters (disks connected to mainboard versus disks
directly connected to power supply).

What I was also wondering whether the list of machines to which
to apply the quirk should be moved to a common location so it exists
only once for ide and scsi/ata instead of once on each side.
Having the list exactly once avoids the risk for content to drift
between ide and scsi/ata.

Bruno
