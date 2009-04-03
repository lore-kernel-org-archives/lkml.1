Return-Path: <linux-kernel-owner+w=401wt.eu-S935254AbZDCWb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935254AbZDCWb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZDCWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:31:47 -0400
Received: from kroah.org ([198.145.64.141]:39865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753636AbZDCWbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:31:42 -0400
Date: Fri, 3 Apr 2009 15:29:02 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6.30 merge window
Message-ID: <20090403222902.GA22389@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big staging merge for the 2.6.30 merge window.

The diffstat summary sums it up nicely:
 713 files changed, 312473 insertions(+), 64562 deletions(-)
Lots of additions, and many cleanups.

Here's a short summary:
  - Comedi, it's all now included, all the drivers, and lots of cleanup
    has started to happen
  - slicoss cleanups and firmware move to proper place
  - sxg development and firmware move to proper place
  - w35und cleanups
  - wlan-ng cleanups
  - dst added
  - pohmelfs added
  - stlc45xx driver added
  - aten2011 usb driver added
  - b3dfg driver added
  - phison ata driver added
  - epl cleanups
  - p9auth driver added
  - rt3070 driver added
  - heci driver added
  - line6 usb driver added
  - serqt_usb driver added
  - lots of other bugfixes and cleanups

They are all selfcontained in the drivers/staging/ tree, with the
exception of some dst-needed header file changes and an export (approved
by the relevant subsystem maintainers) and the documentation and
firmware updates.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches, with the exception of the 3 build fixes (needed
due to the merge window churn) and firmware license update, have been in
the linux-next and -mm releases for the past few weeks.

As I really don't think anyone wants to see 714 patches of this crud,
I'll not copy any list, but if someone wants me to send them to them,
just let me know :)

thanks,

greg k-h

