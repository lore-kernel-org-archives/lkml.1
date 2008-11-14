Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYKNEMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYKNEMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYKNEMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:12:06 -0500
Received: from kroah.org ([198.145.64.141]:49361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751160AbYKNEMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:12:03 -0500
Date: Thu, 13 Nov 2008 20:07:32 -0800
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>,
       Francois Romieu <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, netdev@vger.kernel.org
Subject: Re: [stable] build error with 2.6.27.6+reiser4+ehci-hub patch.
	ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
Message-ID: <20081114040732.GB17810@kroah.com>
References: <200811140045.20166.volker.armin.hemmann@tu-clausthal.de> <20081114000725.GC19644@kroah.com> <20081114012617.GG7331@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114012617.GG7331@solarflare.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 01:26:19AM +0000, Ben Hutchings wrote:
> Greg KH wrote:
> > On Fri, Nov 14, 2008 at 12:45:19AM +0100, Volker Armin Hemmann wrote:
> > > Hi,
> > > with my old config from 2.6.27.5 (which has the same patches) I get this 
> > > error:
> > > make all modules_install install
> > > <snip>
> > >   OBJCOPY arch/x86/boot/setup.bin
> > >   OBJCOPY arch/x86/boot/vmlinux.bin
> > >   HOSTCC  arch/x86/boot/tools/build
> > >   BUILD   arch/x86/boot/bzImage
> > > Root device is (9, 1)
> > > Setup is 11436 bytes (padded to 11776 bytes).
> > > System is 2180 kB
> > > CRC 54816509
> > > Kernel: arch/x86/boot/bzImage is ready  (#1)
> > >   Building modules, stage 2.
> > >   MODPOST 136 modules
> > > ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
> > > make[1]: *** [__modpost] Fehler 1
> > > make: *** [modules] Fehler 2
> > 
> > Francois, this is due to your commit
> > 38d501ca6eb1f05d238bef785e51ca71dbfe0115, in the release, which was a
> > backport of ccdffb9a88b2907b159538d7bfd6256621db4f84.
> > 
> > Care to look into this?
> 
> R8169 needs to select MII.  You could cherry-pick
> b73724921d906d1642f9f6d054079c6b095903fe.

Yes, that looks correct, I'll do that.

Volker, does this patch solve your problem?

thanks,

greg k-h
