Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZFSSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZFSSLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZFSSLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:11:33 -0400
Received: from kroah.org ([198.145.64.141]:41914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZFSSLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:11:30 -0400
Date: Fri, 19 Jun 2009 11:07:28 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING patches for 2.6.30-git tree
Message-ID: <20090619180728.GA21529@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big staging series of patches for your git tree.

They contain a few new drivers, and lots of fixes for the existing
staging drivers.

And hey, look:
 658 files changed, 165585 insertions(+), 240493 deletions(-)

We are removing more crap than we are adding, looks like progress to me!
:)

All of these are contained within the drivers/staging tree, and have
been in the linux-next and -mm trees for a while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

The patches will all be copied to the driverdev mailing list, if people
want to see them there.

thanks,

greg k-h

--------------

 MAINTAINERS                                        |    1 +
 drivers/staging/Kconfig                            |   14 +-
 drivers/staging/Makefile                           |    7 +-
 drivers/staging/agnx/debug.h                       |    9 +-
 drivers/staging/agnx/pci.c                         |   57 +-
 drivers/staging/agnx/phy.c                         |    4 +-
 drivers/staging/agnx/phy.h                         |    2 +-
 drivers/staging/agnx/sta.c                         |    2 +-
 drivers/staging/agnx/sta.h                         |    2 +-
 drivers/staging/altpciechdma/altpciechdma.c        |   34 +-
 drivers/staging/android/Kconfig                    |   10 +-
 drivers/staging/android/Makefile                   |    1 +
 drivers/staging/android/binder.c                   |  436 +-
 drivers/staging/android/logger.c                   |   12 +-
 drivers/staging/android/lowmemorykiller.c          |  101 +-
 drivers/staging/android/ram_console.c              |    9 +-
 drivers/staging/android/timed_gpio.c               |   98 +-
 drivers/staging/android/timed_gpio.h               |    4 +-
 drivers/staging/android/timed_output.c             |  121 +
 drivers/staging/android/timed_output.h             |   37 +
 drivers/staging/asus_oled/asus_oled.c              |    2 +-
 drivers/staging/b3dfg/b3dfg.c                      |    3 +-
 drivers/staging/comedi/Kconfig                     |   11 +-
 drivers/staging/comedi/Makefile                    |    5 -
 drivers/staging/comedi/comedi.h                    |    1 -
 drivers/staging/comedi/comedi_fops.c               |  504 +-
 drivers/staging/comedi/comedi_ksyms.c              |    7 -
 drivers/staging/comedi/comedi_rt.h                 |  149 -
 drivers/staging/comedi/comedidev.h                 |   17 +-
 drivers/staging/comedi/drivers.c                   |   19 +-
 drivers/staging/comedi/drivers/8253.h              |   50 +-
 drivers/staging/comedi/drivers/8255.c              |   23 +-
 drivers/staging/comedi/drivers/8255.h              |   14 +-
 drivers/staging/comedi/drivers/Makefile            |    5 +-
 drivers/staging/comedi/drivers/acl7225b.c          |   22 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.c      |  372 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.h      |   32 +-
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     |  402 +-
 .../comedi/drivers/addi-data/APCI1710_Chrono.h     |   36 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.c     |  309 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.h     |    8 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     | 1012 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.h     |  188 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.c    |  204 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.h    |    8 +-
 .../comedi/drivers/addi-data/APCI1710_Pwm.c        | 1314 ++--
 .../comedi/drivers/addi-data/APCI1710_Pwm.h        |   70 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |  230 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.h        |    6 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |  432 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.h        |    8 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.c        |  198 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.h        |    8 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.c     |  119 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.h     |    6 +-
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |   12 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |  191 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |  356 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |  438 +-
 .../comedi/drivers/addi-data/amcc_s5933_58.h       |   43 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |  169 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |  214 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.h       |   34 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |  106 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.h      |   29 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |  532 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.h      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |  174 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.h      |   29 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  507 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.h      |   52 +-
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |  134 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |  136 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.h      |   26 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |  176 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.h      |   32 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |  174 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.h      |   26 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 1055 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.h      |  142 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      | 1701 ++--
 .../comedi/drivers/addi-data/hwdrv_apci3200.h      |  176 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |  225 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.h      |   44 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |  274 +-
 drivers/staging/comedi/drivers/addi_apci_035.c     |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |  177 +-
 drivers/staging/comedi/drivers/adl_pci7296.c       |   22 +-
 drivers/staging/comedi/drivers/adl_pci7432.c       |   32 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |  325 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  135 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |  648 +-
 drivers/staging/comedi/drivers/adq12b.c            |   82 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  348 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |  122 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  112 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   46 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |   44 +-
 drivers/staging/comedi/drivers/am9513.h            |   16 +-
 drivers/staging/comedi/drivers/amcc_s5933.h        |   10 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |  226 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |  138 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   82 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  131 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |  306 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |  140 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |  160 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |  842 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       | 1755 ++--
 drivers/staging/comedi/drivers/cb_pcidda.c         |  323 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |   75 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |  187 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   71 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |    2 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |    9 +-
 drivers/staging/comedi/drivers/comedi_rt_timer.c   |  728 --
 drivers/staging/comedi/drivers/comedi_test.c       |    3 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |   46 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |  230 +-
 drivers/staging/comedi/drivers/das08.c             |  542 +-
 drivers/staging/comedi/drivers/das08.h             |   24 +-
 drivers/staging/comedi/drivers/das08_cs.c          |   65 +-
 drivers/staging/comedi/drivers/das16.c             |  816 +-
 drivers/staging/comedi/drivers/das16m1.c           |  152 +-
 drivers/staging/comedi/drivers/das1800.c           |  689 +-
 drivers/staging/comedi/drivers/das6402.c           |   47 +-
 drivers/staging/comedi/drivers/das800.c            |  213 +-
 drivers/staging/comedi/drivers/dmm32at.c           |  128 +-
 drivers/staging/comedi/drivers/dt2801.c            |  214 +-
 drivers/staging/comedi/drivers/dt2811.c            |   92 +-
 drivers/staging/comedi/drivers/dt2814.c            |   48 +-
 drivers/staging/comedi/drivers/dt2815.c            |   36 +-
 drivers/staging/comedi/drivers/dt2817.c            |   27 +-
 drivers/staging/comedi/drivers/dt282x.c            |  391 +-
 drivers/staging/comedi/drivers/dt3000.c            |  220 +-
 drivers/staging/comedi/drivers/fl512.c             |   42 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |  234 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   15 +-
 drivers/staging/comedi/drivers/icp_multi.h         |   12 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   83 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |  211 +-
 drivers/staging/comedi/drivers/jr3_pci.h           |    8 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   47 +-
 drivers/staging/comedi/drivers/me4000.c            |    9 +-
 drivers/staging/comedi/drivers/me_daq.c            |    1 +
 drivers/staging/comedi/drivers/mite.c              |   28 +-
 drivers/staging/comedi/drivers/mite.h              |    2 +-
 drivers/staging/comedi/drivers/mpc624.c            |  218 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        |   32 +-
 drivers/staging/comedi/drivers/multiq3.c           |   43 +-
 drivers/staging/comedi/drivers/ni_6527.c           |   73 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |  251 +-
 drivers/staging/comedi/drivers/ni_660x.c           |  232 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   84 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  275 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |   90 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |  327 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |  117 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |  113 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |  110 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |  693 +-
 drivers/staging/comedi/drivers/ni_labpc.h          |   50 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |  105 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |  970 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c         |  256 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |  188 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |  139 +-
 drivers/staging/comedi/drivers/ni_stc.h            |  148 +-
 drivers/staging/comedi/drivers/ni_tio.c            |   18 +-
 drivers/staging/comedi/drivers/ni_tio.h            |   18 +-
 drivers/staging/comedi/drivers/ni_tio_internal.h   |   14 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c         |   40 +-
 drivers/staging/comedi/drivers/pcl711.c            |   68 +-
 drivers/staging/comedi/drivers/pcl724.c            |   54 +-
 drivers/staging/comedi/drivers/pcl725.c            |   24 +-
 drivers/staging/comedi/drivers/pcl726.c            |   72 +-
 drivers/staging/comedi/drivers/pcl730.c            |   34 +-
 drivers/staging/comedi/drivers/pcl812.c            |  320 +-
 drivers/staging/comedi/drivers/pcl816.c            |  417 +-
 drivers/staging/comedi/drivers/pcl818.c            |  578 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   67 +-
 drivers/staging/comedi/drivers/pcm3730.c           |   28 +-
 drivers/staging/comedi/drivers/pcm_common.c        |  111 +
 drivers/staging/comedi/drivers/pcm_common.h        |    8 +
 drivers/staging/comedi/drivers/pcmad.c             |   42 +-
 drivers/staging/comedi/drivers/pcmda12.c           |   45 +-
 drivers/staging/comedi/drivers/pcmmio.c            |  268 +-
 drivers/staging/comedi/drivers/pcmuio.c            |  241 +-
 drivers/staging/comedi/drivers/plx9080.h           |    8 +-
 drivers/staging/comedi/drivers/poc.c               |  104 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   79 +-
 drivers/staging/comedi/drivers/rtd520.c            |   78 +-
 drivers/staging/comedi/drivers/rti800.c            |   77 +-
 drivers/staging/comedi/drivers/rti802.c            |   24 +-
 drivers/staging/comedi/drivers/s526.c              |  386 +-
 drivers/staging/comedi/drivers/s626.c              |  282 +-
 drivers/staging/comedi/drivers/s626.h              |    2 +-
 drivers/staging/comedi/drivers/serial2002.c        |  100 +-
 drivers/staging/comedi/drivers/skel.c              |   90 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |   49 +-
 drivers/staging/comedi/drivers/unioxx5.c           |   86 +-
 drivers/staging/comedi/drivers/usbdux.c            |  181 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |  213 +-
 drivers/staging/comedi/drivers/vmk80xx.c           | 1399 +++
 drivers/staging/comedi/interrupt.h                 |   51 -
 drivers/staging/comedi/kcomedilib/data.c           |    5 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |   33 +-
 drivers/staging/comedi/kcomedilib/ksyms.c          |   49 +-
 drivers/staging/comedi/range.c                     |    9 +-
 drivers/staging/comedi/rt.c                        |  411 -
 drivers/staging/comedi/rt_pend_tq.c                |  113 -
 drivers/staging/comedi/rt_pend_tq.h                |   10 -
 drivers/staging/cpc-usb/Kconfig                    |    4 +
 drivers/staging/cpc-usb/Makefile                   |    3 +
 drivers/staging/{serqt_usb => cpc-usb}/TODO        |    5 +-
 drivers/staging/cpc-usb/cpc-usb_drv.c              | 1185 ++
 drivers/staging/cpc-usb/cpc.h                      |  440 +
 drivers/staging/cpc-usb/cpc_int.h                  |   83 +
 drivers/staging/cpc-usb/cpcusb.h                   |   86 +
 drivers/staging/cpc-usb/sja2m16c.h                 |   41 +
 drivers/staging/cpc-usb/sja2m16c_2.c               |  452 +
 drivers/staging/echo/echo.c                        |    2 +-
 drivers/staging/epl/EplSdoUdpu.c                   |    3 +-
 drivers/staging/epl/ShbIpc-LinuxKernel.c           |    8 +-
 drivers/staging/frontier/alphatrack.c              |    1 -
 drivers/staging/frontier/tranzport.c               |    1 -
 drivers/staging/go7007/wis-sony-tuner.c            |    2 +-
 drivers/staging/heci/heci.h                        |    1 -
 drivers/staging/heci/heci_data_structures.h        |    1 -
 drivers/staging/heci/heci_init.c                   |   14 +-
 drivers/staging/heci/heci_interface.c              |   17 +-
 drivers/staging/heci/heci_interface.h              |    2 +-
 drivers/staging/heci/heci_main.c                   |   50 +-
 drivers/staging/heci/interrupt.c                   |   28 +-
 drivers/staging/heci/io_heci.c                     |   47 +-
 drivers/staging/meilhaus/me0600_ext_irq.c          |    5 -
 drivers/staging/meilhaus/me0900_di.c               |    1 -
 drivers/staging/meilhaus/me1400_device.c           |    1 -
 drivers/staging/meilhaus/me1400_ext_irq.c          |    5 -
 drivers/staging/meilhaus/me4600_ai.c               |    4 -
 drivers/staging/meilhaus/me4600_ai.h               |    1 -
 drivers/staging/meilhaus/me4600_ao.c               |    6 +-
 drivers/staging/meilhaus/me4600_ext_irq.c          |    5 -
 drivers/staging/meilhaus/me6000_ao.c               |    4 -
 drivers/staging/meilhaus/me6000_ao.h               |    1 -
 drivers/staging/meilhaus/me8100_di.c               |    5 -
 drivers/staging/meilhaus/me8200_di.c               |    9 -
 drivers/staging/meilhaus/me8200_do.c               |    5 -
 drivers/staging/meilhaus/memain.c                  |  184 +-
 drivers/staging/meilhaus/memain.h                  |  194 -
 drivers/staging/otus/80211core/ccmd.c              | 2982 +++---
 drivers/staging/otus/80211core/coid.c              |    2 +-
 drivers/staging/p9auth/p9auth.c                    |   24 +-
 drivers/staging/pata_rdc/Kconfig                   |    6 +
 drivers/staging/pata_rdc/Makefile                  |    2 +
 drivers/staging/pata_rdc/pata_rdc.c                |  955 ++
 drivers/staging/pata_rdc/pata_rdc.h                |  144 +
 drivers/staging/pohmelfs/crypto.c                  |    3 +-
 drivers/staging/pohmelfs/dir.c                     |    9 +-
 drivers/staging/pohmelfs/inode.c                   |   15 +-
 drivers/staging/pohmelfs/net.c                     |    7 +-
 drivers/staging/pohmelfs/netfs.h                   |   65 +-
 drivers/staging/pohmelfs/trans.c                   |    7 +-
 drivers/staging/rspiusb/rspiusb.c                  |  559 +-
 drivers/staging/rspiusb/rspiusb.h                  |   28 +-
 drivers/staging/rt2860/2860_main_dev.c             |   41 +-
 drivers/staging/rt2860/Makefile                    |    5 +-
 drivers/staging/rt2860/ap.h                        |   40 +-
 drivers/staging/rt2860/chlist.h                    |   56 +-
 drivers/staging/rt2860/common/2860_rtmp_init.c     |   25 -
 drivers/staging/rt2860/common/action.c             |  444 +-
 drivers/staging/rt2860/common/action.h             |    7 -
 drivers/staging/rt2860/common/ba_action.c          |  179 +-
 drivers/staging/rt2860/common/cmm_data.c           |  647 +-
 drivers/staging/rt2860/common/cmm_data_2860.c      |  105 +-
 drivers/staging/rt2860/common/cmm_info.c           |  273 +-
 drivers/staging/rt2860/common/cmm_sanity.c         |  401 +-
 drivers/staging/rt2860/common/cmm_sync.c           |  113 +-
 drivers/staging/rt2860/common/cmm_wpa.c            |   28 +-
 drivers/staging/rt2860/common/dfs.c                |   21 -
 drivers/staging/rt2860/common/eeprom.c             | 1268 ++-
 drivers/staging/rt2860/common/md5.c                |   12 -
 drivers/staging/rt2860/common/mlme.c               | 1890 ++--
 drivers/staging/rt2860/common/netif_block.c        |  144 -
 drivers/staging/rt2860/common/netif_block.h        |   58 -
 drivers/staging/rt2860/common/rtmp_init.c          | 1253 ++-
 drivers/staging/rt2860/common/rtmp_tkip.c          |   21 -
 drivers/staging/rt2860/common/rtmp_wep.c           |    2 -
 drivers/staging/rt2860/common/spectrum.c           |   57 +-
 drivers/staging/rt2860/leap.h                      |  215 -
 drivers/staging/rt2860/mlme.h                      |  309 -
 drivers/staging/rt2860/oid.h                       |  173 +-
 drivers/staging/rt2860/rt28xx.h                    | 1218 +--
 drivers/staging/rt2860/rt_ate.c                    | 6009 ----------
 drivers/staging/rt2860/rt_ate.h                    |  347 -
 drivers/staging/rt2860/rt_config.h                 |   33 +-
 drivers/staging/rt2860/rt_linux.c                  |   45 +-
 drivers/staging/rt2860/rt_linux.h                  |  188 +-
 drivers/staging/rt2860/rt_main_dev.c               |  717 +-
 drivers/staging/rt2860/rt_profile.c                |  161 +-
 drivers/staging/rt2860/rtmp.h                      | 1831 ++--
 drivers/staging/rt2860/rtmp_def.h                  |  210 +-
 drivers/staging/rt2860/spectrum.h                  |   30 -
 drivers/staging/rt2860/sta/assoc.c                 |  586 +-
 drivers/staging/rt2860/sta/auth.c                  |   14 -
 drivers/staging/rt2860/sta/auth_rsp.c              |   19 -
 drivers/staging/rt2860/sta/connect.c               |  602 +-
 drivers/staging/rt2860/sta/dls.c                   | 2197 ----
 drivers/staging/rt2860/sta/rtmp_data.c             |  336 +-
 drivers/staging/rt2860/sta/sanity.c                |    2 -
 drivers/staging/rt2860/sta/sync.c                  |  290 +-
 drivers/staging/rt2860/sta/wpa.c                   |   12 +-
 drivers/staging/rt2860/sta_ioctl.c                 | 1236 +--
 drivers/staging/rt2860/wpa.h                       |   31 +-
 drivers/staging/rt2870/2870_main_dev.c             |  264 +-
 drivers/staging/rt2870/Makefile                    |    4 -
 drivers/staging/rt2870/aironet.h                   |  211 +-
 drivers/staging/rt2870/ap.h                        |  563 +-
 drivers/staging/rt2870/chlist.h                    | 1297 +--
 drivers/staging/rt2870/common/2870_rtmp_init.c     |  123 +-
 drivers/staging/rt2870/common/action.c             | 1047 +--
 drivers/staging/rt2870/common/action.h             |   69 +-
 drivers/staging/rt2870/common/ba_action.c          | 1799 +---
 drivers/staging/rt2870/common/cmm_data.c           | 2732 +-----
 drivers/staging/rt2870/common/cmm_data_2870.c      |   73 +-
 drivers/staging/rt2870/common/cmm_info.c           | 3713 +------
 drivers/staging/rt2870/common/cmm_sanity.c         | 1664 +---
 drivers/staging/rt2870/common/cmm_sync.c           |  712 +--
 drivers/staging/rt2870/common/cmm_wpa.c            | 1655 +---
 drivers/staging/rt2870/common/dfs.c                |  454 +-
 drivers/staging/rt2870/common/eeprom.c             |  255 +-
 drivers/staging/rt2870/common/md5.c                | 1428 +---
 drivers/staging/rt2870/common/mlme.c               | 8610 +--------------
 drivers/staging/rt2870/common/netif_block.c        |  144 -
 drivers/staging/rt2870/common/rtmp_init.c          | 4133 +-------
 drivers/staging/rt2870/common/rtmp_tkip.c          | 1614 +---
 drivers/staging/rt2870/common/rtmp_wep.c           |  509 +-
 drivers/staging/rt2870/common/rtusb_bulk.c         |  775 +--
 drivers/staging/rt2870/common/rtusb_data.c         |   13 -
 drivers/staging/rt2870/common/rtusb_io.c           |  211 +-
 drivers/staging/rt2870/common/spectrum.c           | 1877 +---
 drivers/staging/rt2870/dfs.h                       |  101 +-
 drivers/staging/rt2870/leap.h                      |  215 -
 drivers/staging/rt2870/link_list.h                 |  135 +-
 drivers/staging/rt2870/md5.h                       |  108 +-
 drivers/staging/rt2870/mlme.h                      | 1472 +---
 drivers/staging/rt2870/netif_block.h               |   58 -
 drivers/staging/rt2870/oid.h                       | 1092 +--
 drivers/staging/rt2870/rt2870.h                    |  252 +-
 drivers/staging/rt2870/rt28xx.h                    | 2690 +-----
 drivers/staging/rt2870/rt_ate.c                    | 6452 ----------
 drivers/staging/rt2870/rt_ate.h                    |  315 -
 drivers/staging/rt2870/rt_config.h                 |  105 +-
 drivers/staging/rt2870/rt_linux.c                  | 1096 +--
 drivers/staging/rt2870/rt_linux.h                  |  907 +--
 drivers/staging/rt2870/rt_main_dev.c               | 1866 +---
 drivers/staging/rt2870/rt_profile.c                | 2021 +----
 drivers/staging/rt2870/rtmp.h                      | 7587 +------------
 drivers/staging/rt2870/rtmp_ckipmic.h              |  114 +-
 drivers/staging/rt2870/rtmp_def.h                  | 1623 +---
 drivers/staging/rt2870/rtmp_type.h                 |   95 +-
 drivers/staging/rt2870/spectrum.h                  |  323 +-
 drivers/staging/rt2870/spectrum_def.h              |   96 +-
 drivers/staging/rt2870/sta/aironet.c               | 1313 +--
 drivers/staging/rt2870/sta/assoc.c                 | 2040 +----
 drivers/staging/rt2870/sta/auth.c                  |  475 +-
 drivers/staging/rt2870/sta/auth_rsp.c              |  167 +-
 drivers/staging/rt2870/sta/connect.c               | 2823 +-----
 drivers/staging/rt2870/sta/dls.c                   | 2210 ----
 drivers/staging/rt2870/sta/rtmp_data.c             | 2620 +----
 drivers/staging/rt2870/sta/sanity.c                |  421 +-
 drivers/staging/rt2870/sta/sync.c                  | 1754 +---
 drivers/staging/rt2870/sta/wpa.c                   | 2108 +----
 drivers/staging/rt2870/sta_ioctl.c                 | 7069 +-----------
 drivers/staging/rt2870/sta_ioctl.c.patch           |   18 -
 drivers/staging/rt2870/tmp60                       | 7037 -----------
 drivers/staging/rt2870/tmp61                       | 7037 -----------
 drivers/staging/rt2870/wpa.h                       |  358 +-
 drivers/staging/rt3070/2870_main_dev.c             | 1628 +---
 drivers/staging/rt3070/Makefile                    |    4 -
 drivers/staging/rt3070/action.h                    |   69 +-
 drivers/staging/rt3070/aironet.h                   |  211 +-
 drivers/staging/rt3070/ap.h                        |  558 +-
 drivers/staging/rt3070/chlist.h                    | 1254 +--
 drivers/staging/rt3070/common/2870_rtmp_init.c     | 1763 +---
 drivers/staging/rt3070/common/action.c             | 1039 +--
 drivers/staging/rt3070/common/ba_action.c          | 1811 +---
 drivers/staging/rt3070/common/cmm_data.c           | 2828 +-----
 drivers/staging/rt3070/common/cmm_data_2870.c      |  981 +--
 drivers/staging/rt3070/common/cmm_info.c           | 3396 +------
 drivers/staging/rt3070/common/cmm_sanity.c         | 1670 +---
 drivers/staging/rt3070/common/cmm_sync.c           |  712 +--
 drivers/staging/rt3070/common/cmm_wpa.c            | 1607 +---
 drivers/staging/rt3070/common/dfs.c                |  442 +-
 drivers/staging/rt3070/common/eeprom.c             | 1499 +---
 drivers/staging/rt3070/common/md5.c                | 1428 +---
 drivers/staging/rt3070/common/mlme.c               | 9137 +--------------
 drivers/staging/rt3070/common/netif_block.c        |  136 -
 drivers/staging/rt3070/common/rtmp_init.c          | 4198 +-------
 drivers/staging/rt3070/common/rtmp_tkip.c          | 1614 +---
 drivers/staging/rt3070/common/rtmp_wep.c           |  509 +-
 drivers/staging/rt3070/common/rtusb_bulk.c         | 1383 +---
 drivers/staging/rt3070/common/rtusb_data.c         |  219 +-
 drivers/staging/rt3070/common/rtusb_io.c           | 1909 +---
 drivers/staging/rt3070/common/spectrum.c           | 1877 +---
 drivers/staging/rt3070/dfs.h                       |  101 +-
 drivers/staging/rt3070/leap.h                      |  215 -
 drivers/staging/rt3070/link_list.h                 |  135 +-
 drivers/staging/rt3070/md5.h                       |  108 +-
 drivers/staging/rt3070/mlme.h                      | 1469 +---
 drivers/staging/rt3070/netif_block.h               |   58 -
 drivers/staging/rt3070/oid.h                       | 1143 +--
 drivers/staging/rt3070/rt2870.h                    |  757 +--
 drivers/staging/rt3070/rt28xx.h                    | 2726 +-----
 drivers/staging/rt3070/rt_ate.c                    | 6506 ----------
 drivers/staging/rt3070/rt_ate.h                    |  294 -
 drivers/staging/rt3070/rt_config.h                 |  122 +-
 drivers/staging/rt3070/rt_linux.c                  | 1064 +--
 drivers/staging/rt3070/rt_linux.h                  |  888 +--
 drivers/staging/rt3070/rt_main_dev.c               | 1802 +---
 drivers/staging/rt3070/rt_profile.c                | 2042 +----
 drivers/staging/rt3070/rtmp.h                      | 7729 +------------
 drivers/staging/rt3070/rtmp_ckipmic.h              |  114 +-
 drivers/staging/rt3070/rtmp_def.h                  | 1560 +---
 drivers/staging/rt3070/rtmp_type.h                 |   96 +-
 drivers/staging/rt3070/spectrum.h                  |  323 +-
 drivers/staging/rt3070/spectrum_def.h              |   96 +-
 drivers/staging/rt3070/sta/aironet.c               | 1313 +--
 drivers/staging/rt3070/sta/assoc.c                 | 2061 +----
 drivers/staging/rt3070/sta/auth.c                  |  476 +-
 drivers/staging/rt3070/sta/auth_rsp.c              |  168 +-
 drivers/staging/rt3070/sta/connect.c               | 2857 +-----
 drivers/staging/rt3070/sta/dls.c                   | 2170 ----
 drivers/staging/rt3070/sta/rtmp_data.c             | 2638 +-----
 drivers/staging/rt3070/sta/sanity.c                |  421 +-
 drivers/staging/rt3070/sta/sync.c                  | 1756 +---
 drivers/staging/rt3070/sta/wpa.c                   | 2100 +----
 drivers/staging/rt3070/sta_ioctl.c                 | 7204 +-----------
 drivers/staging/rt3070/wpa.h                       |  357 +-
 drivers/staging/rtl8187se/Kconfig                  |    2 +-
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |   25 +-
 drivers/staging/rtl8187se/r8180_dm.c               |    6 +-
 drivers/staging/rtl8187se/r8180_pm.c               |    6 +-
 drivers/staging/rtl8192su/Kconfig                  |    6 +
 drivers/staging/rtl8192su/Makefile                 |   66 +
 drivers/staging/rtl8192su/authors                  |    1 +
 drivers/staging/rtl8192su/dot11d.h                 |  102 +
 drivers/staging/rtl8192su/ieee80211.h              | 2901 +++++
 drivers/staging/rtl8192su/ieee80211/EndianFree.h   |  199 +
 drivers/staging/rtl8192su/ieee80211/Makefile       |   31 +
 drivers/staging/rtl8192su/ieee80211/aes.c          |  469 +
 drivers/staging/rtl8192su/ieee80211/api.c          |  246 +
 drivers/staging/rtl8192su/ieee80211/arc4.c         |  103 +
 drivers/staging/rtl8192su/ieee80211/autoload.c     |   40 +
 drivers/staging/rtl8192su/ieee80211/cipher.c       |  299 +
 drivers/staging/rtl8192su/ieee80211/compress.c     |   64 +
 .../staging/rtl8192su/ieee80211/crypto_compat.h    |   90 +
 drivers/staging/rtl8192su/ieee80211/digest.c       |  108 +
 drivers/staging/rtl8192su/ieee80211/dot11d.c       |  239 +
 drivers/staging/rtl8192su/ieee80211/dot11d.h       |  102 +
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    | 2901 +++++
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.c  |  273 +
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.h  |   93 +
 .../rtl8192su/ieee80211/ieee80211_crypt_ccmp.c     |  534 +
 .../rtl8192su/ieee80211/ieee80211_crypt_tkip.c     | 1034 ++
 .../rtl8192su/ieee80211/ieee80211_crypt_wep.c      |  397 +
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |  394 +
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c | 2832 +++++
 .../rtl8192su/ieee80211/ieee80211_softmac.c        | 3580 ++++++
 .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |  711 ++
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |  947 ++
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c | 1032 ++
 drivers/staging/rtl8192su/ieee80211/internal.h     |  115 +
 drivers/staging/rtl8192su/ieee80211/kmap_types.h   |   20 +
 drivers/staging/rtl8192su/ieee80211/michael_mic.c  |  194 +
 drivers/staging/rtl8192su/ieee80211/proc.c         |  116 +
 drivers/staging/rtl8192su/ieee80211/readme         |  162 +
 drivers/staging/rtl8192su/ieee80211/rtl819x_BA.h   |   69 +
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   |  781 ++
 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h   |  517 +
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   | 2037 ++++
 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h  |  749 ++
 drivers/staging/rtl8192su/ieee80211/rtl819x_TS.h   |   56 +
 .../staging/rtl8192su/ieee80211/rtl819x_TSProc.c   |  667 ++
 drivers/staging/rtl8192su/ieee80211/rtl_crypto.h   |  399 +
 drivers/staging/rtl8192su/ieee80211/scatterwalk.c  |  126 +
 drivers/staging/rtl8192su/ieee80211/scatterwalk.h  |   51 +
 drivers/staging/rtl8192su/ieee80211_crypt.h        |   86 +
 drivers/staging/rtl8192su/r8180_93cx6.c            |  146 +
 drivers/staging/rtl8192su/r8180_93cx6.h            |   45 +
 drivers/staging/rtl8192su/r8190_rtl8256.c          |  312 +
 drivers/staging/rtl8192su/r8190_rtl8256.h          |   27 +
 drivers/staging/rtl8192su/r8192SU_HWImg.c          | 4902 ++++++++
 drivers/staging/rtl8192su/r8192SU_HWImg.h          |   44 +
 drivers/staging/rtl8192su/r8192S_Efuse.c           | 2442 ++++
 drivers/staging/rtl8192su/r8192S_Efuse.h           |  101 +
 drivers/staging/rtl8192su/r8192S_FwImgDTM.h        | 3797 ++++++
 drivers/staging/rtl8192su/r8192S_firmware.c        | 1023 ++
 drivers/staging/rtl8192su/r8192S_firmware.h        |  212 +
 drivers/staging/rtl8192su/r8192S_hw.h              | 1677 +++
 drivers/staging/rtl8192su/r8192S_phy.c             | 5028 ++++++++
 drivers/staging/rtl8192su/r8192S_phy.h             |  138 +
 drivers/staging/rtl8192su/r8192S_phyreg.h          | 1033 ++
 drivers/staging/rtl8192su/r8192S_rtl6052.c         |  946 ++
 drivers/staging/rtl8192su/r8192S_rtl6052.h         |  134 +
 drivers/staging/rtl8192su/r8192S_rtl8225.c         |  292 +
 drivers/staging/rtl8192su/r8192S_rtl8225.h         |   30 +
 drivers/staging/rtl8192su/r8192U.h                 | 2112 ++++
 drivers/staging/rtl8192su/r8192U_core.c            |12460 ++++++++++++++++++++
 drivers/staging/rtl8192su/r8192U_dm.c              | 4521 +++++++
 drivers/staging/rtl8192su/r8192U_dm.h              |  309 +
 drivers/staging/rtl8192su/r8192U_hw.h              |  746 ++
 drivers/staging/rtl8192su/r8192U_pm.c              |   77 +
 drivers/staging/rtl8192su/r8192U_pm.h              |   27 +
 drivers/staging/rtl8192su/r8192U_wx.c              | 1350 +++
 drivers/staging/rtl8192su/r8192U_wx.h              |   23 +
 drivers/staging/rtl8192su/r819xU_HTGen.h           |   22 +
 drivers/staging/rtl8192su/r819xU_HTType.h          |  392 +
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |  826 ++
 drivers/staging/rtl8192su/r819xU_cmdpkt.h          |  219 +
 drivers/staging/rtl8192su/r819xU_firmware.c        |  707 ++
 drivers/staging/rtl8192su/r819xU_firmware.h        |  106 +
 drivers/staging/rtl8192su/r819xU_firmware_img.c    | 3447 ++++++
 drivers/staging/rtl8192su/r819xU_firmware_img.h    |   35 +
 drivers/staging/rtl8192su/r819xU_phy.c             | 1826 +++
 drivers/staging/rtl8192su/r819xU_phy.h             |   94 +
 drivers/staging/rtl8192su/r819xU_phyreg.h          |  871 ++
 drivers/staging/serqt_usb/Makefile                 |    1 -
 drivers/staging/serqt_usb/serqt_usb.c              | 2656 -----
 drivers/staging/{serqt_usb => serqt_usb2}/Kconfig  |    4 +-
 drivers/staging/serqt_usb2/Makefile                |    1 +
 drivers/staging/serqt_usb2/serqt_usb2.c            | 1664 +++
 drivers/staging/slicoss/slicoss.c                  |    3 +-
 drivers/staging/stlc45xx/stlc45xx.c                |   11 +-
 drivers/staging/sxg/sxg.c                          |   40 +-
 drivers/staging/sxg/sxg_ethtool.c                  |    2 +-
 drivers/staging/udlfb/Kconfig                      |    8 +
 drivers/staging/udlfb/Makefile                     |    1 +
 drivers/staging/udlfb/udlfb.c                      |  937 ++
 drivers/staging/udlfb/udlfb.h                      |  225 +
 drivers/staging/vt6655/80211hdr.h                  |  357 +
 drivers/staging/vt6655/80211mgr.c                  | 1050 ++
 drivers/staging/vt6655/80211mgr.h                  |  832 ++
 drivers/staging/vt6655/IEEE11h.c                   |  324 +
 drivers/staging/vt6655/IEEE11h.h                   |   68 +
 drivers/staging/vt6655/Kconfig                     |    6 +
 drivers/staging/vt6655/Makefile                    |   38 +
 drivers/staging/vt6655/Makefile.arm                |  181 +
 drivers/staging/vt6655/Makefile.x86                |  209 +
 drivers/staging/vt6655/aes_ccmp.c                  |  410 +
 drivers/staging/vt6655/aes_ccmp.h                  |   48 +
 drivers/staging/vt6655/baseband.c                  | 2990 +++++
 drivers/staging/vt6655/baseband.h                  |  198 +
 drivers/staging/vt6655/bssdb.c                     | 1786 +++
 drivers/staging/vt6655/bssdb.h                     |  380 +
 drivers/staging/vt6655/card.c                      | 3126 +++++
 drivers/staging/vt6655/card.h                      |  273 +
 drivers/staging/vt6655/country.h                   |  192 +
 drivers/staging/vt6655/datarate.c                  |  455 +
 drivers/staging/vt6655/datarate.h                  |   95 +
 drivers/staging/vt6655/desc.h                      |  697 ++
 drivers/staging/vt6655/device.h                    | 1063 ++
 drivers/staging/vt6655/device_cfg.h                |  142 +
 drivers/staging/vt6655/device_main.c               | 4074 +++++++
 drivers/staging/vt6655/dpc.c                       | 1668 +++
 drivers/staging/vt6655/dpc.h                       |   75 +
 drivers/staging/vt6655/hostap.c                    |  914 ++
 drivers/staging/vt6655/hostap.h                    |   94 +
 drivers/staging/vt6655/iocmd.h                     |  481 +
 drivers/staging/vt6655/ioctl.c                     |  775 ++
 drivers/staging/vt6655/ioctl.h                     |   74 +
 drivers/staging/vt6655/iowpa.h                     |  159 +
 drivers/staging/vt6655/iwctl.c                     | 2397 ++++
 drivers/staging/vt6655/iwctl.h                     |  332 +
 drivers/staging/vt6655/kcompat.h                   |   84 +
 drivers/staging/vt6655/key.c                       |  836 ++
 drivers/staging/vt6655/key.h                       |  202 +
 drivers/staging/vt6655/mac.c                       | 1752 +++
 drivers/staging/vt6655/mac.h                       | 1166 ++
 drivers/staging/vt6655/mib.c                       |  616 +
 drivers/staging/vt6655/mib.h                       |  399 +
 drivers/staging/vt6655/michael.c                   |  188 +
 drivers/staging/vt6655/michael.h                   |   62 +
 drivers/staging/vt6655/power.c                     |  441 +
 drivers/staging/vt6655/power.h                     |   85 +
 drivers/staging/vt6655/rc4.c                       |   86 +
 drivers/staging/vt6655/rc4.h                       |   51 +
 drivers/staging/vt6655/rf.c                        | 1283 ++
 drivers/staging/vt6655/rf.h                        |  118 +
 drivers/staging/vt6655/rxtx.c                      | 3269 +++++
 drivers/staging/vt6655/rxtx.h                      |  132 +
 drivers/staging/vt6655/srom.c                      |  437 +
 drivers/staging/vt6655/srom.h                      |  179 +
 drivers/staging/vt6655/tbit.h                      |   78 +
 drivers/staging/vt6655/tcrc.c                      |  207 +
 drivers/staging/vt6655/tcrc.h                      |   71 +
 drivers/staging/vt6655/test                        |    9 +
 drivers/staging/vt6655/tether.c                    |  123 +
 drivers/staging/vt6655/tether.h                    |  256 +
 drivers/staging/vt6655/tkip.c                      |  284 +
 drivers/staging/vt6655/tkip.h                      |   76 +
 drivers/staging/vt6655/tmacro.h                    |  152 +
 drivers/staging/vt6655/tpci.h                      |  117 +
 drivers/staging/vt6655/ttype.h                     |  386 +
 drivers/staging/vt6655/umem.h                      |   75 +
 drivers/staging/vt6655/upc.h                       |  171 +
 drivers/staging/vt6655/vntconfiguration.dat        |    1 +
 drivers/staging/vt6655/vntwifi.c                   |  832 ++
 drivers/staging/vt6655/vntwifi.h                   |  330 +
 drivers/staging/vt6655/wcmd.c                      | 1178 ++
 drivers/staging/vt6655/wcmd.h                      |  151 +
 drivers/staging/vt6655/wctl.c                      |  261 +
 drivers/staging/vt6655/wctl.h                      |  127 +
 drivers/staging/vt6655/wmgr.c                      | 5088 ++++++++
 drivers/staging/vt6655/wmgr.h                      |  521 +
 drivers/staging/vt6655/wpa.c                       |  339 +
 drivers/staging/vt6655/wpa.h                       |   98 +
 drivers/staging/vt6655/wpa2.c                      |  373 +
 drivers/staging/vt6655/wpa2.h                      |  100 +
 drivers/staging/vt6655/wpactl.c                    | 1017 ++
 drivers/staging/vt6655/wpactl.h                    |   89 +
 drivers/staging/vt6655/wroute.c                    |  211 +
 drivers/staging/vt6655/wroute.h                    |   65 +
 drivers/staging/winbond/Makefile                   |    1 -
 drivers/staging/winbond/mds.c                      |    2 +-
 drivers/staging/winbond/mto.c                      |    2 +-
 drivers/staging/winbond/phy_calibration.c          |   19 +
 drivers/staging/winbond/wbhal.c                    |  568 -
 drivers/staging/winbond/wbhal_f.h                  |   21 -
 drivers/staging/winbond/wbhal_s.h                  |    1 -
 drivers/staging/winbond/wbusb.c                    |  785 +-
 drivers/staging/wlan-ng/README                     |    1 -
 drivers/staging/wlan-ng/hfa384x.h                  |  286 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |  323 +-
 drivers/staging/wlan-ng/p80211conv.c               |   21 +-
 drivers/staging/wlan-ng/p80211conv.h               |    4 +-
 drivers/staging/wlan-ng/p80211hdr.h                |    3 -
 drivers/staging/wlan-ng/p80211meta.h               |    1 -
 drivers/staging/wlan-ng/p80211metadef.h            |   48 +
 drivers/staging/wlan-ng/p80211mgmt.h               |   42 +-
 drivers/staging/wlan-ng/p80211msg.h                |    1 -
 drivers/staging/wlan-ng/p80211netdev.c             |   99 +-
 drivers/staging/wlan-ng/p80211netdev.h             |   47 +-
 drivers/staging/wlan-ng/p80211req.c                |   20 +-
 drivers/staging/wlan-ng/p80211req.h                |    2 +-
 drivers/staging/wlan-ng/p80211types.h              |    7 +-
 drivers/staging/wlan-ng/p80211wep.c                |  198 +-
 drivers/staging/wlan-ng/p80211wext.c               |  147 +-
 drivers/staging/wlan-ng/prism2fw.c                 | 1406 +++
 drivers/staging/wlan-ng/prism2mgmt.c               |  117 +-
 drivers/staging/wlan-ng/prism2mgmt.h               |   48 +-
 drivers/staging/wlan-ng/prism2mib.c                |  159 +-
 drivers/staging/wlan-ng/prism2sta.c                |  268 +-
 drivers/staging/wlan-ng/prism2usb.c                |   14 +-
 658 files changed, 165585 insertions(+), 240493 deletions(-)
 create mode 100644 drivers/staging/android/timed_output.c
 create mode 100644 drivers/staging/android/timed_output.h
 delete mode 100644 drivers/staging/comedi/comedi_rt.h
 delete mode 100644 drivers/staging/comedi/drivers/comedi_rt_timer.c
 create mode 100644 drivers/staging/comedi/drivers/pcm_common.c
 create mode 100644 drivers/staging/comedi/drivers/pcm_common.h
 create mode 100644 drivers/staging/comedi/drivers/vmk80xx.c
 delete mode 100644 drivers/staging/comedi/interrupt.h
 delete mode 100644 drivers/staging/comedi/rt.c
 delete mode 100644 drivers/staging/comedi/rt_pend_tq.c
 delete mode 100644 drivers/staging/comedi/rt_pend_tq.h
 create mode 100644 drivers/staging/cpc-usb/Kconfig
 create mode 100644 drivers/staging/cpc-usb/Makefile
 rename drivers/staging/{serqt_usb => cpc-usb}/TODO (63%)
 create mode 100644 drivers/staging/cpc-usb/cpc-usb_drv.c
 create mode 100644 drivers/staging/cpc-usb/cpc.h
 create mode 100644 drivers/staging/cpc-usb/cpc_int.h
 create mode 100644 drivers/staging/cpc-usb/cpcusb.h
 create mode 100644 drivers/staging/cpc-usb/sja2m16c.h
 create mode 100644 drivers/staging/cpc-usb/sja2m16c_2.c
 create mode 100644 drivers/staging/pata_rdc/Kconfig
 create mode 100644 drivers/staging/pata_rdc/Makefile
 create mode 100644 drivers/staging/pata_rdc/pata_rdc.c
 create mode 100644 drivers/staging/pata_rdc/pata_rdc.h
 delete mode 100644 drivers/staging/rt2860/common/netif_block.c
 delete mode 100644 drivers/staging/rt2860/common/netif_block.h
 delete mode 100644 drivers/staging/rt2860/leap.h
 delete mode 100644 drivers/staging/rt2860/rt_ate.c
 delete mode 100644 drivers/staging/rt2860/rt_ate.h
 delete mode 100644 drivers/staging/rt2860/sta/dls.c
 delete mode 100644 drivers/staging/rt2870/common/netif_block.c
 delete mode 100644 drivers/staging/rt2870/leap.h
 delete mode 100644 drivers/staging/rt2870/netif_block.h
 delete mode 100644 drivers/staging/rt2870/rt_ate.c
 delete mode 100644 drivers/staging/rt2870/rt_ate.h
 delete mode 100644 drivers/staging/rt2870/sta/dls.c
 delete mode 100644 drivers/staging/rt2870/sta_ioctl.c.patch
 delete mode 100644 drivers/staging/rt2870/tmp60
 delete mode 100644 drivers/staging/rt2870/tmp61
 delete mode 100644 drivers/staging/rt3070/common/netif_block.c
 delete mode 100644 drivers/staging/rt3070/leap.h
 delete mode 100644 drivers/staging/rt3070/netif_block.h
 delete mode 100644 drivers/staging/rt3070/rt_ate.c
 delete mode 100644 drivers/staging/rt3070/rt_ate.h
 delete mode 100644 drivers/staging/rt3070/sta/dls.c
 create mode 100644 drivers/staging/rtl8192su/Kconfig
 create mode 100644 drivers/staging/rtl8192su/Makefile
 create mode 100644 drivers/staging/rtl8192su/authors
 create mode 100644 drivers/staging/rtl8192su/dot11d.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/EndianFree.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/Makefile
 create mode 100644 drivers/staging/rtl8192su/ieee80211/aes.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/api.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/arc4.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/autoload.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/cipher.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/compress.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/crypto_compat.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/digest.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/dot11d.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/dot11d.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/internal.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/kmap_types.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/michael_mic.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/proc.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/readme
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_BA.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_TS.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_TSProc.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/rtl_crypto.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211/scatterwalk.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/scatterwalk.h
 create mode 100644 drivers/staging/rtl8192su/ieee80211_crypt.h
 create mode 100644 drivers/staging/rtl8192su/r8180_93cx6.c
 create mode 100644 drivers/staging/rtl8192su/r8180_93cx6.h
 create mode 100644 drivers/staging/rtl8192su/r8190_rtl8256.c
 create mode 100644 drivers/staging/rtl8192su/r8190_rtl8256.h
 create mode 100644 drivers/staging/rtl8192su/r8192SU_HWImg.c
 create mode 100644 drivers/staging/rtl8192su/r8192SU_HWImg.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_Efuse.c
 create mode 100644 drivers/staging/rtl8192su/r8192S_Efuse.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_FwImgDTM.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_firmware.c
 create mode 100644 drivers/staging/rtl8192su/r8192S_firmware.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_hw.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_phy.c
 create mode 100644 drivers/staging/rtl8192su/r8192S_phy.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_phyreg.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_rtl6052.c
 create mode 100644 drivers/staging/rtl8192su/r8192S_rtl6052.h
 create mode 100644 drivers/staging/rtl8192su/r8192S_rtl8225.c
 create mode 100644 drivers/staging/rtl8192su/r8192S_rtl8225.h
 create mode 100644 drivers/staging/rtl8192su/r8192U.h
 create mode 100644 drivers/staging/rtl8192su/r8192U_core.c
 create mode 100644 drivers/staging/rtl8192su/r8192U_dm.c
 create mode 100644 drivers/staging/rtl8192su/r8192U_dm.h
 create mode 100644 drivers/staging/rtl8192su/r8192U_hw.h
 create mode 100644 drivers/staging/rtl8192su/r8192U_pm.c
 create mode 100644 drivers/staging/rtl8192su/r8192U_pm.h
 create mode 100644 drivers/staging/rtl8192su/r8192U_wx.c
 create mode 100644 drivers/staging/rtl8192su/r8192U_wx.h
 create mode 100644 drivers/staging/rtl8192su/r819xU_HTGen.h
 create mode 100644 drivers/staging/rtl8192su/r819xU_HTType.h
 create mode 100644 drivers/staging/rtl8192su/r819xU_cmdpkt.c
 create mode 100644 drivers/staging/rtl8192su/r819xU_cmdpkt.h
 create mode 100644 drivers/staging/rtl8192su/r819xU_firmware.c
 create mode 100644 drivers/staging/rtl8192su/r819xU_firmware.h
 create mode 100644 drivers/staging/rtl8192su/r819xU_firmware_img.c
 create mode 100644 drivers/staging/rtl8192su/r819xU_firmware_img.h
 create mode 100644 drivers/staging/rtl8192su/r819xU_phy.c
 create mode 100644 drivers/staging/rtl8192su/r819xU_phy.h
 create mode 100644 drivers/staging/rtl8192su/r819xU_phyreg.h
 delete mode 100644 drivers/staging/serqt_usb/Makefile
 delete mode 100644 drivers/staging/serqt_usb/serqt_usb.c
 rename drivers/staging/{serqt_usb => serqt_usb2}/Kconfig (76%)
 create mode 100644 drivers/staging/serqt_usb2/Makefile
 create mode 100644 drivers/staging/serqt_usb2/serqt_usb2.c
 create mode 100644 drivers/staging/udlfb/Kconfig
 create mode 100644 drivers/staging/udlfb/Makefile
 create mode 100644 drivers/staging/udlfb/udlfb.c
 create mode 100644 drivers/staging/udlfb/udlfb.h
 create mode 100644 drivers/staging/vt6655/80211hdr.h
 create mode 100644 drivers/staging/vt6655/80211mgr.c
 create mode 100644 drivers/staging/vt6655/80211mgr.h
 create mode 100644 drivers/staging/vt6655/IEEE11h.c
 create mode 100644 drivers/staging/vt6655/IEEE11h.h
 create mode 100644 drivers/staging/vt6655/Kconfig
 create mode 100644 drivers/staging/vt6655/Makefile
 create mode 100644 drivers/staging/vt6655/Makefile.arm
 create mode 100644 drivers/staging/vt6655/Makefile.x86
 create mode 100644 drivers/staging/vt6655/aes_ccmp.c
 create mode 100644 drivers/staging/vt6655/aes_ccmp.h
 create mode 100644 drivers/staging/vt6655/baseband.c
 create mode 100644 drivers/staging/vt6655/baseband.h
 create mode 100644 drivers/staging/vt6655/bssdb.c
 create mode 100644 drivers/staging/vt6655/bssdb.h
 create mode 100644 drivers/staging/vt6655/card.c
 create mode 100644 drivers/staging/vt6655/card.h
 create mode 100644 drivers/staging/vt6655/country.h
 create mode 100644 drivers/staging/vt6655/datarate.c
 create mode 100644 drivers/staging/vt6655/datarate.h
 create mode 100644 drivers/staging/vt6655/desc.h
 create mode 100644 drivers/staging/vt6655/device.h
 create mode 100644 drivers/staging/vt6655/device_cfg.h
 create mode 100644 drivers/staging/vt6655/device_main.c
 create mode 100644 drivers/staging/vt6655/dpc.c
 create mode 100644 drivers/staging/vt6655/dpc.h
 create mode 100644 drivers/staging/vt6655/hostap.c
 create mode 100644 drivers/staging/vt6655/hostap.h
 create mode 100644 drivers/staging/vt6655/iocmd.h
 create mode 100644 drivers/staging/vt6655/ioctl.c
 create mode 100644 drivers/staging/vt6655/ioctl.h
 create mode 100644 drivers/staging/vt6655/iowpa.h
 create mode 100644 drivers/staging/vt6655/iwctl.c
 create mode 100644 drivers/staging/vt6655/iwctl.h
 create mode 100644 drivers/staging/vt6655/kcompat.h
 create mode 100644 drivers/staging/vt6655/key.c
 create mode 100644 drivers/staging/vt6655/key.h
 create mode 100644 drivers/staging/vt6655/mac.c
 create mode 100644 drivers/staging/vt6655/mac.h
 create mode 100644 drivers/staging/vt6655/mib.c
 create mode 100644 drivers/staging/vt6655/mib.h
 create mode 100644 drivers/staging/vt6655/michael.c
 create mode 100644 drivers/staging/vt6655/michael.h
 create mode 100644 drivers/staging/vt6655/power.c
 create mode 100644 drivers/staging/vt6655/power.h
 create mode 100644 drivers/staging/vt6655/rc4.c
 create mode 100644 drivers/staging/vt6655/rc4.h
 create mode 100644 drivers/staging/vt6655/rf.c
 create mode 100644 drivers/staging/vt6655/rf.h
 create mode 100644 drivers/staging/vt6655/rxtx.c
 create mode 100644 drivers/staging/vt6655/rxtx.h
 create mode 100644 drivers/staging/vt6655/srom.c
 create mode 100644 drivers/staging/vt6655/srom.h
 create mode 100644 drivers/staging/vt6655/tbit.h
 create mode 100644 drivers/staging/vt6655/tcrc.c
 create mode 100644 drivers/staging/vt6655/tcrc.h
 create mode 100644 drivers/staging/vt6655/test
 create mode 100644 drivers/staging/vt6655/tether.c
 create mode 100644 drivers/staging/vt6655/tether.h
 create mode 100644 drivers/staging/vt6655/tkip.c
 create mode 100644 drivers/staging/vt6655/tkip.h
 create mode 100644 drivers/staging/vt6655/tmacro.h
 create mode 100644 drivers/staging/vt6655/tpci.h
 create mode 100644 drivers/staging/vt6655/ttype.h
 create mode 100644 drivers/staging/vt6655/umem.h
 create mode 100644 drivers/staging/vt6655/upc.h
 create mode 100644 drivers/staging/vt6655/vntconfiguration.dat
 create mode 100644 drivers/staging/vt6655/vntwifi.c
 create mode 100644 drivers/staging/vt6655/vntwifi.h
 create mode 100644 drivers/staging/vt6655/wcmd.c
 create mode 100644 drivers/staging/vt6655/wcmd.h
 create mode 100644 drivers/staging/vt6655/wctl.c
 create mode 100644 drivers/staging/vt6655/wctl.h
 create mode 100644 drivers/staging/vt6655/wmgr.c
 create mode 100644 drivers/staging/vt6655/wmgr.h
 create mode 100644 drivers/staging/vt6655/wpa.c
 create mode 100644 drivers/staging/vt6655/wpa.h
 create mode 100644 drivers/staging/vt6655/wpa2.c
 create mode 100644 drivers/staging/vt6655/wpa2.h
 create mode 100644 drivers/staging/vt6655/wpactl.c
 create mode 100644 drivers/staging/vt6655/wpactl.h
 create mode 100644 drivers/staging/vt6655/wroute.c
 create mode 100644 drivers/staging/vt6655/wroute.h
 delete mode 100644 drivers/staging/winbond/wbhal.c
 create mode 100644 drivers/staging/wlan-ng/prism2fw.c

