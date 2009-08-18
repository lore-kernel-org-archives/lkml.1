Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbZHROGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbZHROGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZHROGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:06:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36499 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZHROGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:06:47 -0400
Date: Tue, 18 Aug 2009 16:06:05 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090818140605.GB9943@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814170228.GM13320@pengutronix.de>
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
X-Uptime: 15:54:25 up 13 days,  1:13, 42 users,  load average: 1.37, 1.17,
	1.15
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 07:02:28PM +0200, Robert Schwebel wrote:
> Hi,
> 
> On Thu, Aug 13, 2009 at 05:33:26PM +0200, Robert Schwebel wrote:
> > On Thu, Aug 13, 2009 at 08:28:26AM -0700, Arjan van de Ven wrote:
> > > > That's bad :-) So there is no room for improvement any more in our
> > > > ARM boot sequences ...
> > >
> > > on x86 we're doing pretty well ;-)
> >
> > On i.MX27 (400 MHz ARM926EJ-S) we currently need 7 s, measured from
> > power-on through the kernel up to "starting init". This is with
> >
> > - no delay in u-boot-v2
> > - rootfs on NAND (UBIFS)
> > - quiet
> > - precalculated loops-per-jiffy
> > - zImage kernel instead of uImage
> 
> Here's a little video of our demo system booting:
> http://www.youtube.com/watch?v=xDbUnNsj0cI
> 
> As you can see there, it needs about 15 s from the release of the reset button
> up to the moment where the application shows it's Qt 4.5.2 based GUI (which is
> when we fade over from the initial framebuffer to the final one, in order to
> hide the qt application startup noise).
> 
> And below is the boot log (after turning "quiet" off again). The numbers are
> the timestamp and the delta to the last timestamp, measured on the controlling
> PC by looking at the serial console output. The ptx_ts script starts when the
> regexp was found, so the numbers start basically in the moment when u-boot-v2
> has initialized the system up to the point where we can see something.
> 
> Result:
> 
> - 2.4 s up from u-boot to the end of "Uncompressing Linux"
> - 300 ms until ubifs initialization starts
> - 3.7 s for ubifs, until "mounted root"
> 
> So we basically have 7 s for the kernel. The rest is userspace, which hasn't
> seen much optimization yet, other than trying to start the GUI application as
> early as possible, while doing all other init stuff in parallel. Adding "quiet"
> brings us another 300 ms.
> 
> That's factor 70 away from the 110 ms boot time Tim has talked about some days
> ago (and he measured on an ARM cpu which had almost half the speed of this
> one), and I'm wondering what we can do to improve the boot time.
> 
> Robert
> 
> rsc@thebe:~$ microcom | ptx_ts "U-Boot 2.0.0-rc9"
> [ 13.522625] <  0.043189>
> [ 13.546627] <  0.024002> OSELAS(R)-phyCORE-trunk (PTXdist-1.99.svn/2009-08-06T08:37:25+0200)
> [ 13.558613] <  0.011986>
> [ 13.690643] <  0.132030>        _            ____ ___  ____  _____
> [ 13.690731] <  0.000088>  _ __ | |__  _   _ / ___/ _ \|  _ \| ____|
> [ 13.698595] <  0.007864> | '_ \| '_ \| | | | |  | | | | |_) |  _|
> [ 13.698654] <  0.000059> | |_) | | | | |_| | |__| |_| |  _ <| |___
> [ 13.702581] <  0.003927> | .__/|_| |_|\__, |\____\___/|_| \_\_____|
> [ 13.706573] <  0.003992> |_|          |___/
> [ 13.706622] <  0.000049>
> [ 13.725043] <  0.018421>
> [ 14.742608] <  1.017565>

I made some changes suggested in this thread:

- enable MMU in the bootloader
- use assembler optimized memcpy/memset in the bootloader
- start an uncompressed image
- disable IP autoconfiguration in the Kernel
- use lpj= command line parameter
- use static device nodes instead of udev
- skip some init scripts
- made the kernel smaller (I do not have both configs handy, so I do not
  know what exactly I changed)

Already looks much better:

