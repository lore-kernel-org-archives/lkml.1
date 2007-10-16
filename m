Return-Path: <linux-kernel-owner+w=401wt.eu-S965751AbXJPVOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbXJPVOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965257AbXJPVOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:14:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:10707 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965261AbXJPVOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:14:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="347963011"
Date: Tue, 16 Oct 2007 14:01:16 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
Message-Id: <20071016140116.cb30483c.kristen.c.accardi@intel.com>
In-Reply-To: <4715217D.2000803@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
	<47150982.6050102@rtr.ca>
	<471509FE.7080505@rtr.ca>
	<47151191.40406@rtr.ca>
	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
	<4715217D.2000803@rtr.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 16:39:25 -0400
Mark Lord <lkml@rtr.ca> wrote:

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

This reinitializes the controller, which is probably why things work
better for you (which does of course touch hardware...).

> 
> I believe the code is leaning too heavily on the BIOS for stuff,
> and like lots of other parts of the kernel we'll need an alternate
> strategy for when things aren't "perfect".

the pitfall for forcing pciehp when the BIOS hasn't provided OSC is that
you don't know for sure that you really have gained control of hot plug
operation properly.  You can obviously try it, using the provide forcing
option as you have done, but the behavior is not predictable.
