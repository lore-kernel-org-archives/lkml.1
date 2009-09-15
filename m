Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZIOTI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZIOTI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbZIOTIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:08:51 -0400
Received: from kroah.org ([198.145.64.141]:35833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758305AbZIOTHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:07:34 -0400
Date: Tue, 15 Sep 2009 12:05:20 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING patches for 2.6.31-git
Message-ID: <20090915190520.GA834@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the bit staging update for the 2.6.31 merge window.

There are a lot of new drivers in here:
	- microsoft hyper-v drivers
	- wireless drivers
	- cowloop
	- others that I can't remember
and lots of cleanups and fixes as well, and a lot of drivers have been
removed due to lack of activity, or because they duplicate other drivers
in the kernel tree.  See the shortlog below for details.

All of these are contained within the drivers/staging tree, and have
been in the linux-next and -mm trees for a while now.

Overall, we almost broke even with our cleanups and removals for what
was done here:
 1267 files changed, 297615 insertions(+), 214568 deletions(-)

So only a small amount of new crap added :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                            |   36 +-
 drivers/staging/Makefile                           |   20 +-
 drivers/staging/agnx/pci.c                         |    2 +-
 drivers/staging/altpciechdma/altpciechdma.c        |    2 +-
 drivers/staging/android/binder.c                   |  713 +-
 drivers/staging/android/lowmemorykiller.c          |   41 +-
 drivers/staging/android/lowmemorykiller.txt        |   16 -
 drivers/staging/asus_oled/asus_oled.c              |  404 +-
 drivers/staging/at76_usb/Kconfig                   |    8 -
 drivers/staging/at76_usb/Makefile                  |    1 -
 drivers/staging/at76_usb/TODO                      |    7 -
 drivers/staging/at76_usb/at76_usb.c                | 5579 -----------
 drivers/staging/at76_usb/at76_usb.h                |  706 --
 drivers/staging/b3dfg/b3dfg.c                      |   41 +-
 drivers/staging/comedi/comedi.h                    | 1002 +-
 drivers/staging/comedi/comedi_compat32.c           |  115 +-
 drivers/staging/comedi/comedi_compat32.h           |    4 +-
 drivers/staging/comedi/comedi_fops.c               |  278 +-
 drivers/staging/comedi/comedi_ksyms.c              |    3 -
 drivers/staging/comedi/comedidev.h                 |   85 +-
 drivers/staging/comedi/comedilib.h                 |   77 +-
 drivers/staging/comedi/drivers.c                   |  184 +-
 drivers/staging/comedi/drivers/8253.h              |   69 +-
 drivers/staging/comedi/drivers/8255.c              |   54 +-
 drivers/staging/comedi/drivers/8255.h              |   16 +-
 drivers/staging/comedi/drivers/acl7225b.c          |   22 +-
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    3 +
 .../comedi/drivers/addi-data/amcc_s5933_58.h       |    3 +
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |   93 +-
 drivers/staging/comedi/drivers/adl_pci7296.c       |   39 +-
 drivers/staging/comedi/drivers/adl_pci7432.c       |   57 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |  126 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  361 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |  532 +-
 drivers/staging/comedi/drivers/adq12b.c            |  371 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  417 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |   73 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  306 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   36 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |   30 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |  314 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |  118 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |  101 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  260 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |  497 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |   42 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |  168 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |  671 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       | 1788 ++--
 drivers/staging/comedi/drivers/cb_pcidda.c         |  218 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |   74 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   89 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   61 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |   56 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |   14 +-
 drivers/staging/comedi/drivers/comedi_fc.h         |    4 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |   29 +-
 drivers/staging/comedi/drivers/comedi_test.c       |  143 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |   48 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |  119 +-
 drivers/staging/comedi/drivers/das08.c             |  622 +-
 drivers/staging/comedi/drivers/das08.h             |    3 +-
 drivers/staging/comedi/drivers/das08_cs.c          |   25 +-
 drivers/staging/comedi/drivers/das16.c             |  828 +-
 drivers/staging/comedi/drivers/das16m1.c           |  132 +-
 drivers/staging/comedi/drivers/das1800.c           |  658 +-
 drivers/staging/comedi/drivers/das6402.c           |   23 +-
 drivers/staging/comedi/drivers/das800.c            |  224 +-
 drivers/staging/comedi/drivers/dmm32at.c           |  144 +-
 drivers/staging/comedi/drivers/dt2801.c            |  242 +-
 drivers/staging/comedi/drivers/dt2811.c            |  178 +-
 drivers/staging/comedi/drivers/dt2814.c            |   16 +-
 drivers/staging/comedi/drivers/dt2815.c            |   38 +-
 drivers/staging/comedi/drivers/dt2817.c            |   19 +-
 drivers/staging/comedi/drivers/dt282x.c            |  264 +-
 drivers/staging/comedi/drivers/dt3000.c            |  145 +-
 drivers/staging/comedi/drivers/dt9812.c            |   85 +-
 drivers/staging/comedi/drivers/fl512.c             |   37 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |  236 +-
 drivers/staging/comedi/drivers/icp_multi.c         |  198 +-
 drivers/staging/comedi/drivers/icp_multi.h         |   74 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |  127 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |  298 +-
 drivers/staging/comedi/drivers/jr3_pci.h           |   40 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   67 +-
 drivers/staging/comedi/drivers/me4000.c            |  881 +-
 drivers/staging/comedi/drivers/me_daq.c            |  218 +-
 drivers/staging/comedi/drivers/mite.c              |  138 +-
 drivers/staging/comedi/drivers/mite.h              |  144 +-
 drivers/staging/comedi/drivers/mpc624.c            |   48 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c        |   26 +-
 drivers/staging/comedi/drivers/multiq3.c           |   45 +-
 drivers/staging/comedi/drivers/ni_6527.c           |  109 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |  402 +-
 drivers/staging/comedi/drivers/ni_660x.c           |  293 +-
 drivers/staging/comedi/drivers/ni_670x.c           |  101 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |   93 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |   69 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |  318 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |  128 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |   80 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |   43 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |  452 +-
 drivers/staging/comedi/drivers/ni_labpc.h          |    5 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |   70 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     | 1662 ++--
 drivers/staging/comedi/drivers/ni_mio_cs.c         |   36 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |  343 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         | 2065 ++--
 drivers/staging/comedi/drivers/ni_stc.h            |   64 +-
 drivers/staging/comedi/drivers/ni_tio.c            |  475 +-
 drivers/staging/comedi/drivers/ni_tio.h            |   47 +-
 drivers/staging/comedi/drivers/ni_tio_internal.h   |   58 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c         |  105 +-
 drivers/staging/comedi/drivers/pcl711.c            |  107 +-
 drivers/staging/comedi/drivers/pcl724.c            |   33 +-
 drivers/staging/comedi/drivers/pcl725.c            |    7 +-
 drivers/staging/comedi/drivers/pcl726.c            |   59 +-
 drivers/staging/comedi/drivers/pcl730.c            |   16 +-
 drivers/staging/comedi/drivers/pcl812.c            |  480 +-
 drivers/staging/comedi/drivers/pcl816.c            |  220 +-
 drivers/staging/comedi/drivers/pcl818.c            |  338 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   28 +-
 drivers/staging/comedi/drivers/pcm3730.c           |   16 +-
 drivers/staging/comedi/drivers/pcmad.c             |   19 +-
 drivers/staging/comedi/drivers/pcmda12.c           |   25 +-
 drivers/staging/comedi/drivers/pcmmio.c            |  287 +-
 drivers/staging/comedi/drivers/pcmuio.c            |  228 +-
 drivers/staging/comedi/drivers/plx9080.h           |    8 +-
 drivers/staging/comedi/drivers/poc.c               |  104 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |  115 +-
 drivers/staging/comedi/drivers/rtd520.c            |  487 +-
 drivers/staging/comedi/drivers/rti800.c            |   83 +-
 drivers/staging/comedi/drivers/rti802.c            |   21 +-
 drivers/staging/comedi/drivers/s526.c              |  203 +-
 drivers/staging/comedi/drivers/s626.c              | 1019 ++-
 drivers/staging/comedi/drivers/s626.h              |   16 +-
 drivers/staging/comedi/drivers/serial2002.c        |  201 +-
 drivers/staging/comedi/drivers/skel.c              |   82 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |   40 +-
 drivers/staging/comedi/drivers/unioxx5.c           |  106 +-
 drivers/staging/comedi/drivers/usbdux.c            |  268 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |  459 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |  135 +-
 drivers/staging/comedi/kcomedilib/data.c           |   12 +-
 drivers/staging/comedi/kcomedilib/dio.c            |    8 +-
 drivers/staging/comedi/kcomedilib/get.c            |   55 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |   35 +-
 drivers/staging/comedi/kcomedilib/ksyms.c          |    4 -
 drivers/staging/comedi/proc.c                      |   23 +-
 drivers/staging/comedi/range.c                     |   21 +-
 drivers/staging/cowloop/Kconfig                    |   16 +
 drivers/staging/cowloop/Makefile                   |    1 +
 drivers/staging/cowloop/TODO                       |   11 +
 drivers/staging/cowloop/cowloop.c                  | 2842 ++++++
 drivers/staging/cowloop/cowloop.h                  |   66 +
 drivers/staging/cpc-usb/TODO                       |    1 +
 drivers/staging/cpc-usb/cpc-usb_drv.c              |    1 -
 drivers/staging/cpc-usb/cpc.h                      |  519 +-
 drivers/staging/cpc-usb/cpc_int.h                  |    8 +-
 drivers/staging/cpc-usb/cpcusb.h                   |    2 +-
 drivers/staging/dream/Kconfig                      |   12 +
 drivers/staging/dream/Makefile                     |    4 +
 drivers/staging/dream/camera/Kconfig               |   46 +
 drivers/staging/dream/camera/Makefile              |    7 +
 drivers/staging/dream/camera/msm_camera.c          | 2181 +++++
 drivers/staging/dream/camera/msm_io7x.c            |  291 +
 drivers/staging/dream/camera/msm_io8x.c            |  320 +
 drivers/staging/dream/camera/msm_v4l2.c            |  797 ++
 drivers/staging/dream/camera/msm_vfe7x.c           |  701 ++
 drivers/staging/dream/camera/msm_vfe7x.h           |  255 +
 drivers/staging/dream/camera/msm_vfe8x.c           |  756 ++
 drivers/staging/dream/camera/msm_vfe8x.h           |  895 ++
 drivers/staging/dream/camera/msm_vfe8x_proc.c      | 4003 ++++++++
 drivers/staging/dream/camera/msm_vfe8x_proc.h      | 1549 +++
 drivers/staging/dream/camera/mt9d112.c             |  761 ++
 drivers/staging/dream/camera/mt9d112.h             |   36 +
 drivers/staging/dream/camera/mt9d112_reg.c         |  307 +
 drivers/staging/dream/camera/mt9p012.h             |   51 +
 drivers/staging/dream/camera/mt9p012_fox.c         | 1305 +++
 drivers/staging/dream/camera/mt9p012_reg.c         |  573 ++
 drivers/staging/dream/camera/mt9t013.c             | 1496 +++
 drivers/staging/dream/camera/mt9t013.h             |   48 +
 drivers/staging/dream/camera/mt9t013_reg.c         |  266 +
 drivers/staging/dream/camera/s5k3e2fx.c            | 1310 +++
 drivers/staging/dream/camera/s5k3e2fx.h            |    9 +
 drivers/staging/dream/gpio_axis.c                  |  180 +
 drivers/staging/dream/gpio_event.c                 |  224 +
 drivers/staging/dream/gpio_input.c                 |  343 +
 drivers/staging/dream/gpio_matrix.c                |  406 +
 drivers/staging/dream/gpio_output.c                |   84 +
 drivers/staging/dream/qdsp5/Makefile               |   17 +
 drivers/staging/dream/qdsp5/adsp.c                 | 1163 +++
 drivers/staging/dream/qdsp5/adsp.h                 |  369 +
 drivers/staging/dream/qdsp5/adsp_6210.c            |  283 +
 drivers/staging/dream/qdsp5/adsp_6220.c            |  284 +
 drivers/staging/dream/qdsp5/adsp_6225.c            |  328 +
 drivers/staging/dream/qdsp5/adsp_driver.c          |  641 ++
 drivers/staging/dream/qdsp5/adsp_info.c            |  121 +
 .../staging/dream/qdsp5/adsp_jpeg_patch_event.c    |   31 +
 drivers/staging/dream/qdsp5/adsp_jpeg_verify_cmd.c |  182 +
 drivers/staging/dream/qdsp5/adsp_lpm_verify_cmd.c  |   65 +
 drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c |   54 +
 drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c  |  239 +
 .../staging/dream/qdsp5/adsp_video_verify_cmd.c    |  163 +
 .../staging/dream/qdsp5/adsp_videoenc_verify_cmd.c |  235 +
 drivers/staging/dream/qdsp5/audio_aac.c            | 1052 ++
 drivers/staging/dream/qdsp5/audio_amrnb.c          |  873 ++
 drivers/staging/dream/qdsp5/audio_evrc.c           |  845 ++
 drivers/staging/dream/qdsp5/audio_in.c             |  967 ++
 drivers/staging/dream/qdsp5/audio_mp3.c            |  971 ++
 drivers/staging/dream/qdsp5/audio_out.c            |  851 ++
 drivers/staging/dream/qdsp5/audio_qcelp.c          |  856 ++
 drivers/staging/dream/qdsp5/audmgr.c               |  313 +
 drivers/staging/dream/qdsp5/audmgr.h               |  215 +
 drivers/staging/dream/qdsp5/audmgr_new.h           |  213 +
 drivers/staging/dream/qdsp5/audpp.c                |  429 +
 drivers/staging/dream/qdsp5/evlog.h                |  133 +
 drivers/staging/dream/qdsp5/snd.c                  |  279 +
 drivers/staging/dream/smd/Kconfig                  |   26 +
 drivers/staging/dream/smd/Makefile                 |    6 +
 .../staging/dream/smd/rpc_server_dog_keepalive.c   |   68 +
 drivers/staging/dream/smd/rpc_server_time_remote.c |   77 +
 drivers/staging/dream/smd/smd.c                    | 1330 +++
 drivers/staging/dream/smd/smd_private.h            |  171 +
 drivers/staging/dream/smd/smd_qmi.c                |  860 ++
 drivers/staging/dream/smd/smd_rpcrouter.c          | 1274 +++
 drivers/staging/dream/smd/smd_rpcrouter.h          |  195 +
 drivers/staging/dream/smd/smd_rpcrouter_device.c   |  376 +
 drivers/staging/dream/smd/smd_rpcrouter_servers.c  |  229 +
 drivers/staging/dream/smd/smd_tty.c                |  213 +
 drivers/staging/dream/synaptics_i2c_rmi.c          |  658 ++
 drivers/staging/dream/synaptics_i2c_rmi.h          |   53 +
 drivers/staging/dst/export.c                       |    2 +-
 drivers/staging/echo/TODO                          |    5 +-
 drivers/staging/echo/bit_operations.h              |  226 -
 drivers/staging/echo/echo.c                        |  190 +-
 drivers/staging/echo/echo.h                        |   15 +-
 drivers/staging/echo/fir.h                         |  109 +-
 drivers/staging/echo/mmx.h                         |  281 -
 drivers/staging/echo/oslec.h                       |   70 +-
 drivers/staging/epl/Benchmark.h                    |  425 -
 drivers/staging/epl/Debug.h                        |  694 --
 drivers/staging/epl/Edrv8139.c                     | 1246 ---
 drivers/staging/epl/EdrvFec.h                      |  114 -
 drivers/staging/epl/EdrvSim.h                      |   89 -
 drivers/staging/epl/Epl.h                          |  272 -
 drivers/staging/epl/EplAmi.h                       |  323 -
 drivers/staging/epl/EplApiGeneric.c                | 2054 ----
 drivers/staging/epl/EplApiLinux.h                  |  141 -
 drivers/staging/epl/EplApiLinuxKernel.c            | 1173 ---
 drivers/staging/epl/EplApiProcessImage.c           |  328 -
 drivers/staging/epl/EplCfg.h                       |  196 -
 drivers/staging/epl/EplDef.h                       |  355 -
 drivers/staging/epl/EplDll.h                       |  205 -
 drivers/staging/epl/EplDllCal.h                    |  123 -
 drivers/staging/epl/EplDllk.c                      | 4052 --------
 drivers/staging/epl/EplDllkCal.c                   | 1260 ---
 drivers/staging/epl/EplDlluCal.c                   |  529 --
 drivers/staging/epl/EplErrDef.h                    |  294 -
 drivers/staging/epl/EplErrorHandlerk.c             |  810 --
 drivers/staging/epl/EplEvent.h                     |  279 -
 drivers/staging/epl/EplEventk.c                    |  853 --
 drivers/staging/epl/EplEventu.c                    |  813 --
 drivers/staging/epl/EplFrame.h                     |  344 -
 drivers/staging/epl/EplIdentu.c                    |  486 -
 drivers/staging/epl/EplInc.h                       |  370 -
 drivers/staging/epl/EplInstDef.h                   |  363 -
 drivers/staging/epl/EplLed.h                       |   92 -
 drivers/staging/epl/EplNmt.h                       |  230 -
 drivers/staging/epl/EplNmtCnu.c                    |  701 --
 drivers/staging/epl/EplNmtMnu.c                    | 2828 ------
 drivers/staging/epl/EplNmtk.c                      | 1840 ----
 drivers/staging/epl/EplNmtkCal.c                   |  147 -
 drivers/staging/epl/EplNmtu.c                      |  706 --
 drivers/staging/epl/EplNmtuCal.c                   |  158 -
 drivers/staging/epl/EplObd.c                       | 3192 -------
 drivers/staging/epl/EplObd.h                       |  456 -
 drivers/staging/epl/EplObdMacro.h                  |  354 -
 drivers/staging/epl/EplObdkCal.c                   |  146 -
 drivers/staging/epl/EplObdu.c                      |  506 -
 drivers/staging/epl/EplObduCal.c                   |  543 --
 drivers/staging/epl/EplPdo.h                       |  117 -
 drivers/staging/epl/EplPdok.c                      |  669 --
 drivers/staging/epl/EplPdokCal.c                   |  266 -
 drivers/staging/epl/EplPdou.c                      |  565 --
 drivers/staging/epl/EplSdo.h                       |  241 -
 drivers/staging/epl/EplSdoAc.h                     |  111 -
 drivers/staging/epl/EplSdoAsndu.c                  |  483 -
 drivers/staging/epl/EplSdoAsySequ.c                | 2522 -----
 drivers/staging/epl/EplSdoComu.c                   | 3345 -------
 drivers/staging/epl/EplSdoUdpu.c                   |  650 --
 drivers/staging/epl/EplStatusu.c                   |  377 -
 drivers/staging/epl/EplTarget.h                    |  140 -
 drivers/staging/epl/EplTimer.h                     |  116 -
 drivers/staging/epl/EplTimeruLinuxKernel.c         |  446 -
 drivers/staging/epl/EplVersion.h                   |   98 -
 drivers/staging/epl/Kconfig                        |    6 -
 drivers/staging/epl/Makefile                       |   41 -
 drivers/staging/epl/SharedBuff.c                   | 1762 ----
 drivers/staging/epl/SharedBuff.h                   |  187 -
 drivers/staging/epl/ShbIpc-LinuxKernel.c           |  944 --
 drivers/staging/epl/ShbIpc.h                       |   99 -
 drivers/staging/epl/ShbLinuxKernel.h               |   68 -
 drivers/staging/epl/SocketLinuxKernel.c            |  197 -
 drivers/staging/epl/SocketLinuxKernel.h            |  105 -
 drivers/staging/epl/TimerHighReskX86.c             |  510 -
 drivers/staging/epl/VirtualEthernetLinux.c         |  348 -
 drivers/staging/epl/amix86.c                       |  861 --
 drivers/staging/epl/demo_main.c                    |  947 --
 drivers/staging/epl/edrv.h                         |  167 -
 drivers/staging/epl/global.h                       |  144 -
 drivers/staging/epl/kernel/EplDllk.h               |  153 -
 drivers/staging/epl/kernel/EplDllkCal.h            |  129 -
 drivers/staging/epl/kernel/EplErrorHandlerk.h      |   88 -
 drivers/staging/epl/kernel/EplEventk.h             |   96 -
 drivers/staging/epl/kernel/EplNmtk.h               |   90 -
 drivers/staging/epl/kernel/EplObdk.h               |  156 -
 drivers/staging/epl/kernel/EplPdok.h               |   98 -
 drivers/staging/epl/kernel/EplPdokCal.h            |   86 -
 drivers/staging/epl/kernel/EplTimerHighResk.h      |   96 -
 drivers/staging/epl/kernel/EplTimerk.h             |  108 -
 drivers/staging/epl/kernel/VirtualEthernet.h       |   84 -
 drivers/staging/epl/proc_fs.c                      |  410 -
 drivers/staging/epl/proc_fs.h                      |   89 -
 drivers/staging/epl/user/EplCfgMau.h               |  276 -
 drivers/staging/epl/user/EplDllu.h                 |   96 -
 drivers/staging/epl/user/EplDlluCal.h              |  106 -
 drivers/staging/epl/user/EplEventu.h               |   96 -
 drivers/staging/epl/user/EplIdentu.h               |   94 -
 drivers/staging/epl/user/EplLedu.h                 |   95 -
 drivers/staging/epl/user/EplNmtCnu.h               |   92 -
 drivers/staging/epl/user/EplNmtMnu.h               |  117 -
 drivers/staging/epl/user/EplNmtu.h                 |  139 -
 drivers/staging/epl/user/EplNmtuCal.h              |   80 -
 drivers/staging/epl/user/EplObdu.h                 |  169 -
 drivers/staging/epl/user/EplObduCal.h              |  126 -
 drivers/staging/epl/user/EplPdou.h                 |   96 -
 drivers/staging/epl/user/EplSdoAsndu.h             |   96 -
 drivers/staging/epl/user/EplSdoAsySequ.h           |  100 -
 drivers/staging/epl/user/EplSdoComu.h              |  114 -
 drivers/staging/epl/user/EplSdoUdpu.h              |   97 -
 drivers/staging/epl/user/EplStatusu.h              |   90 -
 drivers/staging/epl/user/EplTimeru.h               |   95 -
 drivers/staging/et131x/Makefile                    |    3 -
 drivers/staging/et131x/et1310_address_map.h        | 2304 ++---
 drivers/staging/et131x/et1310_eeprom.c             |  215 +-
 drivers/staging/et131x/et1310_eeprom.h             |   22 +-
 drivers/staging/et131x/et1310_jagcore.c            |  220 -
 drivers/staging/et131x/et1310_jagcore.h            |   36 +-
 drivers/staging/et131x/et1310_mac.c                |  358 +-
 drivers/staging/et131x/et1310_mac.h                |    8 +-
 drivers/staging/et131x/et1310_phy.c                |  770 +-
 drivers/staging/et131x/et1310_phy.h                |  941 +-
 drivers/staging/et131x/et1310_pm.c                 |   96 +-
 drivers/staging/et131x/et1310_pm.h                 |   46 +-
 drivers/staging/et131x/et1310_rx.c                 |  572 +-
 drivers/staging/et131x/et1310_rx.h                 |  198 +-
 drivers/staging/et131x/et1310_tx.c                 | 1067 +--
 drivers/staging/et131x/et1310_tx.h                 |  108 +-
 drivers/staging/et131x/et131x_adapter.h            |  141 +-
 drivers/staging/et131x/et131x_config.c             |  325 -
 drivers/staging/et131x/et131x_debug.c              |  217 -
 drivers/staging/et131x/et131x_debug.h              |  255 -
 drivers/staging/et131x/et131x_defs.h               |   28 +-
 drivers/staging/et131x/et131x_initpci.c            |  726 +-
 drivers/staging/et131x/et131x_initpci.h            |    6 +-
 drivers/staging/et131x/et131x_isr.c                |  240 +-
 drivers/staging/et131x/et131x_isr.h                |    6 +-
 drivers/staging/et131x/et131x_netdev.c             |  327 +-
 drivers/staging/et131x/et131x_netdev.h             |    6 +-
 drivers/staging/et131x/et131x_version.h            |    6 +-
 drivers/staging/heci/Kconfig                       |    7 -
 drivers/staging/heci/Makefile                      |    9 -
 drivers/staging/heci/TODO                          |    6 -
 drivers/staging/heci/heci.h                        |  175 -
 drivers/staging/heci/heci_data_structures.h        |  529 --
 drivers/staging/heci/heci_init.c                   | 1083 ---
 drivers/staging/heci/heci_interface.c              |  498 -
 drivers/staging/heci/heci_interface.h              |  170 -
 drivers/staging/heci/heci_main.c                   | 1576 ---
 drivers/staging/heci/heci_version.h                |   54 -
 drivers/staging/heci/interrupt.c                   | 1555 ---
 drivers/staging/heci/io_heci.c                     |  872 --
 drivers/staging/hv/BlkVsc.c                        |  111 +
 drivers/staging/hv/Channel.c                       | 1015 ++
 drivers/staging/hv/Channel.h                       |  112 +
 drivers/staging/hv/ChannelInterface.c              |  152 +
 drivers/staging/hv/ChannelInterface.h              |   35 +
 drivers/staging/hv/ChannelMgmt.c                   |  686 ++
 drivers/staging/hv/ChannelMgmt.h                   |  319 +
 drivers/staging/hv/Connection.c                    |  341 +
 drivers/staging/hv/Hv.c                            |  568 ++
 drivers/staging/hv/Hv.h                            |  144 +
 drivers/staging/hv/Kconfig                         |   32 +
 drivers/staging/hv/Makefile                        |   11 +
 drivers/staging/hv/NetVsc.c                        | 1379 +++
 drivers/staging/hv/NetVsc.h                        |  329 +
 drivers/staging/hv/NetVscApi.h                     |  123 +
 drivers/staging/hv/RingBuffer.c                    |  606 ++
 drivers/staging/hv/RingBuffer.h                    |  101 +
 drivers/staging/hv/RndisFilter.c                   | 1000 ++
 drivers/staging/hv/RndisFilter.h                   |   55 +
 drivers/staging/hv/StorVsc.c                       |  850 ++
 drivers/staging/hv/StorVscApi.h                    |  113 +
 drivers/staging/hv/TODO                            |   13 +
 drivers/staging/hv/VersionInfo.h                   |   31 +
 drivers/staging/hv/Vmbus.c                         |  311 +
 drivers/staging/hv/VmbusApi.h                      |  175 +
 drivers/staging/hv/VmbusChannelInterface.h         |   89 +
 drivers/staging/hv/VmbusPacketFormat.h             |  160 +
 drivers/staging/hv/VmbusPrivate.h                  |  134 +
 drivers/staging/hv/blkvsc_drv.c                    | 1511 +++
 drivers/staging/hv/hv_api.h                        |  905 ++
 drivers/staging/hv/logging.h                       |  119 +
 drivers/staging/hv/netvsc_drv.c                    |  618 ++
 drivers/staging/hv/osd.c                           |  156 +
 drivers/staging/hv/osd.h                           |   69 +
 drivers/staging/hv/rndis.h                         |  652 ++
 drivers/staging/hv/storvsc_drv.c                   | 1208 +++
 drivers/staging/hv/vmbus.h                         |   77 +
 drivers/staging/hv/vmbus_drv.c                     |  999 ++
 drivers/staging/hv/vstorage.h                      |  192 +
 drivers/staging/iio/Documentation/device.txt       |   49 +
 drivers/staging/iio/Documentation/iio_utils.h      |  159 +
 .../iio/Documentation/lis3l02dqbuffersimple.c      |  171 +
 drivers/staging/iio/Documentation/overview.txt     |   62 +
 drivers/staging/iio/Documentation/ring.txt         |   61 +
 drivers/staging/iio/Documentation/trigger.txt      |   38 +
 drivers/staging/iio/Documentation/userspace.txt    |   60 +
 drivers/staging/iio/Kconfig                        |   47 +
 drivers/staging/iio/Makefile                       |   16 +
 drivers/staging/iio/TODO                           |   69 +
 drivers/staging/iio/accel/Kconfig                  |   27 +
 drivers/staging/iio/accel/Makefile                 |   11 +
 drivers/staging/iio/accel/accel.h                  |  167 +
 drivers/staging/iio/accel/kxsd9.c                  |  395 +
 drivers/staging/iio/accel/lis3l02dq.h              |  232 +
 drivers/staging/iio/accel/lis3l02dq_core.c         |  926 ++
 drivers/staging/iio/accel/lis3l02dq_ring.c         |  600 ++
 drivers/staging/iio/accel/sca3000.h                |  298 +
 drivers/staging/iio/accel/sca3000_core.c           | 1509 +++
 drivers/staging/iio/accel/sca3000_ring.c           |  331 +
 drivers/staging/iio/adc/Kconfig                    |   13 +
 drivers/staging/iio/adc/Makefile                   |    8 +
 drivers/staging/iio/adc/adc.h                      |   13 +
 drivers/staging/iio/adc/max1363.h                  |  269 +
 drivers/staging/iio/adc/max1363_core.c             |  623 ++
 drivers/staging/iio/adc/max1363_ring.c             |  241 +
 drivers/staging/iio/chrdev.h                       |  118 +
 drivers/staging/iio/iio.h                          |  411 +
 drivers/staging/iio/industrialio-core.c            |  851 ++
 drivers/staging/iio/industrialio-ring.c            |  568 ++
 drivers/staging/iio/industrialio-trigger.c         |  399 +
 drivers/staging/iio/light/Kconfig                  |   13 +
 drivers/staging/iio/light/Makefile                 |    5 +
 drivers/staging/iio/light/light.h                  |   12 +
 drivers/staging/iio/light/tsl2561.c                |  276 +
 drivers/staging/iio/ring_generic.h                 |  283 +
 drivers/staging/iio/ring_hw.h                      |   22 +
 drivers/staging/iio/ring_sw.c                      |  433 +
 drivers/staging/iio/ring_sw.h                      |  189 +
 drivers/staging/iio/sysfs.h                        |  293 +
 drivers/staging/iio/trigger.h                      |  151 +
 drivers/staging/iio/trigger/Kconfig                |   21 +
 drivers/staging/iio/trigger/Makefile               |    5 +
 drivers/staging/iio/trigger/iio-trig-gpio.c        |  202 +
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |  228 +
 drivers/staging/iio/trigger_consumer.h             |   45 +
 drivers/staging/line6/capture.c                    |    4 +-
 drivers/staging/line6/driver.c                     |    2 +-
 drivers/staging/line6/pod.c                        |    8 +-
 drivers/staging/me4000/Kconfig                     |   10 -
 drivers/staging/me4000/Makefile                    |    1 -
 drivers/staging/me4000/README                      |   13 -
 drivers/staging/me4000/me4000.c                    | 6109 ------------
 drivers/staging/me4000/me4000.h                    |  966 --
 drivers/staging/me4000/me4000_firmware.h           |10033 --------------------
 drivers/staging/me4000/me4610_firmware.h           | 5409 -----------
 drivers/staging/meilhaus/Kconfig                   |  128 -
 drivers/staging/meilhaus/Makefile                  |   43 -
 drivers/staging/meilhaus/TODO                      |   10 -
 drivers/staging/meilhaus/me0600_device.c           |  213 -
 drivers/staging/meilhaus/me0600_device.h           |   97 -
 drivers/staging/meilhaus/me0600_dio.c              |  415 -
 drivers/staging/meilhaus/me0600_dio.h              |   68 -
 drivers/staging/meilhaus/me0600_dio_reg.h          |   41 -
 drivers/staging/meilhaus/me0600_ext_irq.c          |  469 -
 drivers/staging/meilhaus/me0600_ext_irq.h          |   58 -
 drivers/staging/meilhaus/me0600_ext_irq_reg.h      |   18 -
 drivers/staging/meilhaus/me0600_optoi.c            |  243 -
 drivers/staging/meilhaus/me0600_optoi.h            |   58 -
 drivers/staging/meilhaus/me0600_optoi_reg.h        |   35 -
 drivers/staging/meilhaus/me0600_relay.c            |  359 -
 drivers/staging/meilhaus/me0600_relay.h            |   63 -
 drivers/staging/meilhaus/me0600_relay_reg.h        |   36 -
 drivers/staging/meilhaus/me0600_ttli.c             |  238 -
 drivers/staging/meilhaus/me0600_ttli.h             |   58 -
 drivers/staging/meilhaus/me0600_ttli_reg.h         |   35 -
 drivers/staging/meilhaus/me0900_device.c           |  178 -
 drivers/staging/meilhaus/me0900_device.h           |   92 -
 drivers/staging/meilhaus/me0900_di.c               |  245 -
 drivers/staging/meilhaus/me0900_di.h               |   65 -
 drivers/staging/meilhaus/me0900_do.c               |  314 -
 drivers/staging/meilhaus/me0900_do.h               |   68 -
 drivers/staging/meilhaus/me0900_reg.h              |   40 -
 drivers/staging/meilhaus/me1000_device.c           |  206 -
 drivers/staging/meilhaus/me1000_device.h           |   59 -
 drivers/staging/meilhaus/me1000_dio.c              |  438 -
 drivers/staging/meilhaus/me1000_dio.h              |   71 -
 drivers/staging/meilhaus/me1000_dio_reg.h          |   50 -
 drivers/staging/meilhaus/me1400_device.c           |  253 -
 drivers/staging/meilhaus/me1400_device.h           |  108 -
 drivers/staging/meilhaus/me1400_ext_irq.c          |  507 -
 drivers/staging/meilhaus/me1400_ext_irq.h          |   62 -
 drivers/staging/meilhaus/me1400_ext_irq_reg.h      |   56 -
 drivers/staging/meilhaus/me1600_ao.c               | 1017 --
 drivers/staging/meilhaus/me1600_ao.h               |  128 -
 drivers/staging/meilhaus/me1600_ao_reg.h           |   66 -
 drivers/staging/meilhaus/me1600_device.c           |  259 -
 drivers/staging/meilhaus/me1600_device.h           |  101 -
 drivers/staging/meilhaus/me4600_ai.c               | 3405 -------
 drivers/staging/meilhaus/me4600_ai.h               |  175 -
 drivers/staging/meilhaus/me4600_ai_reg.h           |  107 -
 drivers/staging/meilhaus/me4600_ao.c               | 5974 ------------
 drivers/staging/meilhaus/me4600_ao.h               |  259 -
 drivers/staging/meilhaus/me4600_ao_reg.h           |  113 -
 drivers/staging/meilhaus/me4600_device.c           |  371 -
 drivers/staging/meilhaus/me4600_device.h           |  151 -
 drivers/staging/meilhaus/me4600_di.c               |  256 -
 drivers/staging/meilhaus/me4600_di.h               |   64 -
 drivers/staging/meilhaus/me4600_dio.c              |  510 -
 drivers/staging/meilhaus/me4600_dio.h              |   69 -
 drivers/staging/meilhaus/me4600_dio_reg.h          |   63 -
 drivers/staging/meilhaus/me4600_do.c               |  433 -
 drivers/staging/meilhaus/me4600_do.h               |   65 -
 drivers/staging/meilhaus/me4600_ext_irq.c          |  457 -
 drivers/staging/meilhaus/me4600_ext_irq.h          |   78 -
 drivers/staging/meilhaus/me4600_ext_irq_reg.h      |   41 -
 drivers/staging/meilhaus/me4600_reg.h              |   46 -
 drivers/staging/meilhaus/me6000_ao.c               | 3709 --------
 drivers/staging/meilhaus/me6000_ao.h               |  195 -
 drivers/staging/meilhaus/me6000_ao_reg.h           |  177 -
 drivers/staging/meilhaus/me6000_device.c           |  209 -
 drivers/staging/meilhaus/me6000_device.h           |  149 -
 drivers/staging/meilhaus/me6000_dio.c              |  415 -
 drivers/staging/meilhaus/me6000_dio.h              |   68 -
 drivers/staging/meilhaus/me6000_dio_reg.h          |   43 -
 drivers/staging/meilhaus/me6000_reg.h              |   35 -
 drivers/staging/meilhaus/me8100_device.c           |  185 -
 drivers/staging/meilhaus/me8100_device.h           |   97 -
 drivers/staging/meilhaus/me8100_di.c               |  684 --
 drivers/staging/meilhaus/me8100_di.h               |   89 -
 drivers/staging/meilhaus/me8100_di_reg.h           |   47 -
 drivers/staging/meilhaus/me8100_do.c               |  391 -
 drivers/staging/meilhaus/me8100_do.h               |   70 -
 drivers/staging/meilhaus/me8100_do_reg.h           |   36 -
 drivers/staging/meilhaus/me8100_reg.h              |   41 -
 drivers/staging/meilhaus/me8200_device.c           |  192 -
 drivers/staging/meilhaus/me8200_device.h           |   97 -
 drivers/staging/meilhaus/me8200_di.c               |  832 --
 drivers/staging/meilhaus/me8200_di.h               |   92 -
 drivers/staging/meilhaus/me8200_di_reg.h           |   75 -
 drivers/staging/meilhaus/me8200_dio.c              |  418 -
 drivers/staging/meilhaus/me8200_dio.h              |   68 -
 drivers/staging/meilhaus/me8200_dio_reg.h          |   43 -
 drivers/staging/meilhaus/me8200_do.c               |  591 --
 drivers/staging/meilhaus/me8200_do.h               |   75 -
 drivers/staging/meilhaus/me8200_do_reg.h           |   40 -
 drivers/staging/meilhaus/me8200_reg.h              |   46 -
 drivers/staging/meilhaus/me8254.c                  | 1176 ---
 drivers/staging/meilhaus/me8254.h                  |   80 -
 drivers/staging/meilhaus/me8254_reg.h              |  172 -
 drivers/staging/meilhaus/me8255.c                  |  462 -
 drivers/staging/meilhaus/me8255.h                  |   59 -
 drivers/staging/meilhaus/me8255_reg.h              |   50 -
 drivers/staging/meilhaus/mecirc_buf.h              |  131 -
 drivers/staging/meilhaus/mecommon.h                |   26 -
 drivers/staging/meilhaus/medebug.h                 |  125 -
 drivers/staging/meilhaus/medefines.h               |  449 -
 drivers/staging/meilhaus/medevice.c                | 1740 ----
 drivers/staging/meilhaus/medevice.h                |  304 -
 drivers/staging/meilhaus/medlist.c                 |  127 -
 drivers/staging/meilhaus/medlist.h                 |   91 -
 drivers/staging/meilhaus/medlock.c                 |  195 -
 drivers/staging/meilhaus/medlock.h                 |   76 -
 drivers/staging/meilhaus/medriver.h                |  350 -
 drivers/staging/meilhaus/medummy.c                 | 1264 ---
 drivers/staging/meilhaus/medummy.h                 |   40 -
 drivers/staging/meilhaus/meerror.h                 |  100 -
 drivers/staging/meilhaus/mefirmware.c              |  137 -
 drivers/staging/meilhaus/mefirmware.h              |   57 -
 drivers/staging/meilhaus/meids.h                   |   31 -
 drivers/staging/meilhaus/meinternal.h              |  363 -
 drivers/staging/meilhaus/meioctl.h                 |  515 -
 drivers/staging/meilhaus/memain.c                  | 2084 ----
 drivers/staging/meilhaus/memain.h                  |  266 -
 drivers/staging/meilhaus/meplx_reg.h               |   53 -
 drivers/staging/meilhaus/meslist.c                 |  173 -
 drivers/staging/meilhaus/meslist.h                 |  108 -
 drivers/staging/meilhaus/meslock.c                 |  136 -
 drivers/staging/meilhaus/meslock.h                 |   73 -
 drivers/staging/meilhaus/mesubdevice.c             |  317 -
 drivers/staging/meilhaus/mesubdevice.h             |  197 -
 drivers/staging/meilhaus/metempl_device.c          |  135 -
 drivers/staging/meilhaus/metempl_device.h          |   92 -
 drivers/staging/meilhaus/metempl_sub.c             |  149 -
 drivers/staging/meilhaus/metempl_sub.h             |   64 -
 drivers/staging/meilhaus/metempl_sub_reg.h         |   35 -
 drivers/staging/meilhaus/metypes.h                 |   95 -
 drivers/staging/otus/80211core/cagg.c              |    6 +-
 drivers/staging/otus/80211core/cmm.c               |    4 +-
 drivers/staging/otus/80211core/performance.c       |    6 +-
 drivers/staging/otus/hal/hpmain.c                  |    2 +-
 drivers/staging/otus/ioctl.c                       |   25 +-
 drivers/staging/otus/usbdrv.c                      |   14 -
 drivers/staging/otus/usbdrv.h                      |    4 -
 drivers/staging/otus/wrap_buf.c                    |    3 -
 drivers/staging/otus/wrap_dbg.c                    |    3 -
 drivers/staging/otus/wrap_ev.c                     |    7 -
 drivers/staging/otus/wrap_mem.c                    |    3 -
 drivers/staging/otus/wrap_mis.c                    |    3 -
 drivers/staging/otus/wrap_pkt.c                    |    4 -
 drivers/staging/otus/wrap_sec.c                    |    3 -
 drivers/staging/otus/wrap_usb.c                    |    3 -
 drivers/staging/otus/wwrap.c                       |    8 -
 drivers/staging/otus/zdcompat.h                    |   10 -
 drivers/staging/panel/panel.c                      |   50 +-
 drivers/staging/pata_rdc/Kconfig                   |    6 -
 drivers/staging/pata_rdc/Makefile                  |    2 -
 drivers/staging/pata_rdc/pata_rdc.c                |  955 --
 drivers/staging/pata_rdc/pata_rdc.h                |  144 -
 drivers/staging/pohmelfs/config.c                  |  101 +-
 drivers/staging/pohmelfs/crypto.c                  |    4 +-
 drivers/staging/pohmelfs/dir.c                     |   27 +-
 drivers/staging/pohmelfs/inode.c                   |    9 +-
 drivers/staging/pohmelfs/net.c                     |   20 +-
 drivers/staging/pohmelfs/netfs.h                   |    5 +
 drivers/staging/pohmelfs/trans.c                   |    3 +-
 drivers/staging/quatech_usb2/Kconfig               |   15 +
 drivers/staging/quatech_usb2/Makefile              |    1 +
 drivers/staging/quatech_usb2/TODO                  |    8 +
 drivers/staging/quatech_usb2/quatech_usb2.c        | 2025 ++++
 drivers/staging/rar/Kconfig                        |   17 +
 drivers/staging/rar/Makefile                       |    2 +
 drivers/staging/rar/rar_driver.c                   |  444 +
 drivers/staging/rar/rar_driver.h                   |   99 +
 drivers/staging/rspiusb/Kconfig                    |    6 -
 drivers/staging/rspiusb/Makefile                   |    1 -
 drivers/staging/rspiusb/TODO                       |   22 -
 drivers/staging/rspiusb/rspiusb.c                  |  923 --
 drivers/staging/rspiusb/rspiusb.h                  |   33 -
 drivers/staging/rt2860/2860_main_dev.c             |    7 +
 drivers/staging/rt2860/ap.h                        |  453 -
 drivers/staging/rt2860/chlist.h                    |    5 -
 drivers/staging/rt2860/common/action.c             |   11 +-
 drivers/staging/rt2860/common/ba_action.c          |   19 +-
 drivers/staging/rt2860/common/cmm_data.c           |  298 +-
 drivers/staging/rt2860/common/cmm_info.c           |   25 +-
 drivers/staging/rt2860/common/cmm_sanity.c         |  184 -
 drivers/staging/rt2860/common/cmm_wpa.c            |  806 +--
 drivers/staging/rt2860/common/eeprom.c             |   55 +-
 drivers/staging/rt2860/common/mlme.c               |  590 +--
 drivers/staging/rt2860/common/rtmp_init.c          |  386 +-
 drivers/staging/rt2860/common/spectrum.c           |    5 -
 drivers/staging/rt2860/dfs.h                       |   12 -
 drivers/staging/rt2860/link_list.h                 |  134 -
 drivers/staging/rt2860/md4.h                       |   42 -
 drivers/staging/rt2860/oid.h                       |  170 +-
 drivers/staging/rt2860/rt2860.h                    |    2 +
 drivers/staging/rt2860/rt28xx.h                    |   22 +-
 drivers/staging/rt2860/rt_config.h                 |    4 -
 drivers/staging/rt2860/rt_linux.c                  |   19 +-
 drivers/staging/rt2860/rt_linux.h                  |  118 +-
 drivers/staging/rt2860/rt_main_dev.c               |   59 +-
 drivers/staging/rt2860/rt_profile.c                |   44 +-
 drivers/staging/rt2860/rtmp.h                      |  719 +--
 drivers/staging/rt2860/rtmp_ckipmic.h              |   35 -
 drivers/staging/rt2860/rtmp_def.h                  |   14 -
 drivers/staging/rt2860/sta/assoc.c                 |   26 -
 drivers/staging/rt2860/sta/connect.c               |   15 +-
 drivers/staging/rt2860/sta/rtmp_data.c             |   15 +-
 drivers/staging/rt2860/sta/sync.c                  |    2 -
 drivers/staging/rt2860/sta/wpa.c                   |    9 -
 drivers/staging/rt2860/sta_ioctl.c                 | 3174 +------
 drivers/staging/rt2860/wpa.h                       |    3 -
 drivers/staging/rt2870/2870_main_dev.c             |  196 +-
 drivers/staging/rt2870/Kconfig                     |    5 +-
 drivers/staging/rt2870/Makefile                    |    2 +-
 drivers/staging/rt2870/common/2870_rtmp_init.c     |   63 +-
 drivers/staging/rt2870/common/cmm_data_2870.c      |   30 -
 drivers/staging/rt2870/common/firmware.h           |  558 --
 drivers/staging/rt2870/common/rtusb_bulk.c         |    3 +-
 drivers/staging/rt2870/common/rtusb_io.c           |   81 +-
 drivers/staging/rt2870/link_list.h                 |    1 -
 drivers/staging/rt2870/md4.h                       |   42 -
 drivers/staging/rt2870/rt2870.h                    |  215 +-
 drivers/staging/rt3070/2870_main_dev.c             |    1 -
 drivers/staging/rt3070/Kconfig                     |    6 -
 drivers/staging/rt3070/Makefile                    |   43 -
 drivers/staging/rt3070/action.h                    |    1 -
 drivers/staging/rt3070/aironet.h                   |    1 -
 drivers/staging/rt3070/ap.h                        |    1 -
 drivers/staging/rt3070/chlist.h                    |    1 -
 drivers/staging/rt3070/common/2870_rtmp_init.c     |    1 -
 drivers/staging/rt3070/common/action.c             |    1 -
 drivers/staging/rt3070/common/ba_action.c          |    1 -
 drivers/staging/rt3070/common/cmm_data.c           |    1 -
 drivers/staging/rt3070/common/cmm_data_2870.c      |    1 -
 drivers/staging/rt3070/common/cmm_info.c           |    1 -
 drivers/staging/rt3070/common/cmm_sanity.c         |    1 -
 drivers/staging/rt3070/common/cmm_sync.c           |    1 -
 drivers/staging/rt3070/common/cmm_wpa.c            |    1 -
 drivers/staging/rt3070/common/dfs.c                |    1 -
 drivers/staging/rt3070/common/eeprom.c             |    1 -
 drivers/staging/rt3070/common/md5.c                |    1 -
 drivers/staging/rt3070/common/mlme.c               |    1 -
 drivers/staging/rt3070/common/rtmp_init.c          |    1 -
 drivers/staging/rt3070/common/rtmp_tkip.c          |    1 -
 drivers/staging/rt3070/common/rtmp_wep.c           |    1 -
 drivers/staging/rt3070/common/rtusb_bulk.c         |    1 -
 drivers/staging/rt3070/common/rtusb_data.c         |    1 -
 drivers/staging/rt3070/common/rtusb_io.c           |    1 -
 drivers/staging/rt3070/common/spectrum.c           |    1 -
 drivers/staging/rt3070/dfs.h                       |    1 -
 drivers/staging/rt3070/link_list.h                 |    1 -
 drivers/staging/rt3070/md5.h                       |    1 -
 drivers/staging/rt3070/mlme.h                      |    1 -
 drivers/staging/rt3070/oid.h                       |    1 -
 drivers/staging/rt3070/rt2870.h                    |    1 -
 drivers/staging/rt3070/rt28xx.h                    |    1 -
 drivers/staging/rt3070/rt_config.h                 |    1 -
 drivers/staging/rt3070/rt_linux.c                  |    1 -
 drivers/staging/rt3070/rt_linux.h                  |    1 -
 drivers/staging/rt3070/rt_main_dev.c               |    1 -
 drivers/staging/rt3070/rt_profile.c                |    1 -
 drivers/staging/rt3070/rtmp.h                      |    1 -
 drivers/staging/rt3070/rtmp_ckipmic.h              |    1 -
 drivers/staging/rt3070/rtmp_def.h                  |    1 -
 drivers/staging/rt3070/rtmp_type.h                 |    1 -
 drivers/staging/rt3070/spectrum.h                  |    1 -
 drivers/staging/rt3070/spectrum_def.h              |    1 -
 drivers/staging/rt3070/sta/aironet.c               |    1 -
 drivers/staging/rt3070/sta/assoc.c                 |    1 -
 drivers/staging/rt3070/sta/auth.c                  |    1 -
 drivers/staging/rt3070/sta/auth_rsp.c              |    1 -
 drivers/staging/rt3070/sta/connect.c               |    2 -
 drivers/staging/rt3070/sta/rtmp_data.c             |    1 -
 drivers/staging/rt3070/sta/sanity.c                |    1 -
 drivers/staging/rt3070/sta/sync.c                  |    1 -
 drivers/staging/rt3070/sta/wpa.c                   |    1 -
 drivers/staging/rt3070/sta_ioctl.c                 |    1 -
 drivers/staging/rt3070/wpa.h                       |    1 -
 drivers/staging/rt3090/Kconfig                     |    5 +
 drivers/staging/rt3090/Makefile                    |   80 +
 drivers/staging/rt3090/action.h                    |   66 +
 drivers/staging/rt3090/ap.h                        |  512 +
 drivers/staging/rt3090/ap_apcli.h                  |  276 +
 drivers/staging/rt3090/ap_autoChSel.h              |   79 +
 drivers/staging/rt3090/ap_autoChSel_cmm.h          |   66 +
 drivers/staging/rt3090/ap_cfg.h                    |  118 +
 drivers/staging/rt3090/ap_ids.h                    |   82 +
 drivers/staging/rt3090/ap_mbss.h                   |   72 +
 drivers/staging/rt3090/ap_uapsd.h                  |  636 ++
 drivers/staging/rt3090/ap_wds.h                    |  212 +
 drivers/staging/rt3090/chips/rt3090.c              |  123 +
 drivers/staging/rt3090/chips/rt30xx.c              |  525 +
 drivers/staging/rt3090/chips/rt3370.c              |  121 +
 drivers/staging/rt3090/chips/rt3390.c              |  122 +
 drivers/staging/rt3090/chips/rt33xx.c              |  536 ++
 drivers/staging/rt3090/chlist.h                    |  130 +
 drivers/staging/rt3090/common/action.c             | 1057 +++
 drivers/staging/rt3090/common/ba_action.c          | 1779 ++++
 drivers/staging/rt3090/common/cmm_aes.c            | 1560 +++
 drivers/staging/rt3090/common/cmm_asic.c           | 2753 ++++++
 drivers/staging/rt3090/common/cmm_cfg.c            |  295 +
 drivers/staging/rt3090/common/cmm_data.c           | 2763 ++++++
 drivers/staging/rt3090/common/cmm_data_pci.c       | 1576 +++
 drivers/staging/rt3090/common/cmm_info.c           | 3717 ++++++++
 drivers/staging/rt3090/common/cmm_mac_pci.c        | 1757 ++++
 drivers/staging/rt3090/common/cmm_profile.c        | 2321 +++++
 drivers/staging/rt3090/common/cmm_sanity.c         | 1718 ++++
 drivers/staging/rt3090/common/cmm_sync.c           |  734 ++
 drivers/staging/rt3090/common/cmm_tkip.c           |  966 ++
 drivers/staging/rt3090/common/cmm_wep.c            |  500 +
 drivers/staging/rt3090/common/cmm_wpa.c            | 3149 ++++++
 drivers/staging/rt3090/common/crypt_aes.c          | 1007 ++
 drivers/staging/rt3090/common/crypt_biginteger.c   | 1119 +++
 drivers/staging/rt3090/common/crypt_dh.c           |  234 +
 drivers/staging/rt3090/common/crypt_hmac.c         |  279 +
 drivers/staging/rt3090/common/crypt_md5.c          |  353 +
 drivers/staging/rt3090/common/crypt_sha2.c         |  536 ++
 drivers/staging/rt3090/common/dfs.c                |  481 +
 drivers/staging/rt3090/common/ee_efuse.c           | 1548 +++
 drivers/staging/rt3090/common/ee_prom.c            |  308 +
 drivers/staging/rt3090/common/eeprom.c             |   98 +
 drivers/staging/rt3090/common/igmp_snoop.c         | 1365 +++
 drivers/staging/rt3090/common/mlme.c               | 6550 +++++++++++++
 drivers/staging/rt3090/common/mlme_ex.c            |  215 +
 drivers/staging/rt3090/common/netif_block.c        |  147 +
 drivers/staging/rt3090/common/rt_channel.c         | 1287 +++
 drivers/staging/rt3090/common/rt_rf.c              |  201 +
 drivers/staging/rt3090/common/rtmp_init.c          | 3882 ++++++++
 drivers/staging/rt3090/common/rtmp_mcu.c           |  560 ++
 drivers/staging/rt3090/common/rtmp_timer.c         |  327 +
 drivers/staging/rt3090/common/spectrum.c           | 2221 +++++
 drivers/staging/rt3090/config.mk                   |  187 +
 drivers/staging/rt3090/crypt_hmac.h                |   81 +
 drivers/staging/rt3090/crypt_md5.h                 |   78 +
 drivers/staging/rt3090/crypt_sha2.h                |  107 +
 drivers/staging/rt3090/dfs.h                       |  137 +
 drivers/staging/rt3090/eeprom.h                    |   82 +
 drivers/staging/rt3090/firmware.h                  |  517 +
 drivers/staging/rt3090/igmp_snoop.h                |  152 +
 drivers/staging/rt3090/ipv6.h                      |  215 +
 drivers/staging/rt3090/link_list.h                 |  133 +
 drivers/staging/rt3090/mac_pci.h                   |  454 +
 drivers/staging/rt3090/mlme.h                      | 1360 +++
 drivers/staging/rt3090/mlme_ex.h                   |   83 +
 drivers/staging/rt3090/mlme_ex_def.h               |   53 +
 drivers/staging/rt3090/netif_block.h               |   56 +
 drivers/staging/rt3090/oid.h                       | 1144 +++
 drivers/staging/rt3090/pci_main_dev.c              | 1195 +++
 drivers/staging/rt3090/rt3090.h                    |   77 +
 drivers/staging/rt3090/rt30xx.h                    |   48 +
 drivers/staging/rt3090/rt3370.h                    |   64 +
 drivers/staging/rt3090/rt3390.h                    |   77 +
 drivers/staging/rt3090/rt33xx.h                    |   48 +
 drivers/staging/rt3090/rt_ate.c                    | 6089 ++++++++++++
 drivers/staging/rt3090/rt_ate.h                    |  314 +
 drivers/staging/rt3090/rt_config.h                 |  126 +
 drivers/staging/rt3090/rt_linux.c                  | 1623 ++++
 drivers/staging/rt3090/rt_linux.h                  | 1034 ++
 drivers/staging/rt3090/rt_main_dev.c               |  897 ++
 drivers/staging/rt3090/rt_pci_rbus.c               |  989 ++
 drivers/staging/rt3090/rt_profile.c                |  101 +
 drivers/staging/rt3090/rtmp.h                      | 6873 ++++++++++++++
 drivers/staging/rt3090/rtmp_chip.h                 |  355 +
 drivers/staging/rt3090/rtmp_def.h                  | 1650 ++++
 drivers/staging/rt3090/rtmp_dot11.h                |  146 +
 drivers/staging/rt3090/rtmp_iface.h                |   81 +
 drivers/staging/rt3090/rtmp_mac.h                  | 2304 +++++
 drivers/staging/rt3090/rtmp_mcu.h                  |   55 +
 drivers/staging/rt3090/rtmp_os.h                   |   93 +
 drivers/staging/rt3090/rtmp_pci.h                  |  110 +
 drivers/staging/rt3090/rtmp_phy.h                  |  631 ++
 drivers/staging/rt3090/rtmp_timer.h                |  162 +
 drivers/staging/rt3090/rtmp_type.h                 |  147 +
 drivers/staging/rt3090/spectrum.h                  |  234 +
 drivers/staging/rt3090/spectrum_def.h              |  257 +
 drivers/staging/rt3090/sta/assoc.c                 | 1673 ++++
 drivers/staging/rt3090/sta/auth.c                  |  491 +
 drivers/staging/rt3090/sta/auth_rsp.c              |  151 +
 drivers/staging/rt3090/sta/connect.c               | 2759 ++++++
 drivers/staging/rt3090/sta/dls.c                   | 2207 +++++
 drivers/staging/rt3090/sta/rtmp_ckipmic.c          |  579 ++
 drivers/staging/rt3090/sta/rtmp_data.c             | 2661 ++++++
 drivers/staging/rt3090/sta/sanity.c                |  382 +
 drivers/staging/rt3090/sta/sync.c                  | 1840 ++++
 drivers/staging/rt3090/sta/wpa.c                   |  396 +
 drivers/staging/rt3090/sta_ioctl.c                 | 7557 +++++++++++++++
 drivers/staging/rt3090/vr_ikans.h                  |   71 +
 drivers/staging/rt3090/wpa.h                       |  447 +
 drivers/staging/rtl8187se/Makefile                 |   16 -
 drivers/staging/rtl8187se/TODO                     |   15 +
 drivers/staging/rtl8187se/dot11d.h                 |  101 -
 drivers/staging/rtl8187se/ieee80211.h              | 1755 ----
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |   22 -
 drivers/staging/rtl8187se/ieee80211/dot11d.h       |    2 -
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |  665 +-
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |   17 -
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |   88 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |  324 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |  125 +-
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |   88 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |  512 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        | 1033 +--
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   30 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |  270 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |  129 +-
 drivers/staging/rtl8187se/ieee80211/internal.h     |  115 -
 drivers/staging/rtl8187se/ieee80211/rtl_crypto.h   |  399 -
 drivers/staging/rtl8187se/r8180.h                  |   24 +-
 drivers/staging/rtl8187se/r8180_93cx6.h            |    2 -
 drivers/staging/rtl8187se/r8180_core.c             | 2954 +------
 drivers/staging/rtl8187se/r8180_dm.c               |   58 -
 drivers/staging/rtl8187se/r8180_dm.h               |   18 -
 drivers/staging/rtl8187se/r8180_gct.c              |  296 -
 drivers/staging/rtl8187se/r8180_gct.h              |   25 -
 drivers/staging/rtl8187se/r8180_hw.h               |  393 +-
 drivers/staging/rtl8187se/r8180_max2820.c          |  240 -
 drivers/staging/rtl8187se/r8180_max2820.h          |   21 -
 drivers/staging/rtl8187se/r8180_pm.c               |   92 -
 drivers/staging/rtl8187se/r8180_pm.h               |   28 -
 drivers/staging/rtl8187se/r8180_rtl8225.c          |  933 --
 drivers/staging/rtl8187se/r8180_rtl8225.h          |   12 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        | 1552 +--
 drivers/staging/rtl8187se/r8180_rtl8255.c          | 1838 ----
 drivers/staging/rtl8187se/r8180_rtl8255.h          |   19 -
 drivers/staging/rtl8187se/r8180_sa2400.c           |  233 -
 drivers/staging/rtl8187se/r8180_sa2400.h           |   26 -
 drivers/staging/rtl8187se/r8180_wx.c               |   63 +-
 drivers/staging/rtl8187se/r8180_wx.h               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |  665 +--
 drivers/staging/rtl8192e/Kconfig                   |    6 +
 drivers/staging/rtl8192e/Makefile                  |   34 +
 drivers/staging/{rtl8192su => rtl8192e}/dot11d.h   |    0
 drivers/staging/rtl8192e/ieee80211.h               | 2687 ++++++
 drivers/staging/rtl8192e/ieee80211/dot11d.c        |  239 +
 .../{rtl8192su => rtl8192e/ieee80211}/dot11d.h     |    0
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     | 2802 ++++++
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |  273 +
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.h   |   93 +
 .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |  534 ++
 .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      | 1031 ++
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |  393 +
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |  432 +
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  | 2802 ++++++
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c | 3548 +++++++
 .../rtl8192e/ieee80211/ieee80211_softmac_wx.c      |  682 ++
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |  933 ++
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  | 1032 ++
 drivers/staging/rtl8192e/ieee80211/rtl819x_BA.h    |   69 +
 .../staging/rtl8192e/ieee80211/rtl819x_BAProc.c    |  779 ++
 drivers/staging/rtl8192e/ieee80211/rtl819x_HT.h    |  481 +
 .../staging/rtl8192e/ieee80211/rtl819x_HTProc.c    | 1719 ++++
 drivers/staging/rtl8192e/ieee80211/rtl819x_Qos.h   |  748 ++
 drivers/staging/rtl8192e/ieee80211/rtl819x_TS.h    |   56 +
 .../staging/rtl8192e/ieee80211/rtl819x_TSProc.c    |  659 ++
 .../{rtl8192su => rtl8192e}/ieee80211/rtl_crypto.h |    0
 .../{rtl8187se => rtl8192e}/ieee80211_crypt.h      |    0
 drivers/staging/rtl8192e/r8180_93cx6.c             |  146 +
 drivers/staging/rtl8192e/r8180_93cx6.h             |   40 +
 drivers/staging/rtl8192e/r8190_rtl8256.c           | 1161 +++
 drivers/staging/rtl8192e/r8190_rtl8256.h           |   28 +
 drivers/staging/rtl8192e/r8192E.h                  | 1516 +++
 drivers/staging/rtl8192e/r8192E_core.c             | 6462 +++++++++++++
 drivers/staging/rtl8192e/r8192E_dm.c               | 3880 ++++++++
 drivers/staging/rtl8192e/r8192E_dm.h               |  312 +
 drivers/staging/rtl8192e/r8192E_hw.h               |  811 ++
 drivers/staging/rtl8192e/r8192E_wx.c               | 1344 +++
 drivers/staging/rtl8192e/r8192E_wx.h               |   22 +
 drivers/staging/rtl8192e/r8192_pm.c                |  172 +
 drivers/staging/rtl8192e/r8192_pm.h                |   28 +
 drivers/staging/rtl8192e/r819xE_cmdpkt.c           |  804 ++
 drivers/staging/rtl8192e/r819xE_cmdpkt.h           |  207 +
 drivers/staging/rtl8192e/r819xE_firmware.c         |  352 +
 drivers/staging/rtl8192e/r819xE_phy.c              | 3352 +++++++
 drivers/staging/rtl8192e/r819xE_phy.h              |  125 +
 drivers/staging/rtl8192e/r819xE_phyreg.h           |  878 ++
 drivers/staging/rtl8192su/Makefile                 |   39 +-
 drivers/staging/rtl8192su/TODO                     |   18 +
 drivers/staging/rtl8192su/ieee80211.h              | 2901 ------
 drivers/staging/rtl8192su/ieee80211/EndianFree.h   |  199 -
 drivers/staging/rtl8192su/ieee80211/Makefile       |    3 +-
 drivers/staging/rtl8192su/ieee80211/aes.c          |  469 -
 drivers/staging/rtl8192su/ieee80211/api.c          |  246 -
 drivers/staging/rtl8192su/ieee80211/arc4.c         |  103 -
 drivers/staging/rtl8192su/ieee80211/autoload.c     |   40 -
 drivers/staging/rtl8192su/ieee80211/cipher.c       |  299 -
 drivers/staging/rtl8192su/ieee80211/compress.c     |   64 -
 .../staging/rtl8192su/ieee80211/crypto_compat.h    |   90 -
 drivers/staging/rtl8192su/ieee80211/digest.c       |  108 -
 drivers/staging/rtl8192su/ieee80211/dot11d.c       |   25 +-
 drivers/staging/rtl8192su/ieee80211/dot11d.h       |    4 -
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    | 1350 +---
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.c  |   31 +-
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.h  |    7 -
 .../rtl8192su/ieee80211/ieee80211_crypt_ccmp.c     |   66 +-
 .../rtl8192su/ieee80211/ieee80211_crypt_tkip.c     |  292 +-
 .../rtl8192su/ieee80211/ieee80211_crypt_wep.c      |  126 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |   77 +-
 .../staging/rtl8192su/ieee80211/ieee80211_r8192s.h |  436 +
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c |  253 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |  360 +-
 .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |   86 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |   26 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |  272 +-
 drivers/staging/rtl8192su/ieee80211/internal.h     |  115 -
 drivers/staging/rtl8192su/ieee80211/kmap_types.h   |   20 -
 drivers/staging/rtl8192su/ieee80211/michael_mic.c  |  194 -
 drivers/staging/rtl8192su/ieee80211/proc.c         |  116 -
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   |   49 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h   |    9 -
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   |  279 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h  |  168 +-
 .../staging/rtl8192su/ieee80211/rtl819x_TSProc.c   |   34 +-
 drivers/staging/rtl8192su/ieee80211/scatterwalk.c  |  126 -
 drivers/staging/rtl8192su/ieee80211/scatterwalk.h  |   51 -
 drivers/staging/rtl8192su/ieee80211_crypt.h        |   86 -
 drivers/staging/rtl8192su/r8180_93cx6.h            |    5 -
 drivers/staging/rtl8192su/r8190_rtl8256.c          |  312 -
 drivers/staging/rtl8192su/r8190_rtl8256.h          |   27 -
 drivers/staging/rtl8192su/r8192S_Efuse.c           |  113 -
 drivers/staging/rtl8192su/r8192S_FwImgDTM.h        | 3797 --------
 drivers/staging/rtl8192su/r8192S_firmware.c        |  483 -
 drivers/staging/rtl8192su/r8192S_firmware.h        |    5 -
 drivers/staging/rtl8192su/r8192S_hw.h              |  184 -
 drivers/staging/rtl8192su/r8192S_phy.c             |  947 +--
 drivers/staging/rtl8192su/r8192S_phy.h             |    5 +-
 drivers/staging/rtl8192su/r8192S_rtl6052.c         |  104 -
 drivers/staging/rtl8192su/r8192S_rtl6052.h         |   47 -
 drivers/staging/rtl8192su/r8192U.h                 |  528 +-
 drivers/staging/rtl8192su/r8192U_core.c            | 4898 +----------
 drivers/staging/rtl8192su/r8192U_dm.c              |  550 +--
 drivers/staging/rtl8192su/r8192U_dm.h              |   55 -
 drivers/staging/rtl8192su/r8192U_hw.h              |  746 --
 drivers/staging/rtl8192su/r8192U_pm.c              |   11 +-
 drivers/staging/rtl8192su/r8192U_pm.h              |    2 -
 drivers/staging/rtl8192su/r8192U_wx.c              |  132 +-
 drivers/staging/rtl8192su/r8192U_wx.h              |    1 -
 drivers/staging/rtl8192su/r819xU_HTType.h          |    9 -
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |  113 +-
 drivers/staging/rtl8192su/r819xU_cmdpkt.h          |   20 -
 drivers/staging/rtl8192su/r819xU_firmware.c        |  707 --
 drivers/staging/rtl8192su/r819xU_firmware.h        |  106 -
 drivers/staging/rtl8192su/r819xU_firmware_img.c    | 3447 -------
 drivers/staging/rtl8192su/r819xU_firmware_img.h    |   35 -
 drivers/staging/rtl8192su/r819xU_phy.c             | 1826 ----
 drivers/staging/rtl8192su/r819xU_phy.h             |   94 -
 drivers/staging/rtl8192su/r819xU_phyreg.h          |  871 --
 drivers/staging/sep/Kconfig                        |   10 +
 drivers/staging/sep/Makefile                       |    2 +
 drivers/staging/sep/TODO                           |    8 +
 drivers/staging/sep/sep_dev.h                      |  110 +
 drivers/staging/sep/sep_driver.c                   | 2707 ++++++
 drivers/staging/sep/sep_driver_api.h               |  425 +
 drivers/staging/sep/sep_driver_config.h            |  225 +
 drivers/staging/sep/sep_driver_hw_defs.h           |  232 +
 drivers/staging/serqt_usb2/serqt_usb2.c            |    2 +-
 drivers/staging/slicoss/slicoss.c                  |    2 +-
 drivers/staging/sxg/Kconfig                        |   11 -
 drivers/staging/sxg/Makefile                       |    3 -
 drivers/staging/sxg/README                         |   12 -
 drivers/staging/sxg/sxg.c                          | 4543 ---------
 drivers/staging/sxg/sxg.h                          |  787 --
 drivers/staging/sxg/sxg_ethtool.c                  |  328 -
 drivers/staging/sxg/sxg_os.h                       |  149 -
 drivers/staging/sxg/sxgdbg.h                       |  184 -
 drivers/staging/sxg/sxghif.h                       | 1014 --
 drivers/staging/sxg/sxghw.h                        | 1020 --
 drivers/staging/sxg/sxgphycode-1.2.h               |  130 -
 drivers/staging/udlfb/udlfb.h                      |    2 +-
 drivers/staging/usbip/Kconfig                      |    2 +-
 drivers/staging/usbip/stub_dev.c                   |   16 +-
 drivers/staging/usbip/stub_main.c                  |    8 +-
 drivers/staging/usbip/stub_rx.c                    |   49 +-
 drivers/staging/usbip/stub_tx.c                    |   26 +-
 drivers/staging/usbip/usbip_common.c               |  226 +-
 drivers/staging/usbip/usbip_common.h               |   96 +-
 drivers/staging/usbip/usbip_event.c                |   37 +-
 drivers/staging/usbip/vhci_hcd.c                   |  156 +-
 drivers/staging/usbip/vhci_rx.c                    |   41 +-
 drivers/staging/usbip/vhci_sysfs.c                 |   22 +-
 drivers/staging/usbip/vhci_tx.c                    |   22 +-
 drivers/staging/vme/Kconfig                        |   17 +
 drivers/staging/vme/Makefile                       |    7 +
 drivers/staging/vme/TODO                           |   98 +
 drivers/staging/vme/bridges/Kconfig                |   13 +
 drivers/staging/vme/bridges/Makefile               |    2 +
 drivers/staging/vme/bridges/vme_ca91cx42.c         | 1933 ++++
 drivers/staging/vme/bridges/vme_ca91cx42.h         |  505 +
 drivers/staging/vme/bridges/vme_tsi148.c           | 2925 ++++++
 drivers/staging/vme/bridges/vme_tsi148.h           | 1387 +++
 drivers/staging/vme/devices/Kconfig                |    8 +
 drivers/staging/vme/devices/Makefile               |    5 +
 drivers/staging/vme/devices/vme_user.c             |  826 ++
 drivers/staging/vme/devices/vme_user.h             |   52 +
 drivers/staging/vme/vme.c                          | 1497 +++
 drivers/staging/vme/vme.h                          |  161 +
 drivers/staging/vme/vme_api.txt                    |  372 +
 drivers/staging/vme/vme_bridge.h                   |  261 +
 drivers/staging/vt6655/80211hdr.h                  |   10 +-
 drivers/staging/vt6655/80211mgr.c                  |   38 +-
 drivers/staging/vt6655/80211mgr.h                  |   13 +-
 drivers/staging/vt6655/IEEE11h.c                   |   47 +-
 drivers/staging/vt6655/IEEE11h.h                   |   16 -
 drivers/staging/vt6655/Kconfig                     |    2 +-
 drivers/staging/vt6655/Makefile                    |    6 +-
 drivers/staging/vt6655/Makefile.arm                |  181 -
 drivers/staging/vt6655/Makefile.x86                |  209 -
 drivers/staging/vt6655/TODO                        |   21 +
 drivers/staging/vt6655/aes_ccmp.c                  |   30 +-
 drivers/staging/vt6655/aes_ccmp.h                  |    2 -
 drivers/staging/vt6655/baseband.c                  |   61 +-
 drivers/staging/vt6655/baseband.h                  |   35 +-
 drivers/staging/vt6655/bssdb.c                     |  158 +-
 drivers/staging/vt6655/bssdb.h                     |   23 +-
 drivers/staging/vt6655/card.c                      |   80 +-
 drivers/staging/vt6655/card.h                      |   17 -
 drivers/staging/vt6655/country.h                   |   17 +-
 drivers/staging/vt6655/datarate.c                  |   26 +-
 drivers/staging/vt6655/desc.h                      |  103 +-
 drivers/staging/vt6655/device.h                    |  177 +-
 drivers/staging/vt6655/device_cfg.h                |   46 +-
 drivers/staging/vt6655/device_main.c               |  643 +-
 drivers/staging/vt6655/dpc.c                       |  304 +-
 drivers/staging/vt6655/dpc.h                       |   24 +-
 drivers/staging/vt6655/hostap.c                    |  135 +-
 drivers/staging/vt6655/hostap.h                    |   24 -
 drivers/staging/vt6655/iocmd.h                     |   23 +-
 drivers/staging/vt6655/ioctl.c                     |  101 +-
 drivers/staging/vt6655/ioctl.h                     |   17 -
 drivers/staging/vt6655/iowpa.h                     |    4 +-
 drivers/staging/vt6655/iwctl.c                     |  314 +-
 drivers/staging/vt6655/iwctl.h                     |  105 +-
 drivers/staging/vt6655/kcompat.h                   |   49 +-
 drivers/staging/vt6655/key.c                       |  153 +-
 drivers/staging/vt6655/key.h                       |   24 +-
 drivers/staging/vt6655/mac.c                       |  145 +-
 drivers/staging/vt6655/mac.h                       |   19 +-
 drivers/staging/vt6655/mib.c                       |  153 +-
 drivers/staging/vt6655/mib.h                       |   35 +-
 drivers/staging/vt6655/michael.c                   |    7 -
 drivers/staging/vt6655/michael.h                   |    4 -
 drivers/staging/vt6655/power.c                     |   45 +-
 drivers/staging/vt6655/power.h                     |    3 +-
 drivers/staging/vt6655/rc4.c                       |    7 +-
 drivers/staging/vt6655/rc4.h                       |    6 +-
 drivers/staging/vt6655/rf.c                        |   16 +-
 drivers/staging/vt6655/rf.h                        |   16 +-
 drivers/staging/vt6655/rxtx.c                      |  556 +-
 drivers/staging/vt6655/rxtx.h                      |   10 +-
 drivers/staging/vt6655/srom.c                      |   31 +-
 drivers/staging/vt6655/srom.h                      |   24 +-
 drivers/staging/vt6655/tbit.h                      |   78 -
 drivers/staging/vt6655/tcrc.c                      |    9 -
 drivers/staging/vt6655/tcrc.h                      |   18 -
 drivers/staging/vt6655/tether.c                    |   16 +-
 drivers/staging/vt6655/tether.h                    |   26 +-
 drivers/staging/vt6655/tkip.c                      |   12 -
 drivers/staging/vt6655/tkip.h                      |   16 -
 drivers/staging/vt6655/tmacro.h                    |   90 -
 drivers/staging/vt6655/tpci.h                      |  117 -
 drivers/staging/vt6655/ttype.h                     |  261 +-
 drivers/staging/vt6655/umem.h                      |   75 -
 drivers/staging/vt6655/upc.h                       |    5 -
 drivers/staging/vt6655/vntwifi.c                   |   33 +-
 drivers/staging/vt6655/vntwifi.h                   |   19 +-
 drivers/staging/vt6655/wcmd.c                      |  137 +-
 drivers/staging/vt6655/wcmd.h                      |   22 +-
 drivers/staging/vt6655/wctl.c                      |   17 +-
 drivers/staging/vt6655/wctl.h                      |   19 -
 drivers/staging/vt6655/wmgr.c                      |  360 +-
 drivers/staging/vt6655/wmgr.h                      |   33 +-
 drivers/staging/vt6655/wpa.c                       |   71 +-
 drivers/staging/vt6655/wpa.h                       |   14 -
 drivers/staging/vt6655/wpa2.c                      |   55 +-
 drivers/staging/vt6655/wpa2.h                      |   24 +-
 drivers/staging/vt6655/wpactl.c                    |  102 +-
 drivers/staging/vt6655/wpactl.h                    |   17 -
 drivers/staging/vt6655/wroute.c                    |   28 +-
 drivers/staging/vt6655/wroute.h                    |   18 -
 drivers/staging/vt6656/80211hdr.h                  |  353 +
 drivers/staging/vt6656/80211mgr.c                  | 1026 ++
 drivers/staging/vt6656/80211mgr.h                  |  861 ++
 drivers/staging/vt6656/Kconfig                     |    6 +
 drivers/staging/vt6656/Makefile                    |   39 +
 drivers/staging/vt6656/TODO                        |   20 +
 drivers/staging/vt6656/aes_ccmp.c                  |  402 +
 drivers/staging/vt6656/aes_ccmp.h                  |   46 +
 drivers/staging/vt6656/baseband.c                  | 2105 ++++
 drivers/staging/vt6656/baseband.h                  |  146 +
 drivers/staging/vt6656/bssdb.c                     | 1721 ++++
 drivers/staging/vt6656/bssdb.h                     |  359 +
 drivers/staging/vt6656/card.c                      | 1113 +++
 drivers/staging/vt6656/card.h                      |   95 +
 drivers/staging/vt6656/channel.c                   |  525 +
 drivers/staging/vt6656/channel.h                   |   57 +
 drivers/staging/vt6656/control.c                   |  109 +
 drivers/staging/vt6656/control.h                   |   83 +
 drivers/staging/vt6656/country.h                   |  163 +
 drivers/staging/vt6656/datarate.c                  |  499 +
 drivers/staging/vt6656/datarate.h                  |  110 +
 drivers/staging/vt6656/desc.h                      |  443 +
 drivers/staging/vt6656/device.h                    |  939 ++
 drivers/staging/vt6656/device_cfg.h                |  107 +
 drivers/staging/vt6656/dpc.c                       | 1616 ++++
 drivers/staging/vt6656/dpc.h                       |   70 +
 drivers/staging/vt6656/firmware.c                  |  876 ++
 drivers/staging/vt6656/firmware.h                  |   60 +
 drivers/staging/vt6656/hostap.c                    |  868 ++
 drivers/staging/vt6656/hostap.h                    |   70 +
 drivers/staging/vt6656/int.c                       |  193 +
 drivers/staging/vt6656/int.h                       |   83 +
 drivers/staging/vt6656/iocmd.h                     |  475 +
 drivers/staging/vt6656/ioctl.c                     |  701 ++
 drivers/staging/vt6656/ioctl.h                     |   57 +
 drivers/staging/vt6656/iowpa.h                     |  158 +
 drivers/staging/vt6656/iwctl.c                     | 2190 +++++
 drivers/staging/vt6656/iwctl.h                     |  229 +
 drivers/staging/vt6656/kcompat.h                   |   39 +
 drivers/staging/vt6656/key.c                       |  869 ++
 drivers/staging/vt6656/key.h                       |  177 +
 drivers/staging/vt6656/mac.c                       |  482 +
 drivers/staging/vt6656/mac.h                       |  442 +
 drivers/staging/vt6656/main_usb.c                  | 2196 +++++
 drivers/staging/vt6656/mib.c                       |  573 ++
 drivers/staging/vt6656/mib.h                       |  423 +
 drivers/staging/vt6656/michael.c                   |  181 +
 drivers/staging/vt6656/michael.h                   |   58 +
 drivers/staging/vt6656/power.c                     |  424 +
 drivers/staging/vt6656/power.h                     |   84 +
 drivers/staging/vt6656/rc4.c                       |   87 +
 drivers/staging/vt6656/rc4.h                       |   47 +
 drivers/staging/vt6656/rf.c                        | 1151 +++
 drivers/staging/vt6656/rf.h                        |  100 +
 drivers/staging/vt6656/rndis.h                     |  162 +
 drivers/staging/vt6656/rxtx.c                      | 3239 +++++++
 drivers/staging/vt6656/rxtx.h                      |  694 ++
 drivers/staging/vt6656/srom.h                      |  127 +
 drivers/staging/vt6656/tcrc.c                      |  198 +
 drivers/staging/vt6656/tcrc.h                      |   53 +
 drivers/staging/vt6656/tether.c                    |  109 +
 drivers/staging/vt6656/tether.h                    |  236 +
 drivers/staging/vt6656/tkip.c                      |  272 +
 drivers/staging/vt6656/tkip.h                      |   60 +
 drivers/staging/vt6656/tmacro.h                    |   62 +
 drivers/staging/vt6656/ttype.h                     |  162 +
 drivers/staging/vt6656/upc.h                       |  166 +
 drivers/staging/vt6656/usbpipe.c                   |  841 ++
 drivers/staging/vt6656/usbpipe.h                   |   99 +
 drivers/staging/vt6656/vntconfiguration.dat        |    6 +
 drivers/staging/vt6656/wcmd.c                      | 1354 +++
 drivers/staging/vt6656/wcmd.h                      |  150 +
 drivers/staging/vt6656/wctl.c                      |  254 +
 drivers/staging/vt6656/wctl.h                      |  108 +
 drivers/staging/vt6656/wmgr.c                      | 4949 ++++++++++
 drivers/staging/vt6656/wmgr.h                      |  502 +
 drivers/staging/vt6656/wpa.c                       |  316 +
 drivers/staging/vt6656/wpa.h                       |   84 +
 drivers/staging/vt6656/wpa2.c                      |  363 +
 drivers/staging/vt6656/wpa2.h                      |   78 +
 drivers/staging/vt6656/wpactl.c                    | 1008 ++
 drivers/staging/vt6656/wpactl.h                    |   72 +
 drivers/staging/winbond/core.h                     |    4 +-
 drivers/staging/winbond/localpara.h                |    1 -
 drivers/staging/winbond/mds.c                      |   22 +-
 drivers/staging/winbond/mds_f.h                    |    6 +-
 drivers/staging/winbond/mds_s.h                    |   17 +-
 drivers/staging/winbond/mlmetxrx.c                 |    2 +-
 drivers/staging/winbond/mlmetxrx_f.h               |   32 +-
 drivers/staging/winbond/mto.c                      |   26 +-
 drivers/staging/winbond/mto.h                      |  116 +-
 drivers/staging/winbond/wb35rx.c                   |    4 +-
 drivers/staging/winbond/wb35tx.c                   |    4 +-
 drivers/staging/winbond/wbhal_f.h                  |    2 +-
 drivers/staging/winbond/wbhal_s.h                  |    4 +-
 drivers/staging/winbond/wbusb.c                    |    5 -
 drivers/staging/wlan-ng/hfa384x_usb.c              |  205 +-
 drivers/staging/wlan-ng/p80211conv.c               |   12 +-
 drivers/staging/wlan-ng/p80211hdr.h                |   15 -
 drivers/staging/wlan-ng/p80211meta.h               |    6 -
 drivers/staging/wlan-ng/p80211mgmt.h               |    6 -
 drivers/staging/wlan-ng/p80211msg.h                |    6 -
 drivers/staging/wlan-ng/p80211netdev.c             |   62 +-
 drivers/staging/wlan-ng/p80211netdev.h             |    3 -
 drivers/staging/wlan-ng/p80211req.c                |   12 +-
 drivers/staging/wlan-ng/p80211types.h              |    4 -
 drivers/staging/wlan-ng/p80211wep.c                |   27 +-
 drivers/staging/wlan-ng/p80211wext.c               |   77 +-
 drivers/staging/wlan-ng/prism2fw.c                 |  509 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |   23 +-
 drivers/staging/wlan-ng/prism2mib.c                |  144 +-
 drivers/staging/wlan-ng/prism2sta.c                |  153 +-
 drivers/staging/wlan-ng/prism2usb.c                |   10 +-
 1267 files changed, 297615 insertions(+), 214568 deletions(-)
 delete mode 100644 drivers/staging/android/lowmemorykiller.txt
 delete mode 100644 drivers/staging/at76_usb/Kconfig
 delete mode 100644 drivers/staging/at76_usb/Makefile
 delete mode 100644 drivers/staging/at76_usb/TODO
 delete mode 100644 drivers/staging/at76_usb/at76_usb.c
 delete mode 100644 drivers/staging/at76_usb/at76_usb.h
 create mode 100644 drivers/staging/cowloop/Kconfig
 create mode 100644 drivers/staging/cowloop/Makefile
 create mode 100644 drivers/staging/cowloop/TODO
 create mode 100644 drivers/staging/cowloop/cowloop.c
 create mode 100644 drivers/staging/cowloop/cowloop.h
 create mode 100644 drivers/staging/dream/Kconfig
 create mode 100644 drivers/staging/dream/Makefile
 create mode 100644 drivers/staging/dream/camera/Kconfig
 create mode 100644 drivers/staging/dream/camera/Makefile
 create mode 100644 drivers/staging/dream/camera/msm_camera.c
 create mode 100644 drivers/staging/dream/camera/msm_io7x.c
 create mode 100644 drivers/staging/dream/camera/msm_io8x.c
 create mode 100644 drivers/staging/dream/camera/msm_v4l2.c
 create mode 100644 drivers/staging/dream/camera/msm_vfe7x.c
 create mode 100644 drivers/staging/dream/camera/msm_vfe7x.h
 create mode 100644 drivers/staging/dream/camera/msm_vfe8x.c
 create mode 100644 drivers/staging/dream/camera/msm_vfe8x.h
 create mode 100644 drivers/staging/dream/camera/msm_vfe8x_proc.c
 create mode 100644 drivers/staging/dream/camera/msm_vfe8x_proc.h
 create mode 100644 drivers/staging/dream/camera/mt9d112.c
 create mode 100644 drivers/staging/dream/camera/mt9d112.h
 create mode 100644 drivers/staging/dream/camera/mt9d112_reg.c
 create mode 100644 drivers/staging/dream/camera/mt9p012.h
 create mode 100644 drivers/staging/dream/camera/mt9p012_fox.c
 create mode 100644 drivers/staging/dream/camera/mt9p012_reg.c
 create mode 100644 drivers/staging/dream/camera/mt9t013.c
 create mode 100644 drivers/staging/dream/camera/mt9t013.h
 create mode 100644 drivers/staging/dream/camera/mt9t013_reg.c
 create mode 100644 drivers/staging/dream/camera/s5k3e2fx.c
 create mode 100644 drivers/staging/dream/camera/s5k3e2fx.h
 create mode 100644 drivers/staging/dream/gpio_axis.c
 create mode 100644 drivers/staging/dream/gpio_event.c
 create mode 100644 drivers/staging/dream/gpio_input.c
 create mode 100644 drivers/staging/dream/gpio_matrix.c
 create mode 100644 drivers/staging/dream/gpio_output.c
 create mode 100644 drivers/staging/dream/qdsp5/Makefile
 create mode 100644 drivers/staging/dream/qdsp5/adsp.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp.h
 create mode 100644 drivers/staging/dream/qdsp5/adsp_6210.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_6220.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_6225.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_driver.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_info.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_jpeg_patch_event.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_jpeg_verify_cmd.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_lpm_verify_cmd.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_video_verify_cmd.c
 create mode 100644 drivers/staging/dream/qdsp5/adsp_videoenc_verify_cmd.c
 create mode 100644 drivers/staging/dream/qdsp5/audio_aac.c
 create mode 100644 drivers/staging/dream/qdsp5/audio_amrnb.c
 create mode 100644 drivers/staging/dream/qdsp5/audio_evrc.c
 create mode 100644 drivers/staging/dream/qdsp5/audio_in.c
 create mode 100644 drivers/staging/dream/qdsp5/audio_mp3.c
 create mode 100644 drivers/staging/dream/qdsp5/audio_out.c
 create mode 100644 drivers/staging/dream/qdsp5/audio_qcelp.c
 create mode 100644 drivers/staging/dream/qdsp5/audmgr.c
 create mode 100644 drivers/staging/dream/qdsp5/audmgr.h
 create mode 100644 drivers/staging/dream/qdsp5/audmgr_new.h
 create mode 100644 drivers/staging/dream/qdsp5/audpp.c
 create mode 100644 drivers/staging/dream/qdsp5/evlog.h
 create mode 100644 drivers/staging/dream/qdsp5/snd.c
 create mode 100644 drivers/staging/dream/smd/Kconfig
 create mode 100644 drivers/staging/dream/smd/Makefile
 create mode 100644 drivers/staging/dream/smd/rpc_server_dog_keepalive.c
 create mode 100644 drivers/staging/dream/smd/rpc_server_time_remote.c
 create mode 100644 drivers/staging/dream/smd/smd.c
 create mode 100644 drivers/staging/dream/smd/smd_private.h
 create mode 100644 drivers/staging/dream/smd/smd_qmi.c
 create mode 100644 drivers/staging/dream/smd/smd_rpcrouter.c
 create mode 100644 drivers/staging/dream/smd/smd_rpcrouter.h
 create mode 100644 drivers/staging/dream/smd/smd_rpcrouter_device.c
 create mode 100644 drivers/staging/dream/smd/smd_rpcrouter_servers.c
 create mode 100644 drivers/staging/dream/smd/smd_tty.c
 create mode 100644 drivers/staging/dream/synaptics_i2c_rmi.c
 create mode 100644 drivers/staging/dream/synaptics_i2c_rmi.h
 delete mode 100644 drivers/staging/echo/bit_operations.h
 delete mode 100644 drivers/staging/echo/mmx.h
 delete mode 100644 drivers/staging/epl/Benchmark.h
 delete mode 100644 drivers/staging/epl/Debug.h
 delete mode 100644 drivers/staging/epl/Edrv8139.c
 delete mode 100644 drivers/staging/epl/EdrvFec.h
 delete mode 100644 drivers/staging/epl/EdrvSim.h
 delete mode 100644 drivers/staging/epl/Epl.h
 delete mode 100644 drivers/staging/epl/EplAmi.h
 delete mode 100644 drivers/staging/epl/EplApiGeneric.c
 delete mode 100644 drivers/staging/epl/EplApiLinux.h
 delete mode 100644 drivers/staging/epl/EplApiLinuxKernel.c
 delete mode 100644 drivers/staging/epl/EplApiProcessImage.c
 delete mode 100644 drivers/staging/epl/EplCfg.h
 delete mode 100644 drivers/staging/epl/EplDef.h
 delete mode 100644 drivers/staging/epl/EplDll.h
 delete mode 100644 drivers/staging/epl/EplDllCal.h
 delete mode 100644 drivers/staging/epl/EplDllk.c
 delete mode 100644 drivers/staging/epl/EplDllkCal.c
 delete mode 100644 drivers/staging/epl/EplDlluCal.c
 delete mode 100644 drivers/staging/epl/EplErrDef.h
 delete mode 100644 drivers/staging/epl/EplErrorHandlerk.c
 delete mode 100644 drivers/staging/epl/EplEvent.h
 delete mode 100644 drivers/staging/epl/EplEventk.c
 delete mode 100644 drivers/staging/epl/EplEventu.c
 delete mode 100644 drivers/staging/epl/EplFrame.h
 delete mode 100644 drivers/staging/epl/EplIdentu.c
 delete mode 100644 drivers/staging/epl/EplInc.h
 delete mode 100644 drivers/staging/epl/EplInstDef.h
 delete mode 100644 drivers/staging/epl/EplLed.h
 delete mode 100644 drivers/staging/epl/EplNmt.h
 delete mode 100644 drivers/staging/epl/EplNmtCnu.c
 delete mode 100644 drivers/staging/epl/EplNmtMnu.c
 delete mode 100644 drivers/staging/epl/EplNmtk.c
 delete mode 100644 drivers/staging/epl/EplNmtkCal.c
 delete mode 100644 drivers/staging/epl/EplNmtu.c
 delete mode 100644 drivers/staging/epl/EplNmtuCal.c
 delete mode 100644 drivers/staging/epl/EplObd.c
 delete mode 100644 drivers/staging/epl/EplObd.h
 delete mode 100644 drivers/staging/epl/EplObdMacro.h
 delete mode 100644 drivers/staging/epl/EplObdkCal.c
 delete mode 100644 drivers/staging/epl/EplObdu.c
 delete mode 100644 drivers/staging/epl/EplObduCal.c
 delete mode 100644 drivers/staging/epl/EplPdo.h
 delete mode 100644 drivers/staging/epl/EplPdok.c
 delete mode 100644 drivers/staging/epl/EplPdokCal.c
 delete mode 100644 drivers/staging/epl/EplPdou.c
 delete mode 100644 drivers/staging/epl/EplSdo.h
 delete mode 100644 drivers/staging/epl/EplSdoAc.h
 delete mode 100644 drivers/staging/epl/EplSdoAsndu.c
 delete mode 100644 drivers/staging/epl/EplSdoAsySequ.c
 delete mode 100644 drivers/staging/epl/EplSdoComu.c
 delete mode 100644 drivers/staging/epl/EplSdoUdpu.c
 delete mode 100644 drivers/staging/epl/EplStatusu.c
 delete mode 100644 drivers/staging/epl/EplTarget.h
 delete mode 100644 drivers/staging/epl/EplTimer.h
 delete mode 100644 drivers/staging/epl/EplTimeruLinuxKernel.c
 delete mode 100644 drivers/staging/epl/EplVersion.h
 delete mode 100644 drivers/staging/epl/Kconfig
 delete mode 100644 drivers/staging/epl/Makefile
 delete mode 100644 drivers/staging/epl/SharedBuff.c
 delete mode 100644 drivers/staging/epl/SharedBuff.h
 delete mode 100644 drivers/staging/epl/ShbIpc-LinuxKernel.c
 delete mode 100644 drivers/staging/epl/ShbIpc.h
 delete mode 100644 drivers/staging/epl/ShbLinuxKernel.h
 delete mode 100644 drivers/staging/epl/SocketLinuxKernel.c
 delete mode 100644 drivers/staging/epl/SocketLinuxKernel.h
 delete mode 100644 drivers/staging/epl/TimerHighReskX86.c
 delete mode 100644 drivers/staging/epl/VirtualEthernetLinux.c
 delete mode 100644 drivers/staging/epl/amix86.c
 delete mode 100644 drivers/staging/epl/demo_main.c
 delete mode 100644 drivers/staging/epl/edrv.h
 delete mode 100644 drivers/staging/epl/global.h
 delete mode 100644 drivers/staging/epl/kernel/EplDllk.h
 delete mode 100644 drivers/staging/epl/kernel/EplDllkCal.h
 delete mode 100644 drivers/staging/epl/kernel/EplErrorHandlerk.h
 delete mode 100644 drivers/staging/epl/kernel/EplEventk.h
 delete mode 100644 drivers/staging/epl/kernel/EplNmtk.h
 delete mode 100644 drivers/staging/epl/kernel/EplObdk.h
 delete mode 100644 drivers/staging/epl/kernel/EplPdok.h
 delete mode 100644 drivers/staging/epl/kernel/EplPdokCal.h
 delete mode 100644 drivers/staging/epl/kernel/EplTimerHighResk.h
 delete mode 100644 drivers/staging/epl/kernel/EplTimerk.h
 delete mode 100644 drivers/staging/epl/kernel/VirtualEthernet.h
 delete mode 100644 drivers/staging/epl/proc_fs.c
 delete mode 100644 drivers/staging/epl/proc_fs.h
 delete mode 100644 drivers/staging/epl/user/EplCfgMau.h
 delete mode 100644 drivers/staging/epl/user/EplDllu.h
 delete mode 100644 drivers/staging/epl/user/EplDlluCal.h
 delete mode 100644 drivers/staging/epl/user/EplEventu.h
 delete mode 100644 drivers/staging/epl/user/EplIdentu.h
 delete mode 100644 drivers/staging/epl/user/EplLedu.h
 delete mode 100644 drivers/staging/epl/user/EplNmtCnu.h
 delete mode 100644 drivers/staging/epl/user/EplNmtMnu.h
 delete mode 100644 drivers/staging/epl/user/EplNmtu.h
 delete mode 100644 drivers/staging/epl/user/EplNmtuCal.h
 delete mode 100644 drivers/staging/epl/user/EplObdu.h
 delete mode 100644 drivers/staging/epl/user/EplObduCal.h
 delete mode 100644 drivers/staging/epl/user/EplPdou.h
 delete mode 100644 drivers/staging/epl/user/EplSdoAsndu.h
 delete mode 100644 drivers/staging/epl/user/EplSdoAsySequ.h
 delete mode 100644 drivers/staging/epl/user/EplSdoComu.h
 delete mode 100644 drivers/staging/epl/user/EplSdoUdpu.h
 delete mode 100644 drivers/staging/epl/user/EplStatusu.h
 delete mode 100644 drivers/staging/epl/user/EplTimeru.h
 delete mode 100644 drivers/staging/et131x/et1310_jagcore.c
 delete mode 100644 drivers/staging/et131x/et131x_config.c
 delete mode 100644 drivers/staging/et131x/et131x_debug.c
 delete mode 100644 drivers/staging/et131x/et131x_debug.h
 delete mode 100644 drivers/staging/heci/Kconfig
 delete mode 100644 drivers/staging/heci/Makefile
 delete mode 100644 drivers/staging/heci/TODO
 delete mode 100644 drivers/staging/heci/heci.h
 delete mode 100644 drivers/staging/heci/heci_data_structures.h
 delete mode 100644 drivers/staging/heci/heci_init.c
 delete mode 100644 drivers/staging/heci/heci_interface.c
 delete mode 100644 drivers/staging/heci/heci_interface.h
 delete mode 100644 drivers/staging/heci/heci_main.c
 delete mode 100644 drivers/staging/heci/heci_version.h
 delete mode 100644 drivers/staging/heci/interrupt.c
 delete mode 100644 drivers/staging/heci/io_heci.c
 create mode 100644 drivers/staging/hv/BlkVsc.c
 create mode 100644 drivers/staging/hv/Channel.c
 create mode 100644 drivers/staging/hv/Channel.h
 create mode 100644 drivers/staging/hv/ChannelInterface.c
 create mode 100644 drivers/staging/hv/ChannelInterface.h
 create mode 100644 drivers/staging/hv/ChannelMgmt.c
 create mode 100644 drivers/staging/hv/ChannelMgmt.h
 create mode 100644 drivers/staging/hv/Connection.c
 create mode 100644 drivers/staging/hv/Hv.c
 create mode 100644 drivers/staging/hv/Hv.h
 create mode 100644 drivers/staging/hv/Kconfig
 create mode 100644 drivers/staging/hv/Makefile
 create mode 100644 drivers/staging/hv/NetVsc.c
 create mode 100644 drivers/staging/hv/NetVsc.h
 create mode 100644 drivers/staging/hv/NetVscApi.h
 create mode 100644 drivers/staging/hv/RingBuffer.c
 create mode 100644 drivers/staging/hv/RingBuffer.h
 create mode 100644 drivers/staging/hv/RndisFilter.c
 create mode 100644 drivers/staging/hv/RndisFilter.h
 create mode 100644 drivers/staging/hv/StorVsc.c
 create mode 100644 drivers/staging/hv/StorVscApi.h
 create mode 100644 drivers/staging/hv/TODO
 create mode 100644 drivers/staging/hv/VersionInfo.h
 create mode 100644 drivers/staging/hv/Vmbus.c
 create mode 100644 drivers/staging/hv/VmbusApi.h
 create mode 100644 drivers/staging/hv/VmbusChannelInterface.h
 create mode 100644 drivers/staging/hv/VmbusPacketFormat.h
 create mode 100644 drivers/staging/hv/VmbusPrivate.h
 create mode 100644 drivers/staging/hv/blkvsc_drv.c
 create mode 100644 drivers/staging/hv/hv_api.h
 create mode 100644 drivers/staging/hv/logging.h
 create mode 100644 drivers/staging/hv/netvsc_drv.c
 create mode 100644 drivers/staging/hv/osd.c
 create mode 100644 drivers/staging/hv/osd.h
 create mode 100644 drivers/staging/hv/rndis.h
 create mode 100644 drivers/staging/hv/storvsc_drv.c
 create mode 100644 drivers/staging/hv/vmbus.h
 create mode 100644 drivers/staging/hv/vmbus_drv.c
 create mode 100644 drivers/staging/hv/vstorage.h
 create mode 100644 drivers/staging/iio/Documentation/device.txt
 create mode 100644 drivers/staging/iio/Documentation/iio_utils.h
 create mode 100644 drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
 create mode 100644 drivers/staging/iio/Documentation/overview.txt
 create mode 100644 drivers/staging/iio/Documentation/ring.txt
 create mode 100644 drivers/staging/iio/Documentation/trigger.txt
 create mode 100644 drivers/staging/iio/Documentation/userspace.txt
 create mode 100644 drivers/staging/iio/Kconfig
 create mode 100644 drivers/staging/iio/Makefile
 create mode 100644 drivers/staging/iio/TODO
 create mode 100644 drivers/staging/iio/accel/Kconfig
 create mode 100644 drivers/staging/iio/accel/Makefile
 create mode 100644 drivers/staging/iio/accel/accel.h
 create mode 100644 drivers/staging/iio/accel/kxsd9.c
 create mode 100644 drivers/staging/iio/accel/lis3l02dq.h
 create mode 100644 drivers/staging/iio/accel/lis3l02dq_core.c
 create mode 100644 drivers/staging/iio/accel/lis3l02dq_ring.c
 create mode 100644 drivers/staging/iio/accel/sca3000.h
 create mode 100644 drivers/staging/iio/accel/sca3000_core.c
 create mode 100644 drivers/staging/iio/accel/sca3000_ring.c
 create mode 100644 drivers/staging/iio/adc/Kconfig
 create mode 100644 drivers/staging/iio/adc/Makefile
 create mode 100644 drivers/staging/iio/adc/adc.h
 create mode 100644 drivers/staging/iio/adc/max1363.h
 create mode 100644 drivers/staging/iio/adc/max1363_core.c
 create mode 100644 drivers/staging/iio/adc/max1363_ring.c
 create mode 100644 drivers/staging/iio/chrdev.h
 create mode 100644 drivers/staging/iio/iio.h
 create mode 100644 drivers/staging/iio/industrialio-core.c
 create mode 100644 drivers/staging/iio/industrialio-ring.c
 create mode 100644 drivers/staging/iio/industrialio-trigger.c
 create mode 100644 drivers/staging/iio/light/Kconfig
 create mode 100644 drivers/staging/iio/light/Makefile
 create mode 100644 drivers/staging/iio/light/light.h
 create mode 100644 drivers/staging/iio/light/tsl2561.c
 create mode 100644 drivers/staging/iio/ring_generic.h
 create mode 100644 drivers/staging/iio/ring_hw.h
 create mode 100644 drivers/staging/iio/ring_sw.c
 create mode 100644 drivers/staging/iio/ring_sw.h
 create mode 100644 drivers/staging/iio/sysfs.h
 create mode 100644 drivers/staging/iio/trigger.h
 create mode 100644 drivers/staging/iio/trigger/Kconfig
 create mode 100644 drivers/staging/iio/trigger/Makefile
 create mode 100644 drivers/staging/iio/trigger/iio-trig-gpio.c
 create mode 100644 drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
 create mode 100644 drivers/staging/iio/trigger_consumer.h
 delete mode 100644 drivers/staging/me4000/Kconfig
 delete mode 100644 drivers/staging/me4000/Makefile
 delete mode 100644 drivers/staging/me4000/README
 delete mode 100644 drivers/staging/me4000/me4000.c
 delete mode 100644 drivers/staging/me4000/me4000.h
 delete mode 100644 drivers/staging/me4000/me4000_firmware.h
 delete mode 100644 drivers/staging/me4000/me4610_firmware.h
 delete mode 100644 drivers/staging/meilhaus/Kconfig
 delete mode 100644 drivers/staging/meilhaus/Makefile
 delete mode 100644 drivers/staging/meilhaus/TODO
 delete mode 100644 drivers/staging/meilhaus/me0600_device.c
 delete mode 100644 drivers/staging/meilhaus/me0600_device.h
 delete mode 100644 drivers/staging/meilhaus/me0600_dio.c
 delete mode 100644 drivers/staging/meilhaus/me0600_dio.h
 delete mode 100644 drivers/staging/meilhaus/me0600_dio_reg.h
 delete mode 100644 drivers/staging/meilhaus/me0600_ext_irq.c
 delete mode 100644 drivers/staging/meilhaus/me0600_ext_irq.h
 delete mode 100644 drivers/staging/meilhaus/me0600_ext_irq_reg.h
 delete mode 100644 drivers/staging/meilhaus/me0600_optoi.c
 delete mode 100644 drivers/staging/meilhaus/me0600_optoi.h
 delete mode 100644 drivers/staging/meilhaus/me0600_optoi_reg.h
 delete mode 100644 drivers/staging/meilhaus/me0600_relay.c
 delete mode 100644 drivers/staging/meilhaus/me0600_relay.h
 delete mode 100644 drivers/staging/meilhaus/me0600_relay_reg.h
 delete mode 100644 drivers/staging/meilhaus/me0600_ttli.c
 delete mode 100644 drivers/staging/meilhaus/me0600_ttli.h
 delete mode 100644 drivers/staging/meilhaus/me0600_ttli_reg.h
 delete mode 100644 drivers/staging/meilhaus/me0900_device.c
 delete mode 100644 drivers/staging/meilhaus/me0900_device.h
 delete mode 100644 drivers/staging/meilhaus/me0900_di.c
 delete mode 100644 drivers/staging/meilhaus/me0900_di.h
 delete mode 100644 drivers/staging/meilhaus/me0900_do.c
 delete mode 100644 drivers/staging/meilhaus/me0900_do.h
 delete mode 100644 drivers/staging/meilhaus/me0900_reg.h
 delete mode 100644 drivers/staging/meilhaus/me1000_device.c
 delete mode 100644 drivers/staging/meilhaus/me1000_device.h
 delete mode 100644 drivers/staging/meilhaus/me1000_dio.c
 delete mode 100644 drivers/staging/meilhaus/me1000_dio.h
 delete mode 100644 drivers/staging/meilhaus/me1000_dio_reg.h
 delete mode 100644 drivers/staging/meilhaus/me1400_device.c
 delete mode 100644 drivers/staging/meilhaus/me1400_device.h
 delete mode 100644 drivers/staging/meilhaus/me1400_ext_irq.c
 delete mode 100644 drivers/staging/meilhaus/me1400_ext_irq.h
 delete mode 100644 drivers/staging/meilhaus/me1400_ext_irq_reg.h
 delete mode 100644 drivers/staging/meilhaus/me1600_ao.c
 delete mode 100644 drivers/staging/meilhaus/me1600_ao.h
 delete mode 100644 drivers/staging/meilhaus/me1600_ao_reg.h
 delete mode 100644 drivers/staging/meilhaus/me1600_device.c
 delete mode 100644 drivers/staging/meilhaus/me1600_device.h
 delete mode 100644 drivers/staging/meilhaus/me4600_ai.c
 delete mode 100644 drivers/staging/meilhaus/me4600_ai.h
 delete mode 100644 drivers/staging/meilhaus/me4600_ai_reg.h
 delete mode 100644 drivers/staging/meilhaus/me4600_ao.c
 delete mode 100644 drivers/staging/meilhaus/me4600_ao.h
 delete mode 100644 drivers/staging/meilhaus/me4600_ao_reg.h
 delete mode 100644 drivers/staging/meilhaus/me4600_device.c
 delete mode 100644 drivers/staging/meilhaus/me4600_device.h
 delete mode 100644 drivers/staging/meilhaus/me4600_di.c
 delete mode 100644 drivers/staging/meilhaus/me4600_di.h
 delete mode 100644 drivers/staging/meilhaus/me4600_dio.c
 delete mode 100644 drivers/staging/meilhaus/me4600_dio.h
 delete mode 100644 drivers/staging/meilhaus/me4600_dio_reg.h
 delete mode 100644 drivers/staging/meilhaus/me4600_do.c
 delete mode 100644 drivers/staging/meilhaus/me4600_do.h
 delete mode 100644 drivers/staging/meilhaus/me4600_ext_irq.c
 delete mode 100644 drivers/staging/meilhaus/me4600_ext_irq.h
 delete mode 100644 drivers/staging/meilhaus/me4600_ext_irq_reg.h
 delete mode 100644 drivers/staging/meilhaus/me4600_reg.h
 delete mode 100644 drivers/staging/meilhaus/me6000_ao.c
 delete mode 100644 drivers/staging/meilhaus/me6000_ao.h
 delete mode 100644 drivers/staging/meilhaus/me6000_ao_reg.h
 delete mode 100644 drivers/staging/meilhaus/me6000_device.c
 delete mode 100644 drivers/staging/meilhaus/me6000_device.h
 delete mode 100644 drivers/staging/meilhaus/me6000_dio.c
 delete mode 100644 drivers/staging/meilhaus/me6000_dio.h
 delete mode 100644 drivers/staging/meilhaus/me6000_dio_reg.h
 delete mode 100644 drivers/staging/meilhaus/me6000_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8100_device.c
 delete mode 100644 drivers/staging/meilhaus/me8100_device.h
 delete mode 100644 drivers/staging/meilhaus/me8100_di.c
 delete mode 100644 drivers/staging/meilhaus/me8100_di.h
 delete mode 100644 drivers/staging/meilhaus/me8100_di_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8100_do.c
 delete mode 100644 drivers/staging/meilhaus/me8100_do.h
 delete mode 100644 drivers/staging/meilhaus/me8100_do_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8100_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8200_device.c
 delete mode 100644 drivers/staging/meilhaus/me8200_device.h
 delete mode 100644 drivers/staging/meilhaus/me8200_di.c
 delete mode 100644 drivers/staging/meilhaus/me8200_di.h
 delete mode 100644 drivers/staging/meilhaus/me8200_di_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8200_dio.c
 delete mode 100644 drivers/staging/meilhaus/me8200_dio.h
 delete mode 100644 drivers/staging/meilhaus/me8200_dio_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8200_do.c
 delete mode 100644 drivers/staging/meilhaus/me8200_do.h
 delete mode 100644 drivers/staging/meilhaus/me8200_do_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8200_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8254.c
 delete mode 100644 drivers/staging/meilhaus/me8254.h
 delete mode 100644 drivers/staging/meilhaus/me8254_reg.h
 delete mode 100644 drivers/staging/meilhaus/me8255.c
 delete mode 100644 drivers/staging/meilhaus/me8255.h
 delete mode 100644 drivers/staging/meilhaus/me8255_reg.h
 delete mode 100644 drivers/staging/meilhaus/mecirc_buf.h
 delete mode 100644 drivers/staging/meilhaus/mecommon.h
 delete mode 100644 drivers/staging/meilhaus/medebug.h
 delete mode 100644 drivers/staging/meilhaus/medefines.h
 delete mode 100644 drivers/staging/meilhaus/medevice.c
 delete mode 100644 drivers/staging/meilhaus/medevice.h
 delete mode 100644 drivers/staging/meilhaus/medlist.c
 delete mode 100644 drivers/staging/meilhaus/medlist.h
 delete mode 100644 drivers/staging/meilhaus/medlock.c
 delete mode 100644 drivers/staging/meilhaus/medlock.h
 delete mode 100644 drivers/staging/meilhaus/medriver.h
 delete mode 100644 drivers/staging/meilhaus/medummy.c
 delete mode 100644 drivers/staging/meilhaus/medummy.h
 delete mode 100644 drivers/staging/meilhaus/meerror.h
 delete mode 100644 drivers/staging/meilhaus/mefirmware.c
 delete mode 100644 drivers/staging/meilhaus/mefirmware.h
 delete mode 100644 drivers/staging/meilhaus/meids.h
 delete mode 100644 drivers/staging/meilhaus/meinternal.h
 delete mode 100644 drivers/staging/meilhaus/meioctl.h
 delete mode 100644 drivers/staging/meilhaus/memain.c
 delete mode 100644 drivers/staging/meilhaus/memain.h
 delete mode 100644 drivers/staging/meilhaus/meplx_reg.h
 delete mode 100644 drivers/staging/meilhaus/meslist.c
 delete mode 100644 drivers/staging/meilhaus/meslist.h
 delete mode 100644 drivers/staging/meilhaus/meslock.c
 delete mode 100644 drivers/staging/meilhaus/meslock.h
 delete mode 100644 drivers/staging/meilhaus/mesubdevice.c
 delete mode 100644 drivers/staging/meilhaus/mesubdevice.h
 delete mode 100644 drivers/staging/meilhaus/metempl_device.c
 delete mode 100644 drivers/staging/meilhaus/metempl_device.h
 delete mode 100644 drivers/staging/meilhaus/metempl_sub.c
 delete mode 100644 drivers/staging/meilhaus/metempl_sub.h
 delete mode 100644 drivers/staging/meilhaus/metempl_sub_reg.h
 delete mode 100644 drivers/staging/meilhaus/metypes.h
 delete mode 100644 drivers/staging/pata_rdc/Kconfig
 delete mode 100644 drivers/staging/pata_rdc/Makefile
 delete mode 100644 drivers/staging/pata_rdc/pata_rdc.c
 delete mode 100644 drivers/staging/pata_rdc/pata_rdc.h
 create mode 100644 drivers/staging/quatech_usb2/Kconfig
 create mode 100644 drivers/staging/quatech_usb2/Makefile
 create mode 100644 drivers/staging/quatech_usb2/TODO
 create mode 100644 drivers/staging/quatech_usb2/quatech_usb2.c
 create mode 100644 drivers/staging/rar/Kconfig
 create mode 100644 drivers/staging/rar/Makefile
 create mode 100644 drivers/staging/rar/rar_driver.c
 create mode 100644 drivers/staging/rar/rar_driver.h
 delete mode 100644 drivers/staging/rspiusb/Kconfig
 delete mode 100644 drivers/staging/rspiusb/Makefile
 delete mode 100644 drivers/staging/rspiusb/TODO
 delete mode 100644 drivers/staging/rspiusb/rspiusb.c
 delete mode 100644 drivers/staging/rspiusb/rspiusb.h
 delete mode 100644 drivers/staging/rt2860/link_list.h
 delete mode 100644 drivers/staging/rt2860/md4.h
 delete mode 100644 drivers/staging/rt2870/common/firmware.h
 delete mode 100644 drivers/staging/rt2870/link_list.h
 delete mode 100644 drivers/staging/rt2870/md4.h
 delete mode 100644 drivers/staging/rt3070/2870_main_dev.c
 delete mode 100644 drivers/staging/rt3070/Kconfig
 delete mode 100644 drivers/staging/rt3070/Makefile
 delete mode 100644 drivers/staging/rt3070/action.h
 delete mode 100644 drivers/staging/rt3070/aironet.h
 delete mode 100644 drivers/staging/rt3070/ap.h
 delete mode 100644 drivers/staging/rt3070/chlist.h
 delete mode 100644 drivers/staging/rt3070/common/2870_rtmp_init.c
 delete mode 100644 drivers/staging/rt3070/common/action.c
 delete mode 100644 drivers/staging/rt3070/common/ba_action.c
 delete mode 100644 drivers/staging/rt3070/common/cmm_data.c
 delete mode 100644 drivers/staging/rt3070/common/cmm_data_2870.c
 delete mode 100644 drivers/staging/rt3070/common/cmm_info.c
 delete mode 100644 drivers/staging/rt3070/common/cmm_sanity.c
 delete mode 100644 drivers/staging/rt3070/common/cmm_sync.c
 delete mode 100644 drivers/staging/rt3070/common/cmm_wpa.c
 delete mode 100644 drivers/staging/rt3070/common/dfs.c
 delete mode 100644 drivers/staging/rt3070/common/eeprom.c
 delete mode 100644 drivers/staging/rt3070/common/md5.c
 delete mode 100644 drivers/staging/rt3070/common/mlme.c
 delete mode 100644 drivers/staging/rt3070/common/rtmp_init.c
 delete mode 100644 drivers/staging/rt3070/common/rtmp_tkip.c
 delete mode 100644 drivers/staging/rt3070/common/rtmp_wep.c
 delete mode 100644 drivers/staging/rt3070/common/rtusb_bulk.c
 delete mode 100644 drivers/staging/rt3070/common/rtusb_data.c
 delete mode 100644 drivers/staging/rt3070/common/rtusb_io.c
 delete mode 100644 drivers/staging/rt3070/common/spectrum.c
 delete mode 100644 drivers/staging/rt3070/dfs.h
 delete mode 100644 drivers/staging/rt3070/link_list.h
 delete mode 100644 drivers/staging/rt3070/md5.h
 delete mode 100644 drivers/staging/rt3070/mlme.h
 delete mode 100644 drivers/staging/rt3070/oid.h
 delete mode 100644 drivers/staging/rt3070/rt2870.h
 delete mode 100644 drivers/staging/rt3070/rt28xx.h
 delete mode 100644 drivers/staging/rt3070/rt_config.h
 delete mode 100644 drivers/staging/rt3070/rt_linux.c
 delete mode 100644 drivers/staging/rt3070/rt_linux.h
 delete mode 100644 drivers/staging/rt3070/rt_main_dev.c
 delete mode 100644 drivers/staging/rt3070/rt_profile.c
 delete mode 100644 drivers/staging/rt3070/rtmp.h
 delete mode 100644 drivers/staging/rt3070/rtmp_ckipmic.h
 delete mode 100644 drivers/staging/rt3070/rtmp_def.h
 delete mode 100644 drivers/staging/rt3070/rtmp_type.h
 delete mode 100644 drivers/staging/rt3070/spectrum.h
 delete mode 100644 drivers/staging/rt3070/spectrum_def.h
 delete mode 100644 drivers/staging/rt3070/sta/aironet.c
 delete mode 100644 drivers/staging/rt3070/sta/assoc.c
 delete mode 100644 drivers/staging/rt3070/sta/auth.c
 delete mode 100644 drivers/staging/rt3070/sta/auth_rsp.c
 delete mode 100644 drivers/staging/rt3070/sta/connect.c
 delete mode 100644 drivers/staging/rt3070/sta/rtmp_data.c
 delete mode 100644 drivers/staging/rt3070/sta/sanity.c
 delete mode 100644 drivers/staging/rt3070/sta/sync.c
 delete mode 100644 drivers/staging/rt3070/sta/wpa.c
 delete mode 100644 drivers/staging/rt3070/sta_ioctl.c
 delete mode 100644 drivers/staging/rt3070/wpa.h
 create mode 100644 drivers/staging/rt3090/Kconfig
 create mode 100644 drivers/staging/rt3090/Makefile
 create mode 100644 drivers/staging/rt3090/action.h
 create mode 100644 drivers/staging/rt3090/ap.h
 create mode 100644 drivers/staging/rt3090/ap_apcli.h
 create mode 100644 drivers/staging/rt3090/ap_autoChSel.h
 create mode 100644 drivers/staging/rt3090/ap_autoChSel_cmm.h
 create mode 100644 drivers/staging/rt3090/ap_cfg.h
 create mode 100644 drivers/staging/rt3090/ap_ids.h
 create mode 100644 drivers/staging/rt3090/ap_mbss.h
 create mode 100644 drivers/staging/rt3090/ap_uapsd.h
 create mode 100644 drivers/staging/rt3090/ap_wds.h
 create mode 100644 drivers/staging/rt3090/chips/rt3090.c
 create mode 100644 drivers/staging/rt3090/chips/rt30xx.c
 create mode 100644 drivers/staging/rt3090/chips/rt3370.c
 create mode 100644 drivers/staging/rt3090/chips/rt3390.c
 create mode 100644 drivers/staging/rt3090/chips/rt33xx.c
 create mode 100644 drivers/staging/rt3090/chlist.h
 create mode 100644 drivers/staging/rt3090/common/action.c
 create mode 100644 drivers/staging/rt3090/common/ba_action.c
 create mode 100644 drivers/staging/rt3090/common/cmm_aes.c
 create mode 100644 drivers/staging/rt3090/common/cmm_asic.c
 create mode 100644 drivers/staging/rt3090/common/cmm_cfg.c
 create mode 100644 drivers/staging/rt3090/common/cmm_data.c
 create mode 100644 drivers/staging/rt3090/common/cmm_data_pci.c
 create mode 100644 drivers/staging/rt3090/common/cmm_info.c
 create mode 100644 drivers/staging/rt3090/common/cmm_mac_pci.c
 create mode 100644 drivers/staging/rt3090/common/cmm_profile.c
 create mode 100644 drivers/staging/rt3090/common/cmm_sanity.c
 create mode 100644 drivers/staging/rt3090/common/cmm_sync.c
 create mode 100644 drivers/staging/rt3090/common/cmm_tkip.c
 create mode 100644 drivers/staging/rt3090/common/cmm_wep.c
 create mode 100644 drivers/staging/rt3090/common/cmm_wpa.c
 create mode 100644 drivers/staging/rt3090/common/crypt_aes.c
 create mode 100644 drivers/staging/rt3090/common/crypt_biginteger.c
 create mode 100644 drivers/staging/rt3090/common/crypt_dh.c
 create mode 100644 drivers/staging/rt3090/common/crypt_hmac.c
 create mode 100644 drivers/staging/rt3090/common/crypt_md5.c
 create mode 100644 drivers/staging/rt3090/common/crypt_sha2.c
 create mode 100644 drivers/staging/rt3090/common/dfs.c
 create mode 100644 drivers/staging/rt3090/common/ee_efuse.c
 create mode 100644 drivers/staging/rt3090/common/ee_prom.c
 create mode 100644 drivers/staging/rt3090/common/eeprom.c
 create mode 100644 drivers/staging/rt3090/common/igmp_snoop.c
 create mode 100644 drivers/staging/rt3090/common/mlme.c
 create mode 100644 drivers/staging/rt3090/common/mlme_ex.c
 create mode 100644 drivers/staging/rt3090/common/netif_block.c
 create mode 100644 drivers/staging/rt3090/common/rt_channel.c
 create mode 100644 drivers/staging/rt3090/common/rt_rf.c
 create mode 100644 drivers/staging/rt3090/common/rtmp_init.c
 create mode 100644 drivers/staging/rt3090/common/rtmp_mcu.c
 create mode 100644 drivers/staging/rt3090/common/rtmp_timer.c
 create mode 100644 drivers/staging/rt3090/common/spectrum.c
 create mode 100644 drivers/staging/rt3090/config.mk
 create mode 100644 drivers/staging/rt3090/crypt_hmac.h
 create mode 100644 drivers/staging/rt3090/crypt_md5.h
 create mode 100644 drivers/staging/rt3090/crypt_sha2.h
 create mode 100644 drivers/staging/rt3090/dfs.h
 create mode 100644 drivers/staging/rt3090/eeprom.h
 create mode 100644 drivers/staging/rt3090/firmware.h
 create mode 100644 drivers/staging/rt3090/igmp_snoop.h
 create mode 100644 drivers/staging/rt3090/ipv6.h
 create mode 100644 drivers/staging/rt3090/link_list.h
 create mode 100644 drivers/staging/rt3090/mac_pci.h
 create mode 100644 drivers/staging/rt3090/mlme.h
 create mode 100644 drivers/staging/rt3090/mlme_ex.h
 create mode 100644 drivers/staging/rt3090/mlme_ex_def.h
 create mode 100644 drivers/staging/rt3090/netif_block.h
 create mode 100644 drivers/staging/rt3090/oid.h
 create mode 100644 drivers/staging/rt3090/pci_main_dev.c
 create mode 100644 drivers/staging/rt3090/rt3090.h
 create mode 100644 drivers/staging/rt3090/rt30xx.h
 create mode 100644 drivers/staging/rt3090/rt3370.h
 create mode 100644 drivers/staging/rt3090/rt3390.h
 create mode 100644 drivers/staging/rt3090/rt33xx.h
 create mode 100644 drivers/staging/rt3090/rt_ate.c
 create mode 100644 drivers/staging/rt3090/rt_ate.h
 create mode 100644 drivers/staging/rt3090/rt_config.h
 create mode 100644 drivers/staging/rt3090/rt_linux.c
 create mode 100644 drivers/staging/rt3090/rt_linux.h
 create mode 100644 drivers/staging/rt3090/rt_main_dev.c
 create mode 100644 drivers/staging/rt3090/rt_pci_rbus.c
 create mode 100644 drivers/staging/rt3090/rt_profile.c
 create mode 100644 drivers/staging/rt3090/rtmp.h
 create mode 100644 drivers/staging/rt3090/rtmp_chip.h
 create mode 100644 drivers/staging/rt3090/rtmp_def.h
 create mode 100644 drivers/staging/rt3090/rtmp_dot11.h
 create mode 100644 drivers/staging/rt3090/rtmp_iface.h
 create mode 100644 drivers/staging/rt3090/rtmp_mac.h
 create mode 100644 drivers/staging/rt3090/rtmp_mcu.h
 create mode 100644 drivers/staging/rt3090/rtmp_os.h
 create mode 100644 drivers/staging/rt3090/rtmp_pci.h
 create mode 100644 drivers/staging/rt3090/rtmp_phy.h
 create mode 100644 drivers/staging/rt3090/rtmp_timer.h
 create mode 100644 drivers/staging/rt3090/rtmp_type.h
 create mode 100644 drivers/staging/rt3090/spectrum.h
 create mode 100644 drivers/staging/rt3090/spectrum_def.h
 create mode 100644 drivers/staging/rt3090/sta/assoc.c
 create mode 100644 drivers/staging/rt3090/sta/auth.c
 create mode 100644 drivers/staging/rt3090/sta/auth_rsp.c
 create mode 100644 drivers/staging/rt3090/sta/connect.c
 create mode 100644 drivers/staging/rt3090/sta/dls.c
 create mode 100644 drivers/staging/rt3090/sta/rtmp_ckipmic.c
 create mode 100644 drivers/staging/rt3090/sta/rtmp_data.c
 create mode 100644 drivers/staging/rt3090/sta/sanity.c
 create mode 100644 drivers/staging/rt3090/sta/sync.c
 create mode 100644 drivers/staging/rt3090/sta/wpa.c
 create mode 100644 drivers/staging/rt3090/sta_ioctl.c
 create mode 100644 drivers/staging/rt3090/vr_ikans.h
 create mode 100644 drivers/staging/rt3090/wpa.h
 create mode 100644 drivers/staging/rtl8187se/TODO
 delete mode 100644 drivers/staging/rtl8187se/dot11d.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/internal.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/rtl_crypto.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_gct.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_gct.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_max2820.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_max2820.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_pm.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_pm.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8225.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8255.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8255.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_sa2400.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_sa2400.h
 create mode 100644 drivers/staging/rtl8192e/Kconfig
 create mode 100644 drivers/staging/rtl8192e/Makefile
 copy drivers/staging/{rtl8192su => rtl8192e}/dot11d.h (100%)
 create mode 100644 drivers/staging/rtl8192e/ieee80211.h
 create mode 100644 drivers/staging/rtl8192e/ieee80211/dot11d.c
 rename drivers/staging/{rtl8192su => rtl8192e/ieee80211}/dot11d.h (100%)
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211.h
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/rtl819x_BA.h
 create mode 100644 drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/rtl819x_HT.h
 create mode 100644 drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
 create mode 100644 drivers/staging/rtl8192e/ieee80211/rtl819x_Qos.h
 create mode 100644 drivers/staging/rtl8192e/ieee80211/rtl819x_TS.h
 create mode 100644 drivers/staging/rtl8192e/ieee80211/rtl819x_TSProc.c
 rename drivers/staging/{rtl8192su => rtl8192e}/ieee80211/rtl_crypto.h (100%)
 rename drivers/staging/{rtl8187se => rtl8192e}/ieee80211_crypt.h (100%)
 create mode 100644 drivers/staging/rtl8192e/r8180_93cx6.c
 create mode 100644 drivers/staging/rtl8192e/r8180_93cx6.h
 create mode 100644 drivers/staging/rtl8192e/r8190_rtl8256.c
 create mode 100644 drivers/staging/rtl8192e/r8190_rtl8256.h
 create mode 100644 drivers/staging/rtl8192e/r8192E.h
 create mode 100644 drivers/staging/rtl8192e/r8192E_core.c
 create mode 100644 drivers/staging/rtl8192e/r8192E_dm.c
 create mode 100644 drivers/staging/rtl8192e/r8192E_dm.h
 create mode 100644 drivers/staging/rtl8192e/r8192E_hw.h
 create mode 100644 drivers/staging/rtl8192e/r8192E_wx.c
 create mode 100644 drivers/staging/rtl8192e/r8192E_wx.h
 create mode 100644 drivers/staging/rtl8192e/r8192_pm.c
 create mode 100644 drivers/staging/rtl8192e/r8192_pm.h
 create mode 100644 drivers/staging/rtl8192e/r819xE_cmdpkt.c
 create mode 100644 drivers/staging/rtl8192e/r819xE_cmdpkt.h
 create mode 100644 drivers/staging/rtl8192e/r819xE_firmware.c
 create mode 100644 drivers/staging/rtl8192e/r819xE_phy.c
 create mode 100644 drivers/staging/rtl8192e/r819xE_phy.h
 create mode 100644 drivers/staging/rtl8192e/r819xE_phyreg.h
 create mode 100644 drivers/staging/rtl8192su/TODO
 delete mode 100644 drivers/staging/rtl8192su/ieee80211.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/EndianFree.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/aes.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/api.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/arc4.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/autoload.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/cipher.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/compress.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/crypto_compat.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/digest.c
 create mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_r8192s.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/internal.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/kmap_types.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/michael_mic.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/proc.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/scatterwalk.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/scatterwalk.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211_crypt.h
 delete mode 100644 drivers/staging/rtl8192su/r8190_rtl8256.c
 delete mode 100644 drivers/staging/rtl8192su/r8190_rtl8256.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_FwImgDTM.h
 delete mode 100644 drivers/staging/rtl8192su/r8192U_hw.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_firmware.c
 delete mode 100644 drivers/staging/rtl8192su/r819xU_firmware.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_firmware_img.c
 delete mode 100644 drivers/staging/rtl8192su/r819xU_firmware_img.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_phy.c
 delete mode 100644 drivers/staging/rtl8192su/r819xU_phy.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_phyreg.h
 create mode 100644 drivers/staging/sep/Kconfig
 create mode 100644 drivers/staging/sep/Makefile
 create mode 100644 drivers/staging/sep/TODO
 create mode 100644 drivers/staging/sep/sep_dev.h
 create mode 100644 drivers/staging/sep/sep_driver.c
 create mode 100644 drivers/staging/sep/sep_driver_api.h
 create mode 100644 drivers/staging/sep/sep_driver_config.h
 create mode 100644 drivers/staging/sep/sep_driver_hw_defs.h
 delete mode 100644 drivers/staging/sxg/Kconfig
 delete mode 100644 drivers/staging/sxg/Makefile
 delete mode 100644 drivers/staging/sxg/README
 delete mode 100644 drivers/staging/sxg/sxg.c
 delete mode 100644 drivers/staging/sxg/sxg.h
 delete mode 100644 drivers/staging/sxg/sxg_ethtool.c
 delete mode 100644 drivers/staging/sxg/sxg_os.h
 delete mode 100644 drivers/staging/sxg/sxgdbg.h
 delete mode 100644 drivers/staging/sxg/sxghif.h
 delete mode 100644 drivers/staging/sxg/sxghw.h
 delete mode 100644 drivers/staging/sxg/sxgphycode-1.2.h
 create mode 100644 drivers/staging/vme/Kconfig
 create mode 100644 drivers/staging/vme/Makefile
 create mode 100644 drivers/staging/vme/TODO
 create mode 100644 drivers/staging/vme/bridges/Kconfig
 create mode 100644 drivers/staging/vme/bridges/Makefile
 create mode 100644 drivers/staging/vme/bridges/vme_ca91cx42.c
 create mode 100644 drivers/staging/vme/bridges/vme_ca91cx42.h
 create mode 100644 drivers/staging/vme/bridges/vme_tsi148.c
 create mode 100644 drivers/staging/vme/bridges/vme_tsi148.h
 create mode 100644 drivers/staging/vme/devices/Kconfig
 create mode 100644 drivers/staging/vme/devices/Makefile
 create mode 100644 drivers/staging/vme/devices/vme_user.c
 create mode 100644 drivers/staging/vme/devices/vme_user.h
 create mode 100644 drivers/staging/vme/vme.c
 create mode 100644 drivers/staging/vme/vme.h
 create mode 100644 drivers/staging/vme/vme_api.txt
 create mode 100644 drivers/staging/vme/vme_bridge.h
 delete mode 100644 drivers/staging/vt6655/Makefile.arm
 delete mode 100644 drivers/staging/vt6655/Makefile.x86
 create mode 100644 drivers/staging/vt6655/TODO
 delete mode 100644 drivers/staging/vt6655/tbit.h
 delete mode 100644 drivers/staging/vt6655/tpci.h
 delete mode 100644 drivers/staging/vt6655/umem.h
 create mode 100644 drivers/staging/vt6656/80211hdr.h
 create mode 100644 drivers/staging/vt6656/80211mgr.c
 create mode 100644 drivers/staging/vt6656/80211mgr.h
 create mode 100644 drivers/staging/vt6656/Kconfig
 create mode 100644 drivers/staging/vt6656/Makefile
 create mode 100644 drivers/staging/vt6656/TODO
 create mode 100644 drivers/staging/vt6656/aes_ccmp.c
 create mode 100644 drivers/staging/vt6656/aes_ccmp.h
 create mode 100644 drivers/staging/vt6656/baseband.c
 create mode 100644 drivers/staging/vt6656/baseband.h
 create mode 100644 drivers/staging/vt6656/bssdb.c
 create mode 100644 drivers/staging/vt6656/bssdb.h
 create mode 100644 drivers/staging/vt6656/card.c
 create mode 100644 drivers/staging/vt6656/card.h
 create mode 100644 drivers/staging/vt6656/channel.c
 create mode 100644 drivers/staging/vt6656/channel.h
 create mode 100644 drivers/staging/vt6656/control.c
 create mode 100644 drivers/staging/vt6656/control.h
 create mode 100644 drivers/staging/vt6656/country.h
 create mode 100644 drivers/staging/vt6656/datarate.c
 create mode 100644 drivers/staging/vt6656/datarate.h
 create mode 100644 drivers/staging/vt6656/desc.h
 create mode 100644 drivers/staging/vt6656/device.h
 create mode 100644 drivers/staging/vt6656/device_cfg.h
 create mode 100644 drivers/staging/vt6656/dpc.c
 create mode 100644 drivers/staging/vt6656/dpc.h
 create mode 100644 drivers/staging/vt6656/firmware.c
 create mode 100644 drivers/staging/vt6656/firmware.h
 create mode 100644 drivers/staging/vt6656/hostap.c
 create mode 100644 drivers/staging/vt6656/hostap.h
 create mode 100644 drivers/staging/vt6656/int.c
 create mode 100644 drivers/staging/vt6656/int.h
 create mode 100644 drivers/staging/vt6656/iocmd.h
 create mode 100644 drivers/staging/vt6656/ioctl.c
 create mode 100644 drivers/staging/vt6656/ioctl.h
 create mode 100644 drivers/staging/vt6656/iowpa.h
 create mode 100644 drivers/staging/vt6656/iwctl.c
 create mode 100644 drivers/staging/vt6656/iwctl.h
 create mode 100644 drivers/staging/vt6656/kcompat.h
 create mode 100644 drivers/staging/vt6656/key.c
 create mode 100644 drivers/staging/vt6656/key.h
 create mode 100644 drivers/staging/vt6656/mac.c
 create mode 100644 drivers/staging/vt6656/mac.h
 create mode 100644 drivers/staging/vt6656/main_usb.c
 create mode 100644 drivers/staging/vt6656/mib.c
 create mode 100644 drivers/staging/vt6656/mib.h
 create mode 100644 drivers/staging/vt6656/michael.c
 create mode 100644 drivers/staging/vt6656/michael.h
 create mode 100644 drivers/staging/vt6656/power.c
 create mode 100644 drivers/staging/vt6656/power.h
 create mode 100644 drivers/staging/vt6656/rc4.c
 create mode 100644 drivers/staging/vt6656/rc4.h
 create mode 100644 drivers/staging/vt6656/rf.c
 create mode 100644 drivers/staging/vt6656/rf.h
 create mode 100644 drivers/staging/vt6656/rndis.h
 create mode 100644 drivers/staging/vt6656/rxtx.c
 create mode 100644 drivers/staging/vt6656/rxtx.h
 create mode 100644 drivers/staging/vt6656/srom.h
 create mode 100644 drivers/staging/vt6656/tcrc.c
 create mode 100644 drivers/staging/vt6656/tcrc.h
 create mode 100644 drivers/staging/vt6656/tether.c
 create mode 100644 drivers/staging/vt6656/tether.h
 create mode 100644 drivers/staging/vt6656/tkip.c
 create mode 100644 drivers/staging/vt6656/tkip.h
 create mode 100644 drivers/staging/vt6656/tmacro.h
 create mode 100644 drivers/staging/vt6656/ttype.h
 create mode 100644 drivers/staging/vt6656/upc.h
 create mode 100644 drivers/staging/vt6656/usbpipe.c
 create mode 100644 drivers/staging/vt6656/usbpipe.h
 create mode 100644 drivers/staging/vt6656/vntconfiguration.dat
 create mode 100644 drivers/staging/vt6656/wcmd.c
 create mode 100644 drivers/staging/vt6656/wcmd.h
 create mode 100644 drivers/staging/vt6656/wctl.c
 create mode 100644 drivers/staging/vt6656/wctl.h
 create mode 100644 drivers/staging/vt6656/wmgr.c
 create mode 100644 drivers/staging/vt6656/wmgr.h
 create mode 100644 drivers/staging/vt6656/wpa.c
 create mode 100644 drivers/staging/vt6656/wpa.h
 create mode 100644 drivers/staging/vt6656/wpa2.c
 create mode 100644 drivers/staging/vt6656/wpa2.h
 create mode 100644 drivers/staging/vt6656/wpactl.c
 create mode 100644 drivers/staging/vt6656/wpactl.h

---------------

Alan Cox (82):
      Staging: et1310: Fix the coding style
      Staging: sep: Move the RAR support into staging where it is supposed to be
      Staging: rar: fix some initial type problems
      Staging: rar/sep: Don't use random VENDOR_ID macros but the proper names
      Staging: sep: Fix rar build
      Staging: rar/sep: Remove C++isms from the headers
      Staging: sep: Create a structure to hold all the current crap spewed about as globals
      Staging: sep: rework write_register/read_register
      Staging: sep: We have two different repeats of the same logic
      Staging: sep: do something about all the printk macros
      Staging: sep: indent pass
      Staging: sep: first pass after indent
      Staging: sep: priceless ...
      Staging: sep: Put all the ARM bits together
      Staging: sep: function shuffle
      Staging: sep: statically initialize the fops like other drivers
      Staging: sep: kill lock wrapper
      Staging: sep: merge the two files
      Staging: sep: make everything static
      Staging: sep: kill off unused code
      Staging: sep: squish some of the wrapper functions
      Staging: sep: forward declaration removal time
      Staging: sep: fix time handler
      Staging: sep: use O_NDELAY instead of magic APIs
      Staging: sep: rename some fields
      Staging: sep: Fix PCI irq usage
      Staging: sep: Use filp->private_data to create proper device instances
      Staging: sep: clean up after switching to passing sep
      Staging: sep: fix flow API
      Staging: sep: load_rom is remarkably verbose and repetetive
      Staging: sep: remove module int macro
      Staging: sep: Try and get kernel address and user address types right
      Staging: sep: remove extra CFLAGS we don't use
      Staging: sep: Use the proper allocators for the shared area
      Staging: sep: fix a conversion thinko
      Staging: sep: various minor tidyups
      Staging: sep: tidy firmware load
      Staging: sep: Implement some proper open/close methods
      Staging: sep: kick out various fields we can prove are not needed
      Staging: sep: flow ioctl cleanup
      Staging: sep: clean up command sending
      Staging: sep: clean up time
      Staging: sep: untangle the register_fs code
      Staging: sep: use ioremap helpers
      Staging: iio: Fix type warnings
      Staging: altpciechdma: 64bit type warning fix
      Staging: pohmelfs: fix atomic type spew
      Staging: pohmelfs: fix type errors
      Staging: et1310: kill pAdapter in favour of a sane name
      Staging: et131x: spinlocks
      Staging: et131x: power state
      Staging: et131x: kill unused RCV_REF macros
      Staging et131x: kill refcount
      Staging: et131x: MPSend macros
      Staging: et131x: kill copied PCI fields
      Staging: et131x: Take a kref for the PCI pointer we cache
      Staging: et131x: CSRAddress to regs
      Staging: et131x: Eliminate RegistryDMA Cache
      Staging: et131x: eliminate write only registry fields
      Staging: et131x: clean up constant rx/tx registry fields
      Staging: et131x: attack the config stuff
      Staging: et131x: config is already zeroed
      Staging: et131x: fold the diet config into the other code
      Staging: et131x: de-hungarianise a bit
      Staging: et131x: continue pruning unused fields
      Staging: et131x: remove unused PCI identifiers
      Staging: et131x: eeprom remove features
      Staging: et131x: sort out the mmc enable routine
      Staging: et131x: clean up MMC_SRAM_
      Staging: et131x: quick tidy of the debug code
      Staging: et131x: kill the Q_ADDR struct
      Staging: et131x: clean up PM_CSR_t
      Staging: et131x: clean up DMA10/DMA4 types
      Staging: et131x: clean up MP_FLAG macros
      Staging: et131x: kill the interrupt magic define and types
      Staging: et131x: put the jagcore routines in with their users
      Staging: et131x: kill MSI type
      Staging: et131x: kill the loopback type
      Staging: et131x: prune all the debug code
      Staging: et131x: re-order the initpci code to match usual Linux style
      Staging: et131x: kill off the TXDMA error type
      Staging: et131x: kill off the TXDMA CSR type

Alexander Beregalov (12):
      Staging: vt6655: fix build when !CONFIG_WIRELESS_EXT
      Staging: vt6655: remove dependency on WIRELESS_EXT version
      Staging: otus: remove dependency on WIRELESS_EXT version
      Staging: vt6656: remove dependency on kernel version
      Staging: vt6656: remove dependency on WIRELESS_EXT version
      Staging: vt665x: depend on WIRELESS_EXT
      Staging: at76_usb: fix !CONFIG_WIRELESS_EXT build
      Staging: at76_usb: replace mac2str() with %pM
      Staging: wlan-ng: remove dependency on WIRELESS_EXT version
      Staging: rt2860: remove dependency on WIRELESS_EXT version
      Staging: agnx: remove flush_workqueue()
      Staging: vt665x: fix built-in compiling

Arve Hjønnevåg (2):
      Staging: HTC Dream: touchscreen driver for staging
      Staging: dream: add support for input on GPIO pins

Axel K (6):
      Staging: rt3090: add device id 1462:891a
      Staging: rt2860: add new device ids
      Staging: rt2860/rt2870/rt3070/rt3090: fix compiler warning on x86_64
      Staging: rt3090: remove possible conflict with rt2860
      Staging: rt3090: rename device from raX to wlanX
      Staging: rt3090: port changes in WPA_MIX_PAIR_CIPHER to rt3090

Bartlomiej Zolnierkiewicz (140):
      Staging: rt28[67]0: remove unused md4.h
      Staging: rtl8187se/ieee80211: remove unused files
      Staging: rtl8192su/ieee80211: remove unused files
      Staging: rtl8187se: remove duplicate dot11d.h and ieee80211.h includes
      Staging: rtl8192su: remove duplicate dot11d.h and ieee80211.h includes
      Staging: rtl8187se: remove unused ieee80211_crypt.h
      Staging: rtl8192su: remove unused ieee80211_crypt.h
      Staging: rtl8187se: remove kernel version compatibility wrappers
      Staging: rtl8187se: remove support for older wireless extensions
      Staging: rtl8187se/ieee80211: remove dead _RTL8187_EXT_PATCH_ code
      Staging: rtl8187se/ieee80211: remove superfluous ieee80211_* defines
      Staging: rtl8187se/ieee80211: remove unused dump_chnl_map()
      Staging: rtl8187se/ieee80211: remove superfluous JOHN_* ifdefs
      Staging: rtl8192su: remove kernel version compatibility wrappers
      Staging: rtl8192su: remove support for older wireless extensions
      Staging: rtl8192su/ieee80211: remove unused _ReasonCode enums
      Staging: rtl8192su/ieee80211: switch to use <linux/ieee80211.h>
      Staging: rtl8192su: add TODO
      Staging: rtl8187se: add TODO
      Staging: rtl8187se: remove ENABLE_DOT11D ifdefs
      Staging: rtl8187se: remove CONFIG_RTL8180_PM ifdefs
      Staging: rtl8187se: remove THOMAS_TURBO ifdefs
      Staging: rtl8187se: remove CONFIG_RTL818x_S ifdefs
      Staging: rtl8187se: remove CONFIG_RTL8185B ifdefs
      Staging: rtl8187se: remove CONFIG_RTL8180_IO_MAP ifdefs
      Staging: rtl8187se: remove dead code
      Staging: rtl8187se: remove unused radio frontends
      Staging: rtl8187se: remove debugging code from r8180_core.c
      Staging: rtl8187se: remove unused rtl8225_rf_* functions
      Staging: rtl8187se: cleanup r8180_rtl8225.c
      Staging: rtl8187se: merge r8180_rtl8225.c with r8180_rtl8225z2.c
      Staging: rtl8187se: cleanup r8180_pm.c
      Staging: rtl8187se: merge r8180_pm.c with r8180_core.c
      Staging: rtl8187se: remove unused definitions from r8180_hw.h
      Staging: rtl8187se: remove unused definitions from r8180.h
      Staging: rtl8187se: cleanup r8180_rtl8225z2.c
      Staging: rtl8187se: cleanup r8180_core.c
      Staging: add rt3090 wireless driver
      Staging: rtl8192su: remove ENABLE_DOT11D ifdefs
      Staging: rtl8192su: remove CONFIG_RTL8192_PM ifdefs
      Staging: rtl8192su: remove THOMAS_TURBO ifdefs
      Staging: rtl8192su: remove USE_ONE_PIPE ifdefs
      Staging: rtl8192su: remove EEPROM_OLD_FORMAT_SUPPORT ifdefs
      Staging: rtl8192su: remove USB_RX_AGGREGATION_SUPPORT ifdefs
      Staging: rtl8192su: remove USB_TX_DRIVER_AGGREGATION_ENABLE ifdefs
      Staging: rtl8192su: remove RTL8192SU_DISABLE_CCK_RATE ifdefs
      Staging: rtl8192su: remove RTL8192S_DISABLE_FW_DM ifdefs
      Staging: rtl8192su: remove DISABLE_BB_RF ifdefs
      Staging: rtl8192su: remove RTL8192SU_USE_PARAM_TXPWR ifdefs
      Staging: rtl8192su: remove RTL8192SU_FPGA_UNSPECIFIED_NETWORK ifdefs
      Staging: rtl8192su: remove RTL8192SU_FPGA_2MAC_VERIFICATION ifdefs
      Staging: rtl8192su: remove RTL8192SU_ASIC_VERIFICATION ifdefs
      Staging: rtl8192su: remove RTL8192SU_USB_PHY_TEST ifdefs
      Staging: rtl8192su: remove RTL8190_Download_Firmware_From_Header ifdefs
      Staging: rtl8192su: remove RTL8192S_PREPARE_FOR_NORMAL_RELEASE ifdefs
      Staging: rtl8192su: remove RTL8192SU_DISABLE_IQK ifdefs
      Staging: rtl8192su: remove RTL8192SE ifdefs
      Staging: rtl8192su: remove RTL8192SU ifdefs
      Staging: rtl8192su: remove unused files
      Staging: rtl8192su: remove dead code
      Staging: vt6655: remove PRIVATE_OBJ ifdefs
      Staging: vt6655: remove unused Makefile.{arm,x86} files
      Staging: rtl8187se/ieee80211: remove OPENSUSE_SLED ifdefs
      Staging: rtl8187se/ieee80211: remove FEDORACORE_9 ifdef
      Staging: rtl8187se/ieee80211: remove NOT_YET ifdefs
      Staging: rtl8187se: remove ENABLE_IPS ifdefs
      Staging: rtl8187se: rename struct ieee80211_hdr to struct ieee80211_hdr_4addr
      Staging: rtl8187se: rename struct ieee80211_hdr_3addr_qos to struct ieee80211_hdr_3addrqos
      Staging: rtl8187se: rename struct ieee80211_hdr_QOS to struct ieee80211_hdr_4addrqos
      Staging: rtl8187se/ieee80211: switch to use <linux/ieee80211.h>
      Staging: rtl8187se/ieee80211: ieee80211.h reorderings
      Staging: rtl8187se/ieee80211: convert MMIE_TYPE_* defines to enums
      Staging: rtl8192su: remove more unused files
      Staging: rtl8192su: make private ieee80211 stack really private
      Staging: rtl8192su: remove JOHN_DUMP[_TXDESC] ifdefs
      Staging: rtl8192su/ieee80211: remove OPENSUSE_SLED ifdefs
      Staging: rtl8192su/ieee80211: remove superfluous container_of definition
      Staging: rtl8192su: remove NOT_YET ifdefs
      Staging: rtl8192su/ieee80211: remove unused IEEE80211_PRINT_STR()
      Staging: rtl8192su/ieee80211: remove unused ieee80211_wx_get_encode_ext()
      Staging: rtl8192su/ieee80211: ieee80211.h cleanups
      Staging: rtl8192su/ieee80211: move rtl8192su specific code out from ieee80211.h
      Staging: vt6655: add TODO
      Staging: vt6656: add TODO
      Staging: rt2870: duplicated code is executed twice in AsicEvaluateRxAnt()
      Staging: rt3070: fix build warnings
      Staging: rtxxx0: remove support for older wireless extensions
      Staging: rtxxx0: remove dead platform specific code
      Staging: rtxxx0: kill RT8270_USB_DEVICES() macro
      Staging: rtxxx0: PID checking fixes
      Staging: rt3070: kill TimerQThr thread first in RT28xxThreadTerminate()
      Staging: rtxxx0: kill PID macros
      Staging: rtxxx0: remove unused defines
      Staging: rtxxx0: unify different RT30xx{Read,Write}RFRegister() flavors
      Staging: rtxxx0: remove superfluous RT30xx ifdefs
      Staging: rtxxx0: unify RT{USB,MP}FilterCalibration()
      Staging: rtxxx0: unify MlmeCheckPsmChange()
      Staging: rtxxx0: unify AsicEvaluateRxAnt()
      Staging: rtxxx0: remove dead DBG_DIAGNOSE code
      Staging: rtxxx0: remove dead virtual adapter support
      Staging: rtxxx0: debug messages fixes
      Staging: rtxxx0: remove unused link_list.h
      Staging: rtxxx0: remove superfluous function prototypes
      Staging: rtxxx0: remove private debugging ioctls
      Staging: rtxxx0: remove private ioctls
      Staging: rtxxx0: remove unused code
      Staging: rtxxxx: unify AsicRxAntEvalTimeout()
      Staging: rtxxxx: unify AsicSwitchChannel()
      Staging: rtxx70: unify NICInitRT30xxRFRegisters()
      Staging: rtxxxx: RTMPGetRalinkAuthModeStr() fixes
      Staging: rt3070: update allowed channels list for Japan
      Staging: rt3070: fix PID checking in RTUSBEnqueueCmdFromNdis()
      Staging: rt3070: WEP fixes
      Staging: rt3070: AsicSetSlotTime() fix
      Staging: rt3070: remove needless EFUSE_TAG register read
      Staging: rt3070: add remaining rt2870 device ids
      Staging: rt2870: use internal command for AsicUpdateProtect()
      Staging: rt2870: add fRTUSB_BULK_OUT_DATA_NORMAL_5 quirk
      Staging: rt28x0: add SIOCGIWNAME support to rt_ioctl_giwscan()
      Staging: rt28x0: fix GTK length check in ParseKeyData()
      Staging: rt28x0: fix BPP_R66 register handling
      Staging: rt28x0: fix fOP_STATUS_DOZE flag handling
      Staging: rt28x0 fix BACapability policy handling
      Staging: rt28x0: AsicSwitchChannel() fix
      Staging: rt28x0: BssTableSetEntry() fix
      Staging: rt28x0: MlmeSelectTxRateTable() fix
      Staging: rt28x0: MlmeCheckPsmChange() fix
      Staging: rt28x0: MlmeAssocReqAction() fixes for wpa_supplicant support
      Staging: rt28x0: rt_ioctl_siwencode() fixes
      Staging: rt28x0: LinkUp() fixes
      Staging: rt3070: remove unused MiniportDataMMRequest()
      Staging: rt3070: remove unused RT_CMD_SET_* internal commands
      Staging: rt2870: remove SHOW_ADHOC_ENTRY_INFO support
      Staging: rtxxxx: remove unused AsicAntenna{Select,Setting}()
      Staging: rt2870: add eFuse support
      Staging: rt2870: add Antenna Diversity support
      Staging: rtxx70: merge rt3070 with rt2870
      Staging: rt2870: remove old firmware
      Staging: remove no longer needed rt3070 driver
      Staging: rt3090: enable NATIVE_WPA_SUPPLICANT_SUPPORT option

Ben Hutchings (1):
      Staging: rt{2860,2870,3070}sta: Remove unused CRC code

Bill Pemberton (39):
      Staging: hv: Use %ld instead of %d for a long ints
      Staging: hv: Remove C99 comments
      Staging: hv: StorVsc.c: fix print formatting
      Staging: hv: blkvsc_drv.c: fix print formatting
      Staging: hv: fix blkvsc_open() parameters
      Staging: hv: fix blkvsc_release() parameters
      Staging: hv: fix blkvsc_ioctl() parameters
      Staging: hv: Remove X2V_LINUX check
      Staging: hv: NetVsc.c: fix print formatting
      Staging: hv: RndisFilter.c: fix print formatting
      Staging: hv: storvsc_drv.c: fix print formatting
      Staging: hv: vmbus_drv.c: fix print formatting
      Staging: hv: check return value of bus_register()
      Staging: hv: check return value of device_register()
      Staging: hv: vmbus_drv.c: remove unused structs
      Staging: hv: Hv.c: remove unused physAddr
      Staging: hv: remove VMBUS_CHANNEL_PACKET_PAGE_BUFFER typedef
      Staging: hv: remove VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER typedef
      Staging: hv: remove VMBUS_CONNECT_STATE typedef
      Staging: hv: remove VMBUS_CONNECTION typedef
      Staging: hv: remove VMBUS_MSGINFO typedef
      Staging: hv: remove NETVSC_DEVICE typedef
      Staging: hv: Remove WORKQUEUE typedef
      Staging: hv: check return value of driver_for_each_device()
      Staging: hv: comment out blkdev variable in blkvsc_ioctl
      Staging: hv: remove WAITEVENT typedef
      Staging: hv remove TIMER typedef
      Staging: hv: remove HANDLE typedef
      Staging: hv: rework use of workqueues in osd
      Staging: hv: remove WaitEventClose()
      Staging: hv: remove wrapper functions for bit operations
      Staging: hv: remove wrapper functions for atomic operations
      Staging: hv: remove wrapper function VirtualFree
      Staging: hv: remove wrapper functions around kmap_
      Staging: hv: remove use of internal list routines in NetVsc
      Staging: hv: remove more usages of internal list routines
      Staging: hv: remove use of internal list routines in RndisFilter
      Staging: hv: Remove List.h
      Staging: serqt_usb2: fix qt_open parameters

Brian G. Merrell (1):
      Staging: USB-IP code cleanup

Brian Swetland (3):
      Staging: HTC Dream: add smd code
      Staging: HTC Dream: add rpcrouter driver
      Staging: HTC Dream: add camera support

Daniel Walker (9):
      staging: android: binder: move debugging mask into a macro
      staging: android: binder: remove a predefine
      staging: android: binder: add enum usage in function arguments
      staging: android: binder: global variable cleanup.
      staging: android: binder: clean up for all the stat statments
      Staging: android: binder: cleanup some long lines
      Staging: android: lowmemorykiller: remove a predefine
      Staging: android: lowmemorykiller: delete the decription file
      Staging: android: binder: partial checkpatch cleanup

Daniele Napolitano (1):
      Staging: rt2870: new USB ID for Belkin N+ F5D8055

David Rowe (1):
      Staging: echo: top bit patch

Emilio G. Cota (1):
      Staging: vme: fix {master,slave}_get check bug

Evgeniy Polyakov (1):
      Staging: pohmelfs: sync with the development tree

Felipe Balbi (4):
      Staging: cpc-usb: convert comment style in cpc.h
      Staging: cpc-usb: convert comment style in cpc_int.h
      Staging: cpc-usb: convert comment style in cpcusb.h
      Staging: cpc-usb: add one todo entry

Figo.zhang (1):
      Staging: comedi: no need for checking vfree call

Forest Bond (8):
      Staging: Add pristine upstream vt6656 driver sources to drivers/staging/vt6656.
      Staging: vt6656: Add includes to drivers/staging/vt6656.
      Staging: vt6656: Build vt6656.ko, not vntwusb.ko.
      Staging: vt6656: main_usb.c: Drop obsolete fsuid/fsgid accesses.
      Staging: vt6656: Replace net_device->priv accesses with netdev_priv calls.
      Staging: vt6656: use net_device_ops for management functions
      Staging: vt6656: replace call to info with printk call.
      Staging: vt6656: Integrate vt6656 into build system.

Frederik Deweerdt (2):
      Staging: line6: pod.c: style cleanups
      Staging: line6: ffzb returns an unsigned integer

Greg Kroah-Hartman (189):
      Staging: hv: add a TODO file
      Staging: hv: make the Hyper-V virtual bus code build
      Staging: hv: use the correct #ifdef for x86-64
      Staging: hv: add the Hyper-V virtual bus to the build
      Staging: hv: make the Hyper-V virtual storage driver build
      Staging: hv: add the Hyper-V virtual scsi driver to the build
      Staging: hv: storvsc: fix up driver_data usage
      Staging: hv: make the Hyper-V virtual block driver build
      Staging: hv: add the Hyper-V virtual block driver to the build
      Staging: hv: blkvsc: fix up driver_data usage
      Staging: hv: make the Hyper-V virtual network driver build
      Staging: hv: add the Hyper-V virtual network driver to the build
      Staging: hv: netvsc: fix up driver_data usage
      Staging: hv: remove INTERNAL typedef
      Staging: hv: remove PVOID typedef
      Staging: hv: remove VOID typedef
      Staging: hv: remove UINT8 and INT8 typedefs
      Staging: hv: remove UINT16 and INT16 typedefs
      Staging: hv: remove UINT32 and INT32 typedefs
      Staging: hv: remove UINT64 and INT64 and UCHAR typedefs
      Staging: hv: remove USHORT typedef
      Staging: hv: remove ULONGLONG and LONGLONG typedefs
      Staging: hv: remove ULONG_PTR typedef
      Staging: hv: remove ULONG and LONG typedefs
      Staging: hv: remove SIZE_T typedef
      Staging: hv: remove DWORD and BYTE typedefs
      Staging: hv: remove BOOL and BOOLEAN typedefs
      Staging: hv: remove #defines from osd.c
      Staging: hv: remove MIN and MAX usages
      Staging: hv: remove PAGE_SIZE and PAGE_SHIFT and __builtin functions
      Staging: hv: remove STRUCT_PACKED and STRUCT_ALIGNED defines
      Staging: hv: remove UNUSED_VAR usage
      Staging: hv: remove FIELD_OFFSET usage
      Staging: hv: remove TRUE, FALSE, and NULL usage
      Staging: hv: osd: remove MemAlloc wrapper
      Staging: hv: osd: remove MemAllocZeroed wrapper
      Staging: hv: osd: remove MemAllocAtomic wrapper
      Staging: hv: osd: remove MemFree wrapper
      Staging: hv: make Channel->InboundLock a real spinlock
      Staging: hv: make RingInfo->RingLock a real spinlock
      Staging: hv: make Device->RequestLock a real spinlock
      Staging: hv: make netDevice->ReceivePacketListLock a real spinlock
      Staging: hv: make gVmbusConnection.ChannelMsgLock a real spinlock
      Staging: hv: make gVmbusConnection.ChannelLock a real spinlock
      Staging: hv: osd: remove spinlock wrapper functions
      Staging: hv: osd: remove Sleep wrapper
      Staging: hv: osd: remove MemoryFence wrapper
      Staging: hv: osd: remove LogMsg wrapper
      Staging: hv: osd: remove PrintBytes wrapper
      Staging: hv: fix up printk warnings
      Staging: hv: osd: remove GetTickCount and GetTimestamp wrappers
      Staging: hv: force hyper-v drivers to be built as a module
      Staging: hv: remove more printk() warnings
      Staging: hv: properly fix the printk() warnings
      Staging: hv: fix sparse static warnings
      Staging: hv: fix sparse function warnings
      Staging: hv: fix sparse NULL pointer warnings
      Staging: hv: remove custom cpuid function
      Staging: hv: remove custom rdmsrl and wrmsrl functions
      Staging: hv: osd: remove physical address wrapper functions
      Staging: hv: osd: add osd_ prefix to global functions
      Staging: hv: remove timer wrapper functions
      Staging: hv: remove duplicated osd.o inclusions
      Staging: hv: remove ReadMsr and WriteMsr functions from Hv.h
      Staging: hv: cleanup coding style issues in Hv.h
      Staging: hv: cleanup coding style issues in Channel.h
      Staging: hv: cleanup coding style issues in VersionInfo.h
      Staging: hv: cleanup coding style issues in ChannelInterface.h
      Staging: hv: cleanup coding style issues in ChannelMgmt.h
      Staging: hv: cleanup coding style issues in VmbusPrivate.h
      Staging: hv: cleanup coding style issues in RingBuffer.h
      Staging: hv: remove Sources.c
      Staging: hv: clean up NetVsc.h
      Staging: hv: clean up RndisFilter.h
      Staging: hv: clean up typedefs in Hv.h
      Staging: hv: clean up typedefs in ChannelMgmt.h
      Staging: hv: clean up vstorage.h
      Staging: hv: move osd.h
      Staging: hv: osd.h: codingstyle cleanups
      Staging: hv: osd.h: remove GUID typedef
      Staging: hv: osd.h: fix GUID reference problem
      Staging: hv: osd.c: coding style fixes
      Staging: hv: remove include/HvTypes.h
      Staging: hv: remove include/HvHalApi.h
      Staging: hv: coding style cleanup of include/HvHcApi.h
      Staging: hv: coding style cleanup of include/HvVpApi.h
      Staging: hv: move vmbus.h
      Staging: hv: vmbus.h coding style cleanups
      Staging: hv: move rndis.h
      Staging: hv: rndis.h: remove pointless typedefs
      Staging: hv: rndis.h: codingstyle fixes
      Staging: hv: rndis.h: typedef removal, part 1
      Staging: hv: rndis.h: typedef removal, part 2
      Staging: hv: coding style cleanups for HvPtApi.h
      Staging: hv: coding style cleanups for HvSynicApi.h
      Staging: hv: typdef fixes for HvSynicApi.h
      Staging: hv: remove volatile usage from HvSynicApi.h
      Staging: hv: create hv_api.h
      Staging: hv: coding style cleanups for HvStatus.h
      Staging: hv: move HvStatus.h into hv_api.h
      Staging: hv: coding style cleanups for VmbusChannelInterface.h
      Staging: hv: typedef removal from VmbusChannelInterface.h
      Staging: hv: coding style cleanups for VmbusApi.h
      Staging: hv: typedef removal for VmbusApi.h
      Staging: hv: codingsyle cleanups for ChannelMessages.h
      Staging: hv: typedef removal for ChannelMessages.h
      Staging: hv: fix up some coding style issues in logging.h
      Staging: hv: fix up coding style issues in NetVscApi.h
      Staging: hv: fix up typedefs in NetVscApi.h
      Staging: hv: move vstorage.h to hv dir
      Staging: hv: fix remaining style issue in ChannelInterface.h
      Staging: hv: fix typedefs in vstorage.h
      Staging: hv: fix coding style issues in VmbusPacketFormat.h
      Staging: hv: remove typedefs from VmbusPacketFormat.h
      Staging: hv: fix coding style issues in StorVscApi.h
      Staging: hv: fix typedefs in StorVscApi.h
      Staging: hv: fix coding style issues in nvspprotocol.h
      Staging: hv: fix typedefs in nvspprotocol.h
      Staging: hv: move nvspprotocol.h
      Staging: hv: remove ChannelMessages.h
      Staging: hv: move List.h
      Staging: hv: move logging.h
      Staging: hv: move NetVscApi.h
      Staging: hv: move StorVscApi.h
      Staging: hv: move VmbusApi.h
      Staging: hv: move VmbusChannelInterface.h
      Staging: hv: move VmbusPacketFormat.h
      Staging: hv: coding style cleanups of BlkVsc.c
      Staging: hv: coding style cleanups of ChannelInterface.c
      Staging: hv: remove typedefs from ChannelMgmt.c
      Staging: hv: remove typedefs from RndisFilter.c
      Staging: hv: remove typedefs from StorVsc.c
      Staging: hv: coding style cleanups for Connection.c
      Staging: hv: coding style cleanups on Vmbus.c
      Staging: hv: code reduction from Vmbus.c
      Staging: hv: fix coding style issues in Hv.c
      Staging: hv: coding style cleanups for netvsc_drv.c
      Staging: hv: reorganize netvsc_drv.c
      Staging: hv: coding style cleanups for ChannelMgmt.c
      Staging: hv: reorg ChannelMgmt a bit
      Staging: hv: TODO: add some more items
      Staging: hv: coding style cleanups for StorVsc.c
      Staging: hv: reorg StorVsc.c
      Staging: hv: coding style fixes for blkvsc_drv.c
      Staging: hv: coding style cleanup for Channel.c
      Staging: hv: warn the world of a bug in the release function
      Staging: hv: coding style cleanups for vmbus_drv.c
      Staging: hv: coding style cleanup for storvsc_drv.c
      Staging: hv: coding style cleanup for RndisFilter.c
      Staging: hv: coding style cleanup for NetVsc.c
      Staging: hv: rename struct NETVSC_DEVICE
      Staging: hv: remove function pointer typedefs from VmbusApi.h
      Staging: hv: remove function pointer typedefs from NetVscApi.h
      Staging: hv: remove function pointer typedefs from StorVscApi.h
      Staging: hv: remove PFN_CHANNEL_CALLBACK
      Staging: hv: remove function pointer typedefs from vmbus.h
      Staging: hv: update the TODO file
      Staging: vme: change to VME_BUS
      Staging: remove epl driver
      Staging: pata_rdc: remove the driver from the staging tree
      Staging: echo: fix up remaining checkpatch.pl issues
      Staging: echo: remove TODO item
      Staging: echo: remove bit_operations.h
      Staging: echo: remove unneeded USE_MMX defines
      Staging: echo: remove unneeded USE_SSE2 defines
      Staging: echo: coding style cleanups
      Staging: add Realtek 8192 PCI wireless driver
      Staging: rtl8192e: fix lots of sparse warnings
      Staging: rtl8192e: remove unused functions
      Staging: rtl8192e: remove #if 0 sections
      Staging: rtl8192e: remove kernel version checks
      Staging: rtl8192e: remove firmware header file not being used
      Staging: rtl8192e: remove another firmware header file not being used
      Staging: rtl8192e: coding style cleanups on r819xE_firmware.c
      Staging: rtl8192e: remove unneeded ieee80211 files
      Staging: rtl8192e: remove annoying printk()
      Staging: rtl8192e: fix for stack bug
      Staging: rtl8192e: fix timeouts on firmware download
      Staging: get cowloop to build properly
      Staging: cowloop: add TODO file
      Staging: add cowloop to the build
      Staging: cowloop: remove kernel version checks
      Staging: vt665x: rename the module binary
      Staging: remove me4000 driver.
      Staging: meilhaus: remove the drivers
      Staging: rspiusb: remove the driver
      Staging: remove at76_usb wireless driver.
      Staging: remove heci driver
      Staging: remove sxg driver

H.J. Thomassen (1):
      Staging: add cowloop driver

Haiyang Zhang (1):
      Staging: hv: Add Haiyang's email to the TODO file

Hank Janssen (6):
      Staging: hv: add the Hyper-V api header files
      Staging: hv: add the Hyper-V driver header files
      Staging: hv: add the Hyper-V virtual bus
      Staging: hv: add the Hyper-V virtual block driver
      Staging: hv: add the Hyper-V virtual network driver
      Staging: hv: add the Hyper-V virtual storage driver

Huang Weiyi (1):
      Staging: cpc-usb: remove unused #include <linux/version.h>

Iliyan Malchev (1):
      Staging: HTC Dream: add qdsp support

Jan Beulich (1):
      Staging: hv: adjust Hyper-V Kconfig

Jaswinder Singh Rajput (2):
      Staging: otus: includecheck fix: drivers/staging/otus/usbdrv.h
      Staging: rt2860: includecheck fix: rt_linux.h

Jeff Mahoney (6):
      Staging: rtl8192su: compile fixes
      Staging: rtl8192su: fix up printk warnings
      Staging: rtl8192su: fixup size comparison warning
      Staging: rtl8192su: stop using skb->tail
      Staging: rtl8192su: add linux/vmalloc.h
      Staging: rtl8192e: compile fixes

Jim Lieb (16):
      Staging: vt665x: 64bit compile fixes Part 1
      Staging: vt665x: 64bit compile fixes Part 2
      Staging: vt6655 textual cleanup in prep for driver merge
      Staging: vt665x: Text janitor in prep for driver merge
      Staging: vt665x: Text janitor in prep for driver merge, part 2
      Staging: vt665x: Typedef and macro cleanup Part 1
      Staging: vt665x: Typedef and macro cleanup Part 2
      Staging: vt665x: Clean up include files, Part 1
      Staging: vt665x: Clean up include files, Part 2
      Staging: vt665x: Remove umem.h Part 1
      Staging: vt665x: Remove umem.h Part 2
      Staging: vt665x: remove tpci.h file
      Staging: vt665x: remove tpci.h file in vt6656
      Staging: vt665x: cleanup USB definitions
      Staging: vt665x: remove tbit.h
      Staging: vt665x: remove tbit.h part 2

Jiri Slaby (1):
      Staging: dream, fix buf overflow

Jonathan Cameron (15):
      Staging: IIO: core support for device registration and management
      Staging: IIO: max1363 ADC driver
      Staging: IIO: tsl2561 digital light sensor core support
      Staging: IIO: lis3l02dq accelerometer core support
      Staging: IIO: kxsd9 accelerometer minimal support
      Staging: IIO: Add generic ring buffer support to the IIO core
      Staging: IIO: VTI sca3000 series accelerometer driver (spi)
      Staging: IIO: Trigger support added to core.
      Staging: IIO: Ring buffer: Initial pass at rarely locked ring buffer
      Staging: IIO: lis3l02dq ring buffer and data ready trigger support
      Staging: IIO: max1363 add software ring buffer support using ring_sw
      Staging: IIO: Periodic timer based trigger
      Staging: IIO: Proof of concept gpio trigger
      Staging: IIO: Initial documentation
      Staging: IIO: Add todo list for staging

Julia Lawall (9):
      Staging: otus: Drop an unnecessary NULL test
      Staging: b3dfg: Drop NULL test on list_entry result
      Staging: meilhaus: convert nested spin_lock_irqsave to spin_lock
      Staging: Correct use of ! and &
      Staging: dst: correct error-handling code
      staging: Make some structures static
      Staging: rtl8192e: Drop unnecessary NULL test
      Staging: dream: introduce missing kfree
      Staging: iio: introduce missing kfree

Kamalesh Babulal (1):
      Staging: sep: SEP driver build breaks with CONFIG_PCI=n

Karl Relton (1):
      Staging: wlan-ng: Convert firmware loading to load binary ihex format

Kevin A. Granade (1):
      Staging: asus_oled: Cleaned up checkpatch issues.

Marcin Slusarz (3):
      Staging: rt3070: add support for Linksys WUSB54GC-EU v3
      Staging: rt*: fix wait_queue_head_t declaration on stack
      Staging: rt*: don't confuse user of rt3070 driver with rt2870 strings

Mark Allyn (1):
      Staging: sep: Upstream revision 3 of the security processor kernel driver

Martyn Welch (13):
      Staging: VME Framework for the Linux Kernel
      Staging: vme: add VME userspace driver
      Staging: vme: add Universe I/II bridge driver
      Staging: vme: add Tundra TSI148 VME-PCI Bridge driver
      Staging: vme: add TODO file
      Staging: vme: Correct tsi-148 VME interrupt free routine
      Staging: vme: Extend VME core probing for special matches
      Staging: vme: Add syncronize interrupts before removing callback
      Staging: Update VME vme_user module
      Staging: Use proper mutexes in the tsi-148 VME driver
      Staging: vme: add VME Location Monitor management mechanism
      Staging: vme: Update support for the Universe II VME driver
      Staging: vme: Separate the list of TODOs from the API documentation

Michael Buesch (1):
      Staging: rtl8187se: Fix comment-out-typo

Mike Galbraith (1):
      Staging: rt2870sta interface names

Mithlesh Thukral (2):
      staging: wlan-ng: scripts/checkpatch.pl error fixes.
      Staging: Comedi: Lindent changes to comdi driver in staging tree

Moritz Muehlenhoff (5):
      Staging: wlan-ng: Remove some superflous comments
      Staging: wlan-ng: Use kzfree() to securely zero-out the WEP key when freeing it
      Staging: wlan-ng: Drop the special case handling of older wireless extensions, WIRELESS_EXT is at 22 for the current kernel.
      Staging: wlan-ng: Remove more superflous comments
      Staging: hv: Remove compatibility ifdefry

Nicolas Palix (6):
      Staging: hv: Transform some kzalloc calls to kcalloc
      Staging: hv: Transform PDEVICE_OBJECT and DEVICE_OBJECT typedefs into their corresponding structs
      Staging: hv: Remove typedef DRIVER_OBJECT and PDRIVER_OBJECT
      Staging: hv: Remove typedef NETVSC_PACKET and PNETVSC_PACKET
      Staging: hv: Remove typedef STORVSC_REQUEST and PSTORVSC_REQUEST
      Staging: hv: Replace typedef SG_BUFFER_LIST by struct scatterlist

Pavel Machek (7):
      Staging: HTC Dream: Makefile glue
      Staging: htc: Dream: limit Kconfig for only MSM platforms
      Staging: HTC Dream: Cleanup Dream touchscreen driver
      Staging: HTC Dream: touchscreen: more cleanups
      Staging: dream: synaptics touchscreen for dream: documentation
      Staging: Dream: separate Kconfig/Makefile into subdirectory
      Staging: dream: Synaptics touchscreen: check that smbus is available

Pekka Enberg (7):
      Staging: w35und: Convert MDS typedef to struct w35_mds
      Staging: w35und: Remove unused struct _RXBUFFER
      Staging: w35und: Cleanup the mlmetxrx_f.h header file
      Staging: w35und: Convert typedef DESCRIPTOR to struct wb35_descriptor
      Staging: w35und: Remove unused struct _STATISTICS_INFO
      Staging: w35und: Convert typedef MTO_PARAMETERS to struct wb35_mto_param
      Staging: w35und: Remove some write-only struct members

Pranith Kumar (1):
      Staging: otus: Fix warnings in staging/otus/ioctl.c

Randy Dunlap (4):
      Staging: android: lowmemorykiller: fix module param errors
      Staging: hv: blk dev depends on SCSI
      Staging: udlfb: fix printk format warning
      Staging: iio: fix duplicate dev_attr_name

Richard Ash (10):
      Staging: add Support for Quatech ESU2-100 USB 2.0 8-port serial adaptor
      Staging: quatech_usb2: implement open functionality
      Staging: quatech_usb2: close, read, and some ioctl support
      Staging: quatech_usb2: write_room rewrite
      Staging: quatech_usb2: TIOCMGET and TIOCMSET removal
      Staging: quatech_usb2: chars_in_buffer() fix
      Staging: quatech_usb2: vendor implementation of set_termios method
      Staging: quatech_usb2: vendor implementation of break_ctl
      Staging: quatech_usb2: Improve debug output and fix write_room
      Staging: quatech_usb2: Improvements to set_termios method

Robert P. J. Day (2):
      Staging: comedi: Remove references to dead EXPORT_SYMTAB
      Staging: vt6655: Remove Makefile refs to EXPORT_SYMTAB

Roel Kluin (7):
      Staging: comedi: s626: Possible read buffer overflow fix
      Staging: vt6655: fix possible Read buffer overflow
      Staging: rt2860: Fix test in rt_ioctl_siwfrag()
      Staging: rspiusb: Check usb_buffer_map_sg() retval
      Staging: comedi: apci3200: fix test of ui_DelayTime range in i_APCI3200_CommandTestAnalogInput()
      Staging: rt2860: fix possible NULL dereferences
      Staging: comedi: addi-data: NULL dereference of amcc in v_pci_card_list_init()

Shan Wei (1):
      Staging: usb-ip: vhci_hdc:Fix the returned error value

Stoyan Gaydarov (1):
      Staging: ARRAY_SIZE changes

Sudhakar Rajashekhara (1):
      Staging: panel: Add support for TI CLCD interface

Uwe Kleine-König (1):
      Staging: fix typos "man[ae]g?ment" -> "management"

miaofng (1):
      Staging: vt6656: disable wpa related function due to memory failure of this part of codes