--------------

 .../filesystems/pohmelfs/design_notes.txt          |   70 +
 Documentation/filesystems/pohmelfs/info.txt        |   86 +
 .../filesystems/pohmelfs/network_protocol.txt      |  227 +
 drivers/staging/Kconfig                            |   22 +
 drivers/staging/Makefile                           |   11 +
 drivers/staging/agnx/agnx.h                        |   14 +-
 drivers/staging/agnx/debug.h                       |   21 +-
 drivers/staging/agnx/pci.c                         |   75 +-
 drivers/staging/agnx/phy.c                         |   32 +-
 drivers/staging/agnx/rf.c                          |   23 +-
 drivers/staging/agnx/sta.c                         |   21 +-
 drivers/staging/agnx/sta.h                         |    2 +-
 drivers/staging/agnx/table.c                       |   12 +-
 drivers/staging/agnx/xmit.c                        |  216 +-
 drivers/staging/altpciechdma/altpciechdma.c        |   80 +-
 drivers/staging/android/binder.c                   |   18 +-
 drivers/staging/android/ram_console.c              |    8 +-
 drivers/staging/asus_oled/asus_oled.c              |  149 +-
 drivers/staging/at76_usb/TODO                      |    9 +-
 drivers/staging/at76_usb/at76_usb.c                |   21 +-
 drivers/staging/at76_usb/at76_usb.h                |   87 +
 drivers/staging/b3dfg/Kconfig                      |    9 +
 drivers/staging/b3dfg/Makefile                     |    1 +
 drivers/staging/b3dfg/TODO                         |    4 +
 drivers/staging/b3dfg/b3dfg.c                      | 1119 +++
 drivers/staging/comedi/Kconfig                     |   14 +
 drivers/staging/comedi/comedi.h                    |   83 +-
 drivers/staging/comedi/comedi_compat32.c           |  128 +-
 drivers/staging/comedi/comedi_fops.c               |  293 +-
 drivers/staging/comedi/comedi_fops.h               |    1 +
 drivers/staging/comedi/comedi_ksyms.c              |   12 +-
 drivers/staging/comedi/comedi_rt.h                 |    9 +-
 drivers/staging/comedi/comedidev.h                 |  202 +-
 drivers/staging/comedi/comedilib.h                 |  114 +-
 drivers/staging/comedi/drivers.c                   |  187 +-
 drivers/staging/comedi/drivers/8253.h              |  420 +
 drivers/staging/comedi/drivers/8255.c              |  442 +
 drivers/staging/comedi/drivers/8255.h              |   57 +
 drivers/staging/comedi/drivers/Makefile            |  113 +-
 drivers/staging/comedi/drivers/acl7225b.c          |  149 +
 .../comedi/drivers/addi-data/APCI1710_82x54.c      | 1047 +++
 .../comedi/drivers/addi-data/APCI1710_82x54.h      |   73 +
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     | 2032 +++++
 .../comedi/drivers/addi-data/APCI1710_Chrono.h     |   74 +
 .../comedi/drivers/addi-data/APCI1710_Dig_io.c     | 1020 +++
 .../comedi/drivers/addi-data/APCI1710_Dig_io.h     |   46 +
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     | 5363 ++++++++++++
 .../comedi/drivers/addi-data/APCI1710_INCCPT.h     |  271 +
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.c    |  861 ++
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.h    |   47 +
 .../comedi/drivers/addi-data/APCI1710_Pwm.c        | 3588 ++++++++
 .../comedi/drivers/addi-data/APCI1710_Pwm.h        |   76 +
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |  848 ++
 .../comedi/drivers/addi-data/APCI1710_Ssi.h        |   43 +
 .../comedi/drivers/addi-data/APCI1710_Tor.c        | 2049 +++++
 .../comedi/drivers/addi-data/APCI1710_Tor.h        |   57 +
 .../comedi/drivers/addi-data/APCI1710_Ttl.c        | 1038 +++
 .../comedi/drivers/addi-data/APCI1710_Ttl.h        |   44 +
 .../comedi/drivers/addi-data/addi_amcc_S5920.c     |  203 +
 .../comedi/drivers/addi-data/addi_amcc_S5920.h     |   27 +
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |  476 +
 .../staging/comedi/drivers/addi-data/addi_common.c | 3062 +++++++
 .../staging/comedi/drivers/addi-data/addi_common.h |  462 +
 .../staging/comedi/drivers/addi-data/addi_eeprom.c | 1158 +++
 .../comedi/drivers/addi-data/amcc_s5933_58.h       |  457 +
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      | 1265 +++
 .../comedi/drivers/addi-data/hwdrv_APCI1710.h      |   71 +
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |  600 ++
 .../comedi/drivers/addi-data/hwdrv_apci035.h       |  123 +
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |  285 +
 .../comedi/drivers/addi-data/hwdrv_apci1032.h      |   63 +
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 3045 +++++++
 .../comedi/drivers/addi-data/hwdrv_apci1500.h      |  165 +
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |  542 ++
 .../comedi/drivers/addi-data/hwdrv_apci1516.h      |   64 +
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 1105 +++
 .../comedi/drivers/addi-data/hwdrv_apci1564.h      |  119 +
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |  780 ++
 .../comedi/drivers/addi-data/hwdrv_apci16xx.h      |   94 +
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |  460 +
 .../comedi/drivers/addi-data/hwdrv_apci2016.h      |   70 +
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |  579 ++
 .../comedi/drivers/addi-data/hwdrv_apci2032.h      |   81 +
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |  549 ++
 .../comedi/drivers/addi-data/hwdrv_apci2200.h      |   61 +
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 2697 ++++++
 .../comedi/drivers/addi-data/hwdrv_apci3120.h      |  241 +
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      | 3642 ++++++++
 .../comedi/drivers/addi-data/hwdrv_apci3200.h      |  187 +
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |  742 ++
 .../comedi/drivers/addi-data/hwdrv_apci3501.h      |   94 +
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      | 1691 ++++
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.h      |   62 +
 drivers/staging/comedi/drivers/addi_apci_035.c     |    5 +
 drivers/staging/comedi/drivers/addi_apci_1032.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_1564.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_1710.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_2016.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_3001.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_3200.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_3300.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |    3 +
 drivers/staging/comedi/drivers/addi_apci_all.c     |   18 +
 drivers/staging/comedi/drivers/adl_pci6208.c       |  391 +
 drivers/staging/comedi/drivers/adl_pci7296.c       |  174 +
 drivers/staging/comedi/drivers/adl_pci7432.c       |  202 +
 drivers/staging/comedi/drivers/adl_pci8164.c       |  512 ++
 drivers/staging/comedi/drivers/adl_pci9111.c       | 1391 +++
 drivers/staging/comedi/drivers/adl_pci9118.c       | 2100 +++++
 drivers/staging/comedi/drivers/adq12b.c            |  394 +
 drivers/staging/comedi/drivers/adv_pci1710.c       | 1568 ++++
 drivers/staging/comedi/drivers/adv_pci1723.c       |  465 +
 drivers/staging/comedi/drivers/adv_pci_dio.c       | 1077 +++
 drivers/staging/comedi/drivers/aio_aio12_8.c       |  226 +
 drivers/staging/comedi/drivers/aio_iiro_16.c       |  177 +
 drivers/staging/comedi/drivers/am9513.h            |   79 +
 drivers/staging/comedi/drivers/amcc_s5933.h        |  172 +
 drivers/staging/comedi/drivers/amplc_dio200.c      | 1483 ++++
 drivers/staging/comedi/drivers/amplc_pc236.c       |  654 ++
 drivers/staging/comedi/drivers/amplc_pc263.c       |  431 +
 drivers/staging/comedi/drivers/amplc_pci224.c      | 1545 ++++
 drivers/staging/comedi/drivers/amplc_pci230.c      | 2977 +++++++
 drivers/staging/comedi/drivers/c6xdigio.c          |  517 ++
 drivers/staging/comedi/drivers/cb_das16_cs.c       |  976 +++
 drivers/staging/comedi/drivers/cb_pcidas.c         | 1831 ++++
 drivers/staging/comedi/drivers/cb_pcidas64.c       | 4222 +++++++++
 drivers/staging/comedi/drivers/cb_pcidda.c         |  841 ++
 drivers/staging/comedi/drivers/cb_pcidio.c         |  294 +
 drivers/staging/comedi/drivers/cb_pcimdas.c        |  484 ++
 drivers/staging/comedi/drivers/cb_pcimdda.c        |  474 +
 drivers/staging/comedi/drivers/comedi_bond.c       |   56 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |   14 +-
 drivers/staging/comedi/drivers/comedi_fc.h         |   18 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |   44 +-
 drivers/staging/comedi/drivers/comedi_rt_timer.c   |  728 ++
 drivers/staging/comedi/drivers/comedi_test.c       |   80 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |  230 +
 drivers/staging/comedi/drivers/daqboard2000.c      |  877 ++
 drivers/staging/comedi/drivers/das08.c             | 1068 +++
 drivers/staging/comedi/drivers/das08.h             |   78 +
 drivers/staging/comedi/drivers/das08_cs.c          |  488 ++
 drivers/staging/comedi/drivers/das16.c             | 1730 ++++
 drivers/staging/comedi/drivers/das16m1.c           |  765 ++
 drivers/staging/comedi/drivers/das1800.c           | 1758 ++++
 drivers/staging/comedi/drivers/das6402.c           |  354 +
 drivers/staging/comedi/drivers/das800.c            |  894 ++
 drivers/staging/comedi/drivers/dmm32at.c           | 1081 +++
 drivers/staging/comedi/drivers/dt2801.c            |  697 ++
 drivers/staging/comedi/drivers/dt2811.c            |  604 ++
 drivers/staging/comedi/drivers/dt2814.c            |  383 +
 drivers/staging/comedi/drivers/dt2815.c            |  264 +
 drivers/staging/comedi/drivers/dt2817.c            |  178 +
 drivers/staging/comedi/drivers/dt282x.c            | 1471 ++++
 drivers/staging/comedi/drivers/dt3000.c            |  983 +++
 drivers/staging/comedi/drivers/dt9812.c            |   40 +-
 drivers/staging/comedi/drivers/fl512.c             |  186 +
 drivers/staging/comedi/drivers/gsc_hpdi.c          | 1060 +++
 drivers/staging/comedi/drivers/icp_multi.c         |  392 +-
 drivers/staging/comedi/drivers/icp_multi.h         |   19 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |  612 ++
 drivers/staging/comedi/drivers/jr3_pci.c           |  976 +++
 drivers/staging/comedi/drivers/jr3_pci.h           |  681 ++
 drivers/staging/comedi/drivers/ke_counter.c        |  254 +
 drivers/staging/comedi/drivers/me4000.c            |  296 +-
 drivers/staging/comedi/drivers/me4000.h            |  268 +-
 drivers/staging/comedi/drivers/me_daq.c            |   55 +-
 drivers/staging/comedi/drivers/mite.c              |   63 +-
 drivers/staging/comedi/drivers/mite.h              |   68 +-
 drivers/staging/comedi/drivers/mpc624.c            |  386 +
 drivers/staging/comedi/drivers/mpc8260cpm.c        |  169 +
 drivers/staging/comedi/drivers/multiq3.c           |  333 +
 drivers/staging/comedi/drivers/ni_6527.c           |  489 ++
 drivers/staging/comedi/drivers/ni_65xx.c           |  809 ++
 drivers/staging/comedi/drivers/ni_660x.c           | 1324 +++
 drivers/staging/comedi/drivers/ni_670x.c           |  337 +
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  909 ++
 drivers/staging/comedi/drivers/ni_at_ao.c          |  454 +
 drivers/staging/comedi/drivers/ni_atmio.c          |  513 ++
 drivers/staging/comedi/drivers/ni_atmio16d.c       |  860 ++
 drivers/staging/comedi/drivers/ni_daq_700.c        |  841 ++
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |  598 ++
 drivers/staging/comedi/drivers/ni_labpc.c          | 2005 +++++
 drivers/staging/comedi/drivers/ni_labpc.h          |   85 +
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |  573 ++
 drivers/staging/comedi/drivers/ni_mio_common.c     | 5862 +++++++++++++
 drivers/staging/comedi/drivers/ni_mio_cs.c         |  551 ++
 drivers/staging/comedi/drivers/ni_pcidio.c         | 1302 +++
 drivers/staging/comedi/drivers/ni_pcimio.c         | 1788 ++++
 drivers/staging/comedi/drivers/ni_stc.h            | 1498 ++++
 drivers/staging/comedi/drivers/ni_tio.c            | 1691 ++++
 drivers/staging/comedi/drivers/ni_tio.h            |  163 +
 drivers/staging/comedi/drivers/ni_tio_internal.h   |  774 ++
 drivers/staging/comedi/drivers/ni_tiocmd.c         |  523 ++
 drivers/staging/comedi/drivers/pcl711.c            |  623 ++
 drivers/staging/comedi/drivers/pcl724.c            |  222 +
 drivers/staging/comedi/drivers/pcl725.c            |  111 +
 drivers/staging/comedi/drivers/pcl726.c            |  377 +
 drivers/staging/comedi/drivers/pcl730.c            |  168 +
 drivers/staging/comedi/drivers/pcl812.c            | 1605 ++++
 drivers/staging/comedi/drivers/pcl816.c            | 1251 +++
 drivers/staging/comedi/drivers/pcl818.c            | 1988 +++++
 drivers/staging/comedi/drivers/pcm3724.c           |  307 +
 drivers/staging/comedi/drivers/pcm3730.c           |  152 +
 drivers/staging/comedi/drivers/pcmad.c             |  173 +
 drivers/staging/comedi/drivers/pcmda12.c           |  306 +
 drivers/staging/comedi/drivers/pcmmio.c            | 1333 +++
 drivers/staging/comedi/drivers/pcmuio.c            | 1101 +++
 drivers/staging/comedi/drivers/plx9052.h           |   86 +
 drivers/staging/comedi/drivers/plx9080.h           |   80 +-
 drivers/staging/comedi/drivers/poc.c               |  247 +
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   | 1363 +++
 drivers/staging/comedi/drivers/rtd520.c            |  277 +-
 drivers/staging/comedi/drivers/rtd520.h            |  676 +-
 drivers/staging/comedi/drivers/rti800.c            |  458 +
 drivers/staging/comedi/drivers/rti802.c            |  151 +
 drivers/staging/comedi/drivers/s526.c              |  977 +++
 drivers/staging/comedi/drivers/s626.c              | 2538 +++---
 drivers/staging/comedi/drivers/s626.h              | 1226 ++--
 drivers/staging/comedi/drivers/serial2002.c        |  870 ++
 drivers/staging/comedi/drivers/skel.c              |  624 ++
 drivers/staging/comedi/drivers/ssv_dnp.c           |  311 +
 drivers/staging/comedi/drivers/unioxx5.c           |  515 ++
 drivers/staging/comedi/drivers/usbdux.c            |  304 +-
 drivers/staging/comedi/drivers/usbduxfast.c        | 2028 +++--
 drivers/staging/comedi/interrupt.h                 |    9 -
 drivers/staging/comedi/kcomedilib/data.c           |   22 +-
 drivers/staging/comedi/kcomedilib/dio.c            |   18 +-
 drivers/staging/comedi/kcomedilib/get.c            |  132 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |  138 +-
 drivers/staging/comedi/kcomedilib/ksyms.c          |    4 -
 drivers/staging/comedi/pci_ids.h                   |    2 +-
 drivers/staging/comedi/proc.c                      |   17 +-
 drivers/staging/comedi/range.c                     |   35 +-
 drivers/staging/comedi/rt.c                        |   29 +-
 drivers/staging/comedi/rt_pend_tq.c                |    8 +-
 drivers/staging/dst/Kconfig                        |   67 +
 drivers/staging/dst/Makefile                       |    3 +
 drivers/staging/dst/crypto.c                       |  731 ++
 drivers/staging/dst/dcore.c                        |  995 +++
 drivers/staging/dst/export.c                       |  657 ++
 drivers/staging/dst/state.c                        |  839 ++
 drivers/staging/dst/thread_pool.c                  |  345 +
 drivers/staging/dst/trans.c                        |  335 +
 drivers/staging/echo/bit_operations.h              |   30 +-
 drivers/staging/echo/echo.c                        |   42 +-
 drivers/staging/echo/echo.h                        |    2 -
 drivers/staging/echo/fir.h                         |   28 +-
 drivers/staging/echo/mmx.h                         |  408 +-
 drivers/staging/epl/Benchmark.h                    |   12 -
 drivers/staging/epl/Debug.h                        |   48 +-
 drivers/staging/epl/Edrv8139.c                     |  108 +-
 drivers/staging/epl/EdrvFec.h                      |    6 +-
 drivers/staging/epl/EdrvFec5282.h                  |  340 -
 drivers/staging/epl/EdrvSim.h                      |    4 +-
 drivers/staging/epl/Epl.h                          |  139 +-
 drivers/staging/epl/EplAmi.h                       |  121 +-
 drivers/staging/epl/EplApiGeneric.c                |  188 +-
 drivers/staging/epl/EplApiLinuxKernel.c            |  105 +-
 drivers/staging/epl/EplApiProcessImage.c           |   31 +-
 drivers/staging/epl/EplDll.h                       |   50 +-
 drivers/staging/epl/EplDllCal.h                    |    2 +-
 drivers/staging/epl/EplDllk.c                      |  134 +-
 drivers/staging/epl/EplDllkCal.c                   |   14 +-
 drivers/staging/epl/EplDlluCal.c                   |    6 +-
 drivers/staging/epl/EplErrorHandlerk.c             |   36 +-
 drivers/staging/epl/EplEvent.h                     |    8 +-
 drivers/staging/epl/EplEventk.c                    |   24 +-
 drivers/staging/epl/EplEventu.c                    |   25 +-
 drivers/staging/epl/EplFrame.h                     |  166 +-
 drivers/staging/epl/EplIdentu.c                    |   26 +-
 drivers/staging/epl/EplInc.h                       |   23 +-
 drivers/staging/epl/EplInstDef.h                   |   60 +-
 drivers/staging/epl/EplNmt.h                       |    2 +-
 drivers/staging/epl/EplNmtCnu.c                    |   39 +-
 drivers/staging/epl/EplNmtMnu.c                    |  121 +-
 drivers/staging/epl/EplNmtk.c                      |   30 +-
 drivers/staging/epl/EplNmtkCal.c                   |    2 -
 drivers/staging/epl/EplNmtu.c                      |   22 +-
 drivers/staging/epl/EplNmtuCal.c                   |    2 +-
 drivers/staging/epl/EplObd.c                       |  444 +-
 drivers/staging/epl/EplObd.h                       |   58 +-
 drivers/staging/epl/EplObdMacro.h                  |   40 +-
 drivers/staging/epl/EplObdkCal.c                   |    1 -
 drivers/staging/epl/EplObdu.c                      |   69 +-
 drivers/staging/epl/EplObduCal.c                   |   75 +-
 drivers/staging/epl/EplObjDef.h                    |  208 -
 drivers/staging/epl/EplPdo.h                       |    6 +-
 drivers/staging/epl/EplPdok.c                      |   73 +-
 drivers/staging/epl/EplPdou.c                      |   34 +-
 drivers/staging/epl/EplSdo.h                       |   24 +-
 drivers/staging/epl/EplSdoAsndu.c                  |   26 +-
 drivers/staging/epl/EplSdoAsySequ.c                |   72 +-
 drivers/staging/epl/EplSdoComu.c                   |  153 +-
 drivers/staging/epl/EplSdoUdpu.c                   |  163 +-
 drivers/staging/epl/EplStatusu.c                   |   19 +-
 drivers/staging/epl/EplTarget.h                    |  109 +-
 drivers/staging/epl/EplTimer.h                     |    3 +-
 drivers/staging/epl/EplTimeruLinuxKernel.c         |   26 +-
 drivers/staging/epl/EplTimeruNull.c                |  312 -
 drivers/staging/epl/EplTimeruWin32.c               |  513 --
 drivers/staging/epl/SharedBuff.c                   |  111 +-
 drivers/staging/epl/SharedBuff.h                   |   17 -
 drivers/staging/epl/ShbIpc-LinuxKernel.c           |   48 +-
 drivers/staging/epl/ShbIpc-Win32.c                 | 1202 ---
 drivers/staging/epl/ShbIpc.h                       |   26 -
 drivers/staging/epl/TimerHighReskX86.c             |   34 +-
 drivers/staging/epl/VirtualEthernetLinux.c         |    5 +-
 drivers/staging/epl/amix86.c                       |  316 +-
 drivers/staging/epl/demo_main.c                    |   84 +-
 drivers/staging/epl/edrv.h                         |   22 +-
 drivers/staging/epl/global.h                       | 1253 +---
 drivers/staging/epl/kernel/EplDllk.h               |   24 +-
 drivers/staging/epl/kernel/EplDllkCal.h            |   14 +-
 drivers/staging/epl/kernel/EplErrorHandlerk.h      |   20 +-
 drivers/staging/epl/kernel/EplEventk.h             |   28 +-
 drivers/staging/epl/kernel/EplNmtk.h               |   25 +-
 drivers/staging/epl/kernel/EplNmtkCal.h            |   89 -
 drivers/staging/epl/kernel/EplObdk.h               |  122 +-
 drivers/staging/epl/kernel/EplObdkCal.h            |   89 -
 drivers/staging/epl/kernel/EplPdok.h               |   12 -
 drivers/staging/epl/kernel/EplPdokCal.h            |   13 -
 drivers/staging/epl/kernel/EplTimerHighResk.h      |   43 +-
 drivers/staging/epl/kernel/EplTimerk.h             |   36 +-
 drivers/staging/epl/kernel/VirtualEthernet.h       |   16 +-
 drivers/staging/epl/proc_fs.c                      |   23 +-
 drivers/staging/epl/user/EplCfgMau.h               |   80 +-
 drivers/staging/epl/user/EplDllu.h                 |   14 +-
 drivers/staging/epl/user/EplDlluCal.h              |   15 +-
 drivers/staging/epl/user/EplEventu.h               |   28 +-
 drivers/staging/epl/user/EplIdentu.h               |   34 +-
 drivers/staging/epl/user/EplLedu.h                 |   32 +-
 drivers/staging/epl/user/EplNmtCnu.h               |   32 +-
 drivers/staging/epl/user/EplNmtMnu.h               |   42 +-
 drivers/staging/epl/user/EplNmtu.h                 |   38 +-
 drivers/staging/epl/user/EplNmtuCal.h              |   17 +-
 drivers/staging/epl/user/EplObdu.h                 |   83 +-
 drivers/staging/epl/user/EplObduCal.h              |   94 +-
 drivers/staging/epl/user/EplPdou.h                 |   22 +-
 drivers/staging/epl/user/EplSdoAsndu.h             |   33 +-
 drivers/staging/epl/user/EplSdoAsySequ.h           |   41 +-
 drivers/staging/epl/user/EplSdoComu.h              |   48 +-
 drivers/staging/epl/user/EplSdoUdpu.h              |   34 +-
 drivers/staging/epl/user/EplStatusu.h              |   32 +-
 drivers/staging/epl/user/EplTimeru.h               |   38 +-
 drivers/staging/et131x/et1310_rx.c                 |    3 +-
 drivers/staging/frontier/README                    |   53 +-
 drivers/staging/frontier/alphatrack.c              |  383 +-
 drivers/staging/frontier/alphatrack.h              |   80 +-
 drivers/staging/frontier/frontier_compat.h         |   63 -
 drivers/staging/frontier/surface_sysfs.h           |  100 -
 drivers/staging/frontier/tranzport.c               |  685 +-
 drivers/staging/go7007/go7007-v4l2.c               |    1 -
 drivers/staging/go7007/s2250-board.c               |    7 +-
 drivers/staging/heci/Kconfig                       |    6 +
 drivers/staging/heci/Makefile                      |    9 +
 drivers/staging/heci/TODO                          |    6 +
 drivers/staging/heci/heci.h                        |  176 +
 drivers/staging/heci/heci_data_structures.h        |  530 ++
 drivers/staging/heci/heci_init.c                   | 1077 +++
 drivers/staging/heci/heci_interface.c              |  485 ++
 drivers/staging/heci/heci_interface.h              |  170 +
 drivers/staging/heci/heci_main.c                   | 1564 ++++
 drivers/staging/heci/heci_version.h                |   54 +
 drivers/staging/heci/interrupt.c                   | 1553 ++++
 drivers/staging/heci/io_heci.c                     |  847 ++
 drivers/staging/line6/Kconfig                      |   21 +
 drivers/staging/line6/Makefile                     |   15 +
 drivers/staging/line6/audio.c                      |   72 +
 drivers/staging/line6/audio.h                      |   24 +
 drivers/staging/line6/capture.c                    |  372 +
 drivers/staging/line6/capture.h                    |   32 +
 drivers/staging/line6/config.h                     |   48 +
 drivers/staging/line6/control.c                    |  840 ++
 drivers/staging/line6/control.h                    |  187 +
 drivers/staging/line6/driver.c                     | 1102 +++
 drivers/staging/line6/driver.h                     |  204 +
 drivers/staging/line6/dumprequest.c                |  151 +
 drivers/staging/line6/dumprequest.h                |   90 +
 drivers/staging/line6/midi.c                       |  422 +
 drivers/staging/line6/midi.h                       |   87 +
 drivers/staging/line6/midibuf.c                    |  262 +
 drivers/staging/line6/midibuf.h                    |   39 +
 drivers/staging/line6/pcm.c                        |  301 +
 drivers/staging/line6/pcm.h                        |  222 +
 drivers/staging/line6/playback.c                   |  427 +
 drivers/staging/line6/playback.h                   |   30 +
 drivers/staging/line6/pod.c                        | 1151 +++
 drivers/staging/line6/pod.h                        |  204 +
 drivers/staging/line6/revision.h                   |    4 +
 drivers/staging/line6/toneport.c                   |  241 +
 drivers/staging/line6/toneport.h                   |   45 +
 drivers/staging/line6/usbdefs.h                    |   74 +
 drivers/staging/line6/variax.c                     |  546 ++
 drivers/staging/line6/variax.h                     |  108 +
 drivers/staging/me4000/me4000.c                    |  193 +-
 drivers/staging/meilhaus/me0600_device.c           |    4 +-
 drivers/staging/meilhaus/me0600_dio.c              |   18 +-
 drivers/staging/meilhaus/me0600_ext_irq.c          |    8 +-
 drivers/staging/meilhaus/me0600_optoi.c            |   14 +-
 drivers/staging/meilhaus/me0600_relay.c            |   14 +-
 drivers/staging/meilhaus/me0600_ttli.c             |   12 +-
 drivers/staging/meilhaus/me0900_device.c           |    4 +-
 drivers/staging/meilhaus/me0900_di.c               |   12 +-
 drivers/staging/meilhaus/me0900_do.c               |   14 +-
 drivers/staging/meilhaus/me1000_device.c           |    8 +-
 drivers/staging/meilhaus/me1000_dio.c              |    4 +-
 drivers/staging/meilhaus/me1400_device.c           |    4 +-
 drivers/staging/meilhaus/me1400_ext_irq.c          |    7 +-
 drivers/staging/meilhaus/me1600_ao.c               |   70 +-
 drivers/staging/meilhaus/me1600_ao.h               |    4 -
 drivers/staging/meilhaus/me1600_device.c           |    8 +-
 drivers/staging/meilhaus/me4600_ai.c               |  157 +-
 drivers/staging/meilhaus/me4600_ai.h               |    4 -
 drivers/staging/meilhaus/me4600_ao.c               |  191 +-
 drivers/staging/meilhaus/me4600_ao.h               |    4 -
 drivers/staging/meilhaus/me4600_device.c           |    4 +-
 drivers/staging/meilhaus/me4600_di.c               |   14 +-
 drivers/staging/meilhaus/me4600_dio.c              |   16 +-
 drivers/staging/meilhaus/me4600_do.c               |   16 +-
 drivers/staging/meilhaus/me4600_ext_irq.c          |   21 +-
 drivers/staging/meilhaus/me6000_ao.c               |  146 +-
 drivers/staging/meilhaus/me6000_ao.h               |    4 -
 drivers/staging/meilhaus/me6000_device.c           |    4 +-
 drivers/staging/meilhaus/me6000_dio.c              |   16 +-
 drivers/staging/meilhaus/me8100_device.c           |    4 +-
 drivers/staging/meilhaus/me8100_di.c               |   24 +-
 drivers/staging/meilhaus/me8100_do.c               |   16 +-
 drivers/staging/meilhaus/me8200_device.c           |    4 +-
 drivers/staging/meilhaus/me8200_di.c               |   58 +-
 drivers/staging/meilhaus/me8200_dio.c              |   16 +-
 drivers/staging/meilhaus/me8200_do.c               |   26 +-
 drivers/staging/meilhaus/me8254.c                  |   14 +-
 drivers/staging/meilhaus/me8255.c                  |    4 +-
 drivers/staging/meilhaus/mecirc_buf.h              |   16 +-
 drivers/staging/meilhaus/medevice.c                |   14 +-
 drivers/staging/meilhaus/medlist.c                 |    6 +-
 drivers/staging/meilhaus/medlock.c                 |    4 +-
 drivers/staging/meilhaus/medummy.c                 |   84 +-
 drivers/staging/meilhaus/memain.c                  |   34 +-
 drivers/staging/meilhaus/meslist.c                 |    6 +-
 drivers/staging/meilhaus/meslock.c                 |    2 +-
 drivers/staging/meilhaus/mesubdevice.c             |   12 +-
 drivers/staging/meilhaus/metempl_device.c          |    4 +-
 drivers/staging/meilhaus/metempl_sub.c             |   10 +-
 drivers/staging/mimio/Kconfig                      |    2 +-
 drivers/staging/otus/80211core/amsdu.c             |  145 +-
 drivers/staging/otus/80211core/cmmsta.c            |    5 +-
 drivers/staging/otus/80211core/coid.c              |    8 +-
 drivers/staging/otus/80211core/cwm.c               |    6 +-
 drivers/staging/otus/TODO                          |    9 +-
 drivers/staging/otus/hal/hpani.c                   |   46 +-
 drivers/staging/otus/hal/hpmain.c                  |   99 +-
 drivers/staging/otus/hal/hpreg.c                   |    9 +-
 drivers/staging/otus/hal/hprw.c                    |   30 +-
 drivers/staging/otus/hal/hpusb.c                   |   11 +-
 drivers/staging/otus/ioctl.c                       | 4789 +++++------
 drivers/staging/otus/usbdrv.c                      |   12 +-
 drivers/staging/otus/wwrap.c                       |    6 +-
 drivers/staging/otus/zdcompat.h                    |    7 -
 drivers/staging/p9auth/Kconfig                     |    9 +
 drivers/staging/p9auth/Makefile                    |    1 +
 drivers/staging/p9auth/p9auth.c                    |  383 +
 drivers/staging/phison/Kconfig                     |    5 +
 drivers/staging/phison/Makefile                    |    1 +
 drivers/staging/phison/phison.c                    |  106 +
 drivers/staging/pohmelfs/Kconfig                   |   28 +
 drivers/staging/pohmelfs/Makefile                  |    3 +
 drivers/staging/pohmelfs/config.c                  |  478 +
 drivers/staging/pohmelfs/crypto.c                  |  880 ++
 drivers/staging/pohmelfs/dir.c                     | 1093 +++
 drivers/staging/pohmelfs/inode.c                   | 1976 +++++
 drivers/staging/pohmelfs/lock.c                    |  182 +
 drivers/staging/pohmelfs/mcache.c                  |  171 +
 drivers/staging/pohmelfs/net.c                     | 1247 +++
 drivers/staging/pohmelfs/netfs.h                   |  932 ++
 drivers/staging/pohmelfs/path_entry.c              |  114 +
 drivers/staging/pohmelfs/trans.c                   |  715 ++
 drivers/staging/rspiusb/rspiusb.c                  |    5 +-
 drivers/staging/rt2860/2860_main_dev.c             |   50 +-
 drivers/staging/rt2860/Makefile                    |    1 -
 drivers/staging/rt2860/TODO                        |    4 +-
 drivers/staging/rt2860/common/cmm_data.c           |   27 +-
 drivers/staging/rt2860/common/cmm_data_2860.c      |  144 +-
 drivers/staging/rt2860/common/cmm_info.c           |    6 -
 drivers/staging/rt2860/common/cmm_sync.c           |    2 +-
 drivers/staging/rt2860/common/cmm_wpa.c            |   40 +-
 drivers/staging/rt2860/common/mlme.c               |  289 +-
 drivers/staging/rt2860/common/rtmp_init.c          |  157 +-
 drivers/staging/rt2860/common/spectrum.c           |    2 +-
 drivers/staging/rt2860/config.mk                   |    4 -
 drivers/staging/rt2860/oid.h                       |    2 +
 drivers/staging/rt2860/rt2860.h                    |   22 +-
 drivers/staging/rt2860/rt28xx.h                    |    4 -
 drivers/staging/rt2860/rt_ate.c                    |   18 +-
 drivers/staging/rt2860/rt_ate.h                    |    6 -
 drivers/staging/rt2860/rt_config.h                 |    2 -
 drivers/staging/rt2860/rt_linux.c                  |   29 +-
 drivers/staging/rt2860/rt_linux.h                  |   49 +-
 drivers/staging/rt2860/rt_main_dev.c               |  149 +-
 drivers/staging/rt2860/rt_profile.c                |    2 +-
 drivers/staging/rt2860/rtmp.h                      |   61 +-
 drivers/staging/rt2860/rtmp_def.h                  |   29 +-
 drivers/staging/rt2860/sta/assoc.c                 |   23 +-
 drivers/staging/rt2860/sta/connect.c               |   45 +-
 drivers/staging/rt2860/sta/dls.c                   |    4 -
 drivers/staging/rt2860/sta/rtmp_data.c             |   29 +-
 drivers/staging/rt2860/sta/sync.c                  |   16 +-
 drivers/staging/rt2860/sta/wpa.c                   |   10 +-
 drivers/staging/rt2860/sta_ioctl.c                 |   96 +-
 drivers/staging/rt2860/wpa.h                       |    1 +
 drivers/staging/rt2870/2870_main_dev.c             |   67 +-
 drivers/staging/rt2870/TODO                        |    9 +-
 drivers/staging/rt2870/common/2870_rtmp_init.c     |   35 +-
 drivers/staging/rt2870/common/cmm_data.c           |    3 -
 drivers/staging/rt2870/common/rtmp_init.c          |    2 +-
 drivers/staging/rt2870/common/rtusb_io.c           |    3 +-
 drivers/staging/rt2870/common/spectrum.c           |    2 +-
 drivers/staging/rt2870/rt2870.h                    |    7 +-
 drivers/staging/rt2870/rt_linux.c                  |    2 +-
 drivers/staging/rt2870/rt_linux.h                  |   12 +-
 drivers/staging/rt2870/sta_ioctl.c                 |    2 +-
 drivers/staging/rt3070/2870_main_dev.c             | 1627 ++++
 drivers/staging/rt3070/Kconfig                     |    6 +
 drivers/staging/rt3070/Makefile                    |   47 +
 drivers/staging/rt3070/action.h                    |   68 +
 drivers/staging/rt3070/aironet.h                   |  210 +
 drivers/staging/rt3070/ap.h                        |  557 ++
 drivers/staging/rt3070/chlist.h                    | 1253 +++
 drivers/staging/rt3070/common/2870_rtmp_init.c     | 1762 ++++
 drivers/staging/rt3070/common/action.c             | 1038 +++
 drivers/staging/rt3070/common/ba_action.c          | 1810 ++++
 drivers/staging/rt3070/common/cmm_data.c           | 2827 ++++++
 drivers/staging/rt3070/common/cmm_data_2870.c      |  980 +++
 drivers/staging/rt3070/common/cmm_info.c           | 3395 ++++++++
 drivers/staging/rt3070/common/cmm_sanity.c         | 1669 ++++
 drivers/staging/rt3070/common/cmm_sync.c           |  711 ++
 drivers/staging/rt3070/common/cmm_wpa.c            | 1606 ++++
 drivers/staging/rt3070/common/dfs.c                |  441 +
 drivers/staging/rt3070/common/eeprom.c             | 1498 ++++
 drivers/staging/rt3070/common/md5.c                | 1427 +++
 drivers/staging/rt3070/common/mlme.c               | 9136 ++++++++++++++++++++
 drivers/staging/rt3070/common/netif_block.c        |  136 +
 drivers/staging/rt3070/common/rtmp_init.c          | 4197 +++++++++
 drivers/staging/rt3070/common/rtmp_tkip.c          | 1613 ++++
 drivers/staging/rt3070/common/rtmp_wep.c           |  508 ++
 drivers/staging/rt3070/common/rtusb_bulk.c         | 1382 +++
 drivers/staging/rt3070/common/rtusb_data.c         |  218 +
 drivers/staging/rt3070/common/rtusb_io.c           | 1908 ++++
 drivers/staging/rt3070/common/spectrum.c           | 1876 ++++
 drivers/staging/rt3070/dfs.h                       |  100 +
 drivers/staging/rt3070/firmware.h                  |  558 ++
 drivers/staging/rt3070/leap.h                      |  215 +
 drivers/staging/rt3070/link_list.h                 |  134 +
 drivers/staging/rt3070/md4.h                       |   42 +
 drivers/staging/rt3070/md5.h                       |  107 +
 drivers/staging/rt3070/mlme.h                      | 1468 ++++
 drivers/staging/rt3070/netif_block.h               |   58 +
 drivers/staging/rt3070/oid.h                       | 1142 +++
 drivers/staging/rt3070/rt2870.h                    |  756 ++
 drivers/staging/rt3070/rt28xx.h                    | 2725 ++++++
 drivers/staging/rt3070/rt_ate.c                    | 6506 ++++++++++++++
 drivers/staging/rt3070/rt_ate.h                    |  294 +
 drivers/staging/rt3070/rt_config.h                 |  121 +
 drivers/staging/rt3070/rt_linux.c                  | 1063 +++
 drivers/staging/rt3070/rt_linux.h                  |  887 ++
 drivers/staging/rt3070/rt_main_dev.c               | 1800 ++++
 drivers/staging/rt3070/rt_profile.c                | 2041 +++++
 drivers/staging/rt3070/rtmp.h                      | 7728 +++++++++++++++++
 drivers/staging/rt3070/rtmp_ckipmic.h              |  113 +
 drivers/staging/rt3070/rtmp_def.h                  | 1559 ++++
 drivers/staging/rt3070/rtmp_type.h                 |   95 +
 drivers/staging/rt3070/spectrum.h                  |  322 +
 drivers/staging/rt3070/spectrum_def.h              |   95 +
 drivers/staging/rt3070/sta/aironet.c               | 1312 +++
 drivers/staging/rt3070/sta/assoc.c                 | 2060 +++++
 drivers/staging/rt3070/sta/auth.c                  |  475 +
 drivers/staging/rt3070/sta/auth_rsp.c              |  167 +
 drivers/staging/rt3070/sta/connect.c               | 2857 ++++++
 drivers/staging/rt3070/sta/dls.c                   | 2170 +++++
 drivers/staging/rt3070/sta/rtmp_data.c             | 2637 ++++++
 drivers/staging/rt3070/sta/sanity.c                |  420 +
 drivers/staging/rt3070/sta/sync.c                  | 1755 ++++
 drivers/staging/rt3070/sta/wpa.c                   | 2099 +++++
 drivers/staging/rt3070/sta_ioctl.c                 | 7203 +++++++++++++++
 drivers/staging/rt3070/wpa.h                       |  356 +
 drivers/staging/rtl8187se/dot11d.h                 |  202 +-
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |  492 +-
 drivers/staging/rtl8187se/ieee80211/dot11d.h       |  204 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    4 +-
 drivers/staging/rtl8187se/r8180_core.c             |    2 +-
 drivers/staging/rtl8187se/r8180_dm.c               | 3450 ++++----
 drivers/staging/rtl8187se/r8180_dm.h               |   82 +-
 drivers/staging/rtl8187se/r8180_wx.c               |   12 +-
 drivers/staging/serqt_usb/Kconfig                  |    9 +
 drivers/staging/serqt_usb/Makefile                 |    1 +
 drivers/staging/serqt_usb/TODO                     |    8 +
 drivers/staging/serqt_usb/serqt_usb.c              | 2779 ++++++
 drivers/staging/slicoss/gbdownload.h               | 8215 ------------------
 drivers/staging/slicoss/gbrcvucode.h               |  238 -
 drivers/staging/slicoss/oasisdbgdownload.h         | 6850 ---------------
 drivers/staging/slicoss/oasisdownload.h            | 6848 ---------------
 drivers/staging/slicoss/oasisrcvucode.h            |  205 -
 drivers/staging/slicoss/slic.h                     |   86 +-
 drivers/staging/slicoss/slic_os.h                  |   84 -
 drivers/staging/slicoss/slicbuild.h                |   96 -
 drivers/staging/slicoss/slicdbg.h                  |  100 -
 drivers/staging/slicoss/slicdump.h                 |  278 -
 drivers/staging/slicoss/slichw.h                   | 1038 ++--
 drivers/staging/slicoss/slicinc.h                  |  185 -
 drivers/staging/slicoss/slicoss.c                  | 2913 ++-----
 drivers/staging/stlc45xx/Kconfig                   |    8 +
 drivers/staging/stlc45xx/Makefile                  |    1 +
 drivers/staging/stlc45xx/stlc45xx.c                | 2606 ++++++
 drivers/staging/stlc45xx/stlc45xx.h                |  283 +
 drivers/staging/stlc45xx/stlc45xx_lmac.h           |  434 +
 drivers/staging/sxg/Kconfig                        |    2 +-
 drivers/staging/sxg/Makefile                       |    4 +-
 drivers/staging/sxg/saharadbgdownload.h            | 4854 -----------
 drivers/staging/sxg/sxg.c                          | 2885 ++++---
 drivers/staging/sxg/sxg.h                          |  919 +-
 drivers/staging/sxg/sxg_ethtool.c                  |  328 +
 drivers/staging/sxg/sxg_os.h                       |  100 +-
 drivers/staging/sxg/sxgdbg.h                       |  129 +-
 drivers/staging/sxg/sxghif.h                       | 1110 ++-
 drivers/staging/sxg/sxghw.h                        | 1564 ++--
 drivers/staging/sxg/sxgphycode-1.2.h               |  130 +
 drivers/staging/sxg/sxgphycode.h                   |  349 -
 drivers/staging/uc2322/Kconfig                     |   10 +
 drivers/staging/uc2322/Makefile                    |    1 +
 drivers/staging/uc2322/TODO                        |    7 +
 drivers/staging/uc2322/aten2011.c                  | 2452 ++++++
 drivers/staging/usbip/stub_rx.c                    |    4 +-
 drivers/staging/usbip/vhci_sysfs.c                 |    3 +-
 drivers/staging/winbond/bss_f.h                    |   63 -
 drivers/staging/winbond/bssdscpt.h                 |  164 -
 drivers/staging/winbond/common.h                   |   27 -
 drivers/staging/winbond/core.h                     |    7 +-
 drivers/staging/winbond/ds_tkip.h                  |   37 -
 drivers/staging/winbond/gl_80211.h                 |  126 -
 drivers/staging/winbond/ioctls.h                   |  678 --
 drivers/staging/winbond/mds.c                      |   26 +-
 drivers/staging/winbond/mds_s.h                    |   24 +-
 drivers/staging/winbond/mlme_mib.h                 |   84 -
 drivers/staging/winbond/mlmetxrx.c                 |    2 +-
 drivers/staging/winbond/mto.c                      |   24 +-
 drivers/staging/winbond/mto.h                      |   12 +-
 drivers/staging/winbond/mto_f.h                    |   13 -
 drivers/staging/winbond/os_common.h                |    2 -
 drivers/staging/winbond/phy_calibration.c          |   28 +-
 drivers/staging/winbond/phy_calibration.h          |    2 +-
 drivers/staging/winbond/reg.c                      |   81 +-
 drivers/staging/winbond/sme_api.h                  |    3 -
 drivers/staging/winbond/sme_s.h                    |  236 -
 drivers/staging/winbond/wb35_ver.h                 |   30 -
 drivers/staging/winbond/wb35reg.c                  |   41 +-
 drivers/staging/winbond/wb35reg_f.h                |   70 +-
 drivers/staging/winbond/wb35rx.c                   |   43 +-
 drivers/staging/winbond/wb35rx_f.h                 |    6 +-
 drivers/staging/winbond/wb35rx_s.h                 |    8 +-
 drivers/staging/winbond/wb35tx.c                   |   54 +-
 drivers/staging/winbond/wb35tx_f.h                 |    8 +-
 drivers/staging/winbond/wb35tx_s.h                 |    6 +-
 drivers/staging/winbond/wbhal.c                    |   50 +-
 drivers/staging/winbond/wbhal_f.h                  |   94 +-
 drivers/staging/winbond/wbhal_s.h                  |   87 +-
 drivers/staging/winbond/wbusb.c                    |   20 +-
 drivers/staging/winbond/wbusb_s.h                  |   16 +-
 drivers/staging/wlan-ng/README                     |    4 +-
 drivers/staging/wlan-ng/hfa384x.h                  | 2638 ++-----
 drivers/staging/wlan-ng/hfa384x_usb.c              | 2295 ++---
 drivers/staging/wlan-ng/p80211conv.c               |  377 +-
 drivers/staging/wlan-ng/p80211conv.h               |  131 +-
 drivers/staging/wlan-ng/p80211hdr.h                |  146 +-
 drivers/staging/wlan-ng/p80211ioctl.h              |   46 +-
 drivers/staging/wlan-ng/p80211meta.h               |  110 +-
 drivers/staging/wlan-ng/p80211metadef.h            |  544 --
 drivers/staging/wlan-ng/p80211metamib.h            |  105 -
 drivers/staging/wlan-ng/p80211metamsg.h            |  105 -
 drivers/staging/wlan-ng/p80211metastruct.h         |  424 +-
 drivers/staging/wlan-ng/p80211mgmt.h               |  441 +-
 drivers/staging/wlan-ng/p80211msg.h                |   48 +-
 drivers/staging/wlan-ng/p80211netdev.c             |  411 +-
 drivers/staging/wlan-ng/p80211netdev.h             |  218 +-
 drivers/staging/wlan-ng/p80211req.c                |  235 +-
 drivers/staging/wlan-ng/p80211req.h                |   17 +-
 drivers/staging/wlan-ng/p80211types.h              |  505 +-
 drivers/staging/wlan-ng/p80211wep.c                |   24 +-
 drivers/staging/wlan-ng/p80211wext.c               | 1214 ++--
 drivers/staging/wlan-ng/prism2mgmt.c               |  899 +-
 drivers/staging/wlan-ng/prism2mgmt.h               |   69 +-
 drivers/staging/wlan-ng/prism2mib.c                |  905 +--
 drivers/staging/wlan-ng/prism2sta.c                | 1561 ++--
 drivers/staging/wlan-ng/prism2usb.c                |  158 +-
 drivers/staging/wlan-ng/wlan_compat.h              |  193 -
 firmware/Makefile                                  |    6 +
 firmware/WHENCE                                    |   53 +
 firmware/slicoss/gbdownload.sys.ihex               | 6148 +++++++++++++
 firmware/slicoss/gbrcvucode.sys.ihex               |  162 +
 firmware/slicoss/oasisdbgdownload.sys.ihex         | 5124 +++++++++++
 firmware/slicoss/oasisdownload.sys.ihex            | 5124 +++++++++++
 firmware/slicoss/oasisrcvucode.sys.ihex            |  162 +
 firmware/sxg/saharadbgdownloadB.sys.ihex           | 3937 +++++++++
 firmware/sxg/saharadownloadB.sys.ihex              | 3385 ++++++++
 include/linux/connector.h                          |    4 +-
 include/linux/dst.h                                |  587 ++
 mm/filemap.c                                       |    2 +
 713 files changed, 312473 insertions(+), 64562 deletions(-)
 create mode 100644 Documentation/filesystems/pohmelfs/design_notes.txt
 create mode 100644 Documentation/filesystems/pohmelfs/info.txt
 create mode 100644 Documentation/filesystems/pohmelfs/network_protocol.txt
 create mode 100644 drivers/staging/b3dfg/Kconfig
 create mode 100644 drivers/staging/b3dfg/Makefile
 create mode 100644 drivers/staging/b3dfg/TODO
 create mode 100644 drivers/staging/b3dfg/b3dfg.c
 create mode 100644 drivers/staging/comedi/drivers/8253.h
 create mode 100644 drivers/staging/comedi/drivers/8255.c
 create mode 100644 drivers/staging/comedi/drivers/8255.h
 create mode 100644 drivers/staging/comedi/drivers/acl7225b.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/addi_common.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/addi_common.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
 create mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_035.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_1032.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_1500.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_1516.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_1564.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_16xx.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_1710.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_2016.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_2032.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_2200.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_3001.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_3120.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_3200.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_3300.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_3501.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_3xxx.c
 create mode 100644 drivers/staging/comedi/drivers/addi_apci_all.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci6208.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci7296.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci7432.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci8164.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci9111.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci9118.c
 create mode 100644 drivers/staging/comedi/drivers/adq12b.c
 create mode 100644 drivers/staging/comedi/drivers/adv_pci1710.c
 create mode 100644 drivers/staging/comedi/drivers/adv_pci1723.c
 create mode 100644 drivers/staging/comedi/drivers/adv_pci_dio.c
 create mode 100644 drivers/staging/comedi/drivers/aio_aio12_8.c
 create mode 100644 drivers/staging/comedi/drivers/aio_iiro_16.c
 create mode 100644 drivers/staging/comedi/drivers/am9513.h
 create mode 100644 drivers/staging/comedi/drivers/amcc_s5933.h
 create mode 100644 drivers/staging/comedi/drivers/amplc_dio200.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pc236.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pc263.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pci224.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pci230.c
 create mode 100644 drivers/staging/comedi/drivers/c6xdigio.c
 create mode 100644 drivers/staging/comedi/drivers/cb_das16_cs.c
 create mode 100644 drivers/staging/comedi/drivers/cb_pcidas.c
 create mode 100644 drivers/staging/comedi/drivers/cb_pcidas64.c
 create mode 100644 drivers/staging/comedi/drivers/cb_pcidda.c
 create mode 100644 drivers/staging/comedi/drivers/cb_pcidio.c
 create mode 100644 drivers/staging/comedi/drivers/cb_pcimdas.c
 create mode 100644 drivers/staging/comedi/drivers/cb_pcimdda.c
 create mode 100644 drivers/staging/comedi/drivers/comedi_rt_timer.c
 create mode 100644 drivers/staging/comedi/drivers/contec_pci_dio.c
 create mode 100644 drivers/staging/comedi/drivers/daqboard2000.c
 create mode 100644 drivers/staging/comedi/drivers/das08.c
 create mode 100644 drivers/staging/comedi/drivers/das08.h
 create mode 100644 drivers/staging/comedi/drivers/das08_cs.c
 create mode 100644 drivers/staging/comedi/drivers/das16.c
 create mode 100644 drivers/staging/comedi/drivers/das16m1.c
 create mode 100644 drivers/staging/comedi/drivers/das1800.c
 create mode 100644 drivers/staging/comedi/drivers/das6402.c
 create mode 100644 drivers/staging/comedi/drivers/das800.c
 create mode 100644 drivers/staging/comedi/drivers/dmm32at.c
 create mode 100644 drivers/staging/comedi/drivers/dt2801.c
 create mode 100644 drivers/staging/comedi/drivers/dt2811.c
 create mode 100644 drivers/staging/comedi/drivers/dt2814.c
 create mode 100644 drivers/staging/comedi/drivers/dt2815.c
 create mode 100644 drivers/staging/comedi/drivers/dt2817.c
 create mode 100644 drivers/staging/comedi/drivers/dt282x.c
 create mode 100644 drivers/staging/comedi/drivers/dt3000.c
 create mode 100644 drivers/staging/comedi/drivers/fl512.c
 create mode 100644 drivers/staging/comedi/drivers/gsc_hpdi.c
 create mode 100644 drivers/staging/comedi/drivers/ii_pci20kc.c
 create mode 100644 drivers/staging/comedi/drivers/jr3_pci.c
 create mode 100644 drivers/staging/comedi/drivers/jr3_pci.h
 create mode 100644 drivers/staging/comedi/drivers/ke_counter.c
 create mode 100644 drivers/staging/comedi/drivers/mpc624.c
 create mode 100644 drivers/staging/comedi/drivers/mpc8260cpm.c
 create mode 100644 drivers/staging/comedi/drivers/multiq3.c
 create mode 100644 drivers/staging/comedi/drivers/ni_6527.c
 create mode 100644 drivers/staging/comedi/drivers/ni_65xx.c
 create mode 100644 drivers/staging/comedi/drivers/ni_660x.c
 create mode 100644 drivers/staging/comedi/drivers/ni_670x.c
 create mode 100644 drivers/staging/comedi/drivers/ni_at_a2150.c
 create mode 100644 drivers/staging/comedi/drivers/ni_at_ao.c
 create mode 100644 drivers/staging/comedi/drivers/ni_atmio.c
 create mode 100644 drivers/staging/comedi/drivers/ni_atmio16d.c
 create mode 100644 drivers/staging/comedi/drivers/ni_daq_700.c
 create mode 100644 drivers/staging/comedi/drivers/ni_daq_dio24.c
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc.c
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc.h
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc_cs.c
 create mode 100644 drivers/staging/comedi/drivers/ni_mio_common.c
 create mode 100644 drivers/staging/comedi/drivers/ni_mio_cs.c
 create mode 100644 drivers/staging/comedi/drivers/ni_pcidio.c
 create mode 100644 drivers/staging/comedi/drivers/ni_pcimio.c
 create mode 100644 drivers/staging/comedi/drivers/ni_stc.h
 create mode 100644 drivers/staging/comedi/drivers/ni_tio.c
 create mode 100644 drivers/staging/comedi/drivers/ni_tio.h
 create mode 100644 drivers/staging/comedi/drivers/ni_tio_internal.h
 create mode 100644 drivers/staging/comedi/drivers/ni_tiocmd.c
 create mode 100644 drivers/staging/comedi/drivers/pcl711.c
 create mode 100644 drivers/staging/comedi/drivers/pcl724.c
 create mode 100644 drivers/staging/comedi/drivers/pcl725.c
 create mode 100644 drivers/staging/comedi/drivers/pcl726.c
 create mode 100644 drivers/staging/comedi/drivers/pcl730.c
 create mode 100644 drivers/staging/comedi/drivers/pcl812.c
 create mode 100644 drivers/staging/comedi/drivers/pcl816.c
 create mode 100644 drivers/staging/comedi/drivers/pcl818.c
 create mode 100644 drivers/staging/comedi/drivers/pcm3724.c
 create mode 100644 drivers/staging/comedi/drivers/pcm3730.c
 create mode 100644 drivers/staging/comedi/drivers/pcmad.c
 create mode 100644 drivers/staging/comedi/drivers/pcmda12.c
 create mode 100644 drivers/staging/comedi/drivers/pcmmio.c
 create mode 100644 drivers/staging/comedi/drivers/pcmuio.c
 create mode 100644 drivers/staging/comedi/drivers/plx9052.h
 create mode 100644 drivers/staging/comedi/drivers/poc.c
 create mode 100644 drivers/staging/comedi/drivers/quatech_daqp_cs.c
 create mode 100644 drivers/staging/comedi/drivers/rti800.c
 create mode 100644 drivers/staging/comedi/drivers/rti802.c
 create mode 100644 drivers/staging/comedi/drivers/s526.c
 create mode 100644 drivers/staging/comedi/drivers/serial2002.c
 create mode 100644 drivers/staging/comedi/drivers/skel.c
 create mode 100644 drivers/staging/comedi/drivers/ssv_dnp.c
 create mode 100644 drivers/staging/comedi/drivers/unioxx5.c
 create mode 100644 drivers/staging/dst/Kconfig
 create mode 100644 drivers/staging/dst/Makefile
 create mode 100644 drivers/staging/dst/crypto.c
 create mode 100644 drivers/staging/dst/dcore.c
 create mode 100644 drivers/staging/dst/export.c
 create mode 100644 drivers/staging/dst/state.c
 create mode 100644 drivers/staging/dst/thread_pool.c
 create mode 100644 drivers/staging/dst/trans.c
 delete mode 100644 drivers/staging/epl/EdrvFec5282.h
 delete mode 100644 drivers/staging/epl/EplObjDef.h
 delete mode 100644 drivers/staging/epl/EplTimeruNull.c
 delete mode 100644 drivers/staging/epl/EplTimeruWin32.c
 delete mode 100644 drivers/staging/epl/ShbIpc-Win32.c
 delete mode 100644 drivers/staging/epl/kernel/EplNmtkCal.h
 delete mode 100644 drivers/staging/epl/kernel/EplObdkCal.h
 delete mode 100644 drivers/staging/frontier/frontier_compat.h
 delete mode 100644 drivers/staging/frontier/surface_sysfs.h
 create mode 100644 drivers/staging/heci/Kconfig
 create mode 100644 drivers/staging/heci/Makefile
 create mode 100644 drivers/staging/heci/TODO
 create mode 100644 drivers/staging/heci/heci.h
 create mode 100644 drivers/staging/heci/heci_data_structures.h
 create mode 100644 drivers/staging/heci/heci_init.c
 create mode 100644 drivers/staging/heci/heci_interface.c
 create mode 100644 drivers/staging/heci/heci_interface.h
 create mode 100644 drivers/staging/heci/heci_main.c
 create mode 100644 drivers/staging/heci/heci_version.h
 create mode 100644 drivers/staging/heci/interrupt.c
 create mode 100644 drivers/staging/heci/io_heci.c
 create mode 100644 drivers/staging/line6/Kconfig
 create mode 100644 drivers/staging/line6/Makefile
 create mode 100644 drivers/staging/line6/audio.c
 create mode 100644 drivers/staging/line6/audio.h
 create mode 100644 drivers/staging/line6/capture.c
 create mode 100644 drivers/staging/line6/capture.h
 create mode 100644 drivers/staging/line6/config.h
 create mode 100644 drivers/staging/line6/control.c
 create mode 100644 drivers/staging/line6/control.h
 create mode 100644 drivers/staging/line6/driver.c
 create mode 100644 drivers/staging/line6/driver.h
 create mode 100644 drivers/staging/line6/dumprequest.c
 create mode 100644 drivers/staging/line6/dumprequest.h
 create mode 100644 drivers/staging/line6/midi.c
 create mode 100644 drivers/staging/line6/midi.h
 create mode 100644 drivers/staging/line6/midibuf.c
 create mode 100644 drivers/staging/line6/midibuf.h
 create mode 100644 drivers/staging/line6/pcm.c
 create mode 100644 drivers/staging/line6/pcm.h
 create mode 100644 drivers/staging/line6/playback.c
 create mode 100644 drivers/staging/line6/playback.h
 create mode 100644 drivers/staging/line6/pod.c
 create mode 100644 drivers/staging/line6/pod.h
 create mode 100644 drivers/staging/line6/revision.h
 create mode 100644 drivers/staging/line6/toneport.c
 create mode 100644 drivers/staging/line6/toneport.h
 create mode 100644 drivers/staging/line6/usbdefs.h
 create mode 100644 drivers/staging/line6/variax.c
 create mode 100644 drivers/staging/line6/variax.h
 create mode 100644 drivers/staging/p9auth/Kconfig
 create mode 100644 drivers/staging/p9auth/Makefile
 create mode 100644 drivers/staging/p9auth/p9auth.c
 create mode 100644 drivers/staging/phison/Kconfig
 create mode 100644 drivers/staging/phison/Makefile
 create mode 100644 drivers/staging/phison/phison.c
 create mode 100644 drivers/staging/pohmelfs/Kconfig
 create mode 100644 drivers/staging/pohmelfs/Makefile
 create mode 100644 drivers/staging/pohmelfs/config.c
 create mode 100644 drivers/staging/pohmelfs/crypto.c
 create mode 100644 drivers/staging/pohmelfs/dir.c
 create mode 100644 drivers/staging/pohmelfs/inode.c
 create mode 100644 drivers/staging/pohmelfs/lock.c
 create mode 100644 drivers/staging/pohmelfs/mcache.c
 create mode 100644 drivers/staging/pohmelfs/net.c
 create mode 100644 drivers/staging/pohmelfs/netfs.h
 create mode 100644 drivers/staging/pohmelfs/path_entry.c
 create mode 100644 drivers/staging/pohmelfs/trans.c
 create mode 100644 drivers/staging/rt3070/2870_main_dev.c
 create mode 100644 drivers/staging/rt3070/Kconfig
 create mode 100644 drivers/staging/rt3070/Makefile
 create mode 100644 drivers/staging/rt3070/action.h
 create mode 100644 drivers/staging/rt3070/aironet.h
 create mode 100644 drivers/staging/rt3070/ap.h
 create mode 100644 drivers/staging/rt3070/chlist.h
 create mode 100644 drivers/staging/rt3070/common/2870_rtmp_init.c
 create mode 100644 drivers/staging/rt3070/common/action.c
 create mode 100644 drivers/staging/rt3070/common/ba_action.c
 create mode 100644 drivers/staging/rt3070/common/cmm_data.c
 create mode 100644 drivers/staging/rt3070/common/cmm_data_2870.c
 create mode 100644 drivers/staging/rt3070/common/cmm_info.c
 create mode 100644 drivers/staging/rt3070/common/cmm_sanity.c
 create mode 100644 drivers/staging/rt3070/common/cmm_sync.c
 create mode 100644 drivers/staging/rt3070/common/cmm_wpa.c
 create mode 100644 drivers/staging/rt3070/common/dfs.c
 create mode 100644 drivers/staging/rt3070/common/eeprom.c
 create mode 100644 drivers/staging/rt3070/common/md5.c
 create mode 100644 drivers/staging/rt3070/common/mlme.c
 create mode 100644 drivers/staging/rt3070/common/netif_block.c
 create mode 100644 drivers/staging/rt3070/common/rtmp_init.c
 create mode 100644 drivers/staging/rt3070/common/rtmp_tkip.c
 create mode 100644 drivers/staging/rt3070/common/rtmp_wep.c
 create mode 100644 drivers/staging/rt3070/common/rtusb_bulk.c
 create mode 100644 drivers/staging/rt3070/common/rtusb_data.c
 create mode 100644 drivers/staging/rt3070/common/rtusb_io.c
 create mode 100644 drivers/staging/rt3070/common/spectrum.c
 create mode 100644 drivers/staging/rt3070/dfs.h
 create mode 100644 drivers/staging/rt3070/firmware.h
 create mode 100644 drivers/staging/rt3070/leap.h
 create mode 100644 drivers/staging/rt3070/link_list.h
 create mode 100644 drivers/staging/rt3070/md4.h
 create mode 100644 drivers/staging/rt3070/md5.h
 create mode 100644 drivers/staging/rt3070/mlme.h
 create mode 100644 drivers/staging/rt3070/netif_block.h
 create mode 100644 drivers/staging/rt3070/oid.h
 create mode 100644 drivers/staging/rt3070/rt2870.h
 create mode 100644 drivers/staging/rt3070/rt28xx.h
 create mode 100644 drivers/staging/rt3070/rt_ate.c
 create mode 100644 drivers/staging/rt3070/rt_ate.h
 create mode 100644 drivers/staging/rt3070/rt_config.h
 create mode 100644 drivers/staging/rt3070/rt_linux.c
 create mode 100644 drivers/staging/rt3070/rt_linux.h
 create mode 100644 drivers/staging/rt3070/rt_main_dev.c
 create mode 100644 drivers/staging/rt3070/rt_profile.c
 create mode 100644 drivers/staging/rt3070/rtmp.h
 create mode 100644 drivers/staging/rt3070/rtmp_ckipmic.h
 create mode 100644 drivers/staging/rt3070/rtmp_def.h
 create mode 100644 drivers/staging/rt3070/rtmp_type.h
 create mode 100644 drivers/staging/rt3070/spectrum.h
 create mode 100644 drivers/staging/rt3070/spectrum_def.h
 create mode 100644 drivers/staging/rt3070/sta/aironet.c
 create mode 100644 drivers/staging/rt3070/sta/assoc.c
 create mode 100644 drivers/staging/rt3070/sta/auth.c
 create mode 100644 drivers/staging/rt3070/sta/auth_rsp.c
 create mode 100644 drivers/staging/rt3070/sta/connect.c
 create mode 100644 drivers/staging/rt3070/sta/dls.c
 create mode 100644 drivers/staging/rt3070/sta/rtmp_data.c
 create mode 100644 drivers/staging/rt3070/sta/sanity.c
 create mode 100644 drivers/staging/rt3070/sta/sync.c
 create mode 100644 drivers/staging/rt3070/sta/wpa.c
 create mode 100644 drivers/staging/rt3070/sta_ioctl.c
 create mode 100644 drivers/staging/rt3070/wpa.h
 create mode 100644 drivers/staging/serqt_usb/Kconfig
 create mode 100644 drivers/staging/serqt_usb/Makefile
 create mode 100644 drivers/staging/serqt_usb/TODO
 create mode 100644 drivers/staging/serqt_usb/serqt_usb.c
 delete mode 100644 drivers/staging/slicoss/gbdownload.h
 delete mode 100644 drivers/staging/slicoss/gbrcvucode.h
 delete mode 100644 drivers/staging/slicoss/oasisdbgdownload.h
 delete mode 100644 drivers/staging/slicoss/oasisdownload.h
 delete mode 100644 drivers/staging/slicoss/oasisrcvucode.h
 delete mode 100644 drivers/staging/slicoss/slic_os.h
 delete mode 100644 drivers/staging/slicoss/slicbuild.h
 delete mode 100644 drivers/staging/slicoss/slicdbg.h
 delete mode 100644 drivers/staging/slicoss/slicdump.h
 delete mode 100644 drivers/staging/slicoss/slicinc.h
 create mode 100644 drivers/staging/stlc45xx/Kconfig
 create mode 100644 drivers/staging/stlc45xx/Makefile
 create mode 100644 drivers/staging/stlc45xx/stlc45xx.c
 create mode 100644 drivers/staging/stlc45xx/stlc45xx.h
 create mode 100644 drivers/staging/stlc45xx/stlc45xx_lmac.h
 delete mode 100644 drivers/staging/sxg/saharadbgdownload.h
 create mode 100644 drivers/staging/sxg/sxg_ethtool.c
 create mode 100644 drivers/staging/sxg/sxgphycode-1.2.h
 delete mode 100644 drivers/staging/sxg/sxgphycode.h
 create mode 100644 drivers/staging/uc2322/Kconfig
 create mode 100644 drivers/staging/uc2322/Makefile
 create mode 100644 drivers/staging/uc2322/TODO
 create mode 100644 drivers/staging/uc2322/aten2011.c
 delete mode 100644 drivers/staging/winbond/bss_f.h
 delete mode 100644 drivers/staging/winbond/bssdscpt.h
 delete mode 100644 drivers/staging/winbond/common.h
 delete mode 100644 drivers/staging/winbond/ds_tkip.h
 delete mode 100644 drivers/staging/winbond/gl_80211.h
 delete mode 100644 drivers/staging/winbond/ioctls.h
 delete mode 100644 drivers/staging/winbond/mlme_mib.h
 delete mode 100644 drivers/staging/winbond/mto_f.h
 delete mode 100644 drivers/staging/winbond/os_common.h
 delete mode 100644 drivers/staging/winbond/sme_s.h
 delete mode 100644 drivers/staging/winbond/wb35_ver.h
 delete mode 100644 drivers/staging/wlan-ng/p80211metamib.h
 delete mode 100644 drivers/staging/wlan-ng/p80211metamsg.h
 delete mode 100644 drivers/staging/wlan-ng/wlan_compat.h
 create mode 100644 firmware/slicoss/gbdownload.sys.ihex
 create mode 100644 firmware/slicoss/gbrcvucode.sys.ihex
 create mode 100644 firmware/slicoss/oasisdbgdownload.sys.ihex
 create mode 100644 firmware/slicoss/oasisdownload.sys.ihex
 create mode 100644 firmware/slicoss/oasisrcvucode.sys.ihex
 create mode 100644 firmware/sxg/saharadbgdownloadB.sys.ihex
 create mode 100644 firmware/sxg/saharadownloadB.sys.ihex
 create mode 100644 include/linux/dst.h

