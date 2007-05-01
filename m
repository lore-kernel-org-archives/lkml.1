Return-Path: <linux-kernel-owner+w=401wt.eu-S1422968AbXEAAJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422968AbXEAAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422992AbXEAAJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:09:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422968AbXEAAJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:09:25 -0400
Date: Mon, 30 Apr 2007 17:09:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: to something appropriate (was Re: 2.6.22 -mm merge plans)
Message-Id: <20070430170919.45e4b42b.akpm@linux-foundation.org>
In-Reply-To: <46368062.6000100@garzik.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<46368062.6000100@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: to something appropriate (was Re: 2.6.22 -mm merge plans)

smartypants.

On Mon, 30 Apr 2007 19:48:50 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> >  ahci-crash-fix.patch
> >  libata-acpi-add-infrastructure-for-drivers-to-use.patch
> >  pata_acpi-restore-driver.patch
> >  optional-led-trigger-for-libata.patch
> >  ata_timing-ensure-t-cycle-is-always-correct.patch
> >  pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch
> >  drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
> >  pata_icside-driver.patch
> > 
> > ata stuff
> 
> Tejun helpfully posted a bunch of clashing patches for all the ACPI 
> stuff :)  You might be better off dropping and getting a resend after 
> the dust settles.
> 
> That LED trigger patch seems technically correct, but also filling a 
> need that few have.  IMO it craps up the hot path for little gain.

OK, well I'll see what's recoverable after libata-all gets updated, will
blindly spam you with it as usual ;)

> 
> >  8139too-force-media-setting-fix.patch
> >  sundance-change-phy-address-search-from-phy=1-to-phy=0.patch
> >  forcedeth-improve-napi-logic.patch
> >  ne-add-platform_driver.patch
> >  ne-add-platform_driver-fix.patch
> >  ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
> >  mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
> >  ibmtr_cs-fix-hang-on-eject.patch
> > 
> > For netdev tree
> 
> 8139too: needs review w/ attention paid to historical usage, and I 
> haven't had time for months.  Not sure its right.
> 
> sundance: I really think this is phy-dependent, and should not be 
> universally applied.  In the standard MII PHY, phy 0 is a ghost of 
> another id.
> 
> forcedeth: TX NAPI wants more than that minimum effort

Ditto.

> >  ppp_generic-fix-lockdep-warning.patch
> > 
> > Jeff, I guess.  It's not clear that this is correct.
> 
> Usually PPP is paulus -> jgarzik -> linus, but you can bounce it 
> straight to me if Paulus doesn't respond
> 

OK, i'll move it to the netdev queue and will keep sending until something
happens.

> 
> >  pcmcia-pccard-deadlock-fix.patch
> >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> >  at91_cf-minor-fix.patch
> >  add-new_id-to-pcmcia-drivers.patch
> >  ide-cs-recognize-2gb-compactflash-from-transcend.patch
> > 
> > Dominik is busy.  Will probably re-review and send these direct to Linus.
> 
> I really wish "add ID" patches would not get buried in this tree.
> 
> Certainly they are trivial enough to go straight to Linus, but it would 
> be nice to go through subsystem maintainers, some of whom have also 
> picked up these new-id patches.
> 
> We don't send new-id patches for PCI drivers to GregKH, and we should 
> similarly /not/ direct PCMCIA id patches to the PCMCIA bus tree.  It's 
> far more scalable to send new-id patches to the maintainers dealing with 
> the subsystem under which each driver falls (net, scsi, IDE, ...)
> 

Yeah, a new-id patch is a pretty critical bugfix if you happen to have that
hardware.  I'll get all these into 2.6.22 by whatever means and will adopt
your advice in future.

Probably these should go into -stable too, but I don't know what
Greg&Chris's position is on new device IDs.

