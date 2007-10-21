Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbXJUQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbXJUQp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 12:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXJUQpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 12:45:21 -0400
Received: from xenotime.net ([66.160.160.81]:41165 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751493AbXJUQpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 12:45:20 -0400
Date: Sun, 21 Oct 2007 09:45:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Henrik Carlqvist <hc1@poolhem.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-Id: <20071021094517.78dd1916.rdunlap@xenotime.net>
In-Reply-To: <20071021122402.2f0f3b40.hc1@poolhem.se>
References: <200710201257.55616.nick@ukfsn.org>
	<20071020144238.4f258c8c.hc1@poolhem.se>
	<20071020191700.GB8774@uranus.ravnborg.org>
	<26703.1192942058@turing-police.cc.vt.edu>
	<20071021122402.2f0f3b40.hc1@poolhem.se>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 12:24:02 +0200 Henrik Carlqvist wrote:

> On Sun, 21 Oct 2007 00:47:38 -0400
> Valdis.Kletnieks@vt.edu wrote:
> 
> > On Sat, 20 Oct 2007 21:17:00 +0200, Sam Ravnborg said:
> > > I assume
> > > 	depends on MODULES
> > > 
> > > should do the trick.
> > 
> > Umm... I think that will work backwards, and give you CONFIG_FOO=y
> > if.f the kernel *supports* modules. What he needs is to be able to say
> > CONFIG_FOO=n or CONFIG_FOO=m, but *ban* CONFIG_FOO=y.
> 
> Yes, thats right, MODULES does not ban y as would be needed. As an example

Agreed.

> I tried to do a quick test, I edited drivers/scsi/qla2xxx/Kconfig to look
> like this:
> 
> -8<-------------------------------------------------------
> config SCSI_QLA_FC
>         tristate "QLogic QLA2XXX Fibre Channel Support"
>         depends on PCI && SCSI && MODULES
>         select SCSI_FC_ATTRS
>         select FW_LOADER
>         ---help---
>         This qla2xxx driver supports all QLogic Fibre Channel
>         PCI and PCIe host adapters.
> 
>         By default, firmware for the ISP parts will be loaded
>         via the Firmware Loader interface.
> 
>         ISP               Firmware Filename
>         ----------        -----------------
>         21xx              ql2100_fw.bin
>         22xx              ql2200_fw.bin
>         2300, 2312, 6312  ql2300_fw.bin
>         2322, 6322        ql2322_fw.bin
>         24xx              ql2400_fw.bin
> 
>         Upon request, the driver caches the firmware image until
>         the driver is unloaded.
> 
>         Firmware images can be retrieved from:
> 
>                 ftp://ftp.qlogic.com/outgoing/linux/firmware/
> -8<-------------------------------------------------------
> 
> The only thing that I did change was that I added "&& MODULES" to the
> depends line. However, this only causes the driver to be possible to build
> when you build a kernel with module support. Still tristate allows you to
> build it both as a module and as a driver built into the kernel. However,
> when built into the kernel the driver is unusable as it needs its firmware
> which it can't reach. 
> 
> Is there any other way to specify that a functionality can only be built
> as a module, not built into the kernel?

config FOO
	depends on BAR && m

restricts FOO to module-only.

> In my firsta attempts to post about these tests my post ended up not on
> the mailing list but as a reply to Sam Ravnborg only, apologies for
> that...

---
~Randy