---------------

ADDI-DATA GmbH (1):
      Staging: comedi: add addi-data drivers

Adam McDaniel (1):
      Staging: rt2860: Ported v1.7.1.1 changes into v1.8.0.0, becoming v1.8.1.1

Alexander Beregalov (9):
      Staging: meilhaus: remove dependence on kernel version
      Staging: meilhaus: some checkpatch.pl cleanup
      Staging: otus: remove old irqreturn_t definition
      Staging: pohmelfs: fix build breakage
      Staging: pohmelfs: net.c: include vmalloc.h
      Staging: pohmelfs: fix printk format warnings v2
      Staging: pohmelfs should depend on CRYPTO
      Staging: pohmelfs: should include fs_struct.h
      Staging: echo cleanup

Allan Willcox (1):
      Staging: comedi: add amplc_pci230 driver

Anders Blomdell (5):
      Staging: comedi: add jr3_pci driver
      Staging: comedi: add serial2002 driver
      Staging: comedi: add rti802 driver
      Staging: comedi: add multiq3 driver
      Staging: comedi: add daqboard2000 driver

Anders Gnistrup (1):
      Staging: comedi: add fl212 driver

Andre Haupt (14):
      Staging: asus_oled: fix sparse warnings about using plain integer as NULL pointer
      Staging: asus_oled: do not initialise statics to 0 or NULL
      Staging: asus_oled: trailing statements should be on next line
      Staging: asus_oled: fix various checkpatch.pl issues regarding missing or obsolete spaces
      Staging: asus_oled: do not use assignment in if condition
      Staging: me4000: use linux/uaccess.h and linux/io.h
      Staging: me4000: return is not a function, no parentheses required
      Staging: me4000: inline keyword should sit between storage class and type
      Staging: me4000: replace some C99 comments
      Staging: me4000: kfree(NULL) is safe, so no extra checks needed.
      Staging: me4000: fix various checkpatch.pl warnings about bracing
      Staging: me4000: do not use C99 style comments.
      Staging: me4000: use tabs for code indentation
      Staging: me4000: make file_operations const

