Return-Path: <linux-kernel-owner+w=401wt.eu-S933361AbZLKV1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbZLKV1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762663AbZLKV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:27:41 -0500
Received: from kroah.org ([198.145.64.141]:35915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759184AbZLKV13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:27:29 -0500
Date: Fri, 11 Dec 2009 13:27:04 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING patches for 2.6.33-git
Message-ID: <20091211212704.GC6624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big staging merge for the 2.6.33-git tree

Not all that radical of things here, lots of cleanups and fixes from a
lot of different people.  A few new drivers as well.  The Android code
was deleted from the tree due to it being abandonded by its developers.
The Dream code did stay, as Pavel is working hard to get that into
mergable shape.

In the end, we deleted more code than we added, for the second kernel
release in a row:
 679 files changed, 165727 insertions(+), 174515 deletions(-)

So the crap is getting smaller :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                            |   16 +-
 drivers/staging/Makefile                           |   12 +-
 drivers/staging/altpciechdma/altpciechdma.c        |    6 +-
 drivers/staging/android/Kconfig                    |   96 -
 drivers/staging/android/Makefile                   |    6 -
 drivers/staging/android/TODO                       |   10 -
 drivers/staging/android/binder.c                   | 3767 -------
 drivers/staging/android/binder.h                   |  330 -
 drivers/staging/android/logger.c                   |  607 --
 drivers/staging/android/logger.h                   |   48 -
 drivers/staging/android/lowmemorykiller.c          |  173 -
 drivers/staging/android/ram_console.c              |  410 -
 drivers/staging/android/timed_gpio.c               |  166 -
 drivers/staging/android/timed_gpio.h               |   33 -
 drivers/staging/android/timed_output.c             |  121 -
 drivers/staging/android/timed_output.h             |   37 -
 drivers/staging/b3dfg/b3dfg.c                      |   12 -
 drivers/staging/batman-adv/CHANGELOG               |   37 +
 drivers/staging/batman-adv/Kconfig                 |   25 +
 drivers/staging/batman-adv/Makefile                |   22 +
 drivers/staging/batman-adv/README                  |  125 +
 drivers/staging/batman-adv/TODO                    |   51 +
 drivers/staging/batman-adv/aggregation.c           |  232 +
 drivers/staging/batman-adv/aggregation.h           |   37 +
 drivers/staging/batman-adv/bitarray.c              |  177 +
 drivers/staging/batman-adv/bitarray.h              |   45 +
 drivers/staging/batman-adv/compat.h                |   75 +
 drivers/staging/batman-adv/device.c                |  337 +
 drivers/staging/batman-adv/device.h                |   36 +
 drivers/staging/batman-adv/hard-interface.c        |  451 +
 drivers/staging/batman-adv/hard-interface.h        |   36 +
 drivers/staging/batman-adv/hash.c                  |  313 +
 drivers/staging/batman-adv/hash.h                  |   99 +
 drivers/staging/batman-adv/log.c                   |  179 +
 drivers/staging/batman-adv/log.h                   |   32 +
 drivers/staging/batman-adv/main.c                  |  286 +
 drivers/staging/batman-adv/main.h                  |  151 +
 drivers/staging/batman-adv/packet.h                |   96 +
 drivers/staging/batman-adv/proc.c                  |  950 ++
 drivers/staging/batman-adv/proc.h                  |   49 +
 drivers/staging/batman-adv/ring_buffer.c           |   52 +
 drivers/staging/batman-adv/ring_buffer.h           |   23 +
 drivers/staging/batman-adv/routing.c               | 1010 ++
 drivers/staging/batman-adv/routing.h               |   34 +
 drivers/staging/batman-adv/send.c                  |  473 +
 drivers/staging/batman-adv/send.h                  |   36 +
 drivers/staging/batman-adv/soft-interface.c        |  349 +
 drivers/staging/batman-adv/soft-interface.h        |   33 +
 drivers/staging/batman-adv/translation-table.c     |  454 +
 drivers/staging/batman-adv/translation-table.h     |   42 +
 drivers/staging/batman-adv/types.h                 |  124 +
 drivers/staging/batman-adv/vis.c                   |  564 ++
 drivers/staging/batman-adv/vis.h                   |   63 +
 drivers/staging/comedi/comedi.h                    |    8 -
 drivers/staging/comedi/comedi_compat32.c           |  149 +-
 drivers/staging/comedi/comedi_compat32.h           |   16 +-
 drivers/staging/comedi/comedi_fops.c               |   15 -
 drivers/staging/comedi/comedidev.h                 |   60 +-
 drivers/staging/comedi/drivers.c                   |    2 +-
 drivers/staging/comedi/drivers/8253.h              |    3 +-
 drivers/staging/comedi/drivers/8255.c              |   23 +-
 drivers/staging/comedi/drivers/acl7225b.c          |    9 +-
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     |    3 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     |    6 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    7 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |   53 +-
 drivers/staging/comedi/drivers/adl_pci7296.c       |   19 +-
 drivers/staging/comedi/drivers/adl_pci7432.c       |   32 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |   37 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    4 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   18 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    6 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    2 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |    4 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |    5 +-
 drivers/staging/comedi/drivers/dmm32at.c           |    2 +-
 drivers/staging/comedi/drivers/dt2814.c            |    2 +-
 drivers/staging/comedi/drivers/dt282x.c            |    4 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |  126 +-
 drivers/staging/comedi/drivers/icp_multi.c         |  345 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   83 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   21 +-
 drivers/staging/comedi/drivers/me4000.c            |    2 +-
 drivers/staging/comedi/drivers/mite.c              |  231 +-
 drivers/staging/comedi/drivers/mite.h              |    7 -
 drivers/staging/comedi/drivers/multiq3.c           |   25 +-
 drivers/staging/comedi/drivers/ni_6527.c           |   33 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |    6 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   90 +-
 drivers/staging/comedi/drivers/ni_labpc.h          |   52 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |   13 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    2 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c         |    9 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |    2 +-
 drivers/staging/comedi/drivers/pcl711.c            |    1 +
 drivers/staging/comedi/drivers/pcl726.c            |   41 +-
 drivers/staging/comedi/drivers/pcl812.c            |    6 +-
 drivers/staging/comedi/drivers/pcl816.c            |   10 +-
 drivers/staging/comedi/drivers/pcl818.c            |   16 +-
 drivers/staging/comedi/drivers/pcm_common.c        |    4 +-
 drivers/staging/comedi/drivers/pcmmio.c            |  231 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    2 +-
 drivers/staging/comedi/drivers/rtd520.c            |    2 +-
 drivers/staging/comedi/drivers/s626.c              |    2 +-
 drivers/staging/comedi/drivers/s626.h              |    8 -
 drivers/staging/comedi/drivers/serial2002.c        |   13 +-
 drivers/staging/comedi/drivers/skel.c              |    2 +-
 drivers/staging/comedi/drivers/usbdux.c            |   21 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |   24 +-
 drivers/staging/cx25821/cx25821-core.c             |    4 +-
 drivers/staging/dream/Kconfig                      |    4 +
 drivers/staging/dream/TODO                         |   14 +
 drivers/staging/dream/camera/msm_camera.c          |    7 +-
 drivers/staging/dream/camera/msm_vfe7x.c           |    1 +
 drivers/staging/dream/generic_gpio.c               |  274 +
 drivers/staging/dream/gpio_event.c                 |    3 +-
 drivers/staging/dream/gpio_input.c                 |    7 -
 drivers/staging/dream/gpio_matrix.c                |    8 -
 drivers/staging/dream/pmem.c                       | 1335 +++
 drivers/staging/dream/qdsp5/adsp.c                 |    5 -
 drivers/staging/dream/qdsp5/audio_out.c            |    4 -
 drivers/staging/dream/smd/smd_qmi.c                |    5 -
 drivers/staging/dream/smd/smd_rpcrouter.c          |   12 -
 drivers/staging/dream/smd/smd_rpcrouter.h          |    2 -
 drivers/staging/dream/smd/smd_tty.c                |    5 -
 drivers/staging/dream/synaptics_i2c_rmi.c          |    6 +
 drivers/staging/dst/crypto.c                       |   64 +-
 drivers/staging/dst/dcore.c                        |   26 +-
 drivers/staging/dst/export.c                       |   33 +-
 drivers/staging/dst/state.c                        |   75 +-
 drivers/staging/dst/thread_pool.c                  |   39 +-
 drivers/staging/dst/trans.c                        |   18 +-
 drivers/staging/et131x/et1310_address_map.h        |  866 +--
 drivers/staging/et131x/et1310_eeprom.c             |  436 +-
 drivers/staging/et131x/et1310_eeprom.h             |   42 +-
 drivers/staging/et131x/et1310_mac.c                |  318 +-
 drivers/staging/et131x/et1310_phy.c                | 1167 +--
 drivers/staging/et131x/et1310_phy.h                |   35 +-
 drivers/staging/et131x/et1310_rx.c                 |  565 +-
 drivers/staging/et131x/et1310_rx.h                 |   52 +-
 drivers/staging/et131x/et1310_tx.c                 |  622 +-
 drivers/staging/et131x/et1310_tx.h                 |  218 +-
 drivers/staging/et131x/et131x_adapter.h            |   18 +-
 drivers/staging/et131x/et131x_defs.h               |    1 -
 drivers/staging/et131x/et131x_initpci.c            |  596 +-
 drivers/staging/et131x/et131x_initpci.h            |    2 +-
 drivers/staging/et131x/et131x_isr.c                |   33 +-
 drivers/staging/et131x/et131x_netdev.c             |   31 +-
 drivers/staging/hv/hv_api.h                        |    4 +-
 drivers/staging/iio/Documentation/device.txt       |    4 +-
 drivers/staging/iio/Documentation/overview.txt     |    9 +-
 drivers/staging/iio/Kconfig                        |   10 +-
 drivers/staging/iio/accel/Kconfig                  |    2 +
 drivers/staging/iio/accel/accel.h                  |    6 +-
 drivers/staging/iio/accel/sca3000.h                |    4 +-
 drivers/staging/iio/accel/sca3000_core.c           |    2 +-
 drivers/staging/iio/adc/Kconfig                    |   10 +
 drivers/staging/iio/adc/Makefile                   |    2 +-
 drivers/staging/iio/adc/max1363.h                  |    6 +-
 drivers/staging/iio/chrdev.h                       |    4 +-
 drivers/staging/iio/iio.h                          |   36 +-
 drivers/staging/iio/light/Kconfig                  |   18 +-
 drivers/staging/iio/light/Makefile                 |    2 +-
 drivers/staging/iio/light/tsl2561.c                |  272 -
 drivers/staging/iio/light/tsl2563.c                |  773 ++
 drivers/staging/iio/light/tsl2563.h                |    9 +
 drivers/staging/iio/ring_generic.h                 |   73 +-
 drivers/staging/iio/ring_sw.h                      |   68 +-
 drivers/staging/iio/sysfs.h                        |  114 +-
 drivers/staging/iio/trigger.h                      |   35 +-
 drivers/staging/iio/trigger/Kconfig                |    6 +-
 drivers/staging/iio/trigger_consumer.h             |    8 +-
 drivers/staging/line6/capture.c                    |   98 +-
 drivers/staging/line6/control.c                    |  493 +-
 drivers/staging/line6/driver.c                     |  103 +-
 drivers/staging/line6/midi.c                       |   16 +-
 drivers/staging/line6/pcm.c                        |    3 +-
 drivers/staging/line6/playback.c                   |  101 +-
 drivers/staging/line6/pod.c                        |   60 +-
 drivers/staging/line6/toneport.c                   |  119 +-
 drivers/staging/line6/variax.c                     |   31 +-
 drivers/staging/octeon/cvmx-pow.h                  |    2 +-
 drivers/staging/octeon/ethernet-rgmii.c            |    4 +-
 drivers/staging/octeon/ethernet-tx.c               |    2 +-
 drivers/staging/otus/80211core/ccmd.c              |    4 +-
 drivers/staging/otus/80211core/cmm.c               |    4 +-
 drivers/staging/otus/80211core/cmmsta.c            |    4 +-
 drivers/staging/otus/80211core/ctxrx.c             |    2 +-
 drivers/staging/otus/80211core/pub_zfi.h           |    2 +-
 drivers/staging/otus/apdbg.c                       |  667 +-
 drivers/staging/otus/athr_common.h                 |   10 +-
 drivers/staging/otus/oal_dt.h                      |   10 +-
 drivers/staging/otus/oal_marc.h                    |   84 +-
 drivers/staging/otus/usbdrv.c                      |   35 +-
 drivers/staging/otus/usbdrv.h                      |  140 +-
 drivers/staging/otus/wrap_buf.c                    |   20 +-
 drivers/staging/otus/wrap_dbg.c                    |   61 +-
 drivers/staging/otus/wrap_ev.c                     |  350 +-
 drivers/staging/otus/wrap_mem.c                    |   90 +-
 drivers/staging/otus/wrap_mis.c                    |   61 +-
 drivers/staging/otus/wrap_pkt.c                    |  210 +-
 drivers/staging/otus/wrap_sec.c                    |  123 +-
 drivers/staging/otus/wrap_usb.c                    |  213 +-
 drivers/staging/otus/zdusb.h                       |    4 +-
 drivers/staging/p9auth/p9auth.c                    |    3 +-
 drivers/staging/phison/phison.c                    |    4 +-
 drivers/staging/poch/README                        |  124 +-
 drivers/staging/poch/poch.c                        |  198 +-
 drivers/staging/poch/poch.h                        |   16 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    2 +-
 drivers/staging/ramzswap/Kconfig                   |   21 +
 drivers/staging/ramzswap/Makefile                  |    3 +
 drivers/staging/ramzswap/TODO                      |    6 +
 drivers/staging/ramzswap/ramzswap.txt              |   51 +
 drivers/staging/ramzswap/ramzswap_drv.c            | 1435 +++
 drivers/staging/ramzswap/ramzswap_drv.h            |  171 +
 drivers/staging/ramzswap/ramzswap_ioctl.h          |   49 +
 drivers/staging/ramzswap/xvmalloc.c                |  507 +
 drivers/staging/ramzswap/xvmalloc.h                |   30 +
 drivers/staging/ramzswap/xvmalloc_int.h            |   86 +
 drivers/staging/rar/rar_driver.c                   |    4 +-
 drivers/staging/rt2860/2860_main_dev.c             | 1319 ---
 drivers/staging/rt2860/Kconfig                     |    7 +-
 drivers/staging/rt2860/Makefile                    |   31 +-
 drivers/staging/rt2860/TODO                        |    1 -
 drivers/staging/rt2860/aironet.h                   |  210 -
 drivers/staging/rt2860/ap.h                        |   46 +-
 drivers/staging/{rt3090 => rt2860/chip}/mac_pci.h  |  301 +-
 drivers/staging/rt2860/chip/mac_usb.h              |  347 +
 .../{rt3090/netif_block.h => rt2860/chip/rt2860.h} |   42 +-
 .../{rt3090/rt33xx.h => rt2860/chip/rt2870.h}      |   30 +-
 .../{rt3090/rt3370.h => rt2860/chip/rt3070.h}      |   27 +-
 drivers/staging/{rt3090 => rt2860/chip}/rt3090.h   |   21 +-
 drivers/staging/{rt3090 => rt2860/chip}/rt30xx.h   |    9 +-
 drivers/staging/rt2860/chip/rtmp_mac.h             | 1307 +++
 drivers/staging/{rt3090 => rt2860/chip}/rtmp_phy.h |  191 +-
 drivers/staging/rt2860/chips/rt3070.c              |  169 +
 drivers/staging/{rt3090 => rt2860}/chips/rt3090.c  |   72 +-
 drivers/staging/{rt3090 => rt2860}/chips/rt30xx.c  |  429 +-
 drivers/staging/rt2860/chlist.h                    | 1250 +---
 drivers/staging/rt2860/common/2860_rtmp_init.c     |  897 --
 drivers/staging/rt2860/common/action.c             |  658 +-
 drivers/staging/rt2860/common/action.h             |   31 +-
 drivers/staging/rt2860/common/ba_action.c          | 1813 ++--
 .../staging/{rt3090 => rt2860}/common/cmm_aes.c    | 1319 +--
 drivers/staging/rt2860/common/cmm_asic.c           | 2565 +++++
 .../staging/{rt3090 => rt2860}/common/cmm_cfg.c    |  239 +-
 drivers/staging/rt2860/common/cmm_data.c           | 2881 +++----
 drivers/staging/rt2860/common/cmm_data_2860.c      | 1199 ---
 drivers/staging/rt2860/common/cmm_data_pci.c       | 1096 ++
 drivers/staging/rt2860/common/cmm_data_usb.c       |  951 ++
 drivers/staging/rt2860/common/cmm_info.c           | 3503 ++------
 drivers/staging/rt2860/common/cmm_mac_pci.c        | 1661 ++++
 drivers/staging/rt2860/common/cmm_mac_usb.c        | 1165 +++
 drivers/staging/rt2860/common/cmm_sanity.c         | 1635 ++--
 drivers/staging/rt2860/common/cmm_sync.c           |  789 +-
 drivers/staging/rt2860/common/cmm_tkip.c           |  833 ++
 .../staging/{rt3090 => rt2860}/common/cmm_wep.c    |  225 +-
 drivers/staging/rt2860/common/cmm_wpa.c            | 3120 +++++-
 drivers/staging/rt2860/common/crypt_hmac.c         |  187 +
 drivers/staging/rt2860/common/crypt_md5.c          |  339 +
 drivers/staging/rt2860/common/crypt_sha2.c         |  269 +
 drivers/staging/rt2860/common/dfs.c                |  372 +-
 drivers/staging/rt2860/common/ee_efuse.c           |  344 +
 drivers/staging/rt2860/common/ee_prom.c            |  197 +
 drivers/staging/rt2860/common/eeprom.c             | 1482 +---
 drivers/staging/rt2860/common/firmware.h           |    2 +-
 drivers/staging/rt2860/common/firmware_3070.h      |  517 +
 drivers/staging/rt2860/common/md5.c                | 1415 ---
 drivers/staging/rt2860/common/mlme.c               |10404 +++++++-------------
 drivers/staging/rt2860/common/rt_channel.c         | 1705 ++++
 drivers/staging/{rt3090 => rt2860}/common/rt_rf.c  |  103 +-
 drivers/staging/rt2860/common/rtmp_init.c          | 4299 ++++-----
 drivers/staging/rt2860/common/rtmp_mcu.c           |  291 +
 .../staging/{rt3090 => rt2860}/common/rtmp_timer.c |  163 +-
 drivers/staging/rt2860/common/rtmp_tkip.c          | 1586 ---
 drivers/staging/rt2860/common/rtmp_wep.c           |  497 -
 drivers/staging/rt2860/common/spectrum.c           | 1975 +++--
 drivers/staging/rt2860/config.mk                   |  241 -
 drivers/staging/{rt3090 => rt2860}/crypt_hmac.h    |   46 +-
 drivers/staging/{rt3090 => rt2860}/crypt_md5.h     |   51 +-
 .../{rt3090/vr_ikans.h => rt2860/crypt_sha2.h}     |   68 +-
 drivers/staging/rt2860/dfs.h                       |   51 +-
 drivers/staging/{rt3090 => rt2860}/eeprom.h        |   61 +-
 .../staging/{rt3090 => rt2860/iface}/rtmp_pci.h    |   56 +-
 drivers/staging/rt2860/iface/rtmp_usb.h            |  182 +
 drivers/staging/rt2860/md5.h                       |  107 -
 drivers/staging/rt2860/mlme.h                      | 1874 ++--
 drivers/staging/rt2860/oid.h                       | 1240 ++--
 drivers/staging/rt2860/pci_main_dev.c              | 1190 +++
 drivers/staging/rt2860/rt2860.h                    |  333 -
 drivers/staging/rt2860/rt28xx.h                    | 1688 ----
 drivers/staging/rt2860/rt_config.h                 |   29 +-
 drivers/staging/rt2860/rt_linux.c                  | 1371 ++-
 drivers/staging/rt2860/rt_linux.h                  | 1017 +-
 drivers/staging/rt2860/rt_main_dev.c               | 1006 +--
 drivers/staging/rt2860/rt_pci_rbus.c               |  840 ++
 drivers/staging/rt2860/rt_profile.c                | 1862 ----
 drivers/staging/rt2860/rt_usb.c                    |  799 ++
 drivers/staging/rt2860/rtmp.h                      | 9536 +++++++-----------
 drivers/staging/rt2860/rtmp_chip.h                 |  258 +
 drivers/staging/rt2860/rtmp_ckipmic.h              |   45 +-
 drivers/staging/rt2860/rtmp_def.h                  | 1109 +--
 drivers/staging/rt2860/rtmp_dot11.h                |  100 +
 drivers/staging/{rt3090 => rt2860}/rtmp_iface.h    |   64 +-
 drivers/staging/{rt3090 => rt2860}/rtmp_mcu.h      |   18 +-
 drivers/staging/{rt3090 => rt2860}/rtmp_os.h       |   55 +-
 drivers/staging/{rt3090 => rt2860}/rtmp_timer.h    |  107 +-
 drivers/staging/rt2860/rtmp_type.h                 |   85 +-
 drivers/staging/rt2860/rtusb_io.h                  |  185 +
 drivers/staging/rt2860/spectrum.h                  |  223 +-
 drivers/staging/rt2860/spectrum_def.h              |  189 +-
 drivers/staging/rt2860/sta/aironet.c               | 1312 ---
 drivers/staging/rt2860/sta/assoc.c                 | 2082 ++---
 drivers/staging/rt2860/sta/auth.c                  |  635 +-
 drivers/staging/rt2860/sta/auth_rsp.c              |  134 +-
 drivers/staging/rt2860/sta/connect.c               | 3220 +++---
 drivers/staging/rt2860/sta/rtmp_data.c             | 3024 +++---
 drivers/staging/rt2860/sta/sanity.c                |  535 +-
 drivers/staging/rt2860/sta/sync.c                  | 2712 +++---
 drivers/staging/rt2860/sta/wpa.c                   | 2158 +----
 drivers/staging/rt2860/sta_ioctl.c                 | 4866 ++++------
 drivers/staging/rt2860/usb_main_dev.c              |  887 ++
 drivers/staging/rt2860/wpa.h                       |  454 +-
 drivers/staging/rt2870/2870_main_dev.c             | 1530 ---
 drivers/staging/rt2870/Kconfig                     |    2 +
 drivers/staging/rt2870/Makefile                    |   32 +-
 drivers/staging/rt2870/chips/rt3070.c              |    1 +
 drivers/staging/rt2870/chips/rt30xx.c              |    1 +
 drivers/staging/rt2870/common/2870_rtmp_init.c     | 1730 ----
 drivers/staging/rt2870/common/acction.c            |    1 +
 drivers/staging/rt2870/common/cmm_aes.c            |    1 +
 drivers/staging/rt2870/common/cmm_asic.c           |    1 +
 drivers/staging/rt2870/common/cmm_cfg.c            |    1 +
 drivers/staging/rt2870/common/cmm_data_2870.c      |  936 --
 drivers/staging/rt2870/common/cmm_data_usb.c       |    1 +
 drivers/staging/rt2870/common/cmm_mac_usb.c        |    1 +
 drivers/staging/rt2870/common/cmm_profile.c        |    1 +
 drivers/staging/rt2870/common/cmm_tkip.c           |    1 +
 drivers/staging/rt2870/common/cmm_wep.c            |    1 +
 drivers/staging/rt2870/common/crypt_hmac.c         |    1 +
 drivers/staging/rt2870/common/crypt_md5.c          |    1 +
 drivers/staging/rt2870/common/crypt_sha2.c         |    1 +
 drivers/staging/rt2870/common/ee_efuse.c           |    1 +
 drivers/staging/rt2870/common/rt_channel.c         |    1 +
 drivers/staging/rt2870/common/rt_rf.c              |    1 +
 drivers/staging/rt2870/common/rtmp_mcu.c           |    1 +
 drivers/staging/rt2870/common/rtmp_timer.c         |    1 +
 drivers/staging/rt2870/common/rtusb_bulk.c         | 1067 +-
 drivers/staging/rt2870/common/rtusb_data.c         |  220 +-
 drivers/staging/rt2870/common/rtusb_io.c           | 2672 +++---
 drivers/staging/rt2870/rt2870.h                    |  583 --
 drivers/staging/rt2870/rt_usb.c                    |    1 +
 drivers/staging/rt2870/usb_main_dev.c              |    1 +
 drivers/staging/rt3070/firmware.h                  |    2 +-
 drivers/staging/rt3070/md4.h                       |   12 +-
 drivers/staging/rt3090/Kconfig                     |    5 -
 drivers/staging/rt3090/Makefile                    |   80 -
 drivers/staging/rt3090/action.h                    |   66 -
 drivers/staging/rt3090/ap.h                        |  512 -
 drivers/staging/rt3090/ap_apcli.h                  |  276 -
 drivers/staging/rt3090/ap_autoChSel.h              |   79 -
 drivers/staging/rt3090/ap_autoChSel_cmm.h          |   66 -
 drivers/staging/rt3090/ap_cfg.h                    |  118 -
 drivers/staging/rt3090/ap_ids.h                    |   82 -
 drivers/staging/rt3090/ap_mbss.h                   |   72 -
 drivers/staging/rt3090/ap_uapsd.h                  |  636 --
 drivers/staging/rt3090/ap_wds.h                    |  212 -
 drivers/staging/rt3090/chips/rt3370.c              |  121 -
 drivers/staging/rt3090/chips/rt3390.c              |  122 -
 drivers/staging/rt3090/chips/rt33xx.c              |  536 -
 drivers/staging/rt3090/chlist.h                    |  130 -
 drivers/staging/rt3090/common/action.c             | 1057 --
 drivers/staging/rt3090/common/ba_action.c          | 1779 ----
 drivers/staging/rt3090/common/cmm_asic.c           | 2753 ------
 drivers/staging/rt3090/common/cmm_data.c           | 2763 ------
 drivers/staging/rt3090/common/cmm_data_pci.c       | 1576 ---
 drivers/staging/rt3090/common/cmm_info.c           | 3718 -------
 drivers/staging/rt3090/common/cmm_mac_pci.c        | 1757 ----
 drivers/staging/rt3090/common/cmm_profile.c        | 2321 -----
 drivers/staging/rt3090/common/cmm_sanity.c         | 1718 ----
 drivers/staging/rt3090/common/cmm_sync.c           |  734 --
 drivers/staging/rt3090/common/cmm_tkip.c           |  966 --
 drivers/staging/rt3090/common/cmm_wpa.c            | 3149 ------
 drivers/staging/rt3090/common/crypt_aes.c          | 1007 --
 drivers/staging/rt3090/common/crypt_biginteger.c   | 1119 ---
 drivers/staging/rt3090/common/crypt_dh.c           |  234 -
 drivers/staging/rt3090/common/crypt_hmac.c         |  279 -
 drivers/staging/rt3090/common/crypt_md5.c          |  353 -
 drivers/staging/rt3090/common/crypt_sha2.c         |  536 -
 drivers/staging/rt3090/common/dfs.c                |  481 -
 drivers/staging/rt3090/common/ee_efuse.c           | 1548 ---
 drivers/staging/rt3090/common/ee_prom.c            |  308 -
 drivers/staging/rt3090/common/eeprom.c             |   98 -
 drivers/staging/rt3090/common/igmp_snoop.c         | 1365 ---
 drivers/staging/rt3090/common/mlme.c               | 6550 ------------
 drivers/staging/rt3090/common/mlme_ex.c            |  215 -
 drivers/staging/rt3090/common/netif_block.c        |  147 -
 drivers/staging/rt3090/common/rt_channel.c         | 1287 ---
 drivers/staging/rt3090/common/rtmp_init.c          | 3882 --------
 drivers/staging/rt3090/common/rtmp_mcu.c           |  560 --
 drivers/staging/rt3090/common/spectrum.c           | 2221 -----
 drivers/staging/rt3090/config.mk                   |  187 -
 drivers/staging/rt3090/crypt_sha2.h                |  107 -
 drivers/staging/rt3090/dfs.h                       |  137 -
 drivers/staging/rt3090/firmware.h                  |    2 +-
 drivers/staging/rt3090/igmp_snoop.h                |  152 -
 drivers/staging/rt3090/ipv6.h                      |  215 -
 drivers/staging/rt3090/link_list.h                 |  133 -
 drivers/staging/rt3090/mlme.h                      | 1360 ---
 drivers/staging/rt3090/mlme_ex.h                   |   83 -
 drivers/staging/rt3090/mlme_ex_def.h               |   53 -
 drivers/staging/rt3090/oid.h                       | 1144 ---
 drivers/staging/rt3090/pci_main_dev.c              | 1195 ---
 drivers/staging/rt3090/rt3390.h                    |   77 -
 drivers/staging/rt3090/rt_ate.c                    | 6089 ------------
 drivers/staging/rt3090/rt_ate.h                    |  314 -
 drivers/staging/rt3090/rt_config.h                 |  126 -
 drivers/staging/rt3090/rt_linux.c                  | 1624 ---
 drivers/staging/rt3090/rt_linux.h                  | 1034 --
 drivers/staging/rt3090/rt_main_dev.c               |  897 --
 drivers/staging/rt3090/rt_pci_rbus.c               |  989 --
 drivers/staging/rt3090/rt_profile.c                |  101 -
 drivers/staging/rt3090/rtmp.h                      | 6873 -------------
 drivers/staging/rt3090/rtmp_chip.h                 |  355 -
 drivers/staging/rt3090/rtmp_def.h                  | 1650 ----
 drivers/staging/rt3090/rtmp_dot11.h                |  146 -
 drivers/staging/rt3090/rtmp_mac.h                  | 2304 -----
 drivers/staging/rt3090/rtmp_type.h                 |  147 -
 drivers/staging/rt3090/spectrum.h                  |  234 -
 drivers/staging/rt3090/spectrum_def.h              |  257 -
 drivers/staging/rt3090/sta/assoc.c                 | 1673 ----
 drivers/staging/rt3090/sta/auth.c                  |  491 -
 drivers/staging/rt3090/sta/auth_rsp.c              |  151 -
 drivers/staging/rt3090/sta/connect.c               | 2759 ------
 drivers/staging/rt3090/sta/dls.c                   | 2207 -----
 drivers/staging/rt3090/sta/rtmp_ckipmic.c          |  579 --
 drivers/staging/rt3090/sta/rtmp_data.c             | 2661 -----
 drivers/staging/rt3090/sta/sanity.c                |  382 -
 drivers/staging/rt3090/sta/sync.c                  | 1840 ----
 drivers/staging/rt3090/sta/wpa.c                   |  396 -
 drivers/staging/rt3090/sta_ioctl.c                 | 7557 --------------
 drivers/staging/rt3090/wpa.h                       |  447 -
 drivers/staging/rtl8187se/Kconfig                  |    3 +-
 drivers/staging/rtl8187se/Makefile                 |    4 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    1 -
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    6 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    1 -
 drivers/staging/rtl8187se/r8180.h                  |   20 +-
 drivers/staging/rtl8187se/r8180_core.c             |  258 +-
 drivers/staging/rtl8187se/r8180_dm.c               |   13 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |  101 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |   33 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    4 +-
 drivers/staging/rtl8192e/r8190_rtl8256.c           |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 +-
 drivers/staging/rtl8192e/r8192E_dm.c               |   20 +-
 drivers/staging/rtl8192e/r8192E_wx.c               |    2 +-
 drivers/staging/rtl8192e/r819xE_cmdpkt.c           |    2 +-
 drivers/staging/rtl8192e/r819xE_phyreg.h           |    2 +-
 drivers/staging/rtl8192su/Kconfig                  |    2 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c |    1 -
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |    4 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |    1 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |    1 -
 drivers/staging/rtl8192su/ieee80211/readme         |    2 +-
 drivers/staging/rtl8192su/r8192S_phy.c             |    4 +-
 drivers/staging/rtl8192su/r8192S_phyreg.h          |    2 +-
 drivers/staging/rtl8192su/r8192S_rtl6052.c         |    4 +-
 drivers/staging/rtl8192su/r8192U_dm.c              |   10 +-
 drivers/staging/rtl8192su/r8192U_wx.c              |    2 +-
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |    2 +-
 drivers/staging/rtl8192u/Kconfig                   |    6 +
 drivers/staging/rtl8192u/Makefile                  |   33 +
 drivers/staging/rtl8192u/authors                   |    1 +
 drivers/staging/rtl8192u/changes                   |    5 +
 drivers/staging/rtl8192u/copying                   |  340 +
 drivers/staging/rtl8192u/dot11d.h                  |  102 +
 drivers/staging/rtl8192u/ieee80211.h               | 2638 +++++
 drivers/staging/rtl8192u/ieee80211/EndianFree.h    |  194 +
 drivers/staging/rtl8192u/ieee80211/Makefile        |  139 +
 drivers/staging/rtl8192u/ieee80211/aes.c           |  469 +
 drivers/staging/rtl8192u/ieee80211/api.c           |  246 +
 drivers/staging/rtl8192u/ieee80211/arc4.c          |  103 +
 drivers/staging/rtl8192u/ieee80211/autoload.c      |   40 +
 drivers/staging/rtl8192u/ieee80211/cipher.c        |  299 +
 drivers/staging/rtl8192u/ieee80211/compress.c      |   64 +
 drivers/staging/rtl8192u/ieee80211/crypto_compat.h |   60 +
 drivers/staging/rtl8192u/ieee80211/digest.c        |  108 +
 drivers/staging/rtl8192u/ieee80211/dot11d.c        |  223 +
 drivers/staging/rtl8192u/ieee80211/dot11d.h        |  102 +
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     | 2639 +++++
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.c   |  244 +
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.h   |   86 +
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |  480 +
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |  780 ++
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |  297 +
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |  324 +
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  | 2668 +++++
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c | 3287 +++++++
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |  615 ++
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |  912 ++
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |  878 ++
 drivers/staging/rtl8192u/ieee80211/internal.h      |   99 +
 drivers/staging/rtl8192u/ieee80211/kmap_types.h    |   20 +
 drivers/staging/rtl8192u/ieee80211/michael_mic.c   |  194 +
 drivers/staging/rtl8192u/ieee80211/proc.c          |  116 +
 drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h    |   69 +
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |  737 ++
 drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h    |  481 +
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    | 1462 +++
 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h   |  583 ++
 drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h    |   56 +
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |  628 ++
 drivers/staging/rtl8192u/ieee80211/rtl_crypto.h    |  399 +
 drivers/staging/rtl8192u/ieee80211/scatterwalk.c   |  126 +
 drivers/staging/rtl8192u/ieee80211/scatterwalk.h   |   51 +
 drivers/staging/rtl8192u/ieee80211_crypt.h         |   86 +
 drivers/staging/rtl8192u/r8180_93cx6.c             |  146 +
 drivers/staging/rtl8192u/r8180_93cx6.h             |   40 +
 drivers/staging/rtl8192u/r8180_pm.c                |   48 +
 drivers/staging/rtl8192u/r8180_pm.h                |   28 +
 drivers/staging/rtl8192u/r8190_rtl8256.c           |  312 +
 drivers/staging/rtl8192u/r8190_rtl8256.h           |   27 +
 drivers/staging/rtl8192u/r8192U.h                  | 1263 +++
 drivers/staging/rtl8192u/r8192U_core.c             | 6085 ++++++++++++
 drivers/staging/rtl8192u/r8192U_dm.c               | 3890 ++++++++
 drivers/staging/rtl8192u/r8192U_dm.h               |  254 +
 drivers/staging/rtl8192u/r8192U_hw.h               |  411 +
 drivers/staging/rtl8192u/r8192U_wx.c               | 1228 +++
 drivers/staging/rtl8192u/r8192U_wx.h               |   23 +
 drivers/staging/rtl8192u/r819xU_HTGen.h            |   13 +
 drivers/staging/rtl8192u/r819xU_HTType.h           |  391 +
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |  791 ++
 drivers/staging/rtl8192u/r819xU_cmdpkt.h           |  207 +
 drivers/staging/rtl8192u/r819xU_firmware.c         |  434 +
 drivers/staging/rtl8192u/r819xU_firmware.h         |   27 +
 drivers/staging/rtl8192u/r819xU_firmware_img.c     | 3447 +++++++
 drivers/staging/rtl8192u/r819xU_firmware_img.h     |   35 +
 drivers/staging/rtl8192u/r819xU_phy.c              | 1777 ++++
 drivers/staging/rtl8192u/r819xU_phy.h              |   90 +
 drivers/staging/rtl8192u/r819xU_phyreg.h           |  871 ++
 drivers/staging/samsung-laptop/Kconfig             |   10 +
 drivers/staging/samsung-laptop/Makefile            |    1 +
 drivers/staging/samsung-laptop/TODO                |    5 +
 drivers/staging/samsung-laptop/samsung-laptop.c    |  542 +
 drivers/staging/sep/sep_driver.c                   |    6 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |    2 +-
 drivers/staging/slicoss/slicoss.c                  |    1 -
 drivers/staging/usbip/vhci_hcd.c                   |    2 +-
 drivers/staging/vme/TODO                           |    2 +-
 drivers/staging/vme/bridges/vme_ca91cx42.c         |   82 +-
 drivers/staging/vme/bridges/vme_tsi148.c           |  161 +-
 drivers/staging/vme/devices/vme_user.c             |    3 +-
 drivers/staging/vme/vme.c                          |  101 +-
 drivers/staging/vme/vme.h                          |    8 +-
 drivers/staging/vme/vme_api.txt                    |    8 +-
 drivers/staging/vme/vme_bridge.h                   |    9 +-
 drivers/staging/vt6655/device.h                    |    2 -
 drivers/staging/vt6655/device_main.c               |    2 +-
 drivers/staging/vt6655/ioctl.c                     |    4 +-
 drivers/staging/vt6655/kcompat.h                   |   39 -
 drivers/staging/vt6655/mib.h                       |    4 +-
 drivers/staging/vt6655/rxtx.h                      |   17 -
 drivers/staging/vt6655/wcmd.c                      |    1 -
 drivers/staging/vt6655/wpa.c                       |    4 +-
 drivers/staging/vt6655/wroute.c                    |    2 +-
 drivers/staging/vt6656/baseband.c                  |    3 +-
 drivers/staging/vt6656/channel.c                   |    2 +-
 drivers/staging/vt6656/device.h                    |    4 +-
 drivers/staging/vt6656/firmware.c                  |    2 +-
 drivers/staging/vt6656/hostap.c                    |    1 -
 drivers/staging/vt6656/ioctl.c                     |    4 +-
 drivers/staging/vt6656/iwctl.c                     |    2 +-
 drivers/staging/vt6656/kcompat.h                   |   39 -
 drivers/staging/vt6656/main_usb.c                  |   10 +-
 drivers/staging/vt6656/mib.h                       |    4 +-
 drivers/staging/vt6656/rxtx.c                      |    2 +-
 drivers/staging/vt6656/wcmd.c                      |    3 +-
 drivers/staging/vt6656/wpa.c                       |    4 +-
 drivers/staging/wlags49_h2/Kconfig                 |    9 +
 drivers/staging/wlags49_h2/Makefile                |   81 +
 drivers/staging/wlags49_h2/README.ubuntu           |  180 +
 drivers/staging/wlags49_h2/README.wlags49          |  641 ++
 drivers/staging/wlags49_h2/TODO                    |   33 +
 drivers/staging/wlags49_h2/WARNING.txt             |    3 +
 drivers/staging/wlags49_h2/ap_h2.c                 | 3337 +++++++
 drivers/staging/wlags49_h2/ap_h25.c                | 4094 ++++++++
 drivers/staging/wlags49_h2/debug.h                 |  212 +
 drivers/staging/wlags49_h2/dhf.c                   |  390 +
 drivers/staging/wlags49_h2/dhf.h                   |  226 +
 drivers/staging/wlags49_h2/dhfcfg.h                |  158 +
 drivers/staging/wlags49_h2/hcf.c                   | 4881 +++++++++
 drivers/staging/wlags49_h2/hcf.h                   |  405 +
 drivers/staging/wlags49_h2/hcfcfg.h                | 2344 +++++
 drivers/staging/wlags49_h2/hcfdef.h                |  809 ++
 drivers/staging/wlags49_h2/man/wlags49.4           |  734 ++
 drivers/staging/wlags49_h2/mdd.h                   | 1156 +++
 drivers/staging/wlags49_h2/mmd.c                   |  251 +
 drivers/staging/wlags49_h2/mmd.h                   |   78 +
 drivers/staging/wlags49_h2/sta_h2.c                | 4480 +++++++++
 drivers/staging/wlags49_h2/sta_h25.c               | 5255 ++++++++++
 drivers/staging/wlags49_h2/wl_cs.c                 |  702 ++
 drivers/staging/wlags49_h2/wl_cs.h                 |   95 +
 drivers/staging/wlags49_h2/wl_enc.c                |  231 +
 drivers/staging/wlags49_h2/wl_enc.h                |  118 +
 drivers/staging/wlags49_h2/wl_if.h                 |  234 +
 drivers/staging/wlags49_h2/wl_internal.h           | 1056 ++
 drivers/staging/wlags49_h2/wl_main.c               | 3866 ++++++++
 drivers/staging/wlags49_h2/wl_main.h               |  138 +
 drivers/staging/wlags49_h2/wl_netdev.c             | 2070 ++++
 drivers/staging/wlags49_h2/wl_netdev.h             |  154 +
 drivers/staging/wlags49_h2/wl_pci.c                | 1581 +++
 drivers/staging/wlags49_h2/wl_pci.h                |  109 +
 drivers/staging/wlags49_h2/wl_priv.c               | 2078 ++++
 drivers/staging/wlags49_h2/wl_priv.h               |  121 +
 drivers/staging/wlags49_h2/wl_profile.c            | 1111 +++
 drivers/staging/wlags49_h2/wl_profile.h            |   87 +
 drivers/staging/wlags49_h2/wl_sysfs.c              |  135 +
 drivers/staging/wlags49_h2/wl_sysfs.h              |    7 +
 drivers/staging/wlags49_h2/wl_util.c               | 1587 +++
 drivers/staging/wlags49_h2/wl_util.h               |  105 +
 drivers/staging/wlags49_h2/wl_version.h            |  179 +
 drivers/staging/wlags49_h2/wl_wext.c               | 4130 ++++++++
 drivers/staging/wlags49_h2/wl_wext.h               |   96 +
 drivers/staging/wlags49_h25/Kconfig                |    9 +
 drivers/staging/wlags49_h25/Makefile               |   81 +
 drivers/staging/wlags49_h25/README.txt             |   30 +
 drivers/staging/wlags49_h25/TODO                   |   33 +
 drivers/staging/wlags49_h25/ap_h25.c               |    2 +
 drivers/staging/wlags49_h25/debug.h                |    2 +
 drivers/staging/wlags49_h25/dhf.c                  |    2 +
 drivers/staging/wlags49_h25/dhf.h                  |    2 +
 drivers/staging/wlags49_h25/dhfcfg.h               |    2 +
 drivers/staging/wlags49_h25/hcf.c                  |    2 +
 drivers/staging/wlags49_h25/hcf.h                  |    2 +
 drivers/staging/wlags49_h25/hcfcfg.h               |    2 +
 drivers/staging/wlags49_h25/hcfdef.h               |    2 +
 drivers/staging/wlags49_h25/mdd.h                  |    2 +
 drivers/staging/wlags49_h25/mmd.c                  |    2 +
 drivers/staging/wlags49_h25/mmd.h                  |    2 +
 drivers/staging/wlags49_h25/sta_h25.c              |    2 +
 drivers/staging/wlags49_h25/wl_cs.c                |    2 +
 drivers/staging/wlags49_h25/wl_cs.h                |    2 +
 drivers/staging/wlags49_h25/wl_enc.c               |    2 +
 drivers/staging/wlags49_h25/wl_enc.h               |    2 +
 drivers/staging/wlags49_h25/wl_if.h                |    2 +
 drivers/staging/wlags49_h25/wl_internal.h          |    2 +
 drivers/staging/wlags49_h25/wl_main.c              |    2 +
 drivers/staging/wlags49_h25/wl_main.h              |    2 +
 drivers/staging/wlags49_h25/wl_netdev.c            |    2 +
 drivers/staging/wlags49_h25/wl_netdev.h            |    2 +
 drivers/staging/wlags49_h25/wl_priv.c              |    2 +
 drivers/staging/wlags49_h25/wl_priv.h              |    2 +
 drivers/staging/wlags49_h25/wl_profile.c           |    2 +
 drivers/staging/wlags49_h25/wl_profile.h           |    2 +
 drivers/staging/wlags49_h25/wl_sysfs.c             |    2 +
 drivers/staging/wlags49_h25/wl_sysfs.h             |    2 +
 drivers/staging/wlags49_h25/wl_util.c              |    2 +
 drivers/staging/wlags49_h25/wl_util.h              |    2 +
 drivers/staging/wlags49_h25/wl_version.h           |    2 +
 drivers/staging/wlags49_h25/wl_wext.c              |    2 +
 drivers/staging/wlags49_h25/wl_wext.h              |    2 +
 679 files changed, 165727 insertions(+), 174515 deletions(-)
 delete mode 100644 drivers/staging/android/Kconfig
 delete mode 100644 drivers/staging/android/Makefile
 delete mode 100644 drivers/staging/android/TODO
 delete mode 100644 drivers/staging/android/binder.c
 delete mode 100644 drivers/staging/android/binder.h
 delete mode 100644 drivers/staging/android/logger.c
 delete mode 100644 drivers/staging/android/logger.h
 delete mode 100644 drivers/staging/android/lowmemorykiller.c
 delete mode 100644 drivers/staging/android/ram_console.c
 delete mode 100644 drivers/staging/android/timed_gpio.c
 delete mode 100644 drivers/staging/android/timed_gpio.h
 delete mode 100644 drivers/staging/android/timed_output.c
 delete mode 100644 drivers/staging/android/timed_output.h
 create mode 100644 drivers/staging/batman-adv/CHANGELOG
 create mode 100644 drivers/staging/batman-adv/Kconfig
 create mode 100644 drivers/staging/batman-adv/Makefile
 create mode 100644 drivers/staging/batman-adv/README
 create mode 100644 drivers/staging/batman-adv/TODO
 create mode 100644 drivers/staging/batman-adv/aggregation.c
 create mode 100644 drivers/staging/batman-adv/aggregation.h
 create mode 100644 drivers/staging/batman-adv/bitarray.c
 create mode 100644 drivers/staging/batman-adv/bitarray.h
 create mode 100644 drivers/staging/batman-adv/compat.h
 create mode 100644 drivers/staging/batman-adv/device.c
 create mode 100644 drivers/staging/batman-adv/device.h
 create mode 100644 drivers/staging/batman-adv/hard-interface.c
 create mode 100644 drivers/staging/batman-adv/hard-interface.h
 create mode 100644 drivers/staging/batman-adv/hash.c
 create mode 100644 drivers/staging/batman-adv/hash.h
 create mode 100644 drivers/staging/batman-adv/log.c
 create mode 100644 drivers/staging/batman-adv/log.h
 create mode 100644 drivers/staging/batman-adv/main.c
 create mode 100644 drivers/staging/batman-adv/main.h
 create mode 100644 drivers/staging/batman-adv/packet.h
 create mode 100644 drivers/staging/batman-adv/proc.c
 create mode 100644 drivers/staging/batman-adv/proc.h
 create mode 100644 drivers/staging/batman-adv/ring_buffer.c
 create mode 100644 drivers/staging/batman-adv/ring_buffer.h
 create mode 100644 drivers/staging/batman-adv/routing.c
 create mode 100644 drivers/staging/batman-adv/routing.h
 create mode 100644 drivers/staging/batman-adv/send.c
 create mode 100644 drivers/staging/batman-adv/send.h
 create mode 100644 drivers/staging/batman-adv/soft-interface.c
 create mode 100644 drivers/staging/batman-adv/soft-interface.h
 create mode 100644 drivers/staging/batman-adv/translation-table.c
 create mode 100644 drivers/staging/batman-adv/translation-table.h
 create mode 100644 drivers/staging/batman-adv/types.h
 create mode 100644 drivers/staging/batman-adv/vis.c
 create mode 100644 drivers/staging/batman-adv/vis.h
 create mode 100644 drivers/staging/dream/TODO
 create mode 100644 drivers/staging/dream/generic_gpio.c
 create mode 100644 drivers/staging/dream/pmem.c
 delete mode 100644 drivers/staging/iio/light/tsl2561.c
 create mode 100644 drivers/staging/iio/light/tsl2563.c
 create mode 100644 drivers/staging/iio/light/tsl2563.h
 create mode 100644 drivers/staging/ramzswap/Kconfig
 create mode 100644 drivers/staging/ramzswap/Makefile
 create mode 100644 drivers/staging/ramzswap/TODO
 create mode 100644 drivers/staging/ramzswap/ramzswap.txt
 create mode 100644 drivers/staging/ramzswap/ramzswap_drv.c
 create mode 100644 drivers/staging/ramzswap/ramzswap_drv.h
 create mode 100644 drivers/staging/ramzswap/ramzswap_ioctl.h
 create mode 100644 drivers/staging/ramzswap/xvmalloc.c
 create mode 100644 drivers/staging/ramzswap/xvmalloc.h
 create mode 100644 drivers/staging/ramzswap/xvmalloc_int.h
 delete mode 100644 drivers/staging/rt2860/2860_main_dev.c
 delete mode 100644 drivers/staging/rt2860/aironet.h
 rename drivers/staging/{rt3090 => rt2860/chip}/mac_pci.h (62%)
 create mode 100644 drivers/staging/rt2860/chip/mac_usb.h
 rename drivers/staging/{rt3090/netif_block.h => rt2860/chip/rt2860.h} (67%)
 rename drivers/staging/{rt3090/rt33xx.h => rt2860/chip/rt2870.h} (77%)
 rename drivers/staging/{rt3090/rt3370.h => rt2860/chip/rt3070.h} (87%)
 rename drivers/staging/{rt3090 => rt2860/chip}/rt3090.h (83%)
 rename drivers/staging/{rt3090 => rt2860/chip}/rt30xx.h (93%)
 create mode 100644 drivers/staging/rt2860/chip/rtmp_mac.h
 rename drivers/staging/{rt3090 => rt2860/chip}/rtmp_phy.h (78%)
 create mode 100644 drivers/staging/rt2860/chips/rt3070.c
 rename drivers/staging/{rt3090 => rt2860}/chips/rt3090.c (65%)
 rename drivers/staging/{rt3090 => rt2860}/chips/rt30xx.c (54%)
 delete mode 100644 drivers/staging/rt2860/common/2860_rtmp_init.c
 rename drivers/staging/{rt3090 => rt2860}/common/cmm_aes.c (51%)
 create mode 100644 drivers/staging/rt2860/common/cmm_asic.c
 rename drivers/staging/{rt3090 => rt2860}/common/cmm_cfg.c (56%)
 delete mode 100644 drivers/staging/rt2860/common/cmm_data_2860.c
 create mode 100644 drivers/staging/rt2860/common/cmm_data_pci.c
 create mode 100644 drivers/staging/rt2860/common/cmm_data_usb.c
 create mode 100644 drivers/staging/rt2860/common/cmm_mac_pci.c
 create mode 100644 drivers/staging/rt2860/common/cmm_mac_usb.c
 create mode 100644 drivers/staging/rt2860/common/cmm_tkip.c
 rename drivers/staging/{rt3090 => rt2860}/common/cmm_wep.c (75%)
 create mode 100644 drivers/staging/rt2860/common/crypt_hmac.c
 create mode 100644 drivers/staging/rt2860/common/crypt_md5.c
 create mode 100644 drivers/staging/rt2860/common/crypt_sha2.c
 create mode 100644 drivers/staging/rt2860/common/ee_efuse.c
 create mode 100644 drivers/staging/rt2860/common/ee_prom.c
 create mode 100644 drivers/staging/rt2860/common/firmware_3070.h
 delete mode 100644 drivers/staging/rt2860/common/md5.c
 create mode 100644 drivers/staging/rt2860/common/rt_channel.c
 rename drivers/staging/{rt3090 => rt2860}/common/rt_rf.c (69%)
 create mode 100644 drivers/staging/rt2860/common/rtmp_mcu.c
 rename drivers/staging/{rt3090 => rt2860}/common/rtmp_timer.c (69%)
 delete mode 100644 drivers/staging/rt2860/common/rtmp_tkip.c
 delete mode 100644 drivers/staging/rt2860/common/rtmp_wep.c
 delete mode 100644 drivers/staging/rt2860/config.mk
 rename drivers/staging/{rt3090 => rt2860}/crypt_hmac.h (71%)
 rename drivers/staging/{rt3090 => rt2860}/crypt_md5.h (67%)
 rename drivers/staging/{rt3090/vr_ikans.h => rt2860/crypt_sha2.h} (54%)
 rename drivers/staging/{rt3090 => rt2860}/eeprom.h (68%)
 rename drivers/staging/{rt3090 => rt2860/iface}/rtmp_pci.h (62%)
 create mode 100644 drivers/staging/rt2860/iface/rtmp_usb.h
 delete mode 100644 drivers/staging/rt2860/md5.h
 create mode 100644 drivers/staging/rt2860/pci_main_dev.c
 delete mode 100644 drivers/staging/rt2860/rt2860.h
 delete mode 100644 drivers/staging/rt2860/rt28xx.h
 create mode 100644 drivers/staging/rt2860/rt_pci_rbus.c
 delete mode 100644 drivers/staging/rt2860/rt_profile.c
 create mode 100644 drivers/staging/rt2860/rt_usb.c
 create mode 100644 drivers/staging/rt2860/rtmp_chip.h
 create mode 100644 drivers/staging/rt2860/rtmp_dot11.h
 rename drivers/staging/{rt3090 => rt2860}/rtmp_iface.h (70%)
 rename drivers/staging/{rt3090 => rt2860}/rtmp_mcu.h (86%)
 rename drivers/staging/{rt3090 => rt2860}/rtmp_os.h (77%)
 rename drivers/staging/{rt3090 => rt2860}/rtmp_timer.h (65%)
 create mode 100644 drivers/staging/rt2860/rtusb_io.h
 delete mode 100644 drivers/staging/rt2860/sta/aironet.c
 create mode 100644 drivers/staging/rt2860/usb_main_dev.c
 delete mode 100644 drivers/staging/rt2870/2870_main_dev.c
 create mode 100644 drivers/staging/rt2870/chips/rt3070.c
 create mode 100644 drivers/staging/rt2870/chips/rt30xx.c
 delete mode 100644 drivers/staging/rt2870/common/2870_rtmp_init.c
 create mode 100644 drivers/staging/rt2870/common/acction.c
 create mode 100644 drivers/staging/rt2870/common/cmm_aes.c
 create mode 100644 drivers/staging/rt2870/common/cmm_asic.c
 create mode 100644 drivers/staging/rt2870/common/cmm_cfg.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_data_2870.c
 create mode 100644 drivers/staging/rt2870/common/cmm_data_usb.c
 create mode 100644 drivers/staging/rt2870/common/cmm_mac_usb.c
 create mode 100644 drivers/staging/rt2870/common/cmm_profile.c
 create mode 100644 drivers/staging/rt2870/common/cmm_tkip.c
 create mode 100644 drivers/staging/rt2870/common/cmm_wep.c
 create mode 100644 drivers/staging/rt2870/common/crypt_hmac.c
 create mode 100644 drivers/staging/rt2870/common/crypt_md5.c
 create mode 100644 drivers/staging/rt2870/common/crypt_sha2.c
 create mode 100644 drivers/staging/rt2870/common/ee_efuse.c
 create mode 100644 drivers/staging/rt2870/common/rt_channel.c
 create mode 100644 drivers/staging/rt2870/common/rt_rf.c
 create mode 100644 drivers/staging/rt2870/common/rtmp_mcu.c
 create mode 100644 drivers/staging/rt2870/common/rtmp_timer.c
 delete mode 100644 drivers/staging/rt2870/rt2870.h
 create mode 100644 drivers/staging/rt2870/rt_usb.c
 create mode 100644 drivers/staging/rt2870/usb_main_dev.c
 delete mode 100644 drivers/staging/rt3090/Kconfig
 delete mode 100644 drivers/staging/rt3090/Makefile
 delete mode 100644 drivers/staging/rt3090/action.h
 delete mode 100644 drivers/staging/rt3090/ap.h
 delete mode 100644 drivers/staging/rt3090/ap_apcli.h
 delete mode 100644 drivers/staging/rt3090/ap_autoChSel.h
 delete mode 100644 drivers/staging/rt3090/ap_autoChSel_cmm.h
 delete mode 100644 drivers/staging/rt3090/ap_cfg.h
 delete mode 100644 drivers/staging/rt3090/ap_ids.h
 delete mode 100644 drivers/staging/rt3090/ap_mbss.h
 delete mode 100644 drivers/staging/rt3090/ap_uapsd.h
 delete mode 100644 drivers/staging/rt3090/ap_wds.h
 delete mode 100644 drivers/staging/rt3090/chips/rt3370.c
 delete mode 100644 drivers/staging/rt3090/chips/rt3390.c
 delete mode 100644 drivers/staging/rt3090/chips/rt33xx.c
 delete mode 100644 drivers/staging/rt3090/chlist.h
 delete mode 100644 drivers/staging/rt3090/common/action.c
 delete mode 100644 drivers/staging/rt3090/common/ba_action.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_asic.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_data.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_data_pci.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_info.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_mac_pci.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_profile.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_sanity.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_sync.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_tkip.c
 delete mode 100644 drivers/staging/rt3090/common/cmm_wpa.c
 delete mode 100644 drivers/staging/rt3090/common/crypt_aes.c
 delete mode 100644 drivers/staging/rt3090/common/crypt_biginteger.c
 delete mode 100644 drivers/staging/rt3090/common/crypt_dh.c
 delete mode 100644 drivers/staging/rt3090/common/crypt_hmac.c
 delete mode 100644 drivers/staging/rt3090/common/crypt_md5.c
 delete mode 100644 drivers/staging/rt3090/common/crypt_sha2.c
 delete mode 100644 drivers/staging/rt3090/common/dfs.c
 delete mode 100644 drivers/staging/rt3090/common/ee_efuse.c
 delete mode 100644 drivers/staging/rt3090/common/ee_prom.c
 delete mode 100644 drivers/staging/rt3090/common/eeprom.c
 delete mode 100644 drivers/staging/rt3090/common/igmp_snoop.c
 delete mode 100644 drivers/staging/rt3090/common/mlme.c
 delete mode 100644 drivers/staging/rt3090/common/mlme_ex.c
 delete mode 100644 drivers/staging/rt3090/common/netif_block.c
 delete mode 100644 drivers/staging/rt3090/common/rt_channel.c
 delete mode 100644 drivers/staging/rt3090/common/rtmp_init.c
 delete mode 100644 drivers/staging/rt3090/common/rtmp_mcu.c
 delete mode 100644 drivers/staging/rt3090/common/spectrum.c
 delete mode 100644 drivers/staging/rt3090/config.mk
 delete mode 100644 drivers/staging/rt3090/crypt_sha2.h
 delete mode 100644 drivers/staging/rt3090/dfs.h
 delete mode 100644 drivers/staging/rt3090/igmp_snoop.h
 delete mode 100644 drivers/staging/rt3090/ipv6.h
 delete mode 100644 drivers/staging/rt3090/link_list.h
 delete mode 100644 drivers/staging/rt3090/mlme.h
 delete mode 100644 drivers/staging/rt3090/mlme_ex.h
 delete mode 100644 drivers/staging/rt3090/mlme_ex_def.h
 delete mode 100644 drivers/staging/rt3090/oid.h
 delete mode 100644 drivers/staging/rt3090/pci_main_dev.c
 delete mode 100644 drivers/staging/rt3090/rt3390.h
 delete mode 100644 drivers/staging/rt3090/rt_ate.c
 delete mode 100644 drivers/staging/rt3090/rt_ate.h
 delete mode 100644 drivers/staging/rt3090/rt_config.h
 delete mode 100644 drivers/staging/rt3090/rt_linux.c
 delete mode 100644 drivers/staging/rt3090/rt_linux.h
 delete mode 100644 drivers/staging/rt3090/rt_main_dev.c
 delete mode 100644 drivers/staging/rt3090/rt_pci_rbus.c
 delete mode 100644 drivers/staging/rt3090/rt_profile.c
 delete mode 100644 drivers/staging/rt3090/rtmp.h
 delete mode 100644 drivers/staging/rt3090/rtmp_chip.h
 delete mode 100644 drivers/staging/rt3090/rtmp_def.h
 delete mode 100644 drivers/staging/rt3090/rtmp_dot11.h
 delete mode 100644 drivers/staging/rt3090/rtmp_mac.h
 delete mode 100644 drivers/staging/rt3090/rtmp_type.h
 delete mode 100644 drivers/staging/rt3090/spectrum.h
 delete mode 100644 drivers/staging/rt3090/spectrum_def.h
 delete mode 100644 drivers/staging/rt3090/sta/assoc.c
 delete mode 100644 drivers/staging/rt3090/sta/auth.c
 delete mode 100644 drivers/staging/rt3090/sta/auth_rsp.c
 delete mode 100644 drivers/staging/rt3090/sta/connect.c
 delete mode 100644 drivers/staging/rt3090/sta/dls.c
 delete mode 100644 drivers/staging/rt3090/sta/rtmp_ckipmic.c
 delete mode 100644 drivers/staging/rt3090/sta/rtmp_data.c
 delete mode 100644 drivers/staging/rt3090/sta/sanity.c
 delete mode 100644 drivers/staging/rt3090/sta/sync.c
 delete mode 100644 drivers/staging/rt3090/sta/wpa.c
 delete mode 100644 drivers/staging/rt3090/sta_ioctl.c
 delete mode 100644 drivers/staging/rt3090/wpa.h
 create mode 100644 drivers/staging/rtl8192u/Kconfig
 create mode 100644 drivers/staging/rtl8192u/Makefile
 create mode 100644 drivers/staging/rtl8192u/authors
 create mode 100644 drivers/staging/rtl8192u/changes
 create mode 100644 drivers/staging/rtl8192u/copying
 create mode 100644 drivers/staging/rtl8192u/dot11d.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/EndianFree.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/Makefile
 create mode 100644 drivers/staging/rtl8192u/ieee80211/aes.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/api.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/arc4.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/autoload.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/cipher.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/compress.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/crypto_compat.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/digest.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/dot11d.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/dot11d.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/internal.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/kmap_types.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/michael_mic.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/proc.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211/scatterwalk.c
 create mode 100644 drivers/staging/rtl8192u/ieee80211/scatterwalk.h
 create mode 100644 drivers/staging/rtl8192u/ieee80211_crypt.h
 create mode 100644 drivers/staging/rtl8192u/r8180_93cx6.c
 create mode 100644 drivers/staging/rtl8192u/r8180_93cx6.h
 create mode 100644 drivers/staging/rtl8192u/r8180_pm.c
 create mode 100644 drivers/staging/rtl8192u/r8180_pm.h
 create mode 100644 drivers/staging/rtl8192u/r8190_rtl8256.c
 create mode 100644 drivers/staging/rtl8192u/r8190_rtl8256.h
 create mode 100644 drivers/staging/rtl8192u/r8192U.h
 create mode 100644 drivers/staging/rtl8192u/r8192U_core.c
 create mode 100644 drivers/staging/rtl8192u/r8192U_dm.c
 create mode 100644 drivers/staging/rtl8192u/r8192U_dm.h
 create mode 100644 drivers/staging/rtl8192u/r8192U_hw.h
 create mode 100644 drivers/staging/rtl8192u/r8192U_wx.c
 create mode 100644 drivers/staging/rtl8192u/r8192U_wx.h
 create mode 100644 drivers/staging/rtl8192u/r819xU_HTGen.h
 create mode 100644 drivers/staging/rtl8192u/r819xU_HTType.h
 create mode 100644 drivers/staging/rtl8192u/r819xU_cmdpkt.c
 create mode 100644 drivers/staging/rtl8192u/r819xU_cmdpkt.h
 create mode 100644 drivers/staging/rtl8192u/r819xU_firmware.c
 create mode 100644 drivers/staging/rtl8192u/r819xU_firmware.h
 create mode 100644 drivers/staging/rtl8192u/r819xU_firmware_img.c
 create mode 100644 drivers/staging/rtl8192u/r819xU_firmware_img.h
 create mode 100644 drivers/staging/rtl8192u/r819xU_phy.c
 create mode 100644 drivers/staging/rtl8192u/r819xU_phy.h
 create mode 100644 drivers/staging/rtl8192u/r819xU_phyreg.h
 create mode 100644 drivers/staging/samsung-laptop/Kconfig
 create mode 100644 drivers/staging/samsung-laptop/Makefile
 create mode 100644 drivers/staging/samsung-laptop/TODO
 create mode 100644 drivers/staging/samsung-laptop/samsung-laptop.c
 delete mode 100644 drivers/staging/vt6655/kcompat.h
 delete mode 100644 drivers/staging/vt6656/kcompat.h
 create mode 100644 drivers/staging/wlags49_h2/Kconfig
 create mode 100644 drivers/staging/wlags49_h2/Makefile
 create mode 100644 drivers/staging/wlags49_h2/README.ubuntu
 create mode 100644 drivers/staging/wlags49_h2/README.wlags49
 create mode 100644 drivers/staging/wlags49_h2/TODO
 create mode 100644 drivers/staging/wlags49_h2/WARNING.txt
 create mode 100644 drivers/staging/wlags49_h2/ap_h2.c
 create mode 100644 drivers/staging/wlags49_h2/ap_h25.c
 create mode 100644 drivers/staging/wlags49_h2/debug.h
 create mode 100644 drivers/staging/wlags49_h2/dhf.c
 create mode 100644 drivers/staging/wlags49_h2/dhf.h
 create mode 100644 drivers/staging/wlags49_h2/dhfcfg.h
 create mode 100644 drivers/staging/wlags49_h2/hcf.c
 create mode 100644 drivers/staging/wlags49_h2/hcf.h
 create mode 100644 drivers/staging/wlags49_h2/hcfcfg.h
 create mode 100644 drivers/staging/wlags49_h2/hcfdef.h
 create mode 100644 drivers/staging/wlags49_h2/man/wlags49.4
 create mode 100644 drivers/staging/wlags49_h2/mdd.h
 create mode 100644 drivers/staging/wlags49_h2/mmd.c
 create mode 100644 drivers/staging/wlags49_h2/mmd.h
 create mode 100644 drivers/staging/wlags49_h2/sta_h2.c
 create mode 100644 drivers/staging/wlags49_h2/sta_h25.c
 create mode 100644 drivers/staging/wlags49_h2/wl_cs.c
 create mode 100644 drivers/staging/wlags49_h2/wl_cs.h
 create mode 100644 drivers/staging/wlags49_h2/wl_enc.c
 create mode 100644 drivers/staging/wlags49_h2/wl_enc.h
 create mode 100644 drivers/staging/wlags49_h2/wl_if.h
 create mode 100644 drivers/staging/wlags49_h2/wl_internal.h
 create mode 100644 drivers/staging/wlags49_h2/wl_main.c
 create mode 100644 drivers/staging/wlags49_h2/wl_main.h
 create mode 100644 drivers/staging/wlags49_h2/wl_netdev.c
 create mode 100644 drivers/staging/wlags49_h2/wl_netdev.h
 create mode 100644 drivers/staging/wlags49_h2/wl_pci.c
 create mode 100644 drivers/staging/wlags49_h2/wl_pci.h
 create mode 100644 drivers/staging/wlags49_h2/wl_priv.c
 create mode 100644 drivers/staging/wlags49_h2/wl_priv.h
 create mode 100644 drivers/staging/wlags49_h2/wl_profile.c
 create mode 100644 drivers/staging/wlags49_h2/wl_profile.h
 create mode 100644 drivers/staging/wlags49_h2/wl_sysfs.c
 create mode 100644 drivers/staging/wlags49_h2/wl_sysfs.h
 create mode 100644 drivers/staging/wlags49_h2/wl_util.c
 create mode 100644 drivers/staging/wlags49_h2/wl_util.h
 create mode 100644 drivers/staging/wlags49_h2/wl_version.h
 create mode 100644 drivers/staging/wlags49_h2/wl_wext.c
 create mode 100644 drivers/staging/wlags49_h2/wl_wext.h
 create mode 100644 drivers/staging/wlags49_h25/Kconfig
 create mode 100644 drivers/staging/wlags49_h25/Makefile
 create mode 100644 drivers/staging/wlags49_h25/README.txt
 create mode 100644 drivers/staging/wlags49_h25/TODO
 create mode 100644 drivers/staging/wlags49_h25/ap_h25.c
 create mode 100644 drivers/staging/wlags49_h25/debug.h
 create mode 100644 drivers/staging/wlags49_h25/dhf.c
 create mode 100644 drivers/staging/wlags49_h25/dhf.h
 create mode 100644 drivers/staging/wlags49_h25/dhfcfg.h
 create mode 100644 drivers/staging/wlags49_h25/hcf.c
 create mode 100644 drivers/staging/wlags49_h25/hcf.h
 create mode 100644 drivers/staging/wlags49_h25/hcfcfg.h
 create mode 100644 drivers/staging/wlags49_h25/hcfdef.h
 create mode 100644 drivers/staging/wlags49_h25/mdd.h
 create mode 100644 drivers/staging/wlags49_h25/mmd.c
 create mode 100644 drivers/staging/wlags49_h25/mmd.h
 create mode 100644 drivers/staging/wlags49_h25/sta_h25.c
 create mode 100644 drivers/staging/wlags49_h25/wl_cs.c
 create mode 100644 drivers/staging/wlags49_h25/wl_cs.h
 create mode 100644 drivers/staging/wlags49_h25/wl_enc.c
 create mode 100644 drivers/staging/wlags49_h25/wl_enc.h
 create mode 100644 drivers/staging/wlags49_h25/wl_if.h
 create mode 100644 drivers/staging/wlags49_h25/wl_internal.h
 create mode 100644 drivers/staging/wlags49_h25/wl_main.c
 create mode 100644 drivers/staging/wlags49_h25/wl_main.h
 create mode 100644 drivers/staging/wlags49_h25/wl_netdev.c
 create mode 100644 drivers/staging/wlags49_h25/wl_netdev.h
 create mode 100644 drivers/staging/wlags49_h25/wl_priv.c
 create mode 100644 drivers/staging/wlags49_h25/wl_priv.h
 create mode 100644 drivers/staging/wlags49_h25/wl_profile.c
 create mode 100644 drivers/staging/wlags49_h25/wl_profile.h
 create mode 100644 drivers/staging/wlags49_h25/wl_sysfs.c
 create mode 100644 drivers/staging/wlags49_h25/wl_sysfs.h
 create mode 100644 drivers/staging/wlags49_h25/wl_util.c
 create mode 100644 drivers/staging/wlags49_h25/wl_util.h
 create mode 100644 drivers/staging/wlags49_h25/wl_version.h
 create mode 100644 drivers/staging/wlags49_h25/wl_wext.c
 create mode 100644 drivers/staging/wlags49_h25/wl_wext.h

---------------

Alan Cox (45):
      Staging: et131x: kill SUCCESS and FAILURE defines
      Staging: et131x: tidy eeprom code up
      Staging: et131x: extract the eeprom setup logic from initpci
      Staging: et131x: Kill the NoPhyAccess variable
      Staging: et131x: tidy up initpci code
      Staging: et131x: kill NMI hacks
      Staging: et131x: PHY loopback cannot be set (and isn't useful for us anyway)
      Staging: et131x: rxstat is not used
      Staging: et131x: clean up word 3 definition
      Staging: et131x: clean up WORD2 usage
      Staging: et131x: tidy up names for the TX structures
      Staging: et131x: the stuck descriptor copy is never used
      Staging: et131x: pci_alloc_consistent DMA alignment is guaranteed
      Staging: et131x: first pass RX cleanup
      Staging: et131x: Clean up the receive arrays
      Staging: et131x: fold up simple wrapper functions
      Staging: et131x: Remove old SendWaitQueue code
      Staging: et131x: tidy up a bit further
      Staging: et131x: Clean up the tx ring init
      Staging: et131x: Clean up tx naming
      Staging: et131x: kill unused tcb fields
      Staging: et131x: Bring tx into coding style
      Staging: et131x: tx ring mac error is only used as a local
      Staging: et131x: Kill the RX pending list
      Staging: et131x: Kill the RX skb list element - it isn't used
      Staging: et131x: Clean the IPG types up
      Staging: et131x: Clean up the half duplex control reg types
      Staging: et131x: Clean up the MII_MGMT type
      Staging: et131x: Clean up MAC_CFG types
      Staging: et131x: clean up MAX_FM type
      Staging: et131x: kill off MAC_TEST_t
      Staging: et131x: Clean up MII control
      Staging: et131x: phy clean up
      Staging: et131x: Clean up the phy code, especially dup stuff
      Staging: et131x: Kill MAC_IF_CTRL typedefs
      Staging: et131x: clean up MAC_STAT register
      Staging: et131x: clean up mac stat names
      Staging: et131x: kill TXTEST and TXFILL, clean up CF_PARAM
      Staging: et131x: kill TxMacTest field
      Staging: et131x: kill TX_PR_NUM_DES_t
      Staging: et131x: Another typedef solely used to write 0 to a register
      Staging: et131x: kill TX_SHADOW
      Staging: et131x: kill RX_DMA_MAX_PKT_TIME
      Staging: et131x: Clean up number fields
      Staging: et131x: clean up the avail fields in the rx registers

Allison Randal (1):
      Staging: comdi: ni_at_ao.c: fix coding style error

Amit Kucheria (2):
      Staging: iio: Fix typos in documentation
      Staging: iio: tsl2563 ambient light sensor driver

Andrew Lunn (1):
      staging: batman-adv meshing protocol

Andrew Morton (1):
      + drivers-staging-wlags49_h2-remove-cvs-metadata.patch added to -mm tree

André Goddard Rosa (1):
      Staging: fix assorted typos all over the place

BRAGA, Bruno (1):
      Staging: comedi: adl_pci8164 coding style fixes

Bart Massey (4):
      Staging: comedi: ni_labbc_cs: cleaned up debug define a bit
      Staging: comedi: ni_labpc_cs: removed null initialization of static
      Staging: comedi: ni_labpc_cs: removed null check from kfree
      Staging: comedi: ni_labpc_cs: wrapped long comments

Bartlomiej Zolnierkiewicz (35):
      Staging: rt3090: disable HAS_ATE option
      Staging: rt3090: disable HAS_ANTENNA_DIVERSITY_SUPPORT option
      Staging: rt3090: remove private debugging ioctls
      Staging: rt3090: remove private ioctls
      Staging: rt28x0: updates from vendor's V2.1.0.0 drivers
      Staging: rt28x0: remove unused code from common/dfs.c
      Staging: rt2860: add RT3090 chipset support
      Staging: remove no longer needed rt3090 driver
      Staging: rt28x0: remove unused ->eewrite methods
      Staging: rt28x0: remove unused code from common/ee_efuse-c
      Staging: rt28x0: remove private RTPRIV_IOCTL_SET ioctl
      Staging: rt28x0: remove private RTPRIV_IOCTL_GSITESURVEY ioctl
      Staging: rt28x0: remove private WEXT handlers
      Staging: rt28x0: remove support for private driver parameters
      Staging: rt28x0: remove optional loading of EEPROM from file in eFuse mode
      Staging: rt28x0: fix some build warnings
      Staging: rt28x0: remove optional cmm profile parameters
      Staging: rt28x0: remove dead code from rtmp_phy.h
      Staging: rt28x0: remove unused SHA256 code
      Staging: rt28x0: remove dead code
      Staging: rt28x0: remove __LINE__ instances
      Staging: rt28x0: run *.c files through Lindent
      Staging: rt28x0: run common/*.c files through Lindent
      Staging: rt28x0: run sta/*.c files through Lindent
      Staging: rt28x0: run *.h files through Lindent
      Staging: rt28x0: fix comments in *.c files
      Staging: rt28x0: fix comments in common/*.c files
      Staging: rt28x0: fix comments in sta/*.c files
      Staging: rt28x0: fix comments in *.h files
      Staging: rt28x0: remove typedefs (part one)
      Staging: rt28x0: remove typedefs (part two)
      Staging: rt28x0: remove typedefs (part three)
      Staging: rt28x0: Add proper selection of WIRELESS_EXT and WEXT_PRIV
      Staging: rt28x0: fix comments in chip/mac_pci.h
      Staging: rt28x0: remove no longer needed common/cmm_data_2860.c

Ben Kero (1):
      Staging: comedi: 8255: Fix coding style error

Bernd Porr (1):
      Staging: comedi: fix usbdux timeout bug

Bruce Jones (8):
      Staging: comedi: ni_atmio16d: fix formating errors
      Staging: comedi: ni_atmio16d: brace fixes
      Staging: comedi: nt_atmio16d: space and tab fixes
      Staging: comedi: ni_atmio16d: printk fixups
      Staging: comedi: vmk80xx: cleanup formatting
      Staging: comedi: acl7225b.c: CodingStyle printk fixups
      Staging: comedi: adl_pci7296: CodingStyle cleanup
      Staging: comedi: adl_pci7432: coding style cleanup

Daniel Patrick Johnson (4):
      Staging: comedi: ni_mio_cs.c: coding style cleanup
      Staging: Comedi: pcm_common: Fixed all checkpatch issues
      Staging: comedi: pcmmio: Coding style cleanup
      Staging: comedi: pcmmio: more coding style cleanup

Dirk Hohndel (10):
      Staging: comedi: trivial fix of a very frequent spelling mistake
      Staging: comedi: gsc_hpdi: style fixes printk
      Staging: comedi: gsc_hpdi: Fix style issues
      Staging: comedi: gsc_hdpi: style fixes static function
      Staging: comedi: icp_multi: white space style fixes
      Staging: comedi: icp_multi: fix style issue printk
      Staging: comedi: icp_multi: don't init static
      Staging: comedi: ii_pci20kc: white space fixes
      Staging: comedi: ii_pci_20kc: fix style printk
      Staging: comedi: ke_counter: fix style issues

Frederik Deweerdt (1):
      Staging: line6 driver.c: factorize code and cleanups

Greg Kroah-Hartman (7):
      Staging: comedi: 8253: fix coding style error
      Staging: dream: mark as BROKEN
      Staging: vme: fix compiler warnings in vme_ca91cx42.c
      Staging: android: delete android drivers
      Staging: add Samsung Laptop driver
      Staging: samsung-laptop: remove old kernel code
      Staging: samsung-laptop: add TODO file

Henk de Groot (3):
      Staging: wlags49_h2: add Agere driver for HERMES II and HERMES II.5 chipsets
      Staging: wlags49_h2: add TODO files
      Staging: wlags49_h2: fix up signal levels

Huang Weiyi (3):
      Staging: rtl8187se: remove unused #include <linux/version.h>
      Staging: rtl8187su: remove unused #include <linux/version.h>
      Staging: vme: remove unused #include <linux/version.h>

Ian Abbott (3):
      Staging: comedi: serial2002: decrease stack usage
      Staging: comedi: initialize divisor variables
      Staging: comedi: pcl816: update convert_src mask for AI cmdtest

Jerry Chuang (1):
      Staging: Added Realtek rtl8192u driver to staging

Jonathan Cameron (3):
      Staging: IIO: Remove tsl2561 driver. Support merged with tsl2563.
      Staging: IIO: Add tsl2560-2 support to tsl2563 driver.
      Staging: IIO: add selection of IIO_SW_RING to LIS3L02DQ as needed

Julia Lawall (1):
      Staging: slicoss: remove duplicate structure field initialization

Kevyn-Alexandre Paré (3):
      Staging: comedi: amplc_pc263.c: fix coding style issues
      Staging: comedi: amplc_pc263.c: more coding style fixes
      Staging: comedi: pcl726: fix coding style issues

Klaas van Gend (4):
      staging: comedi: multiq3: remove warning on braces
      staging: comedi: multiq3: add KERN_
      Staging: comedi: comedi_fc: checkpatch.pl fixes
      Staging: comedi: drivers: ni_6527: fixup checkpatch.pl warnings

Larry Finger (3):
      Staging: rtl8187se: Remove card8185 variable to simplify flow
      Staging: rtl8187se: Remove card_type
      Staging: rtl8187se: Rename staging driver to avoid name conflict with mainline driver

Mariusz Ziulek (1):
      staging: dst: fix coding style

Martyn Welch (7):
      staging: vme: correct array overflow
      Staging: vme: Pull common VME interrupt handling into core code
      Staging: vme: Allow size of 0 when disabling a window
      Staging: vme: Correct operation of vme_lm_free
      Staging: vme: Clean up tsi148 driver
      Staging: vme: Rename VME DMA functions
      staging: vme: Fix mutex locking

Mauro Carvalho Chehab (3):
      Staging: rtl8192u: make it compile
      Staging: rtl8192u: remove bad whitespaces
      Staging: rtl8192u: remove dead code

Mithlesh Thukral (4):
      Staging: comedi: drivers.c: checkpatch fix
      Staging: otus : checkpatch.pl cleanup for header files
      Staging: otus : checkpatch.pl cleanup for .c files
      Staging: otus : checkpatch.pl cleanup for some more .c files

Nitin Gupta (4):
      Staging: xvmalloc memory allocator
      Staging: virtual block device driver (ramzswap)
      Staging: ramzswap: documentation
      Staging: ramzswap: add TODO file

Otavio Salvador (1):
      Staging: vt6656: use lowercase for VIA USB vendor id

Paul Mundt (1):
      Staging: iio: Fix up the module build.

Pavel Machek (6):
      Staging: dream: make it independant from CONFIG_ANDROID
      Staging: dream: Synaptics touchscreen for HTC Dream: check that smbus is available
      Staging: dream: remove wakelock support
      Staging: dream: remove wakelock support from smd_rpcrouter.h
      Staging: dream: add TODO file
      Staging: dream: add gpio and pmem support

Peter Huewe (4):
      Staging: et131x: adding __init/__exit macros
      Staging: cx25821: adding __init/__exit macros
      Staging: p9auth: adding __init/__exit macros
      Staging: phison: adding __init/__exit macros

Randy Dunlap (9):
      Staging: line6: fix printk formats
      Staging: iio: kconfig and make edits
      Staging: iio: lots of doc fixes
      Staging: wlags49: fix kconfigs dependancy
      Staging: RTL8192SU depends on USB
      Staging: iio: fix ring buffer build
      Staging: vt665*: fix printk formats
      Staging: sep: fix 2 warnings
      Staging: rtl8192u: depends on USB

Robert P. J. Day (1):
      Staging: usbip: Fix typo "Contoroller".

Roel Kluin (4):
      Staging: comedi: addi-data: Cleanup redundant tests on unsigned
      Staging: octeon: don't ignore request_irq() return code
      Staging: vt6655: Correct unsigned bound issue
      Staging: dst: Fix parentheses

Sebastian Dalfuß (3):
      Staging: rt2860: remove remainders of /etc reading stuff
      Staging: rt2860: remove superfluous newlines
      Staging: rt2860: reduce superfluous exclamation marks

Shane Warden (4):
      Staging: comedi: ni_labpc.h: Fixed line lengths of some trailing comments.
      Staging: comedi: comedi_compat32: Fixed checkpatch.pl issues
      Staging: comedi: comedidev.h: Fixed checkpatch.pl issues
      Staging: comedi: comedi_compat32.h: Fixed checkpatch.pl issues

Shawn Bohrer (25):
      staging: line6: Lindent and fix checkpatch warnings in playback.c
      staging: line6: Fix checkpatch errors in playback.c
      staging: line6: Lindent and fix checkpatch warnings in capture.c
      staging: line6: Fix checkpatch errors in capture.c
      staging: line6: Lindent control.c
      staging: line6: Fix some checkpatch warnings in control.c
      staging: line6: Convert simple_strtoul() to strict_strtoul in control.c
      staging: line6: Fix checkpatch warnings in pcm.c
      staging: line6: Lindent and fix some checkpatch warnings in toneport.c
      staging: line6: Convert simple_strtol to strict_strtol in toneport.c
      staging: line6: Convert simple_strtoul to strict_strtoul in variax.c
      staging: line6: Convert simple_strtoul to strict_strtoul in pod.c
      staging: line6: Convert simple_strtoul to strict_strtoul in midi.c
      staging: comedi: Remove check for HAVE_UNLOCKED_IOCTL
      Staging: comedi: remove check for HAVE_COMPAT_IOCTL
      Staging: comedi: Don't check for -ENOIOCTLCMD
      Staging: comedi: remove __cplusplus check
      Staging: comedi: remove EXTERN macro since it is not used
      Staging: vt6655 remove kcompat.h
      Staging: vt6656 remove kcompat.h
      Staging: vt6655 remove duplicate includes
      Staging: vt6656 remove duplicate includes
      Staging: vt6655 remove unneeded version.h
      Staging: vt6656 remove unneeded version.h and version check
      Staging: vt6655: remove __cplusplus ifdefs

Vasilis Liaskovitis (1):
      Staging: b3dfg: remove check for pci bus master

Vijay Kumar (1):
      Staging: poch: Parameter to enable loopback

Vijay Kumar B (6):
      Staging: poch: Parameter to enable synthetic counter
      Staging: poch: Fetch Flush IOCTL interface
      Staging: poch: Increase groups per interrupt
      Staging: poch: Remove circular buffer header
      Staging: poch: Include linux/types.h
      Staging: poch: Add sample Rx code

Vlatko Kosturjak (1):
      Staging: comedi: adl_pci6208: code styling fix

matt mooney (2):
      Staging: comedi: mite.c: fix coding style
      Staging: comedi: mite.h: deletion of unused functions

