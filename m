Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZK1WUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZK1WUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 17:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZK1WUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 17:20:53 -0500
Received: from bar.sig21.net ([80.81.252.164]:60135 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZK1WUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 17:20:52 -0500
Date: Sat, 28 Nov 2009 23:22:03 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Greg KH <greg@kroah.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Mikhail Malygin <mmalygin@ked.de>,
       Hans Werner <hwerner4@gmx.de>, Tejun Heo <tj@kernel.org>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix
 FailSafe issue?
Message-ID: <20091128222203.GA369@sig21.net>
References: <20091126164212.GA24421@sig21.net>
 <20091128191932.GB24048@kroah.com>
 <4B11886E.3030906@gmail.com>
 <20091128213446.GA26420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091128213446.GA26420@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.801,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 01:34:46PM -0800, Greg KH wrote:
> On Sat, Nov 28, 2009 at 02:30:38PM -0600, Robert Hancock wrote:
> > On 11/28/2009 01:19 PM, Greg KH wrote:
> >> On Thu, Nov 26, 2009 at 05:42:12PM +0100, Johannes Stezenbach wrote:
> >>>
> >>> Around 5min after boot or resume if generates the following error:
> >>>
> >>> [  302.364174] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> >>> [  302.364201] ata1.00: failed command: WRITE DMA
> >>> [  302.364234] ata1.00: cmd ca/00:08:f7:01:1a/00:00:00:00:00/e0 tag 0 dma 4096 out
> >>> [  302.364241]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> [  302.364257] ata1.00: status: { DRDY }
> >>> [  307.408107] ata1: link is slow to respond, please be patient (ready=0)
> >>> [  312.392109] ata1: device not ready (errno=-16), forcing hardreset
> >>> [  312.392138] ata1: soft resetting link
> >>> [  312.574482] ata1.00: configured for UDMA/133
> >>> [  312.574506] ata1.00: device reported invalid CHS sector 0
> >>> [  312.574542] ata1: EH complete
> >>
> >> This is because after 5 minutes, the BIOS implements C states in the
> >> processor, which causes a "hic-up" in userspace.  Everything should be
> >> fine after this, and most importantly, the power usage drops by a few
> >> watts, which is most important.
> >
> > Why does this "hiccup" seem to cause interrupts to get lost? This would 
> > cause an up to 30-second stall in disk I/O.
> 
> Yup, it does.
> 
> >>> This also happens when booting with rdinit=/bin/sh, i.e. only running busybox sh
> >>> inside initrd.  The error then appears when accessing the disk after the 5min
> >>> period with dd if=/dev/sda of=/dev/null count=10000.
> >>
> >> Yup, see above for why.
> >>
> >> Samsung does this to make booting their BIOS faster.
> >
> > Ugh.. Seriously?
> 
> Seriously.  It's a BIOS issue, and is the way that Samsung has
> implemented this.  There is nothing that the OS can do about it.
> Windows has the same "issue" here.

Um, "how does Windows handle this" would've been my next question.
I didn't do much with Windows before I wiped it, I mainly used it
to confirm the thing works and to do the BIOS update. I did go through
a few reboot cycles though and I think I would've noticed a 30 second
hang. Maybe they just lowered the ATA timeout to hide it or something.
Otherwise I guess google would turn up complaints from Windows users, too,
not just from Linux users.

BTW, at 5min after boot it is 99% guaranteed that this ATA
exception will happen during the occasional fsck. That
doesn't feel right.

> I do not disagree with you at all about this.  This has been
> communicated to Samsung, but at this point in time, they are not going
> to support ACPI and only want Linux to use this interface.

Well, at least they made the information for the SECLINUX interface
available (to you), but it would be better they'd support ACPI.
I mean if they have to support it for Windows 7 anyway, then
what's the point of not supporting it for other OSs?


While were at it I have another question:  When running on battery the
ethernet throughput drops to ~25Mbit/s.  After a bit of experimenting
I found that this is connected to a BIOS entry about "CPU Power
Saving Mode".  lspci shows that this changes "LnkCtl: ASPM L1
Enabled" to "LnkCtl: ASPM L0s L1 Enabled".  Having this config
option in the BIOS is inflexible.  IIRC there was an app in
Windows which allows to configure it at runtime.  Do you
know how to do it in Linux?


Thanks
Johannes