Ashwin Ganti (1):
      Staging: add p9auth driver

Bart Joris (1):
      Staging: comedi: add ni_670x driver

Bernd Porr (4):
      Staging: comedi: add comedi_num_legacy_minors module parameter
      Staging: comedi: add comedi_usb_auto_[un]config functions
      Staging: comedi: usbdux[fast] firmware upload changes
      Staging: comedi: usbduxfast: fix run-time error

Bill Pemberton (227):
      Staging: comedi: Convert C99 style comments to traditional style comments
      Staging: comedi: Change "foo * bar" to "foo *bar"
      Staging: comedi: Add spaces after commas where suggested by checkpatch.pl
      Staging: comedi: Add spaces around colons as needed
      Staging: comedi: Add spaces around parens as requested by checkpatch.pl
      Staging: comedi: Remove instances of assignments in conditionals
      Staging: comedi: Move trailing statements to next line as requested by checkpatch
      Staging: comedi: Fix cases of open curly on wrong line
      Staging: comedi: Add spaces around colons as requested by checkpatch
      Staging: comedi: Misc code cleanups for checkpatch
      Staging: comedi: Remove checks for NULL before calling kfree()
      Staging: comedi: Remove curly braces where they are not needed
      Staging: comedi: Remove comedi32_chaninfo_struct typedef
      Staging: comedi: Remove boardtype typedef
      Staging: comedi: Remove rtdBoard typedef
      Staging: comedi: Remove s626_board typedef
      Staging: comedi: Remove V_FP_V typedef
      Staging: comedi: Remove comedi_t typedef
      Staging: comedi: Remove lsampl_t and sampl_t typedefs
      Staging: comedi: Remove comedi_device typedef
      Staging: comedi: Remove comedi_subdevice typedef
      Staging: comedi: Remove comedi_async typedef
      Staging: comedi: Remove comedi_driver typedef
      Staging: comedi: Remove comedi_lrange typedef
      Staging: comedi: Remove device_create_result_type typedef
      Staging: comedi: Remove comedi_trig typedef
      Staging: comedi: Remove comedi_cmd typedef
      Staging: comedi: Remove comedi_insn typedef
      Staging: comedi: Remove comedi_insnlist typedef
      Staging: comedi: Remove comedi_chaninfo typedef
      Staging: comedi: Remove comedi_subdinfo typedef
      Staging: comedi: Remove comedi_devinfo typedef
      Staging: comedi: Remove comedi_devconfig typedef
      Staging: comedi: Remove comedi_rangeinfo typedef
      Staging: comedi: Remove comedi_krange typedef
      Staging: comedi: Remove comedi_bufconfig typedef
      Staging: comedi: Remove comedi_bufinfo typedef
      Staging: comedi: Remove DMABUF typedef
      Staging: comedi: Remove pci6208_board typedef
      Staging: comedi: Remove pci6208_private typedef
      Staging: comedi: Remove adl_pci7296_private typedef
      Staging: comedi: Remove adl_pci7432_private typedef
      Staging: comedi: Remove adl_pci8164_private typedef
      Staging: comedi: Remove pci9111_board_struct typedef
      Staging: comedi: Remove pci9111_private_data typedef
      Staging: comedi: Remove pci9111_trigger_sources typedef
      Staging: comedi: Remove pci9111_ISC0_sources typedef
      Staging: comedi: Remove C99 style comments in adl_pci9111.c
      Staging: comedi: Remove boardtype typedef in adl_pci9118.c
      Staging: comedi: Remove pci9118_private typedef
      Staging: comedi: Remove adq12b_board typedef
      Staging: comedi: Remove adq12b_private typedef
      Staging: comedi: Remove boardtype typedef in adv_pci1710.c
      Staging: comedi: Remove pci1710_private typedef
      Staging: comedi: Remove boardtype and pci1723_private typedefs in adv_pci1723.c
      Staging: comedi: Remove hw_cards_id and hw_io_access typedefs in adv_pci_dio.c
      Staging: comedi: Remove diosubd_data typedef
      Staging: comedi: Remove boardtype typedef in adv_pci_dio.c
      Staging: comedi: Remove C99 style comments in adv_pci_dio.c
      Staging: comedi: Remove pci_dio_private typedef
      Staging: comedi: Remove board_type typedef in aio_aio12_8.c
      Staging: comedi: Remove aio12_8_private typedef
      Staging: comedi: Remove counter_mode_register_t typedef
      Staging: comedi: Remove aio_iiro_16_board typedef
      Staging: comedi: Remove aio_iiro_16_private typedef
      Staging: comedi: Remove dio200_board typedef
      Staging: comedi: Remove dio200_layout typedef
      Staging: comedi: Remove dio200_private typedef
      Staging: comedi: Remove dio200_subdev_8254 typedef
      Staging: comedi: Remove dio200_subdev_intr typedef
      Staging: comedi: Remove pc236_board typedef
      Staging: comedi: Remove pc236_private typedef
      Staging: comedi: Remove pc263_board typedef
      Staging: comedi: Remove pc263_private typedef
      Staging: comedi: Remove pci224_board typedef
      Staging: comedi: Remove pci224_private typedef
      Staging: comedi: Remove pci230_board typedef
      Staging: comedi: Remove das16cs_board typedef
      Staging: comedi: Remove das16cs_private typedef
      Staging: comedi: Remove local_info_t typedef
      Staging: comedi: Remove cb_pcidas_board typedef
      Staging: comedi: Remove cb_pcidas_private typedef
      Staging: comedi: Remove cb_pcidda_board typedef
      Staging: comedi: Remove cb_pcidda_private typedef
      Staging: comedi: Remove pcidio_board typedef
      Staging: comedi: Remove pcidio_private typedef
      Staging: comedi: Remove cb_pcimdas_board typedef
      Staging: comedi: Remove timer_private typedef
      Staging: comedi: Remove board_struct typedef
      Staging: comedi: Remove typedef private in cb_pcimdda.c
      Staging: comedi: Remove contec_board typedef
      Staging: comedi: Remove contec_private typedef
      Staging: comedi: Remove contec_model typedef
      Staging: comedi: Remove daqboard2000_hw typedef
      Staging: comedi: Remove boardtype typedef in daqboard2000.c
      Staging: comedi: Remove daqboard2000_private typedef
      Staging: comedi: Remove local_info_t typedef in das08_cs.c
      Staging: comedi: Remove das16_board typedef
      Staging: comedi: Replace C99 comments in jr3_pci.h
      Staging: comedi: Remove u_val_t typedef
      Staging: comedi: Remove s_val_t typedef
      Staging: comedi: Remove raw_channel typedef
      Staging: comedi: Remove force_array_t typedef
      Staging: comedi: Remove six_axis_array_t typedef
      Staging: comedi: Remove vect_bits_t, warning_bits_t, and error_bits_t typedefs
      Staging: comedi: Remove thresh_struct typedef
      Staging: comedi: Remove le_struct_t typedef
      Staging: comedi: Remove jr3_t typedef
      Staging: comedi: Remove link_types typedef
      Staging: comedi: Remove intern_transform_t typedef
      Staging: comedi: Remove jr3_channel_t typedef
      Staging: comedi: Remove das16m1_board typedef
      Staging: comedi: Remove das800_board typedef
      Staging: comedi: Remove das1800_board typedef
      Staging: comedi: Remove das1800_private typedef
      Staging: comedi: Remove das6402_private typedef
      Staging: comedi: Remove dmm32at_board typedef
      Staging: comedi: Remove dmm32at_private typedef
      Staging: comedi: Remove boardtype_t typedef in dt282x.c
      Staging: comedi: Remove dt282x_private typedef
      Staging: comedi: Remove boardtype_t typedef in dt2801.c
      Staging: comedi: Remove boardtype typedef in pcl818.c
      Staging: comedi: Remove dt2801_private typedef
      Staging: comedi: Remove dt2814_private typedef
      Staging: comedi: Remove dt2815_private typedef
      Staging: comedi: Remove dt3k_boardtype typedef
      Staging: comedi: Remove fl512_private typedef
      Staging: comedi: Remove hpdi_board typedef
      Staging: comedi: Remove pci20xxx_private typedef
      Staging: comedi: Remove jr3_pci_dev_private typedef
      Staging: comedi: Remove cnt_board_struct typedef
      Staging: comedi: Remove skel_private typedef
      Staging: comedi: Remove mpc8260cpm_private typedef
      Staging: comedi: Remove ni6527_board typedef
      Staging: comedi: Remove ni_65xx_board typedef
      Staging: comedi: Remove NI_660xRegisterData typedef
      Staging: comedi: Remove ni_670x_private typedef
      Staging: comedi: Remove a2150_private typedef
      Staging: comedi: Remove atao_private typedef
      Staging: comedi: Remove atmio16_board_t typedef
      Staging: comedi: Remove dio700_private typedef
      Staging: comedi: Remove dio24_private typedef
      Staging: comedi: Remove ni_private typedef
      Staging: comedi: Remove nidio_board typedef
      Staging: comedi: Remove pcl818_private typedef
      Staging: comedi: Remove pcmda12_private typedef
      Staging: comedi: Remove s526_private typedef
      Staging: comedi: Remove serial2002_private typedef
      Staging: comedi: Remove dnp_private_data typedef
      Staging: comedi: Remove comment mentioning typedefs
      Staging: comedi: Remove dt3k_private typedef
      Staging: comedi: Remove hpdi_private typedef
      Staging: comedi: Remove poll_delay_t typedef
      Staging: comedi: Remove cnt_device_private typedef
      Staging: comedi: Remove pcl711_private typedef
      Staging: comedi: Remove pcl726_private typedef
      Staging: comedi: Remove pcl812_private typedef
      Staging: comedi: Remove dt2811_private typedef
      Staging: comedi: Remove pcmmio_board typedef
      Staging: comedi: Remove pcmuio_board typedef
      Staging: comedi: Remove rti800_private typedef
      Staging: comedi: Remove rti802_private typedef
      Staging: comedi: Remove config_t typedef
      Staging: comedi: Remove pci20xxx_subdev_private typedef
      Staging: comedi: Remove pcmmio_subdev_private typedef
      Staging: comedi: Remove pcmuio_subdev_private typedef
      Staging: comedi: Remove pcmda12_board typedef
      Staging: comedi: Remove S526_GPCT_APP_CLASS typedef
      Staging: comedi: Remove serial2002_board typedef
      Staging: comedi: Remove skel_board typedef
      Staging: comedi: Remove dnp_board typedef
      Staging: comedi: Remove unioxx5_subd_priv typedef
      Staging: comedi: Remove jr3_pci_subdev_private typedef
      Staging: comedi: Remove pcmmio_private typedef
      Staging: comedi: Remove pcmuio_private typedef
      Staging: comedi: Remove s526_gpct_config_t typedef
      Staging: comedi: Remove transform_t typedef
      Staging: comedi: Remove s526_board typedef
      Staging: comedi: Remove six_axis_t typedef
      Staging: comedi: Remove priv_pcm3724 typedef
      Staging: comedi: Remove pcl816_private typedef
      Staging: comedi: acl7225b: Remove boardtype typedef
      Staging: comedi: cb_pcimdas: Remove timer_private typedef
      Staging: comedi: das800: Remove das800_board typedef
      Staging: comedi: dt2811: Remove boardtype typedef
      Staging: comedi: pcl711: Remove boardtype typedef
      Staging: comedi: pcl724: Remove boardtype typedef
      Staging: comedi: pcl726: Remove boardtype typedef
      Staging: comedi: pcl730: Remove boardtype typedef
      Staging: comedi: pcl812: Remove boardtype typedef
      Staging: comedi: pcl816: Remove boardtype typedef
      Staging: comedi: pcm3724: Remove boardtype typedef
      Staging: comedi: rti800: Remove boardtype typedef
      Staging: comedi: skel.c: Remove skel_private typedef
      Staging: comedi: serial2002: Remove serial2002_private typedef
      Staging: comedi: quatech_daqp_cs: Remove local_info_t typedef
      Staging: comedi: Remove 2.4 irqreturn_t compatibility in comedi/interrupt.h
      Staging: comedi: Remove hw_fifo_info_t typedef
      Staging: comedi: Remove pcidas64_board typedef
      Staging: comedi: Remove pcidas64_private typedef
      Staging: comedi: comedi: remove C99 comments in skel.c
      Staging: comedi: Remove ni6527_private typedef
      Staging: comedi: Remove ni_65xx_private typedef
      Staging: comedi: Remove ni_65xx_subdevice_private typedef
      Staging: comedi: Remove NI_660x_Register typedef
      Staging: comedi: Remove ni_660x_board typedef
      Staging: comedi: Remove ni_660x_private typedef
      Staging: comedi: Remove ni_670x_board typedef
      Staging: comedi: Remove a2150_board typedef
      Staging: comedi: Remove atao_board typedef
      Staging: comedi: Remove atmio16d_private typedef
      Staging: comedi: Remove dio700_board typedef
      Staging: comedi: ni_daq_700.c: Remove local_info_t typedef
      Staging: comedi: Remove nidio96_private typedef
      Staging: comedi: Remove das08_board typedef
      Staging: comedi: Remove me4000_ao_info_t typedef
      Staging: comedi: Remove me4000_ai_info_t typedef
      Staging: comedi: Remove me4000_dio_info_t typedef
      Staging: comedi: Remove me4000_cnt_info_t typedef
      Staging: comedi: Remove me4000_board_t typedef
      Staging: comedi: Remove me4000_ao_context_t typedef
      Staging: comedi: Remove me4000_ai_context_t typedef
      Staging: comedi: Remove me4000_dio_context_t typedef
      Staging: comedi: Remove me4000_cnt_context_t typedef
      Staging: comedi: Remove me4000_info_t typedef
      Staging: comedi: Remove use of VOID typedef in addi-data
      Staging: comedi: Remove CHAR, *PCHAR, and *PCSTR typedefs in addi-data

