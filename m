Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZAFWM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZAFWM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZAFWMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:12:38 -0500
Received: from kroah.org ([198.145.64.141]:51158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980AbZAFWMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:12:31 -0500
Date: Tue, 6 Jan 2009 14:11:29 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6-git
Message-ID: <20090106221129.GB32689@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging patches against your 2.6 git tree, all safe and
self-contained in the drivers/staging/ portion of the tree.

There's a lot of stuff here, as can be seen by the final diffstat
number:
 779 files changed, 472695 insertions(+), 26479 deletions(-)

and yes, it's all crap :)

Short summary of this series is:
	- build fixes due to api changes elsewhere in the kernel tree
	  (specifically v4l2 and network driver changes.)
	- new drivers added:
		- Ralink rt2860 wireless driver
		- Ralink rt2870 wireless driver
      		- ServerEngines benet 10Gb ethernet driver
		- Atheros otus wireless driver
		- agnx wireless driver
		- rtl8187se wireless driver
		- meilhaus data acquision drivers
		- princeton instruments usb camera driver
		- mimio xi whiteboard input driver
		- frontier tranzport and alphatrack drivers
		- android drivers
		- Comedi core and some drivers
		- powerlink core and drivers
		- asus_oled driver
		- lcd-panel driver
		- driver for Altera PCI Express Chaining DMA reference
		  design
	- loads of cleanups to the existing staging drivers

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

These have all been in the -next releases with no known build errors.

I'm not going to send the patches to lkml, as I really doubt people want
to see all 237 patches individually, especially as many of them are just
to big for the list as-is.  If anyone wants me to send them to them
directly, and can't use git, let me know and I'll be glad to patchbomb
you.

thanks,

greg k-h

--------------
 arch/arm/Kconfig                                   |    2 +
 arch/cris/Kconfig                                  |    2 +
 arch/h8300/Kconfig                                 |    2 +
 drivers/staging/Kconfig                            |   32 +
 drivers/staging/Makefile                           |   16 +
 drivers/staging/agnx/Kconfig                       |    5 +
 drivers/staging/agnx/Makefile                      |    8 +
 drivers/staging/agnx/TODO                          |   22 +
 drivers/staging/agnx/agnx.h                        |  154 +
 drivers/staging/agnx/debug.h                       |  418 +
 drivers/staging/agnx/pci.c                         |  644 ++
 drivers/staging/agnx/phy.c                         |  960 +++
 drivers/staging/agnx/phy.h                         |  409 +
 drivers/staging/agnx/rf.c                          |  894 ++
 drivers/staging/agnx/sta.c                         |  219 +
 drivers/staging/agnx/sta.h                         |  222 +
 drivers/staging/agnx/table.c                       |  168 +
 drivers/staging/agnx/table.h                       |   10 +
 drivers/staging/agnx/xmit.c                        |  819 ++
 drivers/staging/agnx/xmit.h                        |  250 +
 drivers/staging/altpciechdma/Kconfig               |   10 +
 drivers/staging/altpciechdma/Makefile              |    2 +
 drivers/staging/altpciechdma/TODO                  |   15 +
 drivers/staging/altpciechdma/altpciechdma.c        | 1184 +++
 drivers/staging/android/Kconfig                    |   86 +
 drivers/staging/android/Makefile                   |    5 +
 drivers/staging/android/TODO                       |   10 +
 drivers/staging/android/binder.c                   | 3503 ++++++++
 drivers/staging/android/binder.h                   |  330 +
 drivers/staging/android/logger.c                   |  607 ++
 drivers/staging/android/logger.h                   |   48 +
 drivers/staging/android/lowmemorykiller.c          |  119 +
 drivers/staging/android/ram_console.c              |  395 +
 drivers/staging/android/timed_gpio.c               |  177 +
 drivers/staging/android/timed_gpio.h               |   31 +
 drivers/staging/asus_oled/Kconfig                  |    6 +
 drivers/staging/asus_oled/Makefile                 |    1 +
 drivers/staging/asus_oled/README                   |  156 +
 drivers/staging/asus_oled/TODO                     |   10 +
 drivers/staging/asus_oled/asus_oled.c              |  745 ++
 drivers/staging/asus_oled/linux.txt                |   33 +
 drivers/staging/asus_oled/linux_f.txt              |   18 +
 drivers/staging/asus_oled/linux_fr.txt             |   33 +
 drivers/staging/asus_oled/tux.txt                  |   33 +
 drivers/staging/asus_oled/tux_r.txt                |   33 +
 drivers/staging/asus_oled/tux_r2.txt               |   33 +
 drivers/staging/asus_oled/zig.txt                  |   33 +
 drivers/staging/at76_usb/Kconfig                   |    2 +-
 drivers/staging/at76_usb/at76_usb.c                | 4640 +++---------
 drivers/staging/at76_usb/at76_usb.h                |  227 +-
 drivers/staging/benet/Kconfig                      |    7 +
 drivers/staging/benet/MAINTAINERS                  |    6 +
 drivers/staging/benet/Makefile                     |   14 +
 drivers/staging/benet/TODO                         |    6 +
 drivers/staging/benet/asyncmesg.h                  |   82 +
 drivers/staging/benet/be_cm.h                      |  134 +
 drivers/staging/benet/be_common.h                  |   53 +
 drivers/staging/benet/be_ethtool.c                 |  348 +
 drivers/staging/benet/be_init.c                    | 1382 ++++
 drivers/staging/benet/be_int.c                     |  863 ++
 drivers/staging/benet/be_netif.c                   |  705 ++
 drivers/staging/benet/benet.h                      |  429 +
 drivers/staging/benet/bestatus.h                   |  103 +
 drivers/staging/benet/cev.h                        |  243 +
 drivers/staging/benet/cq.c                         |  211 +
 drivers/staging/benet/descriptors.h                |   71 +
 drivers/staging/benet/doorbells.h                  |  179 +
 drivers/staging/benet/ep.h                         |   66 +
 drivers/staging/benet/eq.c                         |  299 +
 drivers/staging/benet/eth.c                        | 1273 +++
 drivers/staging/benet/etx_context.h                |   55 +
 drivers/staging/benet/funcobj.c                    |  565 ++
 drivers/staging/benet/fwcmd_common.h               |  222 +
 drivers/staging/benet/fwcmd_common_bmap.h          |  717 ++
 drivers/staging/benet/fwcmd_eth_bmap.h             |  280 +
 drivers/staging/benet/fwcmd_hdr_bmap.h             |   54 +
 drivers/staging/benet/fwcmd_mcc.h                  |   94 +
 drivers/staging/benet/fwcmd_opcodes.h              |  244 +
 drivers/staging/benet/fwcmd_types_bmap.h           |   29 +
 drivers/staging/benet/host_struct.h                |  182 +
 drivers/staging/benet/hwlib.h                      |  830 ++
 drivers/staging/benet/mpu.c                        | 1364 +++
 drivers/staging/benet/mpu.h                        |   74 +
 drivers/staging/benet/mpu_context.h                |   46 +
 drivers/staging/benet/pcicfg.h                     |  825 ++
 drivers/staging/benet/post_codes.h                 |  111 +
 drivers/staging/benet/regmap.h                     |   68 +
 drivers/staging/comedi/Kconfig                     |   27 +
 drivers/staging/comedi/Makefile                    |   17 +
 drivers/staging/comedi/TODO                        |   14 +
 drivers/staging/comedi/comedi.h                    |  916 +++
 drivers/staging/comedi/comedi_compat32.c           |  597 ++
 drivers/staging/comedi/comedi_compat32.h           |   58 +
 drivers/staging/comedi/comedi_fops.c               | 2244 +++++
 drivers/staging/comedi/comedi_fops.h               |    8 +
 drivers/staging/comedi/comedi_ksyms.c              |   77 +
 drivers/staging/comedi/comedi_rt.h                 |  150 +
 drivers/staging/comedi/comedidev.h                 |  537 ++
 drivers/staging/comedi/comedilib.h                 |  192 +
 drivers/staging/comedi/drivers.c                   |  846 ++
 drivers/staging/comedi/drivers/Makefile            |   21 +
 drivers/staging/comedi/drivers/comedi_bond.c       |  535 ++
 drivers/staging/comedi/drivers/comedi_fc.c         |  118 +
 drivers/staging/comedi/drivers/comedi_fc.h         |   76 +
 drivers/staging/comedi/drivers/comedi_parport.c    |  390 +
 drivers/staging/comedi/drivers/comedi_pci.h        |   60 +
 drivers/staging/comedi/drivers/comedi_test.c       |  527 ++
 drivers/staging/comedi/drivers/dt9812.c            | 1162 +++
 drivers/staging/comedi/drivers/icp_multi.c         | 1085 +++
 drivers/staging/comedi/drivers/icp_multi.h         |  278 +
 drivers/staging/comedi/drivers/me4000.c            | 2362 ++++++
 drivers/staging/comedi/drivers/me4000.h            |  446 +
 drivers/staging/comedi/drivers/me_daq.c            |  845 ++
 drivers/staging/comedi/drivers/mite.c              |  809 ++
 drivers/staging/comedi/drivers/mite.h              |  453 +
 drivers/staging/comedi/drivers/plx9080.h           |  429 +
 drivers/staging/comedi/drivers/rtd520.c            | 2283 ++++++
 drivers/staging/comedi/drivers/rtd520.h            |  412 +
 drivers/staging/comedi/drivers/s626.c              | 3254 ++++++++
 drivers/staging/comedi/drivers/s626.h              |  802 ++
 drivers/staging/comedi/drivers/usbdux.c            | 2932 +++++++
 drivers/staging/comedi/drivers/usbduxfast.c        | 1778 ++++
 drivers/staging/comedi/interrupt.h                 |   60 +
 drivers/staging/comedi/kcomedilib/Makefile         |    8 +
 drivers/staging/comedi/kcomedilib/data.c           |   89 +
 drivers/staging/comedi/kcomedilib/dio.c            |   95 +
 drivers/staging/comedi/kcomedilib/get.c            |  294 +
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |  567 ++
 drivers/staging/comedi/kcomedilib/ksyms.c          |  144 +
 drivers/staging/comedi/pci_ids.h                   |   31 +
 drivers/staging/comedi/proc.c                      |  102 +
 drivers/staging/comedi/range.c                     |  161 +
 drivers/staging/comedi/rt.c                        |  412 +
 drivers/staging/comedi/rt_pend_tq.c                |  113 +
 drivers/staging/comedi/rt_pend_tq.h                |   10 +
 drivers/staging/comedi/wrapper.h                   |   25 +
 drivers/staging/echo/TODO                          |    2 -
 drivers/staging/echo/echo.h                        |    4 +-
 drivers/staging/echo/fir.h                         |   44 +-
 drivers/staging/echo/mmx.h                         |    8 +-
 drivers/staging/epl/Benchmark.h                    |  437 +
 drivers/staging/epl/Debug.h                        |  734 ++
 drivers/staging/epl/Edrv8139.c                     | 1252 +++
 drivers/staging/epl/EdrvFec.h                      |  114 +
 drivers/staging/epl/EdrvFec5282.h                  |  340 +
 drivers/staging/epl/EdrvSim.h                      |   89 +
 drivers/staging/epl/Epl.h                          |  273 +
 drivers/staging/epl/EplAmi.h                       |  362 +
 drivers/staging/epl/EplApiGeneric.c                | 2060 +++++
 drivers/staging/epl/EplApiLinux.h                  |  141 +
 drivers/staging/epl/EplApiLinuxKernel.c            | 1260 +++
 drivers/staging/epl/EplApiProcessImage.c           |  347 +
 drivers/staging/epl/EplCfg.h                       |  196 +
 drivers/staging/epl/EplDef.h                       |  355 +
 drivers/staging/epl/EplDll.h                       |  205 +
 drivers/staging/epl/EplDllCal.h                    |  123 +
 drivers/staging/epl/EplDllk.c                      | 4054 +++++++++
 drivers/staging/epl/EplDllkCal.c                   | 1260 +++
 drivers/staging/epl/EplDlluCal.c                   |  529 ++
 drivers/staging/epl/EplErrDef.h                    |  294 +
 drivers/staging/epl/EplErrorHandlerk.c             |  810 ++
 drivers/staging/epl/EplEvent.h                     |  279 +
 drivers/staging/epl/EplEventk.c                    |  853 ++
 drivers/staging/epl/EplEventu.c                    |  814 ++
 drivers/staging/epl/EplFrame.h                     |  344 +
 drivers/staging/epl/EplIdentu.c                    |  488 ++
 drivers/staging/epl/EplInc.h                       |  385 +
 drivers/staging/epl/EplInstDef.h                   |  377 +
 drivers/staging/epl/EplLed.h                       |   92 +
 drivers/staging/epl/EplNmt.h                       |  230 +
 drivers/staging/epl/EplNmtCnu.c                    |  704 ++
 drivers/staging/epl/EplNmtMnu.c                    | 2835 +++++++
 drivers/staging/epl/EplNmtk.c                      | 1842 +++++
 drivers/staging/epl/EplNmtkCal.c                   |  149 +
 drivers/staging/epl/EplNmtu.c                      |  708 ++
 drivers/staging/epl/EplNmtuCal.c                   |  158 +
 drivers/staging/epl/EplObd.c                       | 3262 ++++++++
 drivers/staging/epl/EplObd.h                       |  464 ++
 drivers/staging/epl/EplObdMacro.h                  |  354 +
 drivers/staging/epl/EplObdkCal.c                   |  147 +
 drivers/staging/epl/EplObdu.c                      |  517 ++
 drivers/staging/epl/EplObduCal.c                   |  558 ++
 drivers/staging/epl/EplObjDef.h                    |  208 +
 drivers/staging/epl/EplPdo.h                       |  117 +
 drivers/staging/epl/EplPdok.c                      |  694 ++
 drivers/staging/epl/EplPdokCal.c                   |  266 +
 drivers/staging/epl/EplPdou.c                      |  565 ++
 drivers/staging/epl/EplSdo.h                       |  245 +
 drivers/staging/epl/EplSdoAc.h                     |  111 +
 drivers/staging/epl/EplSdoAsndu.c                  |  483 ++
 drivers/staging/epl/EplSdoAsySequ.c                | 2522 ++++++
 drivers/staging/epl/EplSdoComu.c                   | 3346 ++++++++
 drivers/staging/epl/EplSdoUdpu.c                   |  790 ++
 drivers/staging/epl/EplStatusu.c                   |  380 +
 drivers/staging/epl/EplTarget.h                    |  233 +
 drivers/staging/epl/EplTimer.h                     |  117 +
 drivers/staging/epl/EplTimeruLinuxKernel.c         |  446 +
 drivers/staging/epl/EplTimeruNull.c                |  312 +
 drivers/staging/epl/EplTimeruWin32.c               |  513 ++
 drivers/staging/epl/EplVersion.h                   |   98 +
 drivers/staging/epl/Kconfig                        |    6 +
 drivers/staging/epl/Makefile                       |   41 +
 drivers/staging/epl/SharedBuff.c                   | 1799 ++++
 drivers/staging/epl/SharedBuff.h                   |  204 +
 drivers/staging/epl/ShbIpc-LinuxKernel.c           |  966 +++
 drivers/staging/epl/ShbIpc-Win32.c                 | 1202 +++
 drivers/staging/epl/ShbIpc.h                       |  125 +
 drivers/staging/epl/ShbLinuxKernel.h               |   68 +
 drivers/staging/epl/SocketLinuxKernel.c            |  197 +
 drivers/staging/epl/SocketLinuxKernel.h            |  105 +
 drivers/staging/epl/TimerHighReskX86.c             |  522 ++
 drivers/staging/epl/VirtualEthernetLinux.c         |  342 +
 drivers/staging/epl/amix86.c                       |  905 ++
 drivers/staging/epl/demo_main.c                    |  961 +++
 drivers/staging/epl/edrv.h                         |  167 +
 drivers/staging/epl/global.h                       | 1391 ++++
 drivers/staging/epl/kernel/EplDllk.h               |  165 +
 drivers/staging/epl/kernel/EplDllkCal.h            |  141 +
 drivers/staging/epl/kernel/EplErrorHandlerk.h      |  100 +
 drivers/staging/epl/kernel/EplEventk.h             |  108 +
 drivers/staging/epl/kernel/EplNmtk.h               |  105 +
 drivers/staging/epl/kernel/EplNmtkCal.h            |   89 +
 drivers/staging/epl/kernel/EplObdk.h               |  196 +
 drivers/staging/epl/kernel/EplObdkCal.h            |   89 +
 drivers/staging/epl/kernel/EplPdok.h               |  110 +
 drivers/staging/epl/kernel/EplPdokCal.h            |   99 +
 drivers/staging/epl/kernel/EplTimerHighResk.h      |  109 +
 drivers/staging/epl/kernel/EplTimerk.h             |  118 +
 drivers/staging/epl/kernel/VirtualEthernet.h       |   96 +
 drivers/staging/epl/proc_fs.c                      |  409 +
 drivers/staging/epl/proc_fs.h                      |   89 +
 drivers/staging/epl/user/EplCfgMau.h               |  284 +
 drivers/staging/epl/user/EplDllu.h                 |  108 +
 drivers/staging/epl/user/EplDlluCal.h              |  117 +
 drivers/staging/epl/user/EplEventu.h               |  108 +
 drivers/staging/epl/user/EplIdentu.h               |  108 +
 drivers/staging/epl/user/EplLedu.h                 |  109 +
 drivers/staging/epl/user/EplNmtCnu.h               |  108 +
 drivers/staging/epl/user/EplNmtMnu.h               |  131 +
 drivers/staging/epl/user/EplNmtu.h                 |  155 +
 drivers/staging/epl/user/EplNmtuCal.h              |   91 +
 drivers/staging/epl/user/EplObdu.h                 |  192 +
 drivers/staging/epl/user/EplObduCal.h              |  148 +
 drivers/staging/epl/user/EplPdou.h                 |  108 +
 drivers/staging/epl/user/EplSdoAsndu.h             |  107 +
 drivers/staging/epl/user/EplSdoAsySequ.h           |  111 +
 drivers/staging/epl/user/EplSdoComu.h              |  126 +
 drivers/staging/epl/user/EplSdoUdpu.h              |  109 +
 drivers/staging/epl/user/EplStatusu.h              |  104 +
 drivers/staging/epl/user/EplTimeru.h               |  107 +
 drivers/staging/et131x/et1310_tx.c                 |    3 -
 drivers/staging/et131x/et131x_debug.h              |  160 +-
 drivers/staging/frontier/Kconfig                   |    6 +
 drivers/staging/frontier/Makefile                  |    2 +
 drivers/staging/frontier/README                    |   28 +
 drivers/staging/frontier/TODO                      |    9 +
 drivers/staging/frontier/alphatrack.c              |  853 ++
 drivers/staging/frontier/alphatrack.h              |   92 +
 drivers/staging/frontier/frontier_compat.h         |   63 +
 drivers/staging/frontier/surface_sysfs.h           |  100 +
 drivers/staging/frontier/tranzport.c               | 1006 +++
 drivers/staging/go7007/Kconfig                     |   10 +
 drivers/staging/go7007/Makefile                    |   15 +-
 drivers/staging/go7007/go7007-driver.c             |    5 +-
 drivers/staging/go7007/go7007-fw.c                 |   30 +-
 drivers/staging/go7007/go7007-priv.h               |    2 +
 drivers/staging/go7007/go7007-usb.c                |   95 +-
 drivers/staging/go7007/go7007-v4l2.c               | 1703 +++--
 drivers/staging/go7007/go7007.txt                  |  481 ++
 drivers/staging/go7007/s2250-board.c               |  630 ++
 drivers/staging/go7007/s2250-loader.c              |  188 +
 drivers/staging/go7007/saa7134-go7007.c            |   52 +-
 drivers/staging/go7007/wis-i2c.h                   |    1 +
 drivers/staging/go7007/wis-sony-tuner.c            |    2 +-
 drivers/staging/me4000/me4000.c                    |   99 +-
 drivers/staging/meilhaus/Kconfig                   |  127 +
 drivers/staging/meilhaus/Makefile                  |   43 +
 drivers/staging/meilhaus/TODO                      |   10 +
 drivers/staging/meilhaus/me0600_device.c           |  215 +
 drivers/staging/meilhaus/me0600_device.h           |   97 +
 drivers/staging/meilhaus/me0600_dio.c              |  415 +
 drivers/staging/meilhaus/me0600_dio.h              |   68 +
 drivers/staging/meilhaus/me0600_dio_reg.h          |   41 +
 drivers/staging/meilhaus/me0600_ext_irq.c          |  478 ++
 drivers/staging/meilhaus/me0600_ext_irq.h          |   58 +
 drivers/staging/meilhaus/me0600_ext_irq_reg.h      |   18 +
 drivers/staging/meilhaus/me0600_optoi.c            |  243 +
 drivers/staging/meilhaus/me0600_optoi.h            |   58 +
 drivers/staging/meilhaus/me0600_optoi_reg.h        |   35 +
 drivers/staging/meilhaus/me0600_relay.c            |  359 +
 drivers/staging/meilhaus/me0600_relay.h            |   63 +
 drivers/staging/meilhaus/me0600_relay_reg.h        |   36 +
 drivers/staging/meilhaus/me0600_ttli.c             |  238 +
 drivers/staging/meilhaus/me0600_ttli.h             |   58 +
 drivers/staging/meilhaus/me0600_ttli_reg.h         |   35 +
 drivers/staging/meilhaus/me0900_device.c           |  180 +
 drivers/staging/meilhaus/me0900_device.h           |   92 +
 drivers/staging/meilhaus/me0900_di.c               |  246 +
 drivers/staging/meilhaus/me0900_di.h               |   65 +
 drivers/staging/meilhaus/me0900_do.c               |  314 +
 drivers/staging/meilhaus/me0900_do.h               |   68 +
 drivers/staging/meilhaus/me0900_reg.h              |   40 +
 drivers/staging/meilhaus/me1000_device.c           |  208 +
 drivers/staging/meilhaus/me1000_device.h           |   59 +
 drivers/staging/meilhaus/me1000_dio.c              |  438 +
 drivers/staging/meilhaus/me1000_dio.h              |   71 +
 drivers/staging/meilhaus/me1000_dio_reg.h          |   50 +
 drivers/staging/meilhaus/me1400_device.c           |  256 +
 drivers/staging/meilhaus/me1400_device.h           |  108 +
 drivers/staging/meilhaus/me1400_ext_irq.c          |  517 ++
 drivers/staging/meilhaus/me1400_ext_irq.h          |   62 +
 drivers/staging/meilhaus/me1400_ext_irq_reg.h      |   56 +
 drivers/staging/meilhaus/me1600_ao.c               | 1033 +++
 drivers/staging/meilhaus/me1600_ao.h               |  132 +
 drivers/staging/meilhaus/me1600_ao_reg.h           |   66 +
 drivers/staging/meilhaus/me1600_device.c           |  261 +
 drivers/staging/meilhaus/me1600_device.h           |  101 +
 drivers/staging/meilhaus/me4600_ai.c               | 3434 ++++++++
 drivers/staging/meilhaus/me4600_ai.h               |  180 +
 drivers/staging/meilhaus/me4600_ai_reg.h           |  107 +
 drivers/staging/meilhaus/me4600_ao.c               | 6011 ++++++++++++++
 drivers/staging/meilhaus/me4600_ao.h               |  263 +
 drivers/staging/meilhaus/me4600_ao_reg.h           |  113 +
 drivers/staging/meilhaus/me4600_device.c           |  373 +
 drivers/staging/meilhaus/me4600_device.h           |  151 +
 drivers/staging/meilhaus/me4600_di.c               |  256 +
 drivers/staging/meilhaus/me4600_di.h               |   64 +
 drivers/staging/meilhaus/me4600_dio.c              |  510 ++
 drivers/staging/meilhaus/me4600_dio.h              |   69 +
 drivers/staging/meilhaus/me4600_dio_reg.h          |   63 +
 drivers/staging/meilhaus/me4600_do.c               |  433 +
 drivers/staging/meilhaus/me4600_do.h               |   65 +
 drivers/staging/meilhaus/me4600_ext_irq.c          |  467 ++
 drivers/staging/meilhaus/me4600_ext_irq.h          |   78 +
 drivers/staging/meilhaus/me4600_ext_irq_reg.h      |   41 +
 drivers/staging/meilhaus/me4600_reg.h              |   46 +
 drivers/staging/meilhaus/me6000_ao.c               | 3739 +++++++++
 drivers/staging/meilhaus/me6000_ao.h               |  200 +
 drivers/staging/meilhaus/me6000_ao_reg.h           |  177 +
 drivers/staging/meilhaus/me6000_device.c           |  211 +
 drivers/staging/meilhaus/me6000_device.h           |  149 +
 drivers/staging/meilhaus/me6000_dio.c              |  415 +
 drivers/staging/meilhaus/me6000_dio.h              |   68 +
 drivers/staging/meilhaus/me6000_dio_reg.h          |   43 +
 drivers/staging/meilhaus/me6000_reg.h              |   35 +
 drivers/staging/meilhaus/me8100_device.c           |  187 +
 drivers/staging/meilhaus/me8100_device.h           |   97 +
 drivers/staging/meilhaus/me8100_di.c               |  693 ++
 drivers/staging/meilhaus/me8100_di.h               |   89 +
 drivers/staging/meilhaus/me8100_di_reg.h           |   47 +
 drivers/staging/meilhaus/me8100_do.c               |  391 +
 drivers/staging/meilhaus/me8100_do.h               |   70 +
 drivers/staging/meilhaus/me8100_do_reg.h           |   36 +
 drivers/staging/meilhaus/me8100_reg.h              |   41 +
 drivers/staging/meilhaus/me8200_device.c           |  194 +
 drivers/staging/meilhaus/me8200_device.h           |   97 +
 drivers/staging/meilhaus/me8200_di.c               |  857 ++
 drivers/staging/meilhaus/me8200_di.h               |   92 +
 drivers/staging/meilhaus/me8200_di_reg.h           |   75 +
 drivers/staging/meilhaus/me8200_dio.c              |  418 +
 drivers/staging/meilhaus/me8200_dio.h              |   68 +
 drivers/staging/meilhaus/me8200_dio_reg.h          |   43 +
 drivers/staging/meilhaus/me8200_do.c               |  600 ++
 drivers/staging/meilhaus/me8200_do.h               |   75 +
 drivers/staging/meilhaus/me8200_do_reg.h           |   40 +
 drivers/staging/meilhaus/me8200_reg.h              |   46 +
 drivers/staging/meilhaus/me8254.c                  | 1176 +++
 drivers/staging/meilhaus/me8254.h                  |   80 +
 drivers/staging/meilhaus/me8254_reg.h              |  172 +
 drivers/staging/meilhaus/me8255.c                  |  462 ++
 drivers/staging/meilhaus/me8255.h                  |   59 +
 drivers/staging/meilhaus/me8255_reg.h              |   50 +
 drivers/staging/meilhaus/mecirc_buf.h              |  131 +
 drivers/staging/meilhaus/mecommon.h                |   26 +
 drivers/staging/meilhaus/medebug.h                 |  125 +
 drivers/staging/meilhaus/medefines.h               |  449 +
 drivers/staging/meilhaus/medevice.c                | 1740 ++++
 drivers/staging/meilhaus/medevice.h                |  304 +
 drivers/staging/meilhaus/medlist.c                 |  127 +
 drivers/staging/meilhaus/medlist.h                 |   91 +
 drivers/staging/meilhaus/medlock.c                 |  195 +
 drivers/staging/meilhaus/medlock.h                 |   76 +
 drivers/staging/meilhaus/medriver.h                |  350 +
 drivers/staging/meilhaus/medummy.c                 | 1266 +++
 drivers/staging/meilhaus/medummy.h                 |   40 +
 drivers/staging/meilhaus/meerror.h                 |  100 +
 drivers/staging/meilhaus/mefirmware.c              |  137 +
 drivers/staging/meilhaus/mefirmware.h              |   57 +
 drivers/staging/meilhaus/meids.h                   |   31 +
 drivers/staging/meilhaus/meinternal.h              |  363 +
 drivers/staging/meilhaus/meioctl.h                 |  515 ++
 drivers/staging/meilhaus/memain.c                  | 2022 +++++
 drivers/staging/meilhaus/memain.h                  |  460 ++
 drivers/staging/meilhaus/meplx_reg.h               |   53 +
 drivers/staging/meilhaus/meslist.c                 |  173 +
 drivers/staging/meilhaus/meslist.h                 |  108 +
 drivers/staging/meilhaus/meslock.c                 |  136 +
 drivers/staging/meilhaus/meslock.h                 |   73 +
 drivers/staging/meilhaus/mesubdevice.c             |  317 +
 drivers/staging/meilhaus/mesubdevice.h             |  197 +
 drivers/staging/meilhaus/metempl_device.c          |  137 +
 drivers/staging/meilhaus/metempl_device.h          |   92 +
 drivers/staging/meilhaus/metempl_sub.c             |  149 +
 drivers/staging/meilhaus/metempl_sub.h             |   64 +
 drivers/staging/meilhaus/metempl_sub_reg.h         |   35 +
 drivers/staging/meilhaus/metypes.h                 |   95 +
 drivers/staging/mimio/Kconfig                      |   10 +
 drivers/staging/mimio/Makefile                     |    1 +
 drivers/staging/mimio/mimio.c                      |  914 +++
 drivers/staging/otus/80211core/amsdu.c             |  134 +
 drivers/staging/otus/80211core/cagg.c              | 3611 ++++++++
 drivers/staging/otus/80211core/cagg.h              |  435 +
 drivers/staging/otus/80211core/ccmd.c              | 1861 +++++
 drivers/staging/otus/80211core/cfunc.c             | 1227 +++
 drivers/staging/otus/80211core/cfunc.h             |  449 +
 drivers/staging/otus/80211core/chb.c               |  200 +
 drivers/staging/otus/80211core/cic.c               |  496 ++
 drivers/staging/otus/80211core/cinit.c             | 1911 +++++
 drivers/staging/otus/80211core/cmm.c               | 2141 +++++
 drivers/staging/otus/80211core/cmmap.c             | 2402 ++++++
 drivers/staging/otus/80211core/cmmsta.c            | 5782 +++++++++++++
 drivers/staging/otus/80211core/coid.c              | 2695 ++++++
 drivers/staging/otus/80211core/cprecomp.h          |   32 +
 drivers/staging/otus/80211core/cpsmgr.c            |  731 ++
 drivers/staging/otus/80211core/cscanmgr.c          |  535 ++
 drivers/staging/otus/80211core/ctkip.c             |  598 ++
 drivers/staging/otus/80211core/ctxrx.c             | 4096 +++++++++
 drivers/staging/otus/80211core/cwep.c              |  299 +
 drivers/staging/otus/80211core/cwm.c               |  131 +
 drivers/staging/otus/80211core/cwm.h               |   45 +
 drivers/staging/otus/80211core/freqctrl.c          |  259 +
 drivers/staging/otus/80211core/ledmgr.c            |  557 ++
 drivers/staging/otus/80211core/performance.c       |  431 +
 drivers/staging/otus/80211core/performance.h       |   97 +
 drivers/staging/otus/80211core/pub_usb.h           |  102 +
 drivers/staging/otus/80211core/pub_zfi.h           |  821 ++
 drivers/staging/otus/80211core/pub_zfw.h           |   93 +
 drivers/staging/otus/80211core/queue.c             |  303 +
 drivers/staging/otus/80211core/queue.h             |   37 +
 drivers/staging/otus/80211core/ratectrl.c          |  874 ++
 drivers/staging/otus/80211core/ratectrl.h          |   37 +
 drivers/staging/otus/80211core/struct.h            | 1315 +++
 drivers/staging/otus/80211core/wlan.h              |  595 ++
 drivers/staging/otus/Kconfig                       |   32 +
 drivers/staging/otus/Makefile                      |   67 +
 drivers/staging/otus/TODO                          |    9 +
 drivers/staging/otus/apdbg.c                       |  457 +
 drivers/staging/otus/athr_common.h                 |  141 +
 drivers/staging/otus/hal/hpDKfwu.c                 |  832 ++
 drivers/staging/otus/hal/hpani.c                   |  732 ++
 drivers/staging/otus/hal/hpani.h                   |  420 +
 drivers/staging/otus/hal/hpfw2.c                   | 1018 +++
 drivers/staging/otus/hal/hpfwbu.c                  | 5269 ++++++++++++
 drivers/staging/otus/hal/hpfwspiu.c                |  655 ++
 drivers/staging/otus/hal/hpfwu.c                   | 1017 +++
 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend     |  742 ++
 drivers/staging/otus/hal/hpfwu_2k.c                | 1016 +++
 drivers/staging/otus/hal/hpfwu_BA.c                |  874 ++
 drivers/staging/otus/hal/hpfwu_FB50_mdk.c          |  721 ++
 drivers/staging/otus/hal/hpfwu_OTUS_RC.c           |  715 ++
 drivers/staging/otus/hal/hpfwu_txstream.c          | 1017 +++
 drivers/staging/otus/hal/hpfwuinit.c               |  240 +
 drivers/staging/otus/hal/hpmain.c                  | 4643 +++++++++++
 drivers/staging/otus/hal/hpreg.c                   | 2481 ++++++
 drivers/staging/otus/hal/hpreg.h                   |  524 ++
 drivers/staging/otus/hal/hprw.c                    | 1557 ++++
 drivers/staging/otus/hal/hpusb.c                   | 1584 ++++
 drivers/staging/otus/hal/hpusb.h                   |  437 +
 drivers/staging/otus/hal/otus.ini                  |  414 +
 drivers/staging/otus/ioctl.c                       | 2913 +++++++
 drivers/staging/otus/oal_dt.h                      |   60 +
 drivers/staging/otus/oal_marc.h                    |  135 +
 drivers/staging/otus/usbdrv.c                      | 1148 +++
 drivers/staging/otus/usbdrv.h                      |  252 +
 drivers/staging/otus/wrap_buf.c                    |  114 +
 drivers/staging/otus/wrap_dbg.c                    |  101 +
 drivers/staging/otus/wrap_ev.c                     |  283 +
 drivers/staging/otus/wrap_mem.c                    |  101 +
 drivers/staging/otus/wrap_mis.c                    |  109 +
 drivers/staging/otus/wrap_pkt.c                    |  173 +
 drivers/staging/otus/wrap_sec.c                    |  127 +
 drivers/staging/otus/wrap_usb.c                    |  191 +
 drivers/staging/otus/wwrap.c                       | 1134 +++
 drivers/staging/otus/zdcompat.h                    |   62 +
 drivers/staging/otus/zdusb.c                       |  239 +
 drivers/staging/otus/zdusb.h                       |   43 +
 drivers/staging/panel/Kconfig                      |  278 +
 drivers/staging/panel/Makefile                     |    1 +
 drivers/staging/panel/TODO                         |    9 +
 drivers/staging/panel/lcd-panel-cgram.txt          |   24 +
 drivers/staging/panel/panel.c                      | 2193 +++++
 drivers/staging/poch/README                        |    9 +-
 drivers/staging/poch/poch.c                        |  104 +-
 drivers/staging/rspiusb/Kconfig                    |    6 +
 drivers/staging/rspiusb/Makefile                   |    1 +
 drivers/staging/rspiusb/TODO                       |   22 +
 drivers/staging/rspiusb/rspiusb.c                  |  887 ++
 drivers/staging/rspiusb/rspiusb.h                  |   25 +
 drivers/staging/rt2860/2860_main_dev.c             | 1377 ++++
 drivers/staging/rt2860/Kconfig                     |    5 +
 drivers/staging/rt2860/Makefile                    |   43 +
 drivers/staging/rt2860/TODO                        |   17 +
 drivers/staging/rt2860/aironet.h                   |  210 +
 drivers/staging/rt2860/ap.h                        |  557 ++
 drivers/staging/rt2860/chlist.h                    | 1296 +++
 drivers/staging/rt2860/common/2860_rtmp_init.c     |  922 +++
 drivers/staging/rt2860/common/action.c             | 1031 +++
 drivers/staging/rt2860/common/action.h             |   68 +
 drivers/staging/rt2860/common/ba_action.c          | 1802 ++++
 drivers/staging/rt2860/common/cmm_data.c           | 3466 ++++++++
 drivers/staging/rt2860/common/cmm_data_2860.c      | 1240 +++
 drivers/staging/rt2860/common/cmm_info.c           | 3417 ++++++++
 drivers/staging/rt2860/common/cmm_sanity.c         | 1633 ++++
 drivers/staging/rt2860/common/cmm_sync.c           |  702 ++
 drivers/staging/rt2860/common/cmm_wpa.c            | 1606 ++++
 drivers/staging/rt2860/common/dfs.c                |  453 +
 drivers/staging/rt2860/common/eeprom.c             |  244 +
 drivers/staging/rt2860/common/firmware.h           |  558 ++
 drivers/staging/rt2860/common/md5.c                | 1427 ++++
 drivers/staging/rt2860/common/mlme.c               | 8667 ++++++++++++++++++++
 drivers/staging/rt2860/common/netif_block.c        |  144 +
 drivers/staging/rt2860/common/netif_block.h        |   58 +
 drivers/staging/rt2860/common/rtmp_init.c          | 3744 +++++++++
 drivers/staging/rt2860/common/rtmp_tkip.c          | 1607 ++++
 drivers/staging/rt2860/common/rtmp_wep.c           |  499 ++
 drivers/staging/rt2860/common/spectrum.c           | 1877 +++++
 drivers/staging/rt2860/config.mk                   |  245 +
 drivers/staging/rt2860/dfs.h                       |  100 +
 drivers/staging/rt2860/leap.h                      |  215 +
 drivers/staging/rt2860/link_list.h                 |  134 +
 drivers/staging/rt2860/md4.h                       |   42 +
 drivers/staging/rt2860/md5.h                       |  107 +
 drivers/staging/rt2860/mlme.h                      | 1447 ++++
 drivers/staging/rt2860/oid.h                       |  995 +++
 drivers/staging/rt2860/rt2860.h                    |  349 +
 drivers/staging/rt2860/rt28xx.h                    | 2714 ++++++
 drivers/staging/rt2860/rt_ate.c                    | 6025 ++++++++++++++
 drivers/staging/rt2860/rt_ate.h                    |  353 +
 drivers/staging/rt2860/rt_config.h                 |  101 +
 drivers/staging/rt2860/rt_linux.c                  | 1054 +++
 drivers/staging/rt2860/rt_linux.h                  |  926 +++
 drivers/staging/rt2860/rt_main_dev.c               | 1686 ++++
 drivers/staging/rt2860/rt_profile.c                | 1981 +++++
 drivers/staging/rt2860/rtmp.h                      | 7177 ++++++++++++++++
 drivers/staging/rt2860/rtmp_ckipmic.h              |  113 +
 drivers/staging/rt2860/rtmp_def.h                  | 1588 ++++
 drivers/staging/rt2860/rtmp_type.h                 |   94 +
 drivers/staging/rt2860/spectrum.h                  |  322 +
 drivers/staging/rt2860/spectrum_def.h              |   95 +
 drivers/staging/rt2860/sta/aironet.c               | 1312 +++
 drivers/staging/rt2860/sta/assoc.c                 | 1826 +++++
 drivers/staging/rt2860/sta/auth.c                  |  474 ++
 drivers/staging/rt2860/sta/auth_rsp.c              |  167 +
 drivers/staging/rt2860/sta/connect.c               | 2751 +++++++
 drivers/staging/rt2860/sta/dls.c                   | 2201 +++++
 drivers/staging/rt2860/sta/rtmp_data.c             | 2614 ++++++
 drivers/staging/rt2860/sta/sanity.c                |  420 +
 drivers/staging/rt2860/sta/sync.c                  | 1959 +++++
 drivers/staging/rt2860/sta/wpa.c                   | 2086 +++++
 drivers/staging/rt2860/sta_ioctl.c                 | 6944 ++++++++++++++++
 drivers/staging/rt2860/wpa.h                       |  356 +
 drivers/staging/rt2870/2870_main_dev.c             | 1612 ++++
 drivers/staging/rt2870/Kconfig                     |    6 +
 drivers/staging/rt2870/Makefile                    |   47 +
 drivers/staging/rt2870/TODO                        |   10 +
 drivers/staging/rt2870/aironet.h                   |  210 +
 drivers/staging/rt2870/ap.h                        |  562 ++
 drivers/staging/rt2870/chlist.h                    | 1296 +++
 drivers/staging/rt2870/common/2870_rtmp_init.c     | 1778 ++++
 drivers/staging/rt2870/common/action.c             | 1046 +++
 drivers/staging/rt2870/common/action.h             |   68 +
 drivers/staging/rt2870/common/ba_action.c          | 1798 ++++
 drivers/staging/rt2870/common/cmm_data.c           | 2734 ++++++
 drivers/staging/rt2870/common/cmm_data_2870.c      |  963 +++
 drivers/staging/rt2870/common/cmm_info.c           | 3712 +++++++++
 drivers/staging/rt2870/common/cmm_sanity.c         | 1663 ++++
 drivers/staging/rt2870/common/cmm_sync.c           |  711 ++
 drivers/staging/rt2870/common/cmm_wpa.c            | 1654 ++++
 drivers/staging/rt2870/common/dfs.c                |  453 +
 drivers/staging/rt2870/common/eeprom.c             |  254 +
 drivers/staging/rt2870/common/firmware.h           |  558 ++
 drivers/staging/rt2870/common/md5.c                | 1427 ++++
 drivers/staging/rt2870/common/mlme.c               | 8609 +++++++++++++++++++
 drivers/staging/rt2870/common/netif_block.c        |  144 +
 drivers/staging/rt2870/common/rtmp_init.c          | 4132 ++++++++++
 drivers/staging/rt2870/common/rtmp_tkip.c          | 1613 ++++
 drivers/staging/rt2870/common/rtmp_wep.c           |  508 ++
 drivers/staging/rt2870/common/rtusb_bulk.c         | 1981 +++++
 drivers/staging/rt2870/common/rtusb_data.c         |  229 +
 drivers/staging/rt2870/common/rtusb_io.c           | 2006 +++++
 drivers/staging/rt2870/common/spectrum.c           | 1876 +++++
 drivers/staging/rt2870/dfs.h                       |  100 +
 drivers/staging/rt2870/leap.h                      |  215 +
 drivers/staging/rt2870/link_list.h                 |  134 +
 drivers/staging/rt2870/md4.h                       |   42 +
 drivers/staging/rt2870/md5.h                       |  107 +
 drivers/staging/rt2870/mlme.h                      | 1471 ++++
 drivers/staging/rt2870/netif_block.h               |   58 +
 drivers/staging/rt2870/oid.h                       | 1091 +++
 drivers/staging/rt2870/rt2870.h                    |  761 ++
 drivers/staging/rt2870/rt28xx.h                    | 2689 ++++++
 drivers/staging/rt2870/rt_ate.c                    | 6452 +++++++++++++++
 drivers/staging/rt2870/rt_ate.h                    |  315 +
 drivers/staging/rt2870/rt_config.h                 |  104 +
 drivers/staging/rt2870/rt_linux.c                  | 1095 +++
 drivers/staging/rt2870/rt_linux.h                  |  908 ++
 drivers/staging/rt2870/rt_main_dev.c               | 1863 +++++
 drivers/staging/rt2870/rt_profile.c                | 2020 +++++
 drivers/staging/rt2870/rtmp.h                      | 7586 +++++++++++++++++
 drivers/staging/rt2870/rtmp_ckipmic.h              |  113 +
 drivers/staging/rt2870/rtmp_def.h                  | 1622 ++++
 drivers/staging/rt2870/rtmp_type.h                 |   94 +
 drivers/staging/rt2870/spectrum.h                  |  322 +
 drivers/staging/rt2870/spectrum_def.h              |   95 +
 drivers/staging/rt2870/sta/aironet.c               | 1312 +++
 drivers/staging/rt2870/sta/assoc.c                 | 2039 +++++
 drivers/staging/rt2870/sta/auth.c                  |  474 ++
 drivers/staging/rt2870/sta/auth_rsp.c              |  166 +
 drivers/staging/rt2870/sta/connect.c               | 2822 +++++++
 drivers/staging/rt2870/sta/dls.c                   | 2210 +++++
 drivers/staging/rt2870/sta/rtmp_data.c             | 2619 ++++++
 drivers/staging/rt2870/sta/sanity.c                |  420 +
 drivers/staging/rt2870/sta/sync.c                  | 1753 ++++
 drivers/staging/rt2870/sta/wpa.c                   | 2107 +++++
 drivers/staging/rt2870/sta_ioctl.c                 | 7068 ++++++++++++++++
 drivers/staging/rt2870/sta_ioctl.c.patch           |   18 +
 drivers/staging/rt2870/tmp60                       | 7037 ++++++++++++++++
 drivers/staging/rt2870/tmp61                       | 7037 ++++++++++++++++
 drivers/staging/rt2870/wpa.h                       |  357 +
 drivers/staging/rtl8187se/Kconfig                  |    5 +
 drivers/staging/rtl8187se/Makefile                 |   55 +
 drivers/staging/rtl8187se/dot11d.h                 |  101 +
 drivers/staging/rtl8187se/ieee80211.h              | 1755 ++++
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |  246 +
 drivers/staging/rtl8187se/ieee80211/dot11d.h       |  102 +
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    | 1755 ++++
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |  265 +
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.h  |   86 +
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |  533 ++
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     | 1001 +++
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |  394 +
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |  301 +
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c | 1971 +++++
 .../rtl8187se/ieee80211/ieee80211_softmac.c        | 4029 +++++++++
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |  602 ++
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |  828 ++
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |  884 ++
 drivers/staging/rtl8187se/ieee80211/internal.h     |  115 +
 drivers/staging/rtl8187se/ieee80211/rtl_crypto.h   |  399 +
 drivers/staging/rtl8187se/ieee80211_crypt.h        |   86 +
 drivers/staging/rtl8187se/r8180.h                  |  761 ++
 drivers/staging/rtl8187se/r8180_93cx6.c            |  146 +
 drivers/staging/rtl8187se/r8180_93cx6.h            |   59 +
 drivers/staging/rtl8187se/r8180_core.c             | 6828 +++++++++++++++
 drivers/staging/rtl8187se/r8180_dm.c               | 1725 ++++
 drivers/staging/rtl8187se/r8180_dm.h               |   41 +
 drivers/staging/rtl8187se/r8180_gct.c              |  296 +
 drivers/staging/rtl8187se/r8180_gct.h              |   25 +
 drivers/staging/rtl8187se/r8180_hw.h               |  956 +++
 drivers/staging/rtl8187se/r8180_max2820.c          |  240 +
 drivers/staging/rtl8187se/r8180_max2820.h          |   21 +
 drivers/staging/rtl8187se/r8180_pm.c               |   90 +
 drivers/staging/rtl8187se/r8180_pm.h               |   28 +
 drivers/staging/rtl8187se/r8180_rtl8225.c          |  933 +++
 drivers/staging/rtl8187se/r8180_rtl8225.h          |   44 +
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        | 1587 ++++
 drivers/staging/rtl8187se/r8180_rtl8255.c          | 1838 +++++
 drivers/staging/rtl8187se/r8180_rtl8255.h          |   19 +
 drivers/staging/rtl8187se/r8180_sa2400.c           |  233 +
 drivers/staging/rtl8187se/r8180_sa2400.h           |   26 +
 drivers/staging/rtl8187se/r8180_wx.c               | 1644 ++++
 drivers/staging/rtl8187se/r8180_wx.h               |   21 +
 drivers/staging/rtl8187se/r8185b_init.c            | 3342 ++++++++
 drivers/staging/slicoss/slic.h                     |   34 +
 drivers/staging/slicoss/slicoss.c                  |   84 +-
 drivers/staging/sxg/README                         |    2 -
 drivers/staging/sxg/sxg.c                          |  316 +-
 drivers/staging/sxg/sxg.h                          |  121 +-
 drivers/staging/sxg/sxg_os.h                       |   24 +-
 drivers/staging/sxg/sxgdbg.h                       |   15 +-
 drivers/staging/sxg/sxghif.h                       |  139 +-
 drivers/staging/sxg/sxghw.h                        |   40 +-
 drivers/staging/sxg/sxgphycode.h                   |    2 +-
 drivers/staging/usbip/stub.h                       |    2 +-
 drivers/staging/usbip/stub_dev.c                   |    2 +-
 drivers/staging/usbip/stub_main.c                  |   21 +-
 drivers/staging/usbip/stub_rx.c                    |    9 +-
 drivers/staging/usbip/stub_tx.c                    |    1 -
 drivers/staging/usbip/vhci_hcd.c                   |    2 +-
 drivers/staging/usbip/vhci_sysfs.c                 |    2 +-
 drivers/staging/winbond/Kconfig                    |   12 +-
 drivers/staging/winbond/Makefile                   |   17 +-
 drivers/staging/winbond/adapter.h                  |   23 -
 drivers/staging/winbond/bss_f.h                    |   80 +-
 drivers/staging/winbond/bssdscpt.h                 |   20 +-
 drivers/staging/winbond/common.h                   |   27 +
 drivers/staging/winbond/core.h                     |   42 +
 drivers/staging/winbond/ds_tkip.h                  |   12 +-
 drivers/staging/winbond/gl_80211.h                 |    3 +-
 drivers/staging/winbond/linux/common.h             |  128 -
 drivers/staging/winbond/linux/sysdef.h             |   73 -
 drivers/staging/winbond/linux/wb35rx_f.h           |   17 -
 drivers/staging/winbond/linux/wb35tx_f.h           |   20 -
 drivers/staging/winbond/linux/wbusb.c              |  391 -
 drivers/staging/winbond/linux/wbusb_f.h            |   34 -
 drivers/staging/winbond/localpara.h                |   11 +-
 drivers/staging/winbond/mac_structures.h           |    7 +-
 drivers/staging/winbond/mds.c                      |  831 +-
 drivers/staging/winbond/mds_f.h                    |   42 +-
 drivers/staging/winbond/mds_s.h                    |   42 +-
 drivers/staging/winbond/mlme_mib.h                 |   20 +-
 drivers/staging/winbond/mlme_s.h                   |   11 +-
 drivers/staging/winbond/mlmetxrx.c                 |  113 +-
 drivers/staging/winbond/mlmetxrx_f.h               |   25 +-
 drivers/staging/winbond/mto.c                      |  991 +---
 drivers/staging/winbond/mto.h                      |   27 +-
 drivers/staging/winbond/mto_f.h                    |   12 +-
 drivers/staging/winbond/os_common.h                |    2 +-
 drivers/staging/winbond/phy_calibration.c          |   40 +-
 drivers/staging/winbond/phy_calibration.h          |    6 +
 drivers/staging/winbond/reg.c                      |  349 +-
 drivers/staging/winbond/rxisr.c                    |   30 -
 drivers/staging/winbond/scan_s.h                   |   22 +-
 drivers/staging/winbond/sme_api.c                  |   14 -
 drivers/staging/winbond/sme_api.h                  |    7 +-
 drivers/staging/winbond/sme_s.h                    |   16 +-
 drivers/staging/winbond/sysdef.h                   |   40 +
 drivers/staging/winbond/{linux => }/wb35reg.c      |  531 +-
 drivers/staging/winbond/{linux => }/wb35reg_f.h    |    9 +-
 drivers/staging/winbond/{linux => }/wb35reg_s.h    |   46 +-
 drivers/staging/winbond/{linux => }/wb35rx.c       |  421 +-
 drivers/staging/winbond/wb35rx_f.h                 |   15 +
 drivers/staging/winbond/{linux => }/wb35rx_s.h     |    2 +-
 drivers/staging/winbond/{linux => }/wb35tx.c       |  248 +-
 drivers/staging/winbond/wb35tx_f.h                 |   21 +
 drivers/staging/winbond/{linux => }/wb35tx_s.h     |   14 +-
 drivers/staging/winbond/wbhal.c                    |  830 +--
 drivers/staging/winbond/wbhal_f.h                  |   49 +-
 drivers/staging/winbond/wbhal_s.h                  |   33 +-
 drivers/staging/winbond/wblinux.c                  |  275 -
 drivers/staging/winbond/wblinux_f.h                |   21 +-
 drivers/staging/winbond/wblinux_s.h                |   45 -
 drivers/staging/winbond/wbusb.c                    |  438 +
 drivers/staging/winbond/{linux => }/wbusb_s.h      |   17 +-
 drivers/staging/wlan-ng/Kconfig                    |    6 +-
 drivers/staging/wlan-ng/Makefile                   |    3 +-
 drivers/staging/wlan-ng/README                     |    1 -
 drivers/staging/wlan-ng/hfa384x.c                  | 4018 ---------
 drivers/staging/wlan-ng/hfa384x.h                  | 2491 +++----
 drivers/staging/wlan-ng/hfa384x_usb.c              |  655 +--
 drivers/staging/wlan-ng/p80211conv.c               |   43 +-
 drivers/staging/wlan-ng/p80211conv.h               |   76 +-
 drivers/staging/wlan-ng/p80211hdr.h                |   90 +-
 drivers/staging/wlan-ng/p80211ioctl.h              |    6 +-
 drivers/staging/wlan-ng/p80211meta.h               |   46 +-
 drivers/staging/wlan-ng/p80211metadef.h            | 1785 +----
 drivers/staging/wlan-ng/p80211metamib.h            |    2 +-
 drivers/staging/wlan-ng/p80211metamsg.h            |    2 +-
 drivers/staging/wlan-ng/p80211metastruct.h         |  463 +-
 drivers/staging/wlan-ng/p80211mgmt.h               |  194 +-
 drivers/staging/wlan-ng/p80211mod.c                |  216 -
 drivers/staging/wlan-ng/p80211msg.h                |   14 +-
 drivers/staging/wlan-ng/p80211netdev.c             |  357 +-
 drivers/staging/wlan-ng/p80211netdev.h             |  180 +-
 drivers/staging/wlan-ng/p80211req.c                |   39 +-
 drivers/staging/wlan-ng/p80211req.h                |    2 +-
 drivers/staging/wlan-ng/p80211types.h              |  208 +-
 drivers/staging/wlan-ng/p80211wep.c                |   21 +-
 drivers/staging/wlan-ng/p80211wext.c               |  353 +-
 drivers/staging/wlan-ng/prism2_cs.c                | 1487 ----
 drivers/staging/wlan-ng/prism2_pci.c               |  332 -
 drivers/staging/wlan-ng/prism2_plx.c               |  472 --
 drivers/staging/wlan-ng/prism2mgmt.c               | 1673 +----
 drivers/staging/wlan-ng/prism2mgmt.h               |   59 +-
 drivers/staging/wlan-ng/prism2mib.c                | 2790 +------
 drivers/staging/wlan-ng/prism2sta.c                |  338 +-
 .../staging/wlan-ng/{prism2_usb.c => prism2usb.c}  |   77 +-
 drivers/staging/wlan-ng/version.h                  |   64 -
 drivers/staging/wlan-ng/wlan_compat.h              |  570 +--
 779 files changed, 472695 insertions(+), 26479 deletions(-)
 create mode 100644 drivers/staging/agnx/Kconfig
 create mode 100644 drivers/staging/agnx/Makefile
 create mode 100644 drivers/staging/agnx/TODO
 create mode 100644 drivers/staging/agnx/agnx.h
 create mode 100644 drivers/staging/agnx/debug.h
 create mode 100644 drivers/staging/agnx/pci.c
 create mode 100644 drivers/staging/agnx/phy.c
 create mode 100644 drivers/staging/agnx/phy.h
 create mode 100644 drivers/staging/agnx/rf.c
 create mode 100644 drivers/staging/agnx/sta.c
 create mode 100644 drivers/staging/agnx/sta.h
 create mode 100644 drivers/staging/agnx/table.c
 create mode 100644 drivers/staging/agnx/table.h
 create mode 100644 drivers/staging/agnx/xmit.c
 create mode 100644 drivers/staging/agnx/xmit.h
 create mode 100644 drivers/staging/altpciechdma/Kconfig
 create mode 100644 drivers/staging/altpciechdma/Makefile
 create mode 100644 drivers/staging/altpciechdma/TODO
 create mode 100644 drivers/staging/altpciechdma/altpciechdma.c
 create mode 100644 drivers/staging/android/Kconfig
 create mode 100644 drivers/staging/android/Makefile
 create mode 100644 drivers/staging/android/TODO
 create mode 100644 drivers/staging/android/binder.c
 create mode 100644 drivers/staging/android/binder.h
 create mode 100644 drivers/staging/android/logger.c
 create mode 100644 drivers/staging/android/logger.h
 create mode 100644 drivers/staging/android/lowmemorykiller.c
 create mode 100644 drivers/staging/android/ram_console.c
 create mode 100644 drivers/staging/android/timed_gpio.c
 create mode 100644 drivers/staging/android/timed_gpio.h
 create mode 100644 drivers/staging/asus_oled/Kconfig
 create mode 100644 drivers/staging/asus_oled/Makefile
 create mode 100644 drivers/staging/asus_oled/README
 create mode 100644 drivers/staging/asus_oled/TODO
 create mode 100644 drivers/staging/asus_oled/asus_oled.c
 create mode 100644 drivers/staging/asus_oled/linux.txt
 create mode 100644 drivers/staging/asus_oled/linux_f.txt
 create mode 100644 drivers/staging/asus_oled/linux_fr.txt
 create mode 100644 drivers/staging/asus_oled/tux.txt
 create mode 100644 drivers/staging/asus_oled/tux_r.txt
 create mode 100644 drivers/staging/asus_oled/tux_r2.txt
 create mode 100644 drivers/staging/asus_oled/zig.txt
 create mode 100644 drivers/staging/benet/Kconfig
 create mode 100644 drivers/staging/benet/MAINTAINERS
 create mode 100644 drivers/staging/benet/Makefile
 create mode 100644 drivers/staging/benet/TODO
 create mode 100644 drivers/staging/benet/asyncmesg.h
 create mode 100644 drivers/staging/benet/be_cm.h
 create mode 100644 drivers/staging/benet/be_common.h
 create mode 100644 drivers/staging/benet/be_ethtool.c
 create mode 100644 drivers/staging/benet/be_init.c
 create mode 100644 drivers/staging/benet/be_int.c
 create mode 100644 drivers/staging/benet/be_netif.c
 create mode 100644 drivers/staging/benet/benet.h
 create mode 100644 drivers/staging/benet/bestatus.h
 create mode 100644 drivers/staging/benet/cev.h
 create mode 100644 drivers/staging/benet/cq.c
 create mode 100644 drivers/staging/benet/descriptors.h
 create mode 100644 drivers/staging/benet/doorbells.h
 create mode 100644 drivers/staging/benet/ep.h
 create mode 100644 drivers/staging/benet/eq.c
 create mode 100644 drivers/staging/benet/eth.c
 create mode 100644 drivers/staging/benet/etx_context.h
 create mode 100644 drivers/staging/benet/funcobj.c
 create mode 100644 drivers/staging/benet/fwcmd_common.h
 create mode 100644 drivers/staging/benet/fwcmd_common_bmap.h
 create mode 100644 drivers/staging/benet/fwcmd_eth_bmap.h
 create mode 100644 drivers/staging/benet/fwcmd_hdr_bmap.h
 create mode 100644 drivers/staging/benet/fwcmd_mcc.h
 create mode 100644 drivers/staging/benet/fwcmd_opcodes.h
 create mode 100644 drivers/staging/benet/fwcmd_types_bmap.h
 create mode 100644 drivers/staging/benet/host_struct.h
 create mode 100644 drivers/staging/benet/hwlib.h
 create mode 100644 drivers/staging/benet/mpu.c
 create mode 100644 drivers/staging/benet/mpu.h
 create mode 100644 drivers/staging/benet/mpu_context.h
 create mode 100644 drivers/staging/benet/pcicfg.h
 create mode 100644 drivers/staging/benet/post_codes.h
 create mode 100644 drivers/staging/benet/regmap.h
 create mode 100644 drivers/staging/comedi/Kconfig
 create mode 100644 drivers/staging/comedi/Makefile
 create mode 100644 drivers/staging/comedi/TODO
 create mode 100644 drivers/staging/comedi/comedi.h
 create mode 100644 drivers/staging/comedi/comedi_compat32.c
 create mode 100644 drivers/staging/comedi/comedi_compat32.h
 create mode 100644 drivers/staging/comedi/comedi_fops.c
 create mode 100644 drivers/staging/comedi/comedi_fops.h
 create mode 100644 drivers/staging/comedi/comedi_ksyms.c
 create mode 100644 drivers/staging/comedi/comedi_rt.h
 create mode 100644 drivers/staging/comedi/comedidev.h
 create mode 100644 drivers/staging/comedi/comedilib.h
 create mode 100644 drivers/staging/comedi/drivers.c
 create mode 100644 drivers/staging/comedi/drivers/Makefile
 create mode 100644 drivers/staging/comedi/drivers/comedi_bond.c
 create mode 100644 drivers/staging/comedi/drivers/comedi_fc.c
 create mode 100644 drivers/staging/comedi/drivers/comedi_fc.h
 create mode 100644 drivers/staging/comedi/drivers/comedi_parport.c
 create mode 100644 drivers/staging/comedi/drivers/comedi_pci.h
 create mode 100644 drivers/staging/comedi/drivers/comedi_test.c
 create mode 100644 drivers/staging/comedi/drivers/dt9812.c
 create mode 100644 drivers/staging/comedi/drivers/icp_multi.c
 create mode 100644 drivers/staging/comedi/drivers/icp_multi.h
 create mode 100644 drivers/staging/comedi/drivers/me4000.c
 create mode 100644 drivers/staging/comedi/drivers/me4000.h
 create mode 100644 drivers/staging/comedi/drivers/me_daq.c
 create mode 100644 drivers/staging/comedi/drivers/mite.c
 create mode 100644 drivers/staging/comedi/drivers/mite.h
 create mode 100644 drivers/staging/comedi/drivers/plx9080.h
 create mode 100644 drivers/staging/comedi/drivers/rtd520.c
 create mode 100644 drivers/staging/comedi/drivers/rtd520.h
 create mode 100644 drivers/staging/comedi/drivers/s626.c
 create mode 100644 drivers/staging/comedi/drivers/s626.h
 create mode 100644 drivers/staging/comedi/drivers/usbdux.c
 create mode 100644 drivers/staging/comedi/drivers/usbduxfast.c
 create mode 100644 drivers/staging/comedi/interrupt.h
 create mode 100644 drivers/staging/comedi/kcomedilib/Makefile
 create mode 100644 drivers/staging/comedi/kcomedilib/data.c
 create mode 100644 drivers/staging/comedi/kcomedilib/dio.c
 create mode 100644 drivers/staging/comedi/kcomedilib/get.c
 create mode 100644 drivers/staging/comedi/kcomedilib/kcomedilib_main.c
 create mode 100644 drivers/staging/comedi/kcomedilib/ksyms.c
 create mode 100644 drivers/staging/comedi/pci_ids.h
 create mode 100644 drivers/staging/comedi/proc.c
 create mode 100644 drivers/staging/comedi/range.c
 create mode 100644 drivers/staging/comedi/rt.c
 create mode 100644 drivers/staging/comedi/rt_pend_tq.c
 create mode 100644 drivers/staging/comedi/rt_pend_tq.h
 create mode 100644 drivers/staging/comedi/wrapper.h
 create mode 100644 drivers/staging/epl/Benchmark.h
 create mode 100644 drivers/staging/epl/Debug.h
 create mode 100644 drivers/staging/epl/Edrv8139.c
 create mode 100644 drivers/staging/epl/EdrvFec.h
 create mode 100644 drivers/staging/epl/EdrvFec5282.h
 create mode 100644 drivers/staging/epl/EdrvSim.h
 create mode 100644 drivers/staging/epl/Epl.h
 create mode 100644 drivers/staging/epl/EplAmi.h
 create mode 100644 drivers/staging/epl/EplApiGeneric.c
 create mode 100644 drivers/staging/epl/EplApiLinux.h
 create mode 100644 drivers/staging/epl/EplApiLinuxKernel.c
 create mode 100644 drivers/staging/epl/EplApiProcessImage.c
 create mode 100644 drivers/staging/epl/EplCfg.h
 create mode 100644 drivers/staging/epl/EplDef.h
 create mode 100644 drivers/staging/epl/EplDll.h
 create mode 100644 drivers/staging/epl/EplDllCal.h
 create mode 100644 drivers/staging/epl/EplDllk.c
 create mode 100644 drivers/staging/epl/EplDllkCal.c
 create mode 100644 drivers/staging/epl/EplDlluCal.c
 create mode 100644 drivers/staging/epl/EplErrDef.h
 create mode 100644 drivers/staging/epl/EplErrorHandlerk.c
 create mode 100644 drivers/staging/epl/EplEvent.h
 create mode 100644 drivers/staging/epl/EplEventk.c
 create mode 100644 drivers/staging/epl/EplEventu.c
 create mode 100644 drivers/staging/epl/EplFrame.h
 create mode 100644 drivers/staging/epl/EplIdentu.c
 create mode 100644 drivers/staging/epl/EplInc.h
 create mode 100644 drivers/staging/epl/EplInstDef.h
 create mode 100644 drivers/staging/epl/EplLed.h
 create mode 100644 drivers/staging/epl/EplNmt.h
 create mode 100644 drivers/staging/epl/EplNmtCnu.c
 create mode 100644 drivers/staging/epl/EplNmtMnu.c
 create mode 100644 drivers/staging/epl/EplNmtk.c
 create mode 100644 drivers/staging/epl/EplNmtkCal.c
 create mode 100644 drivers/staging/epl/EplNmtu.c
 create mode 100644 drivers/staging/epl/EplNmtuCal.c
 create mode 100644 drivers/staging/epl/EplObd.c
 create mode 100644 drivers/staging/epl/EplObd.h
 create mode 100644 drivers/staging/epl/EplObdMacro.h
 create mode 100644 drivers/staging/epl/EplObdkCal.c
 create mode 100644 drivers/staging/epl/EplObdu.c
 create mode 100644 drivers/staging/epl/EplObduCal.c
 create mode 100644 drivers/staging/epl/EplObjDef.h
 create mode 100644 drivers/staging/epl/EplPdo.h
 create mode 100644 drivers/staging/epl/EplPdok.c
 create mode 100644 drivers/staging/epl/EplPdokCal.c
 create mode 100644 drivers/staging/epl/EplPdou.c
 create mode 100644 drivers/staging/epl/EplSdo.h
 create mode 100644 drivers/staging/epl/EplSdoAc.h
 create mode 100644 drivers/staging/epl/EplSdoAsndu.c
 create mode 100644 drivers/staging/epl/EplSdoAsySequ.c
 create mode 100644 drivers/staging/epl/EplSdoComu.c
 create mode 100644 drivers/staging/epl/EplSdoUdpu.c
 create mode 100644 drivers/staging/epl/EplStatusu.c
 create mode 100644 drivers/staging/epl/EplTarget.h
 create mode 100644 drivers/staging/epl/EplTimer.h
 create mode 100644 drivers/staging/epl/EplTimeruLinuxKernel.c
 create mode 100644 drivers/staging/epl/EplTimeruNull.c
 create mode 100644 drivers/staging/epl/EplTimeruWin32.c
 create mode 100644 drivers/staging/epl/EplVersion.h
 create mode 100644 drivers/staging/epl/Kconfig
 create mode 100644 drivers/staging/epl/Makefile
 create mode 100644 drivers/staging/epl/SharedBuff.c
 create mode 100644 drivers/staging/epl/SharedBuff.h
 create mode 100644 drivers/staging/epl/ShbIpc-LinuxKernel.c
 create mode 100644 drivers/staging/epl/ShbIpc-Win32.c
 create mode 100644 drivers/staging/epl/ShbIpc.h
 create mode 100644 drivers/staging/epl/ShbLinuxKernel.h
 create mode 100644 drivers/staging/epl/SocketLinuxKernel.c
 create mode 100644 drivers/staging/epl/SocketLinuxKernel.h
 create mode 100644 drivers/staging/epl/TimerHighReskX86.c
 create mode 100644 drivers/staging/epl/VirtualEthernetLinux.c
 create mode 100644 drivers/staging/epl/amix86.c
 create mode 100644 drivers/staging/epl/demo_main.c
 create mode 100644 drivers/staging/epl/edrv.h
 create mode 100644 drivers/staging/epl/global.h
 create mode 100644 drivers/staging/epl/kernel/EplDllk.h
 create mode 100644 drivers/staging/epl/kernel/EplDllkCal.h
 create mode 100644 drivers/staging/epl/kernel/EplErrorHandlerk.h
 create mode 100644 drivers/staging/epl/kernel/EplEventk.h
 create mode 100644 drivers/staging/epl/kernel/EplNmtk.h
 create mode 100644 drivers/staging/epl/kernel/EplNmtkCal.h
 create mode 100644 drivers/staging/epl/kernel/EplObdk.h
 create mode 100644 drivers/staging/epl/kernel/EplObdkCal.h
 create mode 100644 drivers/staging/epl/kernel/EplPdok.h
 create mode 100644 drivers/staging/epl/kernel/EplPdokCal.h
 create mode 100644 drivers/staging/epl/kernel/EplTimerHighResk.h
 create mode 100644 drivers/staging/epl/kernel/EplTimerk.h
 create mode 100644 drivers/staging/epl/kernel/VirtualEthernet.h
 create mode 100644 drivers/staging/epl/proc_fs.c
 create mode 100644 drivers/staging/epl/proc_fs.h
 create mode 100644 drivers/staging/epl/user/EplCfgMau.h
 create mode 100644 drivers/staging/epl/user/EplDllu.h
 create mode 100644 drivers/staging/epl/user/EplDlluCal.h
 create mode 100644 drivers/staging/epl/user/EplEventu.h
 create mode 100644 drivers/staging/epl/user/EplIdentu.h
 create mode 100644 drivers/staging/epl/user/EplLedu.h
 create mode 100644 drivers/staging/epl/user/EplNmtCnu.h
 create mode 100644 drivers/staging/epl/user/EplNmtMnu.h
 create mode 100644 drivers/staging/epl/user/EplNmtu.h
 create mode 100644 drivers/staging/epl/user/EplNmtuCal.h
 create mode 100644 drivers/staging/epl/user/EplObdu.h
 create mode 100644 drivers/staging/epl/user/EplObduCal.h
 create mode 100644 drivers/staging/epl/user/EplPdou.h
 create mode 100644 drivers/staging/epl/user/EplSdoAsndu.h
 create mode 100644 drivers/staging/epl/user/EplSdoAsySequ.h
 create mode 100644 drivers/staging/epl/user/EplSdoComu.h
 create mode 100644 drivers/staging/epl/user/EplSdoUdpu.h
 create mode 100644 drivers/staging/epl/user/EplStatusu.h
 create mode 100644 drivers/staging/epl/user/EplTimeru.h
 create mode 100644 drivers/staging/frontier/Kconfig
 create mode 100644 drivers/staging/frontier/Makefile
 create mode 100644 drivers/staging/frontier/README
 create mode 100644 drivers/staging/frontier/TODO
 create mode 100644 drivers/staging/frontier/alphatrack.c
 create mode 100644 drivers/staging/frontier/alphatrack.h
 create mode 100644 drivers/staging/frontier/frontier_compat.h
 create mode 100644 drivers/staging/frontier/surface_sysfs.h
 create mode 100644 drivers/staging/frontier/tranzport.c
 create mode 100644 drivers/staging/go7007/go7007.txt
 create mode 100644 drivers/staging/go7007/s2250-board.c
 create mode 100644 drivers/staging/go7007/s2250-loader.c
 create mode 100644 drivers/staging/meilhaus/Kconfig
 create mode 100644 drivers/staging/meilhaus/Makefile
 create mode 100644 drivers/staging/meilhaus/TODO
 create mode 100644 drivers/staging/meilhaus/me0600_device.c
 create mode 100644 drivers/staging/meilhaus/me0600_device.h
 create mode 100644 drivers/staging/meilhaus/me0600_dio.c
 create mode 100644 drivers/staging/meilhaus/me0600_dio.h
 create mode 100644 drivers/staging/meilhaus/me0600_dio_reg.h
 create mode 100644 drivers/staging/meilhaus/me0600_ext_irq.c
 create mode 100644 drivers/staging/meilhaus/me0600_ext_irq.h
 create mode 100644 drivers/staging/meilhaus/me0600_ext_irq_reg.h
 create mode 100644 drivers/staging/meilhaus/me0600_optoi.c
 create mode 100644 drivers/staging/meilhaus/me0600_optoi.h
 create mode 100644 drivers/staging/meilhaus/me0600_optoi_reg.h
 create mode 100644 drivers/staging/meilhaus/me0600_relay.c
 create mode 100644 drivers/staging/meilhaus/me0600_relay.h
 create mode 100644 drivers/staging/meilhaus/me0600_relay_reg.h
 create mode 100644 drivers/staging/meilhaus/me0600_ttli.c
 create mode 100644 drivers/staging/meilhaus/me0600_ttli.h
 create mode 100644 drivers/staging/meilhaus/me0600_ttli_reg.h
 create mode 100644 drivers/staging/meilhaus/me0900_device.c
 create mode 100644 drivers/staging/meilhaus/me0900_device.h
 create mode 100644 drivers/staging/meilhaus/me0900_di.c
 create mode 100644 drivers/staging/meilhaus/me0900_di.h
 create mode 100644 drivers/staging/meilhaus/me0900_do.c
 create mode 100644 drivers/staging/meilhaus/me0900_do.h
 create mode 100644 drivers/staging/meilhaus/me0900_reg.h
 create mode 100644 drivers/staging/meilhaus/me1000_device.c
 create mode 100644 drivers/staging/meilhaus/me1000_device.h
 create mode 100644 drivers/staging/meilhaus/me1000_dio.c
 create mode 100644 drivers/staging/meilhaus/me1000_dio.h
 create mode 100644 drivers/staging/meilhaus/me1000_dio_reg.h
 create mode 100644 drivers/staging/meilhaus/me1400_device.c
 create mode 100644 drivers/staging/meilhaus/me1400_device.h
 create mode 100644 drivers/staging/meilhaus/me1400_ext_irq.c
 create mode 100644 drivers/staging/meilhaus/me1400_ext_irq.h
 create mode 100644 drivers/staging/meilhaus/me1400_ext_irq_reg.h
 create mode 100644 drivers/staging/meilhaus/me1600_ao.c
 create mode 100644 drivers/staging/meilhaus/me1600_ao.h
 create mode 100644 drivers/staging/meilhaus/me1600_ao_reg.h
 create mode 100644 drivers/staging/meilhaus/me1600_device.c
 create mode 100644 drivers/staging/meilhaus/me1600_device.h
 create mode 100644 drivers/staging/meilhaus/me4600_ai.c
 create mode 100644 drivers/staging/meilhaus/me4600_ai.h
 create mode 100644 drivers/staging/meilhaus/me4600_ai_reg.h
 create mode 100644 drivers/staging/meilhaus/me4600_ao.c
 create mode 100644 drivers/staging/meilhaus/me4600_ao.h
 create mode 100644 drivers/staging/meilhaus/me4600_ao_reg.h
 create mode 100644 drivers/staging/meilhaus/me4600_device.c
 create mode 100644 drivers/staging/meilhaus/me4600_device.h
 create mode 100644 drivers/staging/meilhaus/me4600_di.c
 create mode 100644 drivers/staging/meilhaus/me4600_di.h
 create mode 100644 drivers/staging/meilhaus/me4600_dio.c
 create mode 100644 drivers/staging/meilhaus/me4600_dio.h
 create mode 100644 drivers/staging/meilhaus/me4600_dio_reg.h
 create mode 100644 drivers/staging/meilhaus/me4600_do.c
 create mode 100644 drivers/staging/meilhaus/me4600_do.h
 create mode 100644 drivers/staging/meilhaus/me4600_ext_irq.c
 create mode 100644 drivers/staging/meilhaus/me4600_ext_irq.h
 create mode 100644 drivers/staging/meilhaus/me4600_ext_irq_reg.h
 create mode 100644 drivers/staging/meilhaus/me4600_reg.h
 create mode 100644 drivers/staging/meilhaus/me6000_ao.c
 create mode 100644 drivers/staging/meilhaus/me6000_ao.h
 create mode 100644 drivers/staging/meilhaus/me6000_ao_reg.h
 create mode 100644 drivers/staging/meilhaus/me6000_device.c
 create mode 100644 drivers/staging/meilhaus/me6000_device.h
 create mode 100644 drivers/staging/meilhaus/me6000_dio.c
 create mode 100644 drivers/staging/meilhaus/me6000_dio.h
 create mode 100644 drivers/staging/meilhaus/me6000_dio_reg.h
 create mode 100644 drivers/staging/meilhaus/me6000_reg.h
 create mode 100644 drivers/staging/meilhaus/me8100_device.c
 create mode 100644 drivers/staging/meilhaus/me8100_device.h
 create mode 100644 drivers/staging/meilhaus/me8100_di.c
 create mode 100644 drivers/staging/meilhaus/me8100_di.h
 create mode 100644 drivers/staging/meilhaus/me8100_di_reg.h
 create mode 100644 drivers/staging/meilhaus/me8100_do.c
 create mode 100644 drivers/staging/meilhaus/me8100_do.h
 create mode 100644 drivers/staging/meilhaus/me8100_do_reg.h
 create mode 100644 drivers/staging/meilhaus/me8100_reg.h
 create mode 100644 drivers/staging/meilhaus/me8200_device.c
 create mode 100644 drivers/staging/meilhaus/me8200_device.h
 create mode 100644 drivers/staging/meilhaus/me8200_di.c
 create mode 100644 drivers/staging/meilhaus/me8200_di.h
 create mode 100644 drivers/staging/meilhaus/me8200_di_reg.h
 create mode 100644 drivers/staging/meilhaus/me8200_dio.c
 create mode 100644 drivers/staging/meilhaus/me8200_dio.h
 create mode 100644 drivers/staging/meilhaus/me8200_dio_reg.h
 create mode 100644 drivers/staging/meilhaus/me8200_do.c
 create mode 100644 drivers/staging/meilhaus/me8200_do.h
 create mode 100644 drivers/staging/meilhaus/me8200_do_reg.h
 create mode 100644 drivers/staging/meilhaus/me8200_reg.h
 create mode 100644 drivers/staging/meilhaus/me8254.c
 create mode 100644 drivers/staging/meilhaus/me8254.h
 create mode 100644 drivers/staging/meilhaus/me8254_reg.h
 create mode 100644 drivers/staging/meilhaus/me8255.c
 create mode 100644 drivers/staging/meilhaus/me8255.h
 create mode 100644 drivers/staging/meilhaus/me8255_reg.h
 create mode 100644 drivers/staging/meilhaus/mecirc_buf.h
 create mode 100644 drivers/staging/meilhaus/mecommon.h
 create mode 100644 drivers/staging/meilhaus/medebug.h
 create mode 100644 drivers/staging/meilhaus/medefines.h
 create mode 100644 drivers/staging/meilhaus/medevice.c
 create mode 100644 drivers/staging/meilhaus/medevice.h
 create mode 100644 drivers/staging/meilhaus/medlist.c
 create mode 100644 drivers/staging/meilhaus/medlist.h
 create mode 100644 drivers/staging/meilhaus/medlock.c
 create mode 100644 drivers/staging/meilhaus/medlock.h
 create mode 100644 drivers/staging/meilhaus/medriver.h
 create mode 100644 drivers/staging/meilhaus/medummy.c
 create mode 100644 drivers/staging/meilhaus/medummy.h
 create mode 100644 drivers/staging/meilhaus/meerror.h
 create mode 100644 drivers/staging/meilhaus/mefirmware.c
 create mode 100644 drivers/staging/meilhaus/mefirmware.h
 create mode 100644 drivers/staging/meilhaus/meids.h
 create mode 100644 drivers/staging/meilhaus/meinternal.h
 create mode 100644 drivers/staging/meilhaus/meioctl.h
 create mode 100644 drivers/staging/meilhaus/memain.c
 create mode 100644 drivers/staging/meilhaus/memain.h
 create mode 100644 drivers/staging/meilhaus/meplx_reg.h
 create mode 100644 drivers/staging/meilhaus/meslist.c
 create mode 100644 drivers/staging/meilhaus/meslist.h
 create mode 100644 drivers/staging/meilhaus/meslock.c
 create mode 100644 drivers/staging/meilhaus/meslock.h
 create mode 100644 drivers/staging/meilhaus/mesubdevice.c
 create mode 100644 drivers/staging/meilhaus/mesubdevice.h
 create mode 100644 drivers/staging/meilhaus/metempl_device.c
 create mode 100644 drivers/staging/meilhaus/metempl_device.h
 create mode 100644 drivers/staging/meilhaus/metempl_sub.c
 create mode 100644 drivers/staging/meilhaus/metempl_sub.h
 create mode 100644 drivers/staging/meilhaus/metempl_sub_reg.h
 create mode 100644 drivers/staging/meilhaus/metypes.h
 create mode 100644 drivers/staging/mimio/Kconfig
 create mode 100644 drivers/staging/mimio/Makefile
 create mode 100644 drivers/staging/mimio/mimio.c
 create mode 100644 drivers/staging/otus/80211core/amsdu.c
 create mode 100644 drivers/staging/otus/80211core/cagg.c
 create mode 100644 drivers/staging/otus/80211core/cagg.h
 create mode 100644 drivers/staging/otus/80211core/ccmd.c
 create mode 100644 drivers/staging/otus/80211core/cfunc.c
 create mode 100644 drivers/staging/otus/80211core/cfunc.h
 create mode 100644 drivers/staging/otus/80211core/chb.c
 create mode 100644 drivers/staging/otus/80211core/cic.c
 create mode 100644 drivers/staging/otus/80211core/cinit.c
 create mode 100644 drivers/staging/otus/80211core/cmm.c
 create mode 100644 drivers/staging/otus/80211core/cmmap.c
 create mode 100644 drivers/staging/otus/80211core/cmmsta.c
 create mode 100644 drivers/staging/otus/80211core/coid.c
 create mode 100644 drivers/staging/otus/80211core/cprecomp.h
 create mode 100644 drivers/staging/otus/80211core/cpsmgr.c
 create mode 100644 drivers/staging/otus/80211core/cscanmgr.c
 create mode 100644 drivers/staging/otus/80211core/ctkip.c
 create mode 100644 drivers/staging/otus/80211core/ctxrx.c
 create mode 100644 drivers/staging/otus/80211core/cwep.c
 create mode 100644 drivers/staging/otus/80211core/cwm.c
 create mode 100644 drivers/staging/otus/80211core/cwm.h
 create mode 100644 drivers/staging/otus/80211core/freqctrl.c
 create mode 100644 drivers/staging/otus/80211core/ledmgr.c
 create mode 100644 drivers/staging/otus/80211core/performance.c
 create mode 100644 drivers/staging/otus/80211core/performance.h
 create mode 100644 drivers/staging/otus/80211core/pub_usb.h
 create mode 100644 drivers/staging/otus/80211core/pub_zfi.h
 create mode 100644 drivers/staging/otus/80211core/pub_zfw.h
 create mode 100644 drivers/staging/otus/80211core/queue.c
 create mode 100644 drivers/staging/otus/80211core/queue.h
 create mode 100644 drivers/staging/otus/80211core/ratectrl.c
 create mode 100644 drivers/staging/otus/80211core/ratectrl.h
 create mode 100644 drivers/staging/otus/80211core/struct.h
 create mode 100644 drivers/staging/otus/80211core/wlan.h
 create mode 100644 drivers/staging/otus/Kconfig
 create mode 100644 drivers/staging/otus/Makefile
 create mode 100644 drivers/staging/otus/TODO
 create mode 100644 drivers/staging/otus/apdbg.c
 create mode 100644 drivers/staging/otus/athr_common.h
 create mode 100644 drivers/staging/otus/hal/hpDKfwu.c
 create mode 100644 drivers/staging/otus/hal/hpani.c
 create mode 100644 drivers/staging/otus/hal/hpani.h
 create mode 100644 drivers/staging/otus/hal/hpfw2.c
 create mode 100644 drivers/staging/otus/hal/hpfwbu.c
 create mode 100644 drivers/staging/otus/hal/hpfwspiu.c
 create mode 100644 drivers/staging/otus/hal/hpfwu.c
 create mode 100644 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend
 create mode 100644 drivers/staging/otus/hal/hpfwu_2k.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_BA.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_FB50_mdk.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_OTUS_RC.c
 create mode 100644 drivers/staging/otus/hal/hpfwu_txstream.c
 create mode 100644 drivers/staging/otus/hal/hpfwuinit.c
 create mode 100644 drivers/staging/otus/hal/hpmain.c
 create mode 100644 drivers/staging/otus/hal/hpreg.c
 create mode 100644 drivers/staging/otus/hal/hpreg.h
 create mode 100644 drivers/staging/otus/hal/hprw.c
 create mode 100644 drivers/staging/otus/hal/hpusb.c
 create mode 100644 drivers/staging/otus/hal/hpusb.h
 create mode 100644 drivers/staging/otus/hal/otus.ini
 create mode 100644 drivers/staging/otus/ioctl.c
 create mode 100644 drivers/staging/otus/oal_dt.h
 create mode 100644 drivers/staging/otus/oal_marc.h
 create mode 100644 drivers/staging/otus/usbdrv.c
 create mode 100644 drivers/staging/otus/usbdrv.h
 create mode 100644 drivers/staging/otus/wrap_buf.c
 create mode 100644 drivers/staging/otus/wrap_dbg.c
 create mode 100644 drivers/staging/otus/wrap_ev.c
 create mode 100644 drivers/staging/otus/wrap_mem.c
 create mode 100644 drivers/staging/otus/wrap_mis.c
 create mode 100644 drivers/staging/otus/wrap_pkt.c
 create mode 100644 drivers/staging/otus/wrap_sec.c
 create mode 100644 drivers/staging/otus/wrap_usb.c
 create mode 100644 drivers/staging/otus/wwrap.c
 create mode 100644 drivers/staging/otus/zdcompat.h
 create mode 100644 drivers/staging/otus/zdusb.c
 create mode 100644 drivers/staging/otus/zdusb.h
 create mode 100644 drivers/staging/panel/Kconfig
 create mode 100644 drivers/staging/panel/Makefile
 create mode 100644 drivers/staging/panel/TODO
 create mode 100644 drivers/staging/panel/lcd-panel-cgram.txt
 create mode 100644 drivers/staging/panel/panel.c
 create mode 100644 drivers/staging/rspiusb/Kconfig
 create mode 100644 drivers/staging/rspiusb/Makefile
 create mode 100644 drivers/staging/rspiusb/TODO
 create mode 100644 drivers/staging/rspiusb/rspiusb.c
 create mode 100644 drivers/staging/rspiusb/rspiusb.h
 create mode 100644 drivers/staging/rt2860/2860_main_dev.c
 create mode 100644 drivers/staging/rt2860/Kconfig
 create mode 100644 drivers/staging/rt2860/Makefile
 create mode 100644 drivers/staging/rt2860/TODO
 create mode 100644 drivers/staging/rt2860/aironet.h
 create mode 100644 drivers/staging/rt2860/ap.h
 create mode 100644 drivers/staging/rt2860/chlist.h
 create mode 100644 drivers/staging/rt2860/common/2860_rtmp_init.c
 create mode 100644 drivers/staging/rt2860/common/action.c
 create mode 100644 drivers/staging/rt2860/common/action.h
 create mode 100644 drivers/staging/rt2860/common/ba_action.c
 create mode 100644 drivers/staging/rt2860/common/cmm_data.c
 create mode 100644 drivers/staging/rt2860/common/cmm_data_2860.c
 create mode 100644 drivers/staging/rt2860/common/cmm_info.c
 create mode 100644 drivers/staging/rt2860/common/cmm_sanity.c
 create mode 100644 drivers/staging/rt2860/common/cmm_sync.c
 create mode 100644 drivers/staging/rt2860/common/cmm_wpa.c
 create mode 100644 drivers/staging/rt2860/common/dfs.c
 create mode 100644 drivers/staging/rt2860/common/eeprom.c
 create mode 100644 drivers/staging/rt2860/common/firmware.h
 create mode 100644 drivers/staging/rt2860/common/md5.c
 create mode 100644 drivers/staging/rt2860/common/mlme.c
 create mode 100644 drivers/staging/rt2860/common/netif_block.c
 create mode 100644 drivers/staging/rt2860/common/netif_block.h
 create mode 100644 drivers/staging/rt2860/common/rtmp_init.c
 create mode 100644 drivers/staging/rt2860/common/rtmp_tkip.c
 create mode 100644 drivers/staging/rt2860/common/rtmp_wep.c
 create mode 100644 drivers/staging/rt2860/common/spectrum.c
 create mode 100644 drivers/staging/rt2860/config.mk
 create mode 100644 drivers/staging/rt2860/dfs.h
 create mode 100644 drivers/staging/rt2860/leap.h
 create mode 100644 drivers/staging/rt2860/link_list.h
 create mode 100644 drivers/staging/rt2860/md4.h
 create mode 100644 drivers/staging/rt2860/md5.h
 create mode 100644 drivers/staging/rt2860/mlme.h
 create mode 100644 drivers/staging/rt2860/oid.h
 create mode 100644 drivers/staging/rt2860/rt2860.h
 create mode 100644 drivers/staging/rt2860/rt28xx.h
 create mode 100644 drivers/staging/rt2860/rt_ate.c
 create mode 100644 drivers/staging/rt2860/rt_ate.h
 create mode 100644 drivers/staging/rt2860/rt_config.h
 create mode 100644 drivers/staging/rt2860/rt_linux.c
 create mode 100644 drivers/staging/rt2860/rt_linux.h
 create mode 100644 drivers/staging/rt2860/rt_main_dev.c
 create mode 100644 drivers/staging/rt2860/rt_profile.c
 create mode 100644 drivers/staging/rt2860/rtmp.h
 create mode 100644 drivers/staging/rt2860/rtmp_ckipmic.h
 create mode 100644 drivers/staging/rt2860/rtmp_def.h
 create mode 100644 drivers/staging/rt2860/rtmp_type.h
 create mode 100644 drivers/staging/rt2860/spectrum.h
 create mode 100644 drivers/staging/rt2860/spectrum_def.h
 create mode 100644 drivers/staging/rt2860/sta/aironet.c
 create mode 100644 drivers/staging/rt2860/sta/assoc.c
 create mode 100644 drivers/staging/rt2860/sta/auth.c
 create mode 100644 drivers/staging/rt2860/sta/auth_rsp.c
 create mode 100644 drivers/staging/rt2860/sta/connect.c
 create mode 100644 drivers/staging/rt2860/sta/dls.c
 create mode 100644 drivers/staging/rt2860/sta/rtmp_data.c
 create mode 100644 drivers/staging/rt2860/sta/sanity.c
 create mode 100644 drivers/staging/rt2860/sta/sync.c
 create mode 100644 drivers/staging/rt2860/sta/wpa.c
 create mode 100644 drivers/staging/rt2860/sta_ioctl.c
 create mode 100644 drivers/staging/rt2860/wpa.h
 create mode 100644 drivers/staging/rt2870/2870_main_dev.c
 create mode 100644 drivers/staging/rt2870/Kconfig
 create mode 100644 drivers/staging/rt2870/Makefile
 create mode 100644 drivers/staging/rt2870/TODO
 create mode 100644 drivers/staging/rt2870/aironet.h
 create mode 100644 drivers/staging/rt2870/ap.h
 create mode 100644 drivers/staging/rt2870/chlist.h
 create mode 100644 drivers/staging/rt2870/common/2870_rtmp_init.c
 create mode 100644 drivers/staging/rt2870/common/action.c
 create mode 100644 drivers/staging/rt2870/common/action.h
 create mode 100644 drivers/staging/rt2870/common/ba_action.c
 create mode 100644 drivers/staging/rt2870/common/cmm_data.c
 create mode 100644 drivers/staging/rt2870/common/cmm_data_2870.c
 create mode 100644 drivers/staging/rt2870/common/cmm_info.c
 create mode 100644 drivers/staging/rt2870/common/cmm_sanity.c
 create mode 100644 drivers/staging/rt2870/common/cmm_sync.c
 create mode 100644 drivers/staging/rt2870/common/cmm_wpa.c
 create mode 100644 drivers/staging/rt2870/common/dfs.c
 create mode 100644 drivers/staging/rt2870/common/eeprom.c
 create mode 100644 drivers/staging/rt2870/common/firmware.h
 create mode 100644 drivers/staging/rt2870/common/md5.c
 create mode 100644 drivers/staging/rt2870/common/mlme.c
 create mode 100644 drivers/staging/rt2870/common/netif_block.c
 create mode 100644 drivers/staging/rt2870/common/rtmp_init.c
 create mode 100644 drivers/staging/rt2870/common/rtmp_tkip.c
 create mode 100644 drivers/staging/rt2870/common/rtmp_wep.c
 create mode 100644 drivers/staging/rt2870/common/rtusb_bulk.c
 create mode 100644 drivers/staging/rt2870/common/rtusb_data.c
 create mode 100644 drivers/staging/rt2870/common/rtusb_io.c
 create mode 100644 drivers/staging/rt2870/common/spectrum.c
 create mode 100644 drivers/staging/rt2870/dfs.h
 create mode 100644 drivers/staging/rt2870/leap.h
 create mode 100644 drivers/staging/rt2870/link_list.h
 create mode 100644 drivers/staging/rt2870/md4.h
 create mode 100644 drivers/staging/rt2870/md5.h
 create mode 100644 drivers/staging/rt2870/mlme.h
 create mode 100644 drivers/staging/rt2870/netif_block.h
 create mode 100644 drivers/staging/rt2870/oid.h
 create mode 100644 drivers/staging/rt2870/rt2870.h
 create mode 100644 drivers/staging/rt2870/rt28xx.h
 create mode 100644 drivers/staging/rt2870/rt_ate.c
 create mode 100644 drivers/staging/rt2870/rt_ate.h
 create mode 100644 drivers/staging/rt2870/rt_config.h
 create mode 100644 drivers/staging/rt2870/rt_linux.c
 create mode 100644 drivers/staging/rt2870/rt_linux.h
 create mode 100644 drivers/staging/rt2870/rt_main_dev.c
 create mode 100644 drivers/staging/rt2870/rt_profile.c
 create mode 100644 drivers/staging/rt2870/rtmp.h
 create mode 100644 drivers/staging/rt2870/rtmp_ckipmic.h
 create mode 100644 drivers/staging/rt2870/rtmp_def.h
 create mode 100644 drivers/staging/rt2870/rtmp_type.h
 create mode 100644 drivers/staging/rt2870/spectrum.h
 create mode 100644 drivers/staging/rt2870/spectrum_def.h
 create mode 100644 drivers/staging/rt2870/sta/aironet.c
 create mode 100644 drivers/staging/rt2870/sta/assoc.c
 create mode 100644 drivers/staging/rt2870/sta/auth.c
 create mode 100644 drivers/staging/rt2870/sta/auth_rsp.c
 create mode 100644 drivers/staging/rt2870/sta/connect.c
 create mode 100644 drivers/staging/rt2870/sta/dls.c
 create mode 100644 drivers/staging/rt2870/sta/rtmp_data.c
 create mode 100644 drivers/staging/rt2870/sta/sanity.c
 create mode 100644 drivers/staging/rt2870/sta/sync.c
 create mode 100644 drivers/staging/rt2870/sta/wpa.c
 create mode 100644 drivers/staging/rt2870/sta_ioctl.c
 create mode 100644 drivers/staging/rt2870/sta_ioctl.c.patch
 create mode 100644 drivers/staging/rt2870/tmp60
 create mode 100644 drivers/staging/rt2870/tmp61
 create mode 100644 drivers/staging/rt2870/wpa.h
 create mode 100644 drivers/staging/rtl8187se/Kconfig
 create mode 100644 drivers/staging/rtl8187se/Makefile
 create mode 100644 drivers/staging/rtl8187se/dot11d.h
 create mode 100644 drivers/staging/rtl8187se/ieee80211.h
 create mode 100644 drivers/staging/rtl8187se/ieee80211/dot11d.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/dot11d.h
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211.h
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
 create mode 100644 drivers/staging/rtl8187se/ieee80211/internal.h
 create mode 100644 drivers/staging/rtl8187se/ieee80211/rtl_crypto.h
 create mode 100644 drivers/staging/rtl8187se/ieee80211_crypt.h
 create mode 100644 drivers/staging/rtl8187se/r8180.h
 create mode 100644 drivers/staging/rtl8187se/r8180_93cx6.c
 create mode 100644 drivers/staging/rtl8187se/r8180_93cx6.h
 create mode 100644 drivers/staging/rtl8187se/r8180_core.c
 create mode 100644 drivers/staging/rtl8187se/r8180_dm.c
 create mode 100644 drivers/staging/rtl8187se/r8180_dm.h
 create mode 100644 drivers/staging/rtl8187se/r8180_gct.c
 create mode 100644 drivers/staging/rtl8187se/r8180_gct.h
 create mode 100644 drivers/staging/rtl8187se/r8180_hw.h
 create mode 100644 drivers/staging/rtl8187se/r8180_max2820.c
 create mode 100644 drivers/staging/rtl8187se/r8180_max2820.h
 create mode 100644 drivers/staging/rtl8187se/r8180_pm.c
 create mode 100644 drivers/staging/rtl8187se/r8180_pm.h
 create mode 100644 drivers/staging/rtl8187se/r8180_rtl8225.c
 create mode 100644 drivers/staging/rtl8187se/r8180_rtl8225.h
 create mode 100644 drivers/staging/rtl8187se/r8180_rtl8225z2.c
 create mode 100644 drivers/staging/rtl8187se/r8180_rtl8255.c
 create mode 100644 drivers/staging/rtl8187se/r8180_rtl8255.h
 create mode 100644 drivers/staging/rtl8187se/r8180_sa2400.c
 create mode 100644 drivers/staging/rtl8187se/r8180_sa2400.h
 create mode 100644 drivers/staging/rtl8187se/r8180_wx.c
 create mode 100644 drivers/staging/rtl8187se/r8180_wx.h
 create mode 100644 drivers/staging/rtl8187se/r8185b_init.c
 delete mode 100644 drivers/staging/winbond/adapter.h
 create mode 100644 drivers/staging/winbond/common.h
 create mode 100644 drivers/staging/winbond/core.h
 delete mode 100644 drivers/staging/winbond/linux/common.h
 delete mode 100644 drivers/staging/winbond/linux/sysdef.h
 delete mode 100644 drivers/staging/winbond/linux/wb35rx_f.h
 delete mode 100644 drivers/staging/winbond/linux/wb35tx_f.h
 delete mode 100644 drivers/staging/winbond/linux/wbusb.c
 delete mode 100644 drivers/staging/winbond/linux/wbusb_f.h
 delete mode 100644 drivers/staging/winbond/rxisr.c
 delete mode 100644 drivers/staging/winbond/sme_api.c
 create mode 100644 drivers/staging/winbond/sysdef.h
 rename drivers/staging/winbond/{linux => }/wb35reg.c (52%)
 rename drivers/staging/winbond/{linux => }/wb35reg_f.h (95%)
 rename drivers/staging/winbond/{linux => }/wb35reg_s.h (90%)
 rename drivers/staging/winbond/{linux => }/wb35rx.c (77%)
 create mode 100644 drivers/staging/winbond/wb35rx_f.h
 rename drivers/staging/winbond/{linux => }/wb35rx_s.h (96%)
 rename drivers/staging/winbond/{linux => }/wb35tx.c (73%)
 create mode 100644 drivers/staging/winbond/wb35tx_f.h
 rename drivers/staging/winbond/{linux => }/wb35tx_s.h (82%)
 delete mode 100644 drivers/staging/winbond/wblinux.c
 delete mode 100644 drivers/staging/winbond/wblinux_s.h
 create mode 100644 drivers/staging/winbond/wbusb.c
 rename drivers/staging/winbond/{linux => }/wbusb_s.h (68%)
 delete mode 100644 drivers/staging/wlan-ng/hfa384x.c
 delete mode 100644 drivers/staging/wlan-ng/p80211mod.c
 delete mode 100644 drivers/staging/wlan-ng/prism2_cs.c
 delete mode 100644 drivers/staging/wlan-ng/prism2_pci.c
 delete mode 100644 drivers/staging/wlan-ng/prism2_plx.c
 rename drivers/staging/wlan-ng/{prism2_usb.c => prism2usb.c} (84%)
 delete mode 100644 drivers/staging/wlan-ng/version.h

---------------

Alexander Beregalov (3):
      Staging: otus: remove dependence on kernel version
      Staging: me4000: switch to list_for_each*()
      Staging: usbip: switch to list_for_each_entry()

Anders Blomdell (1):
      Staging: comedi: add usb dt9812 driver

Anne Smorthit (1):
      Staging: comedi: add icp_multi driver

Arve Hjønnevåg (2):
      Staging: android: add binder driver
      Staging: android: add ram_console driver

Bernd Porr (2):
      Staging: comedi: add usb usbdux driver
      Staging: comedi: add usb usbduxfast driver

Dan Christian (1):
      Staging: comedi: add rtd520 driver

Daniel Krueger (1):
      Staging: add epl stack

David Kiliani (1):
      Staging: Add the Meilhaus ME-IDS driver package

David Schleef (8):
      Staging: add comedi core
      Staging: comedi: add kcomedilib to the tree
      Staging: comedi: add local copy of interrupt.h
      Staging: comedi: add pci and usb wrapper header files
      Staging: comedi: comedi driver common function module
      Staging: comedi: add mite comedi pci driver
      Staging: comedi: add comedi_bond driver
      Staging: comedi: add comedi_parport driver

David Taht (1):
      Staging: add frontier tranzport and alphatrack drivers

F. Duncan M. Haldane (1):
      Staging: Kconfig for ARCH=arm,8300, cris

Gianluca Palli (1):
      Staging: comedi: add s626 driver

Greg Kroah-Hartman (81):
      Staging: go7007: fixes due to video_usercopy api change
      Staging: go7007: fixes due v4l2_file_operations api change
      Staging: w35und: remove usb_submit_urb wrapper function
      Staging: w35und: remove usb_alloc_urb wrapper function
      Staging: w35und: fix config build warnings
      Staging: wlan-ng: fix compiler warnings
      Staging: at76_usb: fix build breakage
      Staging: at76_usb: remove compiler warnings
      Staging: at76_usb: fix up all remaining checkpatch.pl warnings
      Staging: go7007: fix minor build warnings
      Staging: go7007: add some more v4l2 ioctls
      Staging: agnx: fix build errors due to ssid removal
      Staging: agnx: fix build errors due to rate control API changes
      Staging: agnx: fix build warnings
      Staging: otus: fix netdev->priv usage
      Staging: otus: fix urb callback function type
      Staging: add rt2860 wireless driver
      Staging: rt2860: disable root hack for reading files
      Staging: rt2860: fix up netdev->priv usage
      Staging: rt2860: Fix minor compiler warnings
      Staging: rt2860: enable WPA_SUPPLICANT support
      Staging: benet: fix netif api breakage
      Staging: benet: fix up netdev->priv change
      Staging: benet: build is broken unless CONFIG_NETPOLL is enabled
      Staging: benet: fix build error.
      Staging: comedi: fix up a lot of checkpatch.pl warnings
      Staging: comedi: fix checkpatch.pl errors in comedi_fops.c
      Staging: comedi: fix build error in comedilib.h
      Staging: comedi: set up infrastructure for individual drivers
      Staging: comedi: dt9812: fix up a lot of coding style issues
      Staging: comedi: dt9812: remove dt9812.h
      Staging: comedi: dt9812: remove typedefs
      Staging: comedi: dt9812: fix sparse warnings
      Staging: comedi: usbdux: remove kernel version checks
      Staging: comedi: usbdux: code style cleanups
      Staging: comedi: usbdux: remove // comments
      Staging: comedi: usbdux: fix up printk calls
      Staging: comedi: usbdux: remove checkpatch.pl warnings
      Staging: comedi: usbdux: remove typedef
      Staging: comedi: usbdux: remove comedi usb wrappers
      Staging: comedi: usbduxfast: remove comedi usb wrappers
      Staging: comedi: dt9812: remove #ifdef that is not needed
      Staging: comedi: remove usb wrappers
      Staging: comedi: remove PCI wrappers
      Staging: comedi: fix checkpatch.pl issues in comedi_bond.c
      Staging: comedi: fix checkpatch.pl issues in comedi_fc.c
      Staging: comedi: remove typedefs from comedi_bond.c
      Staging: comedi: fix sparse issues in comedi_bond.c
      Staging: comedi: fix checkpatch.pl issues in comedi_test.c
      Staging: comedi: fix sparse issues in comedi_test.c
      Staging: comedi: remove typedefs from comedi_test.c
      Staging: comedi: fix comedi_parport.c checkpatch.pl issues.
      Staging: comedi: fix comedi_fc.h checkpatch.pl issues.
      Staging: comedi: fix comedi_pci.h checkpatch.pl issues.
      Staging: comedi: comedi_pci.h: remove unneeded wrapper
      Staging: comedi: comedi_pci.h: remove comedi_pci_enable_no_regions
      Staging: comedi: comedi_pci.h: remove comedi_pci_disable_no_regions
      Staging: comedi: me_daq: fix checkpatch.pl issues
      Staging: comedi: me_daq: remove typedefs
      Staging: comedi: me_daq: fix sparse issues
      Staging: comedi: fix checkpatch.pl warning in interrupt.h
      Staging: add rtl8187se driver
      Staging: rtl8187se: remove unneeded files
      Staging: rtl8187se: make the built module be the proper name
      Staging: rtl8187se: remove duplicate pci ids
      Staging: add princeton instruments usb camera driver
      Staging: add mimio xi driver
      Staging: add rt2870 wireless driver
      Staging: rt2870: disable root hack for reading files
      Staging: rt2870: fix up netdev->priv usage
      Staging: frontier: remove unused alphatrack_sysfs.c file
      Staging: frontier: fix compiler warnings
      Staging: epl: run Lindent on all kernel/*.h files
      Staging: epl: run Lindent on all user/*.h files
      Staging: epl: run Lindent on *.h files
      Staging: epl: run Lindent on *.c files
      Staging: epl: hr timers all run in hard irq context now
      Staging: epl: fix netdev->priv b0rkage
      Staging: add android framework
      Staging: android: remove dummy android.c driver
      Staging: android: binder: fix build errors

Guenter Gebhardt (1):
      Staging: comedi: add me4000 driver

Harvey Harrison (2):
      staging: correct dubious use of !x & y
      Staging: go7007: annotate code pointers

Huang Weiyi (1):
      Staging: wlan-ng: remove unused #include <version.h>

J.R. Mauro (11):
      Staging: sxg: remove typedefs
      Staging: sxg: break the build in a cleaner way when !x86
      Staging: sxg: update README
      Staging: echo: remove typedefs
      Staging: echo: Lindent drivers/staging/echo
      Staging: et131x: fix build failure
      Staging: otus: fix name clash
      Staging: rt2860: use standard bit-reverse function
      Staging: comedi: fix build if CONFIG_PROC_FS is not set
      Staging: android: binder: Fix gcc warnings about improper format specifiers for size_t in printk
      staging: android: binder: Fix use of euid

Jakub Schmidtke (1):
      Staging: add asus_oled driver

Joachim Wuttke (1):
      Staging: comedi: add comedi_test driver

Johann Felix Soden (1):
      Staging: et131x: remove unused variable in et1310_tx.c

John W. Linville (1):
      Staging: at76_usb: update drivers/staging/at76_usb w/ mac80211 port

Julia Lawall (1):
      Staging: wlan-ng: p80211wext.c: use ARRAY_SIZE

Kamalesh Babulal (2):
      Staging: asus_oled: fix build dependancy
      Staging: meilhaus: fix __symbol_get problems

Kay Sievers (1):
      staging: struct device - replace bus_id with dev_name(), dev_set_name()

Leon Woestenberg (1):
      Staging: add Driver for Altera PCI Express Chaining DMA reference design

Li YanBo (1):
      Staging: add agnx wireless driver

Lior Dotan (3):
      Staging: slicoss: use kzalloc
      Staging: slicoss: use correct type for memory allcations
      Staging: slicoss: use request_firmware

Luis R. Rodriguez (1):
      Staging: add otus Atheros wireless network driver

Mauro Carvalho Chehab (1):
      Staging: go7007: Convert driver to use video_ioctl2

Michael Hillmann (1):
      Staging: comedi: add me_daq driver

Mike Lockwood (2):
      Staging: android: add timed_gpio driver
      Staging: android: timed_gpio: Rename android_timed_gpio to timed_gpio

Oliver Neukum (2):
      Staging: at76_usb: cleanup dma on stack issues
      Staging: go7007: small cleanup

Pavel Machek (1):
      Staging: w35und: fix Kconfig

Pekka Enberg (45):
      Staging: w35und: make wb35_probe() and wb35_disconnect() funtions static
      Staging: w35und: remove unused wb35_open() and wb35_close() functions
      Staging: w35und: use msleep() and udelay()
      Staging: w35und: remove the no-op pa_stall_execution macro
      Staging: w35und: purb typedef removal
      Staging: w35und: reg queue struct typedef removal
      Staging: w35und: wb35reg struct typedef removal
      Staging: w35und: padapter struct typedef removal
      Staging: w35und: merge wblinux struct to adapter
      Staging: w35und: wb35_probe() cleanup
      w35und: remove dead code from wbusb_f.h
      Staging: w35und: remove true/false boolean macros
      Staging: w35und: OS_MEMORY_ALLOC wrapper removal
      Staging: w35und: usb_put_dev() is missing from wb35_disconnect()
      Staging: w35und: remove macro magic from MLME_GetNextPacket()
      Staging: w35und: plug memory leak in wbsoft_tx()
      Staging: w35und: move supported band initialization out of wb35_probe()
      Staging: w35und: remove timer wrappers
      Staging: w35und: remove atomic op wrappers
      Staging: w35und: remove memcpy/memcmp wrappers
      Staging: w35und: remove abs() and BIT() macros
      Staging: w35und: remove unused macros from common.h
      Staging: w35und: remove unused link status code
      Staging: w35und: #include cleanup
      Staging: w35und: remove some dead code
      Staging: w35und: move source files to one directory
      Staging: w35und: move struct wbsoft_priv to core.h and use it
      Staging: w35und: remove ->adapter from struct _HW_DATA_T
      Staging: w35und: clean up adapter.h a bit
      Staging: w35und: merge struct wb35_adapter to struct wbsoft_priv
      Staging: w35und: remove global struct ieee80211_hw
      Staging: w35und: inline DRIVER_AUTHOR and DRIVER_DESC macros
      Staging: w35und: clean up wblinux.c a bit
      Staging: w35und: remove unused ->ShutDowned member from struct LOCAL_PARA
      Staging: w35und: move global wbsoft_enabled to struct wbsoft_priv
      Staging: w35und: move packet_came() to wb35rx.c
      Staging: w35und: remove ->skb_array from struct wbsoft_priv
      Staging: w35und: remove ->shutdown from struct wbsoft_priv
      Staging: w35und: make functions local to mds.c static
      Staging: w35und: make functions local to mlmetxrx.c static
      Staging: w35und: remove dead code from mto.c
      Staging: w35und: make functions local to wb35rx.c static
      Staging: w35und: make functions local to wb35tx.c static
      Staging: w35und: remove dead code from wbhal.c
      Staging: w35und: remove rxisr.c as dead code

Pete Eberlein (2):
      Staging: go7007: saa7134 updates
      Staging: go7007: add sensoray 2250/2251 support

Qinghuang Feng (1):
      Staging: usbip: cleanup kerneldoc

Richard Kennedy (7):
      Staging: wlan-ng: p80211netdev.c fix netdev alloc to prevent oops on device start
      Staging: wlan-ng: prism2_usb.c always enable the card in probe_usb
      Staging: wlan-ng: hfa384x_usb.c use newest version of 384x_drvr_start
      Staging: wlan-ng: p80211wext.c add latest changes & remove extra nulls from wext_handlers
      Staging: wlan-ng: p80211wext don't set default key id twice
      Staging: wlan-ng: hfa384x_usbin_callback: check for hardware removed
      Staging: wlan-ng: p80211conv.c copy code from wlan-ng-devel branch to not drop packets

Robert Love (1):
      Staging: android: add logging driver

Roel Kluin (1):
      Staging: wlan-ng: skb_p80211_to_ether() - payload_length is unsigned, check before subtraction

San Mehat (1):
      Staging: android: add lowmemorykiller driver

Sathya Perla (5):
      Staging: benet: patch to remove subdirectories
      Staging: benet: fix build errors when CONFIG_NETPOLL is off
      Staging: benet: patch to use offsetof() instead of AMAP_BYTE_OFFSET()
      Staging: benet: fix problems reported by checkpatch
      Staging: benet: cleanup a check while posting rx buffers

Solomon Peachy (20):
      Staging: wlan-ng: Remove PCI/PLX/PCMCIA files.
      Staging: wlan-ng: Update Help text to mention prism3 devices.
      Staging: wlan-ng: Delete PCI/PLX/PCMCIA-specific code.
      Staging: wlan-ng: Make wlan-ng use WEXT mode by default.
      Staging: wlan-ng: Eliminate more <2.6 kernel support.
      Staging: wlan-ng: Eliminate all backwards-compatibility for <2.6.13 kernels.
      Staging: wlan-ng: Eliminate a boatload of tertiaryAP-only code.
      Staging: wlan-ng: Remove AP-only code from MLME functions.
      Staging: wlan-ng: Get rid of the MTU tests in the rx conversion path.
      Staging: wlan-ng: Eliminate one more rx mtu test.
      Staging: wlan-ng: Eliminate local 'version.h'
      Staging: wlan-ng: Eliminate usage of procfs.
      Staging: wlan-ng: Use standard kernel integer (u32/s32/etc) types.
      Staging: wlan-ng: Eliminate all backwards-compatible kernel code.
      Staging: wlan-ng: Wireless Extension support is mandatory.
      Staging: wlan-ng: use WIRELESS_EXT, not CONFIG_WIRELESS_EXT
      Staging: wlan-ng: Delete a large pile of now-unused code.
      Staging: wlan-ng: Delete a pile of unused mibs. And fix WEXT SET_TXPOWER.
      Staging: wlan-ng: Consolidate wlan-ng into a single module.
      Staging: wlan-ng: Purge all MIBs not used internally.

Stoyan Gaydarov (1):
      Staging: et131x: Cleanup et131x_debug.h defines

Subbu Seetharaman (1):
      Staging: Add ServerEngines benet 10Gb ethernet driver

Vijay Kumar (8):
      Staging: poch: Block size bug fix
      Staging: poch: Update TODO list
      Staging: poch: Correct pages from bytes.
      Staging: poch: minor fixes
      Staging: poch: Fix build warnings
      Staging: poch: Rx control register init
      Staging: poch: Fix user space protocol syncing
      Staging: poch: Fine grained locking

Willy Tarreau (4):
      Staging: add lcd-panel driver
      Staging: panel: major checkpatch cleanup
      Staging: panel: remove ifdefs and code for pre-2.6 kernels
      Staging: panel: remove support for smartcards