---------------

Alessio Igor Bogani (3):
      Staging: comedi: replace __FUNCTION__ usages
      Staging: sxg: replace __FUNCTION__ usages
      Staging: rt3070: replace __FUNCTION__ usages

Alexander Beregalov (7):
      Staging: comedi: comedi_test.c should include timer.h
      Staging: comedi: data.c should include delay.h
      Staging: agnx: replace print_mac with %pM
      Staging: rtl8187se: convert to net_device_ops
      Staging: stlc45xx: replace print_mac with %pM
      Staging: cpc-usb: depends on PROC_FS
      Staging: cpc-usb: fix printk format warnings

Anders Kaseorg (2):
      Staging: rt2860: Don't call sprintf() with overlapping input and output.
      Staging: rt2870: Don't call sprintf() with overlapping input and output.

Andre Lopes (1):
      staging: b3dfg: clean up MODULE_PARM_DESC newline

Arve Hjønnevåg (2):
      Staging: android: lowmemorykiller: Only iterate over process list when needed.
      Staging: android: lowmemorykiller: Don't count free space unless it meets the specified limit by itself

Bartlomiej Zolnierkiewicz (102):
      Staging: rt2870: remove unused files
      Staging: rt2870: remove kernel version compatibility wrappers
      Staging: rt3070: remove kernel version compatibility wrappers
      Staging: rt2860: remove IWE_STREAM_ADD_*() macros
      Staging: rt2870: remove IWE_STREAM_ADD_*() macros
      Staging: rt2860: remove dead WIN_NDIS code
      Staging: rt2860: remove dead UNDER_CE code
      Staging: rt2870: remove dead UNDER_CE code
      Staging: rt3070: remove dead UNDER_CE code
      Staging: rt2860: remove dead WSC_AP_SUPPORT code
      Staging: rt2870: remove dead WSC_AP_SUPPORT code
      Staging: rt3070: remove dead *WSC_INCLUDED code
      Staging: rt2860: remove dead WDS_SUPPORT code
      Staging: rt2870: remove dead WDS_SUPPORT code
      Staging: rt3070: remove dead WDS_SUPPORT code
      Staging: rt3070: remove dead MLME_EX code
      Staging: rt2860: remove dead APCLI_SUPPORT code
      Staging: rt2870: remove dead APCLI_SUPPORT code
      Staging: rt2860: remove dead CONFIG_APSTA_MIXED_SUPPORT code
      Staging: rt2870: remove dead CONFIG_APSTA_MIXED_SUPPORT code
      Staging: rt3070: remove dead CONFIG_APSTA_MIXED_SUPPORT code
      Staging: rt2860: remove dead UCOS code
      Staging: rt2870: remove dead UCOS code
      Staging: rt3070: remove dead UCOS code
      Staging: rt2860: remove dead NINTENDO_AP code
      Staging: rt2870: remove dead NINTENDO_AP code
      Staging: rt3070: remove dead NINTENDO_AP code
      Staging: rt2860: remove dead BIN_IN_FILE code
      Staging: rt2870: remove dead BIN_IN_FILE code
      Staging: rt3070: remove dead BIN_IN_FILE code
      Staging: rt2860: remove dead RALINK_ATE code
      Staging: rt2870: remove dead RALINK_ATE code
      Staging: rt3070: remove dead RALINK_ATE code
      Staging: rt2860: remove dead BLOCK_NET_IF code
      Staging: rt2870: remove dead BLOCK_NET_IF code
      Staging: rt3070: remove dead BLOCK_NET_IF code
      Staging: rt2860: remove dead DFS_SUPPORT code
      Staging: rt2870: remove dead DFS_SUPPORT code
      Staging: rt3070: remove dead DFS_SUPPORT code
      Staging: rt2860: remove dead CARRIER_DETECTION_SUPPORT code
      Staging: rt2870: remove dead CARRIER_DETECTION_SUPPORT code
      Staging: rt3070: remove dead CARRIER_DETECTION_SUPPORT code
      Staging: rt2860: remove dead MULTIPLE_CARD_SUPPORT code
      Staging: rt2870: remove dead MULTIPLE_CARD_SUPPORT code
      Staging: rt3070: remove dead MULTIPLE_CARD_SUPPORT code
      Staging: rt2860: remove dead QOS_DLS_SUPPORT code
      Staging: rt2870: remove dead QOS_DLS_SUPPORT code
      Staging: rt3070: remove dead QOS_DLS_SUPPORT code
      Staging: rt2860: remove dead EXT_BUILD_CHANNEL_LIST code
      Staging: rt2870: remove dead EXT_BUILD_CHANNEL_LIST code
      Staging: rt3070: remove dead EXT_BUILD_CHANNEL_LIST code
      Staging: rt2860: remove dead SNMP_SUPPORT code
      Staging: rt2870: remove dead SNMP_SUPPORT code
      Staging: rt3070: remove dead SNMP_SUPPORT code
      Staging: rt2860: remove dead SINGLE_SKU code
      Staging: rt2870: remove dead SINGLE_SKU code
      Staging: rt3070: remove dead SINGLE_SKU code
      Staging: rt2860: remove dead LEAP_SUPPORT code
      Staging: rt2870: remove dead LEAP_SUPPORT code
      Staging: rt3070: remove dead LEAP_SUPPORT code
      Staging: rt2860: remove dead DOT11N_DRAFT3 code
      Staging: rt2870: remove dead DOT11N_DRAFT3 code
      Staging: rt3070: remove dead DOT11N_DRAFT3 code
      Staging: rt2860: remove dead INF_AMAZON_SE code
      Staging: rt2870: remove dead INF_AMAZON_SE code
      Staging: rt3070: remove dead INF_AMAZON_SE code
      Staging: rt2860: remove dead RT_BIG_ENDIAN code
      Staging: rt2870: remove dead RT_BIG_ENDIAN code
      Staging: rt3070: remove dead RT_BIG_ENDIAN code
      Staging: rt2860: remove CONFIG_STA_SUPPORT ifdefs
      Staging: rt2870: remove CONFIG_STA_SUPPORT ifdefs
      Staging: rt3070: remove CONFIG_STA_SUPPORT ifdefs
      Staging: rt2860: remove NATIVE_WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2870: remove NATIVE_WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt3070: remove NATIVE_WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2860: remove WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2870: remove WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt3070: remove WPA_SUPPLICANT_SUPPORT ifdefs
      Staging: rt2860: remove DOT11_N_SUPPORT ifdefs
      Staging: rt2870: remove DOT11_N_SUPPORT ifdefs
      Staging: rt3070: remove DOT11_N_SUPPORT ifdefs
      Staging: rt2860: remove dead CONFIG_AP_SUPPORT code
      Staging: rt2870: remove dead CONFIG_AP_SUPPORT code
      Staging: rt3070: remove dead CONFIG_AP_SUPPORT code
      Staging: rt2860: use empty ASSERT() macro
      Staging: rt2870: use empty ASSERT() macro
      Staging: rt3070: use empty ASSERT() macro
      Staging: rt2860: remove dead code
      Staging: rt2870: remove dead code
      Staging: rt3070: remove dead code
      Staging: rt2870: prepare for rt{28,30}70/*.[ch] merge
      Staging: rt{28,30}70: merge rt{28,30}70/*.[ch]
      Staging: rt2870: prepare for rt{28,30}70/common/*.[ch] merge
      Staging: rt{28,30}70: merge rt{28,30}70/common/*.[ch]
      Staging: rt2870: prepare for rt{28,30}70/sta/*.[ch] merge
      Staging: rt{28,30}70: merge rt{28,30}70/sta/*.[ch]
      Staging: rt2860: prepare for rt28[67]0/*.[ch] merge
      Staging: rt28[67]0: merge rt28[67]0/*.[ch]
      Staging: rt2860: prepare for rt28[67]0/common/*.[ch] merge
      Staging: rt28[67]0: merge rt28[67]0/common/*.[ch]
      Staging: rt2860: prepare for rt28[67]0/sta/*.[ch] merge
      Staging: rt28[67]0: merge rt28[67]0/sta/*.[ch]

Bernd Porr (2):
      Staging: comedi: convert usbdux* to use firmware_request
      Staging: comedi: usbdux: buffer overflow error handling

Bill Pemberton (79):
      Staging: comedi: Remove ni_board typedef
      Staging: comedi: Remove ni_private typedef
      Staging: comedi: Remove local_info_t typedef in ni_labpc_cs
      Staging: comedi: Remove dio24_board_struct typedef
      Staging: comedi: Remove local_info_t typedef in ni_daq_dio24
      Staging: comedi: Remove BYTE and *PBYTE typedefs in addi-data
      Staging: comedi: Remove SHORT and *PSHORT typedefs in addi-data
      Staging: comedi: Remove USHORT and *PUSHORT typedefs in addi-data
      Staging: comedi: Remove WORD and *PWORD typedefs in addi-data
      Staging: comedi: Remove INT and *PINT typedefs in addi-data
      Staging: comedi: Remove UINT and *PUINT typedefs in addi-data
      Staging: comedi: Remove LONG and *PLONG typedefs in addi-data
      Staging: comedi: Remove ULONG and *PULONG typedefs in addi-data
      Staging: comedi: Remove DWORD and *PDWORD typedefs in addi-data
      Staging: comedi: Remove ULONG_PTR typedef in addi-data
      Staging: comedi: Remove PCRANGE typedef in addi-data
      Staging: comedi: Remove boardtype typedef in addi-data
      Staging: comedi: Remove str_ModuleInfo typedef in addi-data
      Staging: comedi: Remove addi_private typedef in addi-data
      Staging: comedi: Remove str_MainHeader typedef in addi-data/addi_eeprom.c
      Staging: comedi: Remove str_DigitalInputHeader typedef in addi-data/addi_eeprom.c
      Staging: comedi: Remove str_DigitalOutputHeader typedef in addi-data/addi_eeprom.c
      Staging: comedi: Remove str_TimerDetails typedef in addi-data/addi_eeprom.c
      Staging: comedi: Remove str_TimerMainHeader typedef in addi-data/addi_eeprom.c
      Staging: comedi: Remove str_AnalogReadInformation typedef in addi-data/hwdrv_apci3120.h
      Staging: comedi: Remove str_Module typedef in addi-data/hwdrv_apci3200.h
      Staging: comedi: Remove str_BoardInfos typedef in addi-data/hwdrv_apci3200
      Staging: comedi: Remove str_ADDIDATA_RTDStruct typedef in addi-data/hwdrv_apci3200
      Staging: comedi: Remove labpc_board_struct typedef
      Staging: comedi: Remove labpc_private typedef
      Staging: comedi: Remove str_AnalogInputHeader typedef in addi-data/addi_eeprom.c
      Staging: comedi: remove C99 comments in 8253.h
      Staging: comedi: remove C99 comments in acl7225b.c
      Staging: comedi: remove C99 comments in APCI1710_82x54.c
      Staging: comedi: remove C99 comments in das1800.c
      Staging: comedi: remove C99 comments in pcl818.c
      Staging: comedi: remove C99 comments in hwdrv_apci1500.c
      Staging: comedi: remove C99 comments in APCI1710_Pwm.c
      Staging: comedi: remove C99 comments in hwdrv_apci1564.c
      Staging: comedi: remove C99 comments in hwdrv_apci3200.c
      Staging: comedi: remove C99 comments in hwdrv_apci3120.c
      Staging: comedi: remove C99 comments in adl_pci6208.c
      Staging: comedi: remove C99 comments in adl_pci9118.c
      Staging: comedi: remove C99 comments in adv_pci1723.c
      Staging: comedi: remove C99 comments in c6xdigio.c
      Staging: comedi: remove C99 comments in cb_pcidas64.c
      Staging: comedi: remove C99 comments in cb_pcidas.c
      Staging: comedi: remove C99 comments in cb_pcimdas.c
      Staging: comedi: remove C99 comments in gsc_hpdi.c
      Staging: comedi: remove C99 comments in mpc624.c
      Staging: comedi: remove C99 comments in ni_at_a2150.c
      Staging: comedi: remove C99 comments in ni_labpc.c
      Staging: comedi: remove C99 comments in pcl724.c
      Staging: comedi: remove C99 comments in pcl816.c
      Staging: comedi: remove C99 comments in s526.c
      Staging: comedi: Remove C99 comments
      Staging: comedi: fix "foo * bar" should be "foo *bar"
      Staging: comedi: Add spaces after commas
      Staging Comedi: fix spacing around parens
      Staging: Comedi: change space indentation to tabs
      Staging: comedi: remove assignment in conditionals
      Staging: comedi: Remove parens around return values
      Staging: comedi: fix the way structs are initialized.
      Staging: comedi: more remove C99 comments
      Staging: comedi: remove space after ampersand
      Staging: comedi: more fix "foo * bar" should be "foo *bar"
      Staging: comedi: more fix the way structs are initialized.
      Staging: comedi: make use of ARRAY_SIZE macro
      Staging: comedi: comment out useless if
      Staging: comedi: move while to same line as } in do loops
      Staging: comedi: replace for loop with msleep()
      Staging: comedi: simply read and write functions in adl_pci8164
      staging: comedi: Remove MIN macro
      staging: comedi: Move pcm do_cmdtest function into a single source file
      Staging: pohmelfs: move open brace to same line on structs
      Staging: pohmelfs: Remove C99 comments
      Staging: pohmelfs: Remove braces around single statements
      Staging: Add serqt_usb2, a rewrite of serqt_usb for the usb-serial layer
      Staging: serqt_usb2 add the driver to the build

Bryan Stephenson (1):
      Staging: rt2860: fix for driver RT2860 to be able to connect to WPA2 networks

David Rientjes (2):
      Staging: android: lowmemorykiller: cleanup android low memory killer
      Staging: android: lowmemorykiller: fix possible android low memory killer NULL pointer

David Rowe (1):
      Staging: oslec bug fix

Diego Liziero (1):
      Staging winbond: boolean negation and bitwise operation in wrong order

Dongxiao Xu (8):
      Staging: heci: fix userspace pointer mess
      Staging: heci: fix wrong order of device_lock and file_lock
      Staging: heci: fix spinlock order mess of device_lock and read_io_lock
      Staging: heci: fix softirq safe to unsafe spinlock issue
      Staging: heci: fix typos and add wait after disconnect
      Staging: heci: fix setting h_is bit in h_csr register
      Staging: heci: do not print error when heci_bh_handler is already on workqueue
      Staging: heci: fix the problem that file_ext->state should be protected by device_lock

Dragoslav Zaric (1):
      Staging: otus: 80211core/ccmd.c: Fix Coding Style

Forest Bond (8):
      Staging: Add pristine upstream vt6655 driver sources
      Staging: vt6655 Add includes to drivers/staging/vt6655.
      Staging: vt6655: Drop obsolete fsuid/fsgid accesses.
      Staging: vt6655: Build vt6655.ko, not viawget.ko.
      Staging: vt6655: Replace net_device->priv accesses with netdev_priv calls.
      Staging: vt6655: Remove LINUX_VERSION_CODE preprocessor conditionals.
      Staging: vt6655: use net_device_ops for management functions
      Staging: vt6655: Integrate drivers/staging/vt6655 into build system.

Frank Mori Hess (5):
      Staging: comedi: Finish removing ni_private typedef
      Staging: comedi: Fixed Kconfig option for COMEDI_PCMCIA_DRIVERS
      Staging: Comedi: ni_600x: Added support for comedi_poll.
      Staging: comedi: Added sysfs attribute files for setting and querying subdevice buffer sizes.
      Staging: comedi: jr3_pci: Use struct device from pci_dev for firmware loading.

Gerard Lledo (1):
      Staging: comedi: cb_pcidas.c: Fix build warning (type mismatch)

Greg Kroah-Hartman (43):
      Staging: add mailing list address for staging tree
      Staging: comedi: fix build errors in pcmcia comedi drivers
      Staging: comedi: set PCI and PCMCIA defines
      Staging: comedi: vmk80xx.c: get the driver to build properly
      Staging: comedi: remove comedi-specific wrappers
      Staging: comedi: remove RT code
      Staging: comedi: remove some RT code that lingered
      staging: comedi: fix pcmcia build breakage
      Staging: agnx: fix build warnings
      Staging: meilhaus: fix build warnings
      Staging: remove driver_data direct access of struct device
      Staging: rt2870: fix build warnings
      Staging: android: lowmemorykiller: fix up remaining checkpatch warnings
      Staging: android: logger: fix up remaining checkpatch warnings
      Staging: android: ram_console: fix up remaining checkpatch warnings
      Staging: android: binder: fix up some checkpatch warnings
      Staging: android: fix Kconfig issues
      Staging: cpc-usb: fix some build problems in the driver
      Staging: cpc-usb: add driver to the build
      Staging: cpc-usb: fix up checkpatch errors in cpc-usb_drv.c
      Staging: cpc-usb: fix checkpatch warnings in sja2m16c.h
      Staging: cpc-usb: add TODO file
      Staging: cpc-usb: fix build warnings
      Staging: rtl8192su: fix build warnings
      Staging: altpciechdma: fix build warnings
      Staging: slicoss: fix build warnings
      Staging: asus_oled: fix build warnings
      Staging: remove obsolete serqt_usb driver
      Staging: pata_rdc: add driver to the build system
      Staging: pata_rdc: convert code to work in 2.6.29
      Staging: pata_rdc: coding style fixes
      Staging: pata_rdc: remove function prototypes
      Staging: pata_rdc: use PCI_DEVICE
      Staging: pata_rdc: fix build warnings
      Staging: pata_rdc: remove broken flag
      Staging: pata_rdc: remove dbgprintf macro
      Staging: pata_rdc: remove DRIVER macros
      Staging: pata_rdc: remove pointless comments
      Staging: udlfb: add udlfb driver to build
      Staging: udlfb: clean up checkpatch warnings in udlfb.h
      Staging: udlfb: clean up checkpatch warnings in udlfb.c
      Staging: udlfb: fix some sparse warnings.
      Staging: comedi: fix build errors

Huang Weiyi (3):
      Staging: comedi: remove dupilcated #include
      Staging: rt3070: remove dupilcated #include
      Staging: remove unused #include <linux/version.h>'s

Ian Abbott (6):
      Staging: comedi: 'pcmcia_parse_tuple()' now has two arguments, not three.
      Staging: comedi: pcl818: Fix option handling for FIFO mode (hopefully!).
      Staging: comedi: pcl818: Tidy up AI command after channel dropout or similar error.
      Staging: comedi: Work around malformed RTAI_VERSION_CODE.
      Staging: comedi: Undo stupid commit made 3 months ago
      Staging: comedi: amplc_pc236: Corrected documentation.

J.R. Mauro (1):
      Staging: rspiusb: make driver compile

Jean Delvare (4):
      Staging: sxg: Add missing __devexit_p()
      Staging: rtl8187se: Use to_delayed_work
      Staging: altpciechdma: Add missing __devexit_p()
      Staging: slicoss: Add missing __devexit_p()

Jerry Chuang (1):
      Staging: add rtl8192SU wireless usb driver

Jiri Slaby (8):
      staging: comedi, remove interrupt.h
      staging: agnx, probe cleanup
      staging: agnx, remove memlens from probe
      staging: agnx, fix fail paths in probe
      staging: agnx, fix bssid compiler warnings
      staging: meilhaus, switch to misc device
      staging: meilhaus, annotate cpi functions
      staging: meilhaus, move tables to .c

Julia Lawall (3):
      Staging: wlan-ng: p80211wext.c: problem with IW_ENCODE_ALG_WEP
      Staging: cpc-usb: Adjust NULL test
      Staging: rtl8192su: Correct use of ! and &

Karl Relton (2):
      Staging: wlan-ng: Move firmware loading into driver
      Staging: wlan-ng: Change KERN_DEBUG or pr_debug to match orig driver

Kevin Huang (1):
      Staging: add pata_rdc driver

Manuel Gebele (3):
      Staging: comedi: add vmk80xx USB driver
      Staging: comedi: Makefile changes
      Staging: Comedi: vmk80xx: Add k8061 support

Mike Lockwood (1):
      Staging: android: timed_gpio: Separate timed_output class into a separate driver.

Mithlesh Thukral (2):
      Staging: wlan-ng: Lindent cleanups
      Staging: wlan-ng: Update README file. Remove Lindent task

Oleg Nesterov (1):
      Staging: epl: do not use CLONE_SIGHAND with allow_signal()

Pekka Enberg (16):
      Staging: w35und: remove unused code from wbsoft_configure_filter()
      Staging: w35und: replace switch error handling with gotos in wb35_hw_init()
      Staging: w35und: move hal_init_hardware() and hal_halt() int wbusb.c
      Staging: w35und: simplify error handling in wb35_hw_init()
      Staging: w35und: simplify hal_init_hardware() error handling
      Staging: w35und: more simplify hal_init_hardware() error handling
      Staging: w35und: simplify hal_init_hardware() and hal_halt()
      Staging: w35und: clean up comments in wbusb.c
      Staging: w35und: inline hal_set_phy_type() to wb35_hw_init()
      Staging: w35und: reformat wbusb.c
      Staging: w35und: remove MODULE_AUTHOR
      Staging: w35und: make led lookup tables static
      Staging: w35und: reformat wbhal.c
      Staging: w35und: merge wbhal.c to wbusb.c
      Staging: w35und: inline hal_set_rf_power() to mto.c
      Staging: w35und: merge rest of wbhal.c to phy_calibration.c

Randy Dunlap (2):
      Staging: comedi: uses udelay, needs delay.h
      Staging: vt6655: uses pci functions, should depend on PCI

Richard Genoud (3):
      Staging: rspiusb: clean rspiusb code
      Staging: rspiusb.c: break the huge piusb_ioctl function into several ones
      Staging: rspiusb: duplicate code in pixis_io

Robert P. J. Day (1):
      Staging: meilhaus: Remove long-deprecated SA_* interrupt macros.

Roberto De Ioris (2):
      Staging: add udlfb driver
      Staging: udlfb: update to version 0.2.3

Roel Kluin (7):
      Staging: comedi: non working tests on unsigned cmd->convert_arg
      staging: comedi: fix missing parentheses
      Staging: rtl8187se: wmm_param[1].ac_aci_acm_aifsn tested twice
      Staging: fix operator precedence errors
      Staging: otus: beyond ARRAY_SIZE of wd->ap.wds.encryMode
      staging: rtlxxxx: off by one in AsicSendCommandToMcu() and NDIS_STATUS NICLoadFirmware()
      staging: wis-sony-tuner.c: fix &&/|| error

Sebastian Haas (1):
      Staging: add cpc-usb driver to the staging tree

Serge E. Hallyn (1):
      staging: p9auth: prevent some oopses and memory leaks

Tim Gardner (1):
      Staging: winbond: mac80211 - unify config_interface and bss_info_changed

Tobias Klauser (1):
      Staging: pohmelfs: Storage class should be before const qualifier

vibi sreenivasan (2):
      Staging: rspiusb: Fix a bunch of warnings.
      Staging: rspiusb: copy_to/from_user related fixes