Blaine Lee (1):
      Staging: comedi: add pcm3730 driver

Brent Baccala (1):
      Staging: comedi: add quatech_daqp_cs driver

Calin Culianu (3):
      Staging: comedi: add pcmda12 driver
      Staging: comedi: add pcmmio and pcmuio drivers
      Staging: comedi: add cb_pcimdda driver

Chris R. Baugher (1):
      Staging: comedi: add ni_at_atmio16d driver

Dan Carpenter (1):
      Staging: altpciechdma: Null deref in altpciechdma.c remove()

Daniel Drake (1):
      Staging: add b3dfg driver

Daniel Vecino Castel (1):
      Staging: comedi: add ni_daq_dio24 driver

David A. Schleef (1):
      Staging: comedi: add poc driver

David Schleef (28):
      Staging: comedi: add 8253.h header
      Staging: comedi: add 8255 driver
      Staging: comedi: add rti800 driver
      Staging: comedi: add plx9052 header file
      Staging: comedi: add nt_atmio driver
      Staging: comedi: add nt_mio_cs driver
      Staging: comedi: add nt_pcimio driver
      Staging: comedi: add das08 drivers
      Staging: comedi: add comedi_rt_timer virtual driver
      Staging: comedi: add skeleton driver
      Staging: comedi: add mpc8260 driver
      Staging: comedi: add ni_mio_common code
      Staging: comedi: add pcmad driver
      Staging: comedi: add pcl711 driver
      Staging: comedi: add cb_das16_cs driver
      Staging: comedi: add pcl725 driver
      Staging: comedi: add pcl726 driver
      Staging: comedi: add ni_6527 driver
      Staging: comedi: add ni_at_ao driver
      Staging: comedi: add ni_pcidio driver
      Staging: comedi: add das16 driver
      Staging: comedi: add dt2601 driver
      Staging: comedi: add dt2811 driver
      Staging: comedi: add dt2814 driver
      Staging: comedi: add dt2815 driver
      Staging: comedi: add dt2817 driver
      Staging: comedi: add dt282x driver
      Staging: comedi: add dt3000 driver

