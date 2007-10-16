Return-Path: <linux-kernel-owner+w=401wt.eu-S935565AbXJPVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565AbXJPVyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933891AbXJPVx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:53:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60330 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875AbXJPVx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:53:56 -0400
Date: Tue, 16 Oct 2007 14:41:43 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] PCIe Hotplug: NFG unless I boot with card
	already inserted.
Message-ID: <20071016214143.GC21815@kroah.com>
References: <4714C0A6.1030204@rtr.ca> <4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4715217D.2000803@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 04:39:25PM -0400, Mark Lord wrote:
> Kristen Carlson Accardi wrote:
> >...
> > I tried to reproduce this on a Lenovo T61, which does have proper firmware
> > support for _OSC, and also has been validated, and the driver which is 
> > in 2.6.23-git8 seems to work fine, even across suspend resume.  I suspect
> > that your system just doesn't support pcie hotplug properly.
> 
> No, the hardware seems to work perfectly.
> 
> We just have a software issue.  We *know* it's only software
> because rmmod+modprobe fixes things, without any hardware intervention.
> 
> I believe the code is leaning too heavily on the BIOS for stuff,
> and like lots of other parts of the kernel we'll need an alternate
> strategy for when things aren't "perfect".
> 
> > You might try getting a BIOS update from Dell.
> 
> The machine already has the latest BIOS, thanks.

Dell laptops are known to have broken BIOS acpi code in regards to pci
express hotplug issues.  Seriously, we rely on acpi here for a lot of
this, and unless it is properly set up, it will not work.

And this is broken because Windows can't even handle this kind of thing,
so it isn't tested :(

So a short note to Dell might be helpful, although in the end, I think
this looks like a kernel issue as you have proven with your patch.

thanks,

greg k-h
