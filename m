Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbYHRSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbYHRSzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbYHRSyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:54:20 -0400
Received: from isilmar.linta.de ([213.133.102.198]:35935 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760868AbYHRSyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:54:09 -0400
Date: Mon, 18 Aug 2008 20:50:25 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC] PCMCIA patches for 2.6.28
Message-ID: <20080818185025.GA11647@comet.dominikbrodowski.net>
Mail-Followup-To: linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following pcmcia-related patches are in the queue for 2.6.28 and
are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git

Comments, reviews and feedback are welcome. The diffstat and list of changes
follows; the individual diffs are sent (at least) to the linux-pcmcia list.

Dominik Brodowski (40):
      pcmcia: only copy CIS override data once
      pcmcia: add pcmcia_loop_config() helper
      pcmcia: use pcmcia_loop_config in pata and ide drivers
      pcmcia: use pcmcia_loop_config in bluetooth drivers
      pcmcia: use dev_printk and dev_dbg in yenta_socket
      pcmcia: use dev_printk in module pcmcia_core
      pcmcia: use dev_printk in module pcmcia
      pcmcia: use dev_printk in module rsrc_nonstatic
      pcmcia: don't add extra DEBUG cflag
      pcmcia: remove unused cs_socket_name() definition
      pcmcia: use pcmcia_loop_config in scsi pcmcia drivers
      pcmcia: use pcmcia_loop_config in ISDN pcmcia drivers
      pcmcia: use pcmcia_loop_config in net pcmcia drivers
      pcmcia: use pcmcia_loop_config in misc pcmcia drivers
      pcmcia: pcmcia_config_loop() ConfigIndex unification
      pcmcia: pcmcia_config_loop() default CIS entry handling
      pcmcia: pcmcia_config_loop() improvement by passing vcc
      Merge branches 'pcmcia-config-loop' and 'pcmcia-printk' into pcmcia
      pcmcia: remove remaining in-kernel pcmcia_get_configuration_info() users
      pcmcia: move pccard_get_configuration_info to ioctl
      pcmcia: move config_info_t definition to ioctl-related parts in header files
      pcmcia: deprecate CS_SUCCESS
      pcmcia: deprecate unused CS_ error codes
      pcmcia: deprecate CS_OUT_OF_RESOURCE
      pcmcia: deprecate CS_UNSUPPORTED_*
      pcmcia: deprecate CS_BAD_VCC and CS_BAD_VPP
      pcmcia: deprecate CS_NO_CARD
      pcmcia: deprecate CS_GENERAL_FAILURE
      pcmcia: deprecate CS_BAD_HANDLE
      pcmcia: deprecate CS_CONFIGURATION_LOCKED
      pcmcia: deprecate CS_IN_USE
      pcmcia: deprecate CS_NO_MORE_ITEMS
      pcmcia: deprecate CS_BAD_ATTRIBUTE, CS_BAD_TYPE and CS_BAD_PAGE
      pcmcia: deprecate CS_BAD_BASE, CS_BAD_IRQ, CS_BAD_OFFSET and CS_BAD_SIZE
      pcmcia: deprecate CS_BAD_ARGS
      pcmcia: deprecate CS_BAD_TUPLE
      pcmcia: remove CS_ error codes alltogether
      pcmcia: use dev_printk for cs_error()
      pcmcia: uniform device IDs of pata_pcmcia and ide-cs
      pcmcia: don't add extra DEBUG cflag bugfix

 Documentation/pcmcia/driver-changes.txt |    6 +
 drivers/ata/pata_pcmcia.c               |  168 ++++++--------
 drivers/bluetooth/bluecard_cs.c         |    8 +-
 drivers/bluetooth/bt3c_cs.c             |  123 ++++------
 drivers/bluetooth/btuart_cs.c           |  124 ++++------
 drivers/bluetooth/dtl1_cs.c             |   67 ++-----
 drivers/char/pcmcia/cm4000_cs.c         |   73 ++----
 drivers/char/pcmcia/cm4040_cs.c         |   79 +++----
 drivers/char/pcmcia/ipwireless/main.c   |   46 ++---
 drivers/ide/legacy/ide-cs.c             |  155 ++++++-------
 drivers/isdn/hardware/avm/avm_cs.c      |   85 +++-----
 drivers/isdn/hisax/avma1_cs.c           |   81 ++-----
 drivers/isdn/hisax/elsa_cs.c            |   77 ++-----
 drivers/isdn/hisax/sedlbauer_cs.c       |  197 ++++++++---------
 drivers/isdn/hisax/teles_cs.c           |   77 ++-----
 drivers/mtd/maps/pcmciamtd.c            |   26 +--
 drivers/net/pcmcia/3c574_cs.c           |    6 +-
 drivers/net/pcmcia/3c589_cs.c           |    6 +-
 drivers/net/pcmcia/axnet_cs.c           |   77 +++----
 drivers/net/pcmcia/com20020_cs.c        |    8 +-
 drivers/net/pcmcia/fmvj18x_cs.c         |   18 +-
 drivers/net/pcmcia/ibmtr_cs.c           |    2 +-
 drivers/net/pcmcia/pcnet_cs.c           |   85 ++++----
 drivers/net/pcmcia/smc91c92_cs.c        |  138 +++++-------
 drivers/net/pcmcia/xirc2ps_cs.c         |   75 ++++---
 drivers/net/wireless/airo_cs.c          |  222 +++++++++---------
 drivers/net/wireless/atmel_cs.c         |  119 +++++------
 drivers/net/wireless/b43/pcmcia.c       |   14 +-
 drivers/net/wireless/hostap/hostap_cs.c |  235 +++++++++-----------
 drivers/net/wireless/netwave_cs.c       |    4 +-
 drivers/net/wireless/orinoco_cs.c       |  163 ++++++--------
 drivers/net/wireless/ray_cs.c           |    4 +-
 drivers/net/wireless/spectrum_cs.c      |  162 ++++++--------
 drivers/net/wireless/wavelan_cs.c       |   16 +-
 drivers/net/wireless/wl3501_cs.c        |    4 +-
 drivers/parport/parport_cs.c            |   70 +++----
 drivers/pcmcia/Makefile                 |    4 -
 drivers/pcmcia/cardbus.c                |    2 +-
 drivers/pcmcia/cistpl.c                 |  240 +++++++++++----------
 drivers/pcmcia/cs.c                     |   72 +++---
 drivers/pcmcia/cs_internal.h            |   11 +-
 drivers/pcmcia/ds.c                     |  238 +++++++++-----------
 drivers/pcmcia/ds_internal.h            |    2 +-
 drivers/pcmcia/m32r_cfc.c               |    2 +-
 drivers/pcmcia/m32r_pcc.c               |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c            |    4 +-
 drivers/pcmcia/o2micro.h                |    6 +-
 drivers/pcmcia/pcmcia_ioctl.c           |  114 ++++++++--
 drivers/pcmcia/pcmcia_resource.c        |  374 +++++++++++++++++--------------
 drivers/pcmcia/rsrc_nonstatic.c         |   67 +++---
 drivers/pcmcia/soc_common.c             |    2 +-
 drivers/pcmcia/socket_sysfs.c           |   13 +-
 drivers/pcmcia/tcic.c                   |    2 +-
 drivers/pcmcia/ti113x.h                 |   70 +++---
 drivers/pcmcia/yenta_socket.c           |   77 ++++---
 drivers/scsi/pcmcia/aha152x_stub.c      |   58 +++---
 drivers/scsi/pcmcia/fdomain_stub.c      |   37 ++--
 drivers/scsi/pcmcia/nsp_cs.c            |  192 ++++++++--------
 drivers/scsi/pcmcia/qlogic_stub.c       |   47 ++---
 drivers/scsi/pcmcia/sym53c500_cs.c      |   46 ++--
 drivers/serial/serial_cs.c              |  300 +++++++++++--------------
 drivers/ssb/pcmcia.c                    |   22 +-
 drivers/telephony/ixj_pcmcia.c          |   72 +++----
 drivers/usb/host/sl811_cs.c             |  130 +++++-------
 include/pcmcia/cistpl.h                 |   18 +-
 include/pcmcia/cs.h                     |   55 -----
 include/pcmcia/ds.h                     |   43 ++++-
 include/pcmcia/ss.h                     |    4 +-
 68 files changed, 2346 insertions(+), 2800 deletions(-)