David Täht (6):
      Staging: frontier: Make checkpatch.pl considerably happier with tranzport driver.
      Staging: frontier: Make checkpatch.pl much happier with alphatrack driver
      Staging: frontier: removed now unused frontier_compat.h file
      Staging: frontier: Updated documentation
      Staging: frontier: Make checkpatch.pl happy with alphatrack.h
      Staging: frontier: Remove unused components of the alphatrack/tranzport sysfs interface.

Dragoslav Zaric (2):
      Staging: otus: ioctl.c: Fix Coding Style
      Staging: otus: 80211core/amsdu.c: Fix Coding Style

Drew Csillag (1):
      Staging: comedi: add pcm3724 driver

Duane Griffin (1):
      Staging: b3dfg: fixups and improvements

Emmanuel Pacaud (1):
      Staging: comedi: add adl_pci9111 driver

Eric Sesterhenn (1):
      Staging: et131x: list usage cleanup

Erik Andrén (10):
      Staging: agnx: Fixup agnx.h checkpatch warnings
      Staging: agnx: Fixup debug.h checkpatch warnings
      Staging: agnx: Fixup pci.c checkpatch warnings
      Staging: agnx: Fixup phy.c checkpatch warnings
      Staging: agnx: Fixup rf.c checkpatch warnings
      Staging: agnx: Fixup sta.c checkpatch warnings
      Staging: agnx: Fixup sta.h checkpatch warnings
      Staging: agnx: Fixup table.c checkpatch warnings
      Staging: agnx: Fixup xmit.c checkpatch warnings
      Staging: altpciechdma: checkpatch fixups

