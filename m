Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZD0NeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZD0NeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZD0Ndx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:33:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54562 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbZD0Ndw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:33:52 -0400
Date: Mon, 27 Apr 2009 14:33:49 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [BUG] 2.6.30-rc3: bnx2 failing to load firmware
Message-ID: <20090427133348.GB912@csn.ul.ie>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090424175238.GA19646@csn.ul.ie> <534721.54493.qm@web32602.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <534721.54493.qm@web32602.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 05:34:47AM -0700, Martin Knoblauch wrote:
> 
> > From: Mel Gorman <mel@csn.ul.ie>
> > To: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Michael Chan <mchan@broadcom.com>; David S. Miller <davem@davemloft.net>
> > Sent: Friday, April 24, 2009 7:52:39 PM
> > Subject: [BUG] 2.6.30-rc3: bnx2 failing to load firmware
> > 
> > On Tue, Apr 21, 2009 at 08:27:57PM -0700, Linus Torvalds wrote:
> > > 
> > > Another week, another -rc.
> > > 
> > 
> > Getting this when loading the bnx2 driver
> > 
> > bnx2 0000:04:00.0: firmware: requesting bnx2/bnx2-mips-06-4.6.16.fw
> > bnx2: Can't load firmware file "bnx2/bnx2-mips-06-4.6.16.fw"
> > bnx2 0000:04:00.0: PCI INT A disabled
> > bnx2: probe of 0000:04:00.0 failed with error -2
> > bnx2 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > bnx2 0000:06:00.0: firmware: requesting bnx2/bnx2-mips-06-4.6.16.fw
> > bnx2: Can't load firmware file "bnx2/bnx2-mips-06-4.6.16.fw"
> > bnx2 0000:06:00.0: PCI INT A disabled
> > bnx2: probe of 0000:06:00.0 failed with error -2
> > 
> > The firmware-related parts of the .config are
> > 
> > CONFIG_PREVENT_FIRMWARE_BUILD=y
> > CONFIG_FIRMWARE_IN_KERNEL=y
> > CONFIG_EXTRA_FIRMWARE=""
> > CONFIG_FIRMWARE_EDID=y
> > CONFIG_FIRMWARE_MEMMAP=y
> > 
> > Reverting commit 57579f7629a3d46c307405fbd2ea6bdb650d692f "fixes" it no
> > doubt there is a better fix. The patch author (Michael) is cc'd but if
> > nothing else happens, I'll investigate more after the weekend.
> > 
> > dmesg and .config attached.
> > 
> 
>  just curious, what userspace are you using? I have, starting with 2.6.29, a similar problem with tg3. My RHEL4.3 userspace broke hotplugging, because as of 2.6.29 there are two "sysfs" lines in /"proc/mounts". I fixed it in "/etc/hotplug/firmware.agent" by just assuming "/sys" as the "sysfs" mountpoint.
> 

RHEL 5.3 in this case but it looks like the problem is in mkinitrd and
fixed already for later releases. For testing, I'm just going to build
the network module in and not worry about getting mkinitrd right on this
version of RHEL.

>  Maybe of course totally unrelated.
> 
> Cheers
> Martin
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
