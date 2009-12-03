Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZLCICy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZLCICy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZLCICy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:02:54 -0500
Received: from isilmar.linta.de ([213.133.102.198]:41830 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751849AbZLCICx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:02:53 -0500
Date: Thu, 3 Dec 2009 09:02:41 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates for 2.6.33
Message-ID: <20091203080241.GA21400@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20091024082400.GA28377@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091024082400.GA28377@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

several PCMCIA updates for 2.6.33 are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Please pull from that location. The diffstat and list of changes is below.

Thanks,
        Dominik

----

Avi Cohen Stuart (1):
      pcmcia: correct handling for Zoomed Video registers in topic.h

Dominik Brodowski (32):
      serial_cs: use pcmcia_loop_config() and pre-determined values
      pcmcia: use pre-determined values
      pcmcia: use pcmcia_loop_config in misc pcmcia drivers
      ipwireless: make more use of pcmcia_loop_config()
      pcmcia: add new CIS access helpers
      pcmcia: convert net pcmcia drivers to use new CIS helpers
      pcmcia: convert ssb pcmcia driver to use new CIS helpers
      pcmcia: convert pcmciamtd driver to use new CIS helpers
      pcmcia: remove pcmcia_get_{first,next}_tuple()
      pcmcia: use dynamic debug instead of custom infrastructure
      pcmcia: use dynamic debug in PCMCIA socket drivers
      pcmcia: extend error reporting and debug messages in core
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (ide)
      pcmcia: deprecate CS_CHECK (bluetooth)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (char)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (isdn)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (net)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (ray-cs.c)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (wireless)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (scsi)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (serial_cs)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (sound)
      pcmcia: use dynamic debug infrastructure, deprecate CS_CHECK (misc drivers)
      pcmcia: remove now-defunct cs_error, pcmcia_error_{func,ret}
      pcmcia: use dev_dbg and dev_print in pd6729.c
      pcmcia/staging: update comedi drivers
      pcmcia: autoload module pcmcia
      pcmcia: move some window-related code to pcmcia_ioctl.c
      pcmcia: remove unused "window_t" typedef
      pcmcia: pcmcia_request_window() doesn't need a pointer to a pointer
      pcmcia: remove deprecated handle_to_dev() macro
      pcmcia: rework the irq_req_t typedef

Julia Lawall (1):
      drivers/pcmcia: remove unnecessary kzalloc

Magnus Damm (4):
      pcmcia: Pass struct pcmcia_device to pcmcia_release_window()
      pcmcia: Pass struct pcmcia_device to pcmcia_map_mem_page()
      pcmcia: Pass struct pcmcia_socket to pcmcia_get_mem_page()
      pcmcia: Change window_handle_t logic to unsigned long

Randy Dunlap (1):
      pcmcia: fix printk formats

Russell King - ARM Linux (10):
      PCMCIA: soc_common: convert to a stand alone module
      PCMCIA: soc_common: provide single socket add/remove functionality
      PCMCIA: soc_common: push socket removal down to SoC specific support
      PCMCIA: soc_common: push socket probe down into SoC specific support
      PCMCIA: sa1111: wrap soc_pcmcia_socket to contain sa1111 specific data
      PCMCIA: sa1111: remove duplicated initializers
      PCMCIA: soc_common: constify soc_pcmcia_socket ops member
      PCMCIA: soc_common: remove 'dev' member from soc_pcmcia_socket
      PCMCIA: ss: allow PCI IRQs > 255
      PCMCIA: stop duplicating pci_irq in soc_pcmcia_socket

Wolfram Sang (1):
      pcmcia: drop already defined PCI_IDs


 Documentation/pcmcia/driver-changes.txt          |   12 +
 drivers/ata/pata_pcmcia.c                        |   17 +-
 drivers/bluetooth/bluecard_cs.c                  |   16 +-
 drivers/bluetooth/bt3c_cs.c                      |   13 +-
 drivers/bluetooth/btuart_cs.c                    |   13 +-
 drivers/bluetooth/dtl1_cs.c                      |   12 +-
 drivers/char/pcmcia/cm4000_cs.c                  |   73 ++--
 drivers/char/pcmcia/cm4040_cs.c                  |   52 +--
 drivers/char/pcmcia/ipwireless/hardware.c        |    8 +-
 drivers/char/pcmcia/ipwireless/main.c            |  296 +++++---------
 drivers/char/pcmcia/synclink_cs.c                |   80 ++---
 drivers/ide/ide-cs.c                             |   33 +-
 drivers/isdn/hardware/avm/avm_cs.c               |    4 -
 drivers/isdn/hisax/avma1_cs.c                    |   28 +--
 drivers/isdn/hisax/elsa_cs.c                     |   46 +--
 drivers/isdn/hisax/sedlbauer_cs.c                |   64 +--
 drivers/isdn/hisax/teles_cs.c                    |   38 +--
 drivers/mtd/maps/pcmciamtd.c                     |  197 +++++-----
 drivers/net/pcmcia/3c574_cs.c                    |   90 ++---
 drivers/net/pcmcia/3c589_cs.c                    |  102 ++---
 drivers/net/pcmcia/axnet_cs.c                    |   56 +--
 drivers/net/pcmcia/com20020_cs.c                 |   63 ++--
 drivers/net/pcmcia/fmvj18x_cs.c                  |  189 ++++-----
 drivers/net/pcmcia/ibmtr_cs.c                    |   71 ++--
 drivers/net/pcmcia/nmclan_cs.c                   |  173 ++++-----
 drivers/net/pcmcia/pcnet_cs.c                    |   80 ++---
 drivers/net/pcmcia/smc91c92_cs.c                 |  340 +++++-----------
 drivers/net/pcmcia/xirc2ps_cs.c                  |  259 +++++-------
 drivers/net/wireless/airo_cs.c                   |   55 +--
 drivers/net/wireless/atmel_cs.c                  |   51 +--
 drivers/net/wireless/b43/pcmcia.c                |   26 +--
 drivers/net/wireless/hostap/hostap_cs.c          |   51 +--
 drivers/net/wireless/libertas/if_cs.c            |   72 ++--
 drivers/net/wireless/netwave_cs.c                |   95 ++---
 drivers/net/wireless/orinoco/orinoco_cs.c        |   33 +-
 drivers/net/wireless/orinoco/spectrum_cs.c       |   60 ++--
 drivers/net/wireless/ray_cs.c                    |  357 ++++++++--------
 drivers/net/wireless/wavelan_cs.c                |   35 +--
 drivers/net/wireless/wl3501_cs.c                 |   74 ++---
 drivers/parport/parport_cs.c                     |   38 +--
 drivers/pcmcia/Kconfig                           |   42 ++-
 drivers/pcmcia/Makefile                          |   10 +-
 drivers/pcmcia/cardbus.c                         |    4 +-
 drivers/pcmcia/cirrus.h                          |   10 -
 drivers/pcmcia/cistpl.c                          |   71 +++-
 drivers/pcmcia/cs.c                              |   67 ++--
 drivers/pcmcia/cs_internal.h                     |   42 +--
 drivers/pcmcia/ds.c                              |  188 ++-------
 drivers/pcmcia/i82365.c                          |   37 +--
 drivers/pcmcia/m32r_cfc.c                        |  105 ++---
 drivers/pcmcia/m32r_pcc.c                        |   51 +--
 drivers/pcmcia/m8xx_pcmcia.c                     |   40 +--
 drivers/pcmcia/o2micro.h                         |   22 -
 drivers/pcmcia/pcmcia_ioctl.c                    |   92 +++--
 drivers/pcmcia/pcmcia_resource.c                 |  482 ++++++++++++++--------
 drivers/pcmcia/pd6729.c                          |   70 ++--
 drivers/pcmcia/pd6729.h                          |    7 -
 drivers/pcmcia/pxa2xx_base.c                     |   94 +++--
 drivers/pcmcia/pxa2xx_base.h                     |    3 +
 drivers/pcmcia/pxa2xx_cm_x255.c                  |    2 +-
 drivers/pcmcia/pxa2xx_cm_x270.c                  |    2 +-
 drivers/pcmcia/pxa2xx_e740.c                     |    2 +-
 drivers/pcmcia/pxa2xx_lubbock.c                  |   14 +-
 drivers/pcmcia/pxa2xx_mainstone.c                |    2 +-
 drivers/pcmcia/pxa2xx_palmld.c                   |    2 +-
 drivers/pcmcia/pxa2xx_palmtx.c                   |    2 +-
 drivers/pcmcia/pxa2xx_sharpsl.c                  |    2 +-
 drivers/pcmcia/pxa2xx_trizeps4.c                 |    4 +-
 drivers/pcmcia/pxa2xx_viper.c                    |    2 +-
 drivers/pcmcia/rsrc_mgr.c                        |    1 +
 drivers/pcmcia/sa1100_assabet.c                  |    2 +-
 drivers/pcmcia/sa1100_badge4.c                   |   11 +-
 drivers/pcmcia/sa1100_cerf.c                     |    2 +-
 drivers/pcmcia/sa1100_generic.c                  |   11 +-
 drivers/pcmcia/sa1100_h3600.c                    |    4 +-
 drivers/pcmcia/sa1100_jornada720.c               |   42 +--
 drivers/pcmcia/sa1100_neponset.c                 |   13 +-
 drivers/pcmcia/sa1100_shannon.c                  |    2 +-
 drivers/pcmcia/sa1100_simpad.c                   |    2 +-
 drivers/pcmcia/sa1111_generic.c                  |   65 +++-
 drivers/pcmcia/sa1111_generic.h                  |   17 +-
 drivers/pcmcia/sa11xx_base.c                     |   99 +++--
 drivers/pcmcia/sa11xx_base.h                     |    2 +
 drivers/pcmcia/soc_common.c                      |  225 +++++------
 drivers/pcmcia/soc_common.h                      |   10 +-
 drivers/pcmcia/tcic.c                            |   29 +-
 drivers/pcmcia/topic.h                           |   15 +-
 drivers/scsi/pcmcia/aha152x_stub.c               |   42 +--
 drivers/scsi/pcmcia/fdomain_stub.c               |   44 +--
 drivers/scsi/pcmcia/nsp_cs.c                     |    8 +-
 drivers/scsi/pcmcia/qlogic_stub.c                |   45 +--
 drivers/scsi/pcmcia/sym53c500_cs.c               |   42 +--
 drivers/serial/serial_cs.c                       |  143 ++-----
 drivers/ssb/pcmcia.c                             |  232 ++++++-----
 drivers/staging/comedi/drivers/cb_das16_cs.c     |  221 +++--------
 drivers/staging/comedi/drivers/das08_cs.c        |  203 +++-------
 drivers/staging/comedi/drivers/ni_daq_700.c      |  237 ++++-------
 drivers/staging/comedi/drivers/ni_daq_dio24.c    |  236 ++++-------
 drivers/staging/comedi/drivers/ni_labpc_cs.c     |  225 ++++-------
 drivers/staging/comedi/drivers/ni_mio_cs.c       |  127 ++-----
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |  219 +++--------
 drivers/telephony/ixj_pcmcia.c                   |   36 +-
 drivers/usb/host/sl811_cs.c                      |   49 +--
 include/linux/pci_ids.h                          |    2 +
 include/pcmcia/cs.h                              |   14 +-
 include/pcmcia/cs_types.h                        |    3 +-
 include/pcmcia/ds.h                              |   88 ++---
 include/pcmcia/ss.h                              |   13 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c               |   27 +-
 sound/pcmcia/vx/vxpocket.c                       |   27 +-
 110 files changed, 3081 insertions(+), 4597 deletions(-)