Evan Ko (1):
      Staging: add phison ATA driver to the tree

Everett Wang (1):
      Staging: comedi: add s526 driver

Evgeniy Polyakov (23):
      Staging: dst: core files.
      Staging: dst: network state machine.
      Staging: dst: export node.
      Staging: dst: thread pool.
      Staging: dst: transactions.
      Staging: dst: crypto processing.
      Staging: dst: kconfig and makefile changes.
      Staging: dst: kconfig update.
      Staging: DST: optimize bio allocation.
      Staging: DST: extend thread pool exit conditions.
      Staging: DST: Do not allow empty barriers.
      Staging: DST: Kconfig text update.
      Staging: DST: fix build dependancy
      Staging: pohmelfs: documentation.
      Staging: pohmelfs: configuration interface.
      Staging: pohmelfs: crypto processing.
      Staging: pohmelfs: directory operations.
      Staging: pohmelfs: inode operations.
      Staging: pohmelfs: distributed locking and cache coherency protocol.
      Staging: pohmelfs: network operations.
      Staging: pohmelfs: transaction layer.
      Staging: pohmelfs: kconfig/makefile and vfs changes.
      Staging: pohmelfs: select crypto modules from the config.

Frank Mori Hess (13):
      Staging: comedi: add National Instruments infrastructure
      Staging: comedi: add ni_labpc drivers
      Staging: comedi: add gsc_hpdi driver
      Staging: comedi: add das16m1 driver
      Staging: comedi: add cb_pcidas64 driver
      Staging: comedi: add das1800 driver
      Staging: comedi: add das800 driver
      Staging: comedi: add ni_at_a2150 driver
      Staging: comedi: Added reading of board serial number from eeprom for m-series boards
      Staging: comedi: usbduxfast bugfix
      Staging: comedi: Fixed minor numbers for subdevice files.
      Staging: comedi: Added some validation of comedi module parameter values.
      Staging: comedi: fix bug with invalid minor number usage.

Fred Brooks (1):
      Staging: comedi: add ni_daq_700 driver

