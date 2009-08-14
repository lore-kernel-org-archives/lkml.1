Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZHNUnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZHNUnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZHNUnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:43:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZHNUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:43:48 -0400
Date: Fri, 14 Aug 2009 22:43:05 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090814204305.GA31727@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 22:34:43 up 9 days,  7:53,  1 user,  load average: 0.11, 0.04,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 10:04:57PM +0200, Denys Vlasenko wrote:
> > rsc@thebe:~$ microcom | ptx_ts "U-Boot 2.0.0-rc9"
> > [  2.395740] <  2.395740>
> > [  2.395860] <  0.000120>
> > [  0.000011] <  0.000011> U-Boot 2.0.0-rc9 (Aug  5 2009 - 10:05:58)
> > [  0.000059] <  0.000048>
> > [  0.003823] <  0.003764> Board: Phytec phyCORE-i.MX27
> > [  0.010753] <  0.006930> cfi_probe: cfi_flash base: 0xc0000000 size: 0x02000000
> > [  0.018711] <  0.007958> NAND device: Manufacturer ID: 0x20, Chip ID: 0x36 (ST Micro NAND 64MiB 1,8V 8-bit)
> > [  0.026592] <  0.007881> imxfb@imxfb0: i.MX Framebuffer driver
> > [  0.178655] <  0.152063> dev_protect: currently broken
> > [  0.178736] <  0.000081> Using environment in NOR Flash
> > [  0.182577] <  0.003841> initialising PLLs
> > [  0.367142] <  0.184565> Malloc space: 0xa3f00000 -> 0xa7f00000 (size 64 MB)
> > [  0.370568] <  0.003426> Stack space : 0xa3ef8000 -> 0xa3f00000 (size 32 kB)
> > [  0.445993] <  0.075425> running /env/bin/init...
> > [  0.870592] <  0.424599>
> > [  0.874559] <  0.003967> Hit any key to stop autoboot:  0
>
> boot loader is not fast. considering its simple task, it can be made
> faster.

Yup, will check. Almost 1 s seems really long.

> > [  1.326621] <  0.452062> loaded zImage from /dev/nand0.kernel.bb with size 1679656
> > [  2.009996] <  0.683375> Uncompressing Linux............................................................................................................... done, booting the kernel.
> > [  2.416999] <  0.407003> Linux version 2.6.31-rc4-g056f82f-dirty (sha@octopus) (gcc version 4.3.2 (OSELAS.Toolchain-1.99.3) ) #1 PREEMPT Thu Aug 6 08:37:19 CEST 2009
> 
> Other people already commented on this (kernel is too big)

Not sure (the kernel is already customized for the board), but I'll take
a look again.

> > [  2.418729] <  0.001730> CPU: ARM926EJ-S [41069264] revision 4 (ARMv5TEJ), cr=00053177
> > [  2.423081] <  0.004352> CPU: VIVT data cache, VIVT instruction cache
> > [  2.426592] <  0.003511> Machine: phyCORE-i.MX27
> ...
> > [  2.742628] <  0.016050> 0x000000360000-0x000004000000 : "root"
> > [  3.058610] <  0.315982> UBI: attaching mtd7 to ubi0
> > [  3.062878] <  0.004268> UBI: physical eraseblock size:   16384 bytes (16 KiB)
> > [  3.070601] <  0.007723> UBI: logical eraseblock size:    15360 bytes
> > [  3.070665] <  0.000064> UBI: smallest flash I/O unit:    512
> > [  3.078564] <  0.007899> UBI: VID header offset:          512 (aligned 512)
> > [  3.078609] <  0.000045> UBI: data offset:                1024
> > [  5.006609] <  1.928000> UBI: attached mtd7 to ubi0
> > [  5.013157] <  0.006548> UBI: MTD device name:            "root"
> 
> As others commented, ubi looks slow and you probably need to find out why.

So it seems like our UBS is much slower than usual?

> > [  5.014566] <  0.001409> UBI: MTD device size:            60 MiB
> > [  5.018660] <  0.004094> UBI: number of good PEBs:        3880
> > [  5.022585] <  0.003925> UBI: number of bad PEBs:         0
> > [  5.026797] <  0.004212> UBI: max. allowed volumes:       89
> > [  5.026849] <  0.000052> UBI: wear-leveling threshold:    4096
> > [  5.030779] <  0.003930> UBI: number of internal volumes: 1
> > [  5.034583] <  0.003804> UBI: number of user volumes:     1
> > [  5.046572] <  0.011989> UBI: available PEBs:             0
> > [  5.046622] <  0.000050> UBI: total number of reserved PEBs: 3880
> > [  5.046657] <  0.000035> UBI: number of PEBs reserved for bad PEB handling: 38
> > [  5.050606] <  0.003949> UBI: max/mean erase counter: 2/0
> > [  5.050668] <  0.000062> UBI: image sequence number: 0
> > [  5.058619] <  0.007951> UBI: background thread "ubi_bgt0d" started, PID 215
> > [  5.062620] <  0.004001> oprofile: using timer interrupt.
> > [  5.070584] <  0.007964> TCP cubic registered
> > [  5.070637] <  0.000053> NET: Registered protocol family 17
> > [  5.074624] <  0.003987> RPC: Registered udp transport module.
> > [  5.082616] <  0.007992> RPC: Registered tcp transport module.
> > [  5.605159] <  0.522543> eth0: config: auto-negotiation on, 100FDX, 100HDX, 10FDX, 10HDX.
> > [  6.602621] <  0.997462> IP-Config: Complete:
> > [  6.606638] <  0.004017>      device=eth0, addr=192.168.23.197, mask=255.255.0.0, gw=192.168.23.2,
> > [  6.614588] <  0.007950>      host=192.168.23.197, domain=, nis-domain=(none),
> > [  6.618652] <  0.004064>      bootserver=192.168.23.2, rootserver=192.168.23.2, rootpath=
> 
> Well, this ~1 second is not really kernel's fault, it's DHCP delay.
> But, do you need to do it at this moment?
> You do not seem to be using networking filesystems.
> You can run DHCP client in userspace.

The board has ip autoconfig configured in, because we also use tftp/nfs
boot for development. But it had been disabled on the commandline:

ip=192.168.23.197:192.168.23.2:192.168.23.2:255.255.0.0:::

That shouldn't do dhcp, right?

> So, about 4 seconds for kernel init (I subtracted DHCP and boot loader times).
> 
> And now userspace takes 7 seconds, mostly because it does not
> parallelize boot process:
> 
> > init started: BusyBox v1.13.4 (2009-08-06 08:30:14 CEST)
> > [  7.050625] <  0.187504> mounting filesystems...done.
> > [  7.078608] <  0.027983> running rc.d services...
> 
> these services seem to start one by one:
> 
> > [  7.137924] <  0.059316> starting udev
> > [  7.147925] <  0.010001> mounting tmpfs at /dev
> > [  7.182299] <  0.034374> creating static nodes
> > [  7.410613] <  0.228314> starting udevd...done
> > [  8.811097] <  1.400484> waiting for devices...done
> > [  8.918710] <  0.107613> syslogd starting
> > [  9.050585] <  0.131875> tweaking ondemand scaling governor
> > [ 10.010600] <  0.960015> Starting system message bus: dbus.
> ...
> > [ 13.546627] <  0.024002> OSELAS(R)-phyCORE-trunk (PTXdist-1.99.svn/2009-08-06T08:37:25+0200)

Well, the application is started in the very beginning, so all the
services should start while the app is already gaining speed.

Thanks,

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