[  0.000005] <  0.000005> U-Boot 2.0.0-rc10-00241-g3f10fe9-dirty (Aug 18 2009 - 13:29:25)
[  0.000026] <  0.000021>
[  0.000041] <  0.000015> Board: Phytec phyCORE-i.MX27
[  0.000054] <  0.000013> cfi_probe: cfi_flash base: 0xc0000000 size: 0x02000000
[  0.000067] <  0.000013> NAND device: Manufacturer ID: 0x20, Chip ID: 0x36 (ST Micro NAND 64MiB 1,8V 8-bit)
[  0.000080] <  0.000013> imxfb@imxfb0: i.MX Framebuffer driver
[  0.000092] <  0.000012> dma_alloc: 0xa6f56e40 0x10000000
[  0.000105] <  0.000013> dma_alloc: 0xa6f57088 0x10000000
[  0.000118] <  0.000013> dev_protect: currently broken
[  0.000129] <  0.000011> Using environment in NOR Flash
[  0.000141] <  0.000012> initialising PLLs
[  0.128972] <  0.128831> Malloc space: 0xa6f00000 -> 0xa7f00000 (size 16 MB)
[  0.128995] <  0.000023> Stack space : 0xa6ef8000 -> 0xa6f00000 (size 32 kB)
[  0.129008] <  0.000013> running /env/bin/init...
[  0.224963] <  0.095955>
[  0.224984] <  0.000021> Hit any key to stop autoboot:  0
[  0.224999] <  0.000015> copy
[  0.592964] <  0.367965> done
[  0.652010] <  0.059046> Linux version 2.6.31-rc4-00004-g05786f8-dirty (sha@octopus) (gcc version 4.3.2 (OSELAS.Toolchain-1.99.3) ) #206 PREEMPT Tue Aug 18 14:08:51 CEST 2009
[  0.652030] <  0.000020> CPU: ARM926EJ-S [41069264] revision 4 (ARMv5TEJ), cr=00053177
[  0.652044] <  0.000014> CPU: VIVT data cache, VIVT instruction cache
[  0.652057] <  0.000013> Machine: phyCORE-i.MX27
[  0.652069] <  0.000012> Memory policy: ECC disabled, Data cache writeback
[  0.652082] <  0.000013> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
[  0.706012] <  0.053930> Kernel command line: console=ttymxc0,115200 earlyprintk lpj=995328 mt9v022.sensor_type=color ip=192.168.23.197:192.168.23.2:192.168.23.2:255.255.0.0::: ubi.mtd=7 root=ubi0:root rootfstype=ubifs mtdparts="physmap-flash.0:256k(uboot)ro,128k(ubootenv),3M(kernel),-(root);mxc_nand:256k(uboot)ro,128k(ubootenv),3M(kernel),-(root)"
[  0.706034] <  0.000022> console [earlyser0] enabled
[  0.706049] <  0.000015> Unknown boot option `mt9v022.sensor_type=color': ignoring
[  0.706062] <  0.000013> PID hash table entries: 512 (order: 9, 2048 bytes)
[  0.706075] <  0.000013> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[  0.706087] <  0.000012> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[  0.755997] <  0.049910> Memory: 128MB = 128MB total
[  0.756016] <  0.000019> Memory: 127004KB available (2404K code, 205K data, 80K init, 0K highmem)
[  0.756030] <  0.000014> NR_IRQS:272
[  0.756042] <  0.000012> MXC GPIO hardware
[  0.756055] <  0.000013> MXC IRQ initialized
[  0.756067] <  0.000012> Console: colour dummy device 80x30
[  0.756079] <  0.000012> Calibrating delay loop (skipped) preset value.. 199.06 BogoMIPS (lpj=995328)
[  0.756092] <  0.000013> Mount-cache hash table entries: 512
[  0.756104] <  0.000012> CPU: Testing write buffer coherency: ok
[  0.771968] <  0.015864> NET: Registered protocol family 16
[  0.803967] <  0.031999> bio: create slab <bio-0> at 0
[  0.869007] <  0.065040> NET: Registered protocol family 2
[  0.869025] <  0.000018> IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[  0.869040] <  0.000015> TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[  0.869053] <  0.000013> TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[  0.869066] <  0.000013> TCP: Hash tables configured (established 4096 bind 4096)
[  0.869078] <  0.000012> TCP reno registered
[  0.869090] <  0.000012> NET: Registered protocol family 1
[  0.869103] <  0.000013> msgmni has been set to 248
[  0.869115] <  0.000012> io scheduler noop registered (default)
[  0.869127] <  0.000012> i.MX Framebuffer driver
[  0.884970] <  0.015843> Console: switching to colour frame buffer device 30x40
[  0.974022] <  0.089052> Serial: IMX driver
[  0.974127] <  0.000105> Platform driver 'imx-uart' needs updating - please use dev_pm_ops
[  0.974217] <  0.000090> imx-uart.0: ttymxc0 at MMIO 0x1000a000 (irq = 20) is a IMX
[  0.974306] <  0.000089> console handover: boot [earlyser0] -> real [ttymxc0]
[  0.974392] <  0.000086> imx-uart.1: ttymxc1 at MMIO 0x1000b000 (irq = 19) is a IMX
[  0.974481] <  0.000089> imx-uart.2: ttymxc2 at MMIO 0x1000c000 (irq = 18) is a IMX
[  0.974569] <  0.000088> FEC Ethernet Driver
[  0.974651] <  0.000082> Platform driver 'fec' needs updating - please use dev_pm_ops
[  0.974737] <  0.000086> fec: PHY @ 0x0, ID 0x00221613 -- KS8721BL
[  1.019018] <  0.044281> physmap platform flash device: 02000000 at c0000000
[  1.019118] <  0.000100> physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
[  1.019207] <  0.000089>  Intel/Sharp Extended Query Table at 0x010A
[  1.019293] <  0.000086>  Intel/Sharp Extended Query Table at 0x010A
[  1.019377] <  0.000084>  Intel/Sharp Extended Query Table at 0x010A
[  1.019460] <  0.000083>  Intel/Sharp Extended Query Table at 0x010A
[  1.019544] <  0.000084>  Intel/Sharp Extended Query Table at 0x010A
[  1.019627] <  0.000083> Using buffer write method
[  1.019714] <  0.000087> Using auto-unlock on power-up/resume
[  1.019797] <  0.000083> cfi_cmdset_0001: Erase suspend on write enabled
[  1.019881] <  0.000084> 4 cmdlinepart partitions found on MTD device physmap-flash.0
[  1.082018] <  0.062137> Creating 4 MTD partitions on "physmap-flash.0":
[  1.082112] <  0.000094> 0x000000000000-0x000000040000 : "uboot"
[  1.082199] <  0.000087> 0x000000040000-0x000000060000 : "ubootenv"
[  1.082287] <  0.000088> 0x000000060000-0x000000360000 : "kernel"
[  1.082371] <  0.000084> 0x000000360000-0x000002000000 : "root"
[  1.082453] <  0.000082> NAND device: Manufacturer ID: 0x20, Chip ID: 0x36 (ST Micro NAND 64MiB 1,8V 8-bit)
[  1.082543] <  0.000090> RedBoot partition parsing not available
[  1.082627] <  0.000084> 4 cmdlinepart partitions found on MTD device mxc_nand
[  1.082715] <  0.000088> Creating 4 MTD partitions on "mxc_nand":
[  1.082798] <  0.000083> 0x000000000000-0x000000040000 : "uboot"
[  1.082882] <  0.000084> 0x000000040000-0x000000060000 : "ubootenv"
[  1.097976] <  0.015094> 0x000000060000-0x000000360000 : "kernel"
[  1.113978] <  0.016002> 0x000000360000-0x000004000000 : "root"
[  1.425012] <  0.311034> UBI: attaching mtd7 to ubi0
[  1.425043] <  0.000031> UBI: physical eraseblock size:   16384 bytes (16 KiB)
[  1.425057] <  0.000014> UBI: logical eraseblock size:    15360 bytes
[  1.425071] <  0.000014> UBI: smallest flash I/O unit:    512
[  1.425083] <  0.000012> UBI: VID header offset:          512 (aligned 512)
[  1.425096] <  0.000013> UBI: data offset:                1024
[  3.008058] <  1.582962> UBI: attached mtd7 to ubi0
[  3.008090] <  0.000032> UBI: MTD device name:            "root"
[  3.008105] <  0.000015> UBI: MTD device size:            60 MiB
[  3.008119] <  0.000014> UBI: number of good PEBs:        3880
[  3.008132] <  0.000013> UBI: number of bad PEBs:         0
[  3.008145] <  0.000013> UBI: max. allowed volumes:       89
[  3.008159] <  0.000014> UBI: wear-leveling threshold:    4096
[  3.008172] <  0.000013> UBI: number of internal volumes: 1
[  3.008185] <  0.000013> UBI: number of user volumes:     1
[  3.008199] <  0.000014> UBI: available PEBs:             0
[  3.008212] <  0.000013> UBI: total number of reserved PEBs: 3880
[  3.008226] <  0.000014> UBI: number of PEBs reserved for bad PEB handling: 38
[  3.051029] <  0.042803> UBI: max/mean erase counter: 2/0
[  3.051052] <  0.000023> UBI: image sequence number: 0
[  3.051066] <  0.000014> UBI: background thread "ubi_bgt0d" started, PID 218
[  3.051081] <  0.000015> i2c /dev entries driver
[  3.051094] <  0.000013> rtc-pcf8563 1-0051: chip found, driver version 0.4.3
[  3.051108] <  0.000014> rtc-pcf8563 1-0051: rtc core: registered rtc-pcf8563 as rtc0
[  3.051122] <  0.000014> Driver for 1-wire Dallas network protocol.
[  3.148042] <  0.096920> i.MX SDHC driver
[  3.148067] <  0.000025> mxc-mmc: probe of mxc-mmc.1 failed with error -16
[  3.148082] <  0.000015> TCP cubic registered
[  3.148095] <  0.000013> NET: Registered protocol family 17
[  3.148107] <  0.000012> RPC: Registered udp transport module.
[  3.148119] <  0.000012> RPC: Registered tcp transport module.
[  3.148132] <  0.000013> rtc-pcf8563 1-0051: low voltage detected, date/time is not reliable.
[  3.148145] <  0.000013> rtc-pcf8563 1-0051: retrieved date/time is not valid.
[  3.148157] <  0.000012> rtc-pcf8563 1-0051: hctosys: invalid date/time
[  3.148170] <  0.000013> UBIFS: recovery needed
[  3.211043] <  0.062873> UBIFS: recovery completed
[  3.211064] <  0.000021> UBIFS: mounted UBI device 0, volume 1, name "root"
[  3.211080] <  0.000016> UBIFS: file system size:   58490880 bytes (57120 KiB, 55 MiB, 3808 LEBs)
[  3.211093] <  0.000013> UBIFS: journal size:       7741440 bytes (7560 KiB, 7 MiB, 504 LEBs)
[  3.211105] <  0.000012> UBIFS: media format:       w4/r0 (latest is w4/r0)
[  3.211118] <  0.000013> UBIFS: default compressor: lzo
[  3.211130] <  0.000012> UBIFS: reserved for root:  0 bytes (0 KiB)
[  3.211143] <  0.000013> VFS: Mounted root (ubifs filesystem) on device 0:12.
[  3.211155] <  0.000012> Freeing init memory: 80K
init started: BusyBox v1.13.4 (2009-08-06 08:30:14 CEST)
[  3.514007] <  0.159993> mounting filesystems...done.
[  3.546005] <  0.031998> running rc.d services...
[  3.626007] <  0.080002> syslogd starting
[  3.786013] <  0.160006> Starting telnetd...
[  3.962014] <  0.176001> starting network interfaces...
[  4.818032] <  0.856018> eth0: config: auto-negotiation on, 100FDX, 100HDX, 10FDX, 10HDX.
[  5.058038] <  0.240006> ip: cannot find device "can0"
[  5.250040] <  0.192002> ip: SIOCGIFFLAGS: No such device
[  5.298033] <  0.047993>
[  5.336039] <  0.038006> OSELAS(R)-phyCORE-trunk (PTXdist-1.99.svn/2009-08-06T08:37:25+0200)
[  5.368028] <  0.031989>
[  5.840066] <  0.472038>        _            ____ ___  ____  _____
[  5.840090] <  0.000024>  _ __ | |__  _   _ / ___/ _ \|  _ \| ____|
[  5.840104] <  0.000014> | '_ \| '_ \| | | | |  | | | | |_) |  _|
[  5.840116] <  0.000012> | |_) | | | | |_| | |__| |_| |  _ <| |___
[  5.840129] <  0.000013> | .__/|_| |_|\__, |\____\___/|_| \_\_____|
[  5.840141] <  0.000012> |_|          |___/
[  5.840154] <  0.000013>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