Greg Kroah-Hartman (131):
      Staging: slicoss: remove TRUE/FALSE usage
      Staging: slicoss: remove jiffies macros
      Staging: slicoss: remove DEBUG_REGISTER_TRACE
      Staging: slicoss: remove WRITE_REG64 wrapper
      Staging: slicoss: remove WRITE_REG wrapper
      Staging: slicoss: remove slic_os.h
      Staging: slicoss: remove unused #defines
      Staging: slicoss: delete slicbuild.h
      Staging: slicoss: clean up SLIC_DUMP_ENABLED
      Staging: slicoss: remove SLIC_GET_STATS_TIMER_ENABLED
      Staging: slicoss: delete slicinc.h
      Staging: slicoss: remove SLIC_GET_STATS_ENABLED
      Staging: slicoss: add proper KERN_DEBUG to 2 printks
      Staging: slicoss: remove SLIC_POWER_MANAGEMENT_ENABLED
      Staging: slicoss: remove LINUX_FREES_ADAPTER_RESOURCES
      Staging: slicoss: remove SLIC_PING_TIMER_ENABLED
      Staging: slicoss: remove VALID_ADDRESS macro
      Staging: slicoss: remove DBG_MSG
      Staging: slicoss: remove SLIC_ETHTOOL_SUPPORT
      Staging: slicoss: remove SLICLEVEL and SLIC_DISPLAY macros
      Staging: slicoss: remove DBG_ERROR macro
      Staging: slicoss: remove ASSERTMSG macro
      Staging: slicoss: delete slicdbg.h
      Staging: slicoss: slichw.h cleanup
      Staging: sxg: fix build warnings in sxg_ethtool
      Staging: sxg: remove firmware files from sgx_ethtool.c
      Staging: sxg: fix build warnings in downloadB firmware files
      Staging: sxg: fix build warnings in sxg.c
      Staging: go7007: fix build error
      Staging: rtl8187se: fix \r\n line ends
      staging: dst: replace bus_id with dev_set_name
      Staging: add aten2011 usb to serial converter driver.
      Staging: aten2011: run lindent
      Staging: aten2011: move .h files into the driver
      Staging: aten2011: remove kernel version dependencies
      Staging: aten2011: fix up comments by removing most of them.
      Staging: aten2011: remove unneeded defines
      Staging: aten2011: remove function prototypes.
      Staging: aten2011: fix up sparse warnings
      Staging: aten2011: remove unused fields from structures.
      Staging: aten2011: clean up init and exit functions
      Staging: aten2011: remove paranoia check functions
      Staging: aten2011: fix up the set_reg_sync function
      Staging: aten2011: fix up the get_reg_sync function
      Staging: aten2011: fix up the set_uart_reg function
      Staging: aten2011: fix up the get_uart_reg function
      Staging: aten2011: delete the Dump_serial_port function
      Staging: aten2011: remove wrappers around serial get and put data functions
      Staging: aten2011: fix up c++ comments
      Staging: aten2011: remove DPRINTK macro
      Staging: aten2011: s/__FUNCTION__/__func__
      Staging: aten2011: fix checkpatch errors and warnings
      Staging: phison: fix up checkpatch and other formatting issues
      Staging: phison: port code to work properly with latest libata
      Staging: phison: add driver to the build system
      Staging: comedi: fix bus_id use in jr3_pci driver
      Staging: comedi: add c6xdigio driver
      Staging: comedi: add new drivers to the kernel build
      Staging: comedi: addi-data header file cleanups
      Staging: comedi: addi-data: APCI1710_82x54 cleanups
      Staging: comedi: fix 64bit build errors
      Staging: epl: remove unneeded files
      Staging: epl: remove complier macros from global.h
      Staging: epl: remove NULL from global.h
      Staging: epl: remove PUBLIC definition
      Staging: epl: remove _WIN_32_ and _NO_OS_ defines
      Staging: epl: remove INLINE mess
      Staging: epl: remove __KERNEL__ checks
      Staging: epl: unwind rest of _LINUX_ #ifdefs
      Staging: epl: remove EplObjDef.h
      Staging: epl: remove GENERIC
      Staging: epl: remove NEAR
      Staging: epl: remove FAR
      Staging: epl: remove ROM
      Staging: epl: remove MEM
      Staging: epl: remove REENTRANT
      Staging: epl: remove compiler warning from SharedBuff.c
      Staging: epl: remove some unused types
      Staging: epl: remove CONST
      Staging: epl: delete EdrvFec5282.h
      Staging: epl: remove BYTE
      Staging: epl: remove QWORD
      Staging: epl: remove DWORD
      Staging: epl: remove WORD
      Staging: epl: fix up some non-ANSI functions
      Staging: epl: clean up demo_main.c
      Staging: epl: remove kernel version checks
      Staging: epl: fix sparse warning in proc_fs.c
      Staging: epl: remove EPLDLLEXPORT
      Staging: epl: fix up epl/user/*.h files
      Staging: epl: fix up epl/kernel/*.h files
      Staging: epl: don't check for devfs
      Staging: epl: remove pointless highres timer check
      Staging: p9auth: fix credential logic
      Staging: p9auth: add to the kernel build
      Staging: p9auth: remove unneeded header file
      Staging: p9auth: fix up codingstyle issues
      Staging: p9auth: fix up sparse warnings
      Staging: p9auth: use kzalloc
      Staging: p9auth: clean up #includes
      Staging: heci: remove kcompat.h
      Staging: heci: fix checkpatch warnings
      Staging: heci: fix some sparse warnings
      Staging: heci: add TODO file
      Staging: add rt3070 wireless driver
      Staging: line6: fix bus_id usage
      Staging: line6: add to the build
      Staging: line6: remove DEVICE_ATTRIBUTE
      Staging: line6: remove PT_REGS
      Staging: line6: remove KERNEL_VERSION checks
      Staging: line6: static function cleanups
      Staging: line6: fix up NULL assignment mistakes
      Staging: line6: coding style cleanups for .h files.
      Staging: line6: fix checkpatch errors in capture.c
      Staging: line6: fix checkpatch errors in control.c
      Staging: line6: fix checkpatch errors in playback.c
      Staging: line6: fix checkpatch errors in pod.c
      Staging: line6: fix checkpatch errors in audio.c
      Staging: line6: fix checkpatch errors in driver.c
      Staging: line6: fix checkpatch errors in dumprequest.c
      Staging: line6: fix checkpatch errors in midi.c
      Staging: line6: fix checkpatch errors in midibuf.c
      Staging: line6: fix checkpatch errors in pcm.c
      Staging: line6: fix checkpatch errors in toneport.c
      Staging: line6: fix checkpatch errors in variax.c
      staging: document that the wifi staging drivers a bit better
      Staging: add USB serial Quatech driver
      Staging: serqt_usb: Lindent the code
      Staging: serqt_usb: add TODO file
      Staging: serqt_usb: fix checkpatch errors
      Staging: serqt_usb: fix build due to proc tty changes

Herton Ronaldo Krzesinski (2):
      Staging: agnx: mac80211 hw config change flags
      Staging: rtl8187se: fix build warnings

Huang Weiyi (1):
      Staging: remove duplicated #include's

Ian Abbott (12):
      Staging: comedi: add amplc_pc236 driver
      Staging: comedi: add adv_pci1723 driver
      Staging: comedi: add ampl_dio200 driver
      Staging: comedi: add amplc_pc263 driver
      Staging: comedi: add amplc_pci224 driver
      Staging: comedi: new devices for ni_pcimio.c
      Staging: comedi: Add a module parameter 'comedi_autoconfig'.
      Staging: comedi: Make comedi_auto_config() succeed when auto-configuration disabled.
      Staging: comedi: comedi_rt_task_context_t fix
      Staging: comedi: Use explicit value for enumerated constant INSN_CONFIG_GET_HARDWARE_BUFFER_SIZE.
      Staging: comedi: newer gcc warning fixes
      Staging: comedi: comedi_open: Fix null pointer dereference.

Ivan Martinez (2):
      Staging: comedi: add cb_pcidas driver
      Staging: comedi: add cb_pcidda driver

J.P. Mellor (1):
      Staging: comedi: add ni_660x driver

Jeremy Theler (1):
      Staging: comedi: add adq12b driver

Jon Grierson (2):
      Staging: comedi: add adl_pci7296 driver
      Staging: comedi: add ni_65xx driver

Josef Jiru (1):
      Staging: rt2870: add Linksys WUSB600N device id

José Luis Sánchez (2):
      Staging: comedi: add acl7225b driver
      Staging: comedi: add pcl730 driver

Juan Grigera (1):
      Staging: comedi: add pcl816 driver

Julia Lawall (12):
      Staging: agnx: Move a dereference below a NULL test
      Staging: go7007: Move a dereference below a NULL test
      Staging: go7007: introduce missing kfree
      Staging: meilhaus: Correct use of ! and &
      Staging: meilhaus: Use DEFINE_SPINLOCK
      Staging: rspiusb: use USB API functions rather than constants
      Staging: otus: use USB API functions rather than constants
      Staging: rt2860,rt2870: Correct use of ! and &
      Staging: comedi: Correct use of ! and &
      Staging: comedi: Use DEFINE_SPINLOCK
      Staging: comedi: introduce missing kfree
      Staging: comedi: Move a dereference below a NULL test

Justin Bronder (1):
      Staging: b3dfg: Prepare b3dfg for submission upstream.

Kalle Valo (3):
      Staging: at76_usb: mention mac80211 port in TODO file
      Staging: at76_usb: convert to use linux/ieee80211.h
      Staging: Add stlc45xx, wi-fi driver for stlc4550/4560

Kruchinin Daniil (1):
      Staging: comedi: add unioxx5 driver

Lior Dotan (5):
      Staging: slicoss: use request_firmware
      Staging: SLICOSS: remove the static firmware header files
      Staging: slicoss: add binary firmware to firmware directory
      Staging: SLICOSS: free resources on entry_probe error path
      Staging: SLICOSS: use gfp_kernel where possible

Marcin Obara (1):
      Staging: add heci driver

Mariusz Kozlowski (12):
      Staging: comedi: usbduxfast: remove kernel version checks
      Staging: comedi: usbduxfast: add comedi debug to Kconfig
      Staging: comedi: usbduxfast: fix checkpatch issues plus some style cleanups etc.
      Staging: comedi: usbduxfast: annotate __init and __exit functions
      Staging: comedi: usbduxfast: remove .bss variable initialization
      Staging: comedi: usbduxfast: don't initialize semaphores on init
      Staging: comedi: usbduxfast: balance semaphores up/down in attach error path
      Staging: comedi: usbdux: remove .bss variable initialization
      Staging: comedi: usbdux: don't initialize semaphores on init
      Staging: comedi: usbdux: annotate __init and __exit functions
      Staging: comedi: remove LINUX_VERSION_CODE checks
      Staging: comedi: remove unnecessary #include <linux/version.h>

Mark Einon (2):
      Staging: rt2860: Fix remaining build warnings
      Staging: rt2860: Remove dependency on CFLAG RT2860

Markus Grabner (1):
      Staging: add line6 usb driver

Markus Kempf (1):
      Staging: comedi: add ii_pci20kc driver

Michael Hillmann (1):
      Staging: comedi: add ke_counter driver

Michal Dobes (7):
      Staging: comedi: add amcc_s5933 header file
      Staging: comedi: add adl_pci9118 driver
      Staging: comedi: add adv_pci1710 driver
      Staging: comedi: add pcl724 driver
      Staging: comedi: add pcl821 driver
      Staging: comedi: add pcl818 driver
      Staging: comedi: add adv_pci_dio driver

Michel Lachaine (2):
      Staging: comedi: add adl_pci7432 driver
      Staging: comedi: add adl_pci8164 driver

Mithlesh Thukral (31):
      Staging: sxg: New SXG_SGL design and MAC Header changes
      Staging: sxg: Typedef removal - pending work
      Staging: sxg: Commenting style fixes - Pending work
      Staging: sxg: Indentation fixes - mostly 80 char lines
      Staging: sxg: Receive code and data structure cleanups
      Staging: sxg: Ethtool framework and Receive code path changes
      Staging: sxg: SXG SGL related cleanup in data structures and code
      Staging: sxg: Locking related changes. Fix locking levels
      Staging: sxg: Add Ethtool functionality enhancement and misc cleanups
      Staging: sxg: Firmware updates
      Staging: sxg: Fix to load card on low memory machines
      Staging: sxg: Add multicast support for Sahara SXG driver
      Staging: sxg: Add NAPI feature to Sahara SXG Driver
      Staging: sxg: Cleanup the SXG driver of unused space and functions
      Staging: sxg: Add Jumbo frames support to Sahara SXG Driver
      Staging: sxg: Removed unnecessary checks while taking Transmit Locks
      Staging: sxg: Make SXG driver use MSI-X interrupts if possible
      Staging: sxg: Add Checksum Offload support for Sahara SXG driver
      Staging: sxg: Fix memory leak in case of allocation failure
      Staging: sxg: Add firmware files for Rev B card
      Staging: sxg: Add Rev B support in the Sahara SXG driver
      Staging: sxg: Remove unused Rev A microcode files
      Staging: sxg: Add checksum control option through ethtool interface
      Staging: sxg: Fix memory leak caused by double allocation of rings
      Staging: sxg: Fix the module in Kconfig file for Sahara SXG driver
      Staging: sxg: Fix interface bug not working after open is called second time.
      Staging: sxg: Read the correct MAC address from the card for Rev B cards
      Staging: sxg: Fix a warning dump emitted by rtnl_watchdog during LTP tests
      Staging: sxg: Add watchdog timer for managing Link states for SXG driver
      Staging: sxg: Add support to download the firmware using request_firmware()
      Staging: sxg: slicoss: Specify the license for Sahara SXG and Slicoss drivers

Moritz Muehlenhoff (64):
      Staging: wlan-ng: Remove use of __WLAN_ATTRIB_PACK__
      Staging: wlan-ng: Remove use of WLAN_ADDR_LEN
      Staging: wlan-ng: Remove stray comments in header files
      Staging: wlan-ng: Cleanup wlan_compat.h more
      Staging: wlan-ng: Remove DBFENTER/DBFEXIT macros
      Staging: wlan-ng: Use generic byteorder macros
      Staging: wlan-ng: Replace BITx with the generic BIT(x)
      Staging: wlan-ng: Move URB_ASYNC_UNLINK and USB_QUEUE_BULK out of wlan_compat.h
      Staging: wlan-ng: Remove WLAN_LOG_INFO
      Staging: wlan-ng: Remove wlan_max()/wlan_min()
      Staging: wlan-ng: Replace WLAN_LOG_NOTICE with printk()
      Staging: wlan-ng: Replace WLAN_LOG_ERROR() with printk()
      Staging: wlan-ng: Replace WLAN_LOG_WARNING() with printk()
      Staging: wlan-ng: Replace wlan_isprint() with generic isprint()
      Staging: wlan-ng: Remove dead/unused code from p80211types.h
      Staging: wlan-ng: Remove dead/unused code from p80211hdr.h
      Staging: wlan-ng: Remove dead/unused code from p80211meta.h
      Staging: wlan-ng: Remove dead/unused code from hfa384x.h
      Staging: wlan-ng: Remove dead/unused code from p80211msg.h
      Staging: wlan-ng: Remove dead/unused code from p80211netdev.h
      Staging: wlan-ng: Remove dead/unused code from p80211conv.c
      Staging: wlan-ng: Remove dead/unused code from p80211conv.h
      Staging: wlan-ng: Remove dead/unused code from p80211req.c
      Staging: wlan-ng: Replace SSWAP() with the generic swap(). Also remove a
      Staging: wlan-ng: Remove more dead/unused code from p80211types.h
      Staging: wlan-ng: Remove dead/unused code from prism2sta.c
      Staging: wlan-ng: Remove dead code from prism2mgmt.c
      Staging: wlan-ng: Remove dead code from hfa384x_usb.c
      Staging: wlan-ng: Remove unused header file p80211metamib.h
      Staging: wlan-ng: Remove dead/unused code from p80211metadef.h
      Staging: wlan-ng: Remove dead/unused code from p80211ioctl.h
      Staging: wlan-ng: Remove dead/unused code from hfa384x.h and p80211metamsg.h
      Staging: wlan-ng: Remove more dead/unused code from hfa384x.h
      Staging: wlan-ng: Remove WLAN_INCLUDE_DEBUG and some related, mostly unused
      Staging: wlan-ng: Move netdevice_t typedef into p80211netdev.h
      Staging: wlan-ng: Move wlan_mkprintstr() and wlan_hexchar() macros into prism2sta.c
      Staging: wlan-ng: Replace WLAN_LOG_DEBUG() with printk(KERN_DEBUG
      Staging: wlan-ng: p80211req.h: Coding style cleanups
      Staging: wlan-ng: p80211req.c: Coding style cleanups
      Staging: wlan-ng: prism2mgmt.h: Coding style cleanups
      Staging: wlan-ng: hfa384x.h: Coding style cleanups
      Staging: wlan-ng: p80211wext.c: Coding style cleanups
      Staging: wlan-ng: p80211meta.h: Coding style cleanups
      Staging: wlan-ng: p80211ioctl.h: Coding style cleanups
      Staging: wlan-ng: p80211metastruct.h: Coding style cleanups
      Staging: wlan-ng: p80211hdr.h: Coding style cleanups
      Staging: wlan-ng: p80211conv.h: Coding style cleanups
      Staging: wlan-ng: p80211conv.c: Coding style cleanups
      Staging: wlan-ng: p80211types.h: Coding style cleanups
      Staging: wlan-ng: p80211msg.h: Coding style cleanups
      Staging: wlan-ng: p80211netdev.h: Coding style cleanups
      Staging: wlan-ng: p80211mgmt.h: Coding style cleanups
      Staging: wlan-ng: prism2mib.c: Coding style cleanups
      Staging: wlan-ng: prism2usb.c: Coding style cleanups
      Staging: wlan-ng: prism2sta.c: Coding style cleanups
      Staging: wlan-ng: p80211netdev.c: Coding style cleanups
      Staging: wlan-ng: hfa384x_usb.c: Coding style cleanups
      Staging: wlan-ng: prism2mgmt.c: Coding style cleanups
      Staging: wlan-ng: Remove dead code from prism2mib.c
      Staging: wlan-ng: Remove more dead code from hfa384x_usb.c
      Staging: wlan-ng: Remove unnecessary checks for NULL before calling kfree()
      Staging: wlan-ng: Remove dead code from p80211netdev.c
      Staging: wlan-ng: Remove the now empty wlan_compat.h
      Staging: wlan-ng: Replace local byteorder macros

Oystein Svendsen (1):
      Staging: comedi: add das6402 driver

Pablo Mejia (1):
      Staging: comedi: add aio_aio12_8 driver

Pekka Enberg (14):
      Staging: w35und: remove unused header files
      Staging: w35und: remove unnecessary os_common.h header file
      Staging: w35und: remove crazy commented out includes
      Staging: w35und: unify mto.h and mto_f.h header files
      Staging: w35und: convert code to use ETH_ALEN
      Staging: w35und: remove useless macro from common.h
      Staging: w35und: kill WBDEBUG and remove common.h header file
      Staging: w35und: typedef removal
      Staging: w35und: remove hw_data_t typedef
      Staging: w35und: Remove MTO_FUNC_INPUT macro obfuscation
      Staging: w35und: remove unused bssdscpt.h header
      Staging: w35und: remove ds_tkip.h header
      Staging: w35und: remove gl_80211.h header
      Staging: rt2860: remove kernel version compatibility wrappers

Perry J. Piplani (1):
      Staging: comedi: add dmm32at driver

Peter Teoh (1):
      Staging: rt2870: Removal of kernel_thread() API

Randy Dunlap (16):
      Staging: sxg: fix napi interface build
      Staging: altera: fix printk format warnings
      Staging: mimio: depends on INPUT
      Staging: otus: fix mixed declarations
      Staging: android: binder: fix printk format warnings
      Staging: android: ram_console: fix printk format warning
      Staging: Android: fix more printk formats
      Staging: rtl8187se: fix printk format warnings
      Staging: rt2860: fix printk format warnings
      Staging: pohmelfs: fix kconfig dependencies
      Staging: stlc45xx: fix printk format warnings
      Staging: phison: fix kconfig for clean build
      Staging: phison: depends on PCI
      Staging: p9auth: fix dependency/build error
      Staging: line6: depends on SND
      Staging: line6: fix build error, select SND_RAWMIDI

Richard Bytheway (1):
      Staging: comedi: add cb_pcimdas driver

Richard Kennedy (1):
      Staging: wlan-ng: block ioctls until card fully initialised

Robert Schwebel (1):
      Staging: comedi: add ssv_dnp driver

Roel Kluin (5):
      Staging: agnx: i reaches -1, tested 0
      Staging: meilhaus: unsigned won't get negative after subtraction
      Staging: otus: logical/bit and confusion
      Staging: rtl8187se: ! x & y problem in inactive code
      Staging: comedi: rtd520: &&/|| typo

Stanislaw Raczynski (1):
      Staging: comedi: add mpc624 driver

Stefano Rivoir (1):
      Staging: comedi: add contec_pci_dio driver

Stoyan Gaydarov (1):
      Staging: BUG to BUG_ON changes

Wei Yongjun (2):
      Staging: usbip: kmem_cache_alloc/memset -> kmem_cache_zalloc
      Staging: remove some pointless conditionals before kfree_skb()

Yoshiya Matsuzaka (1):
      Staging: comedi: add cb_pcidio driver

Zachary Ware (1):
      Staging: comedi: add aio_iiro_16 driver

nsyeow (1):
      Staging: comedi: add adl_pci6208 driver

