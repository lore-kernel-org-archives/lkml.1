Return-Path: <linux-kernel-owner+w=401wt.eu-S1946150AbXD3Xsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946150AbXD3Xsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946130AbXD3Xsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:48:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43930 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946151AbXD3Xsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:48:52 -0400
Message-ID: <46368062.6000100@garzik.org>
Date: Mon, 30 Apr 2007 19:48:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: to something appropriate (was Re: 2.6.22 -mm merge plans)
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>  ahci-crash-fix.patch
>  libata-acpi-add-infrastructure-for-drivers-to-use.patch
>  pata_acpi-restore-driver.patch
>  optional-led-trigger-for-libata.patch
>  ata_timing-ensure-t-cycle-is-always-correct.patch
>  pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch
>  drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
>  pata_icside-driver.patch
> 
> ata stuff

Tejun helpfully posted a bunch of clashing patches for all the ACPI 
stuff :)  You might be better off dropping and getting a resend after 
the dust settles.

That LED trigger patch seems technically correct, but also filling a 
need that few have.  IMO it craps up the hot path for little gain.

The other stuff should be in my mbox to be reviewed and applied


>  8139too-force-media-setting-fix.patch
>  sundance-change-phy-address-search-from-phy=1-to-phy=0.patch
>  forcedeth-improve-napi-logic.patch
>  ne-add-platform_driver.patch
>  ne-add-platform_driver-fix.patch
>  ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
>  mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
>  ibmtr_cs-fix-hang-on-eject.patch
> 
> For netdev tree

8139too: needs review w/ attention paid to historical usage, and I 
haven't had time for months.  Not sure its right.

sundance: I really think this is phy-dependent, and should not be 
universally applied.  In the standard MII PHY, phy 0 is a ghost of 
another id.

forcedeth: TX NAPI wants more than that minimum effort

other stuff: in mbox


>  ppp_generic-fix-lockdep-warning.patch
> 
> Jeff, I guess.  It's not clear that this is correct.

Usually PPP is paulus -> jgarzik -> linus, but you can bounce it 
straight to me if Paulus doesn't respond


>  pcmcia-pccard-deadlock-fix.patch
>  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
>  at91_cf-minor-fix.patch
>  add-new_id-to-pcmcia-drivers.patch
>  ide-cs-recognize-2gb-compactflash-from-transcend.patch
> 
> Dominik is busy.  Will probably re-review and send these direct to Linus.

I really wish "add ID" patches would not get buried in this tree.

Certainly they are trivial enough to go straight to Linus, but it would 
be nice to go through subsystem maintainers, some of whom have also 
picked up these new-id patches.

We don't send new-id patches for PCI drivers to GregKH, and we should 
similarly /not/ direct PCMCIA id patches to the PCMCIA bus tree.  It's 
far more scalable to send new-id patches to the maintainers dealing with 
the subsystem under which each driver falls (net, scsi, IDE, ...)


>  pci-device-ensure-sysdata-initialised-v2.patch
> 
> This is for Jeff's git-pciseg.patch which is sort-of on hold at present.

HP was kind enough to dig up another machine for me.  Other machines are 
appearing with x86 PCI domains (aka PCI segments) these days, so I need 
to get this into upstream.

	Jeff


