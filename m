Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYJMRvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYJMRvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYJMRvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:51:32 -0400
Received: from isilmar.linta.de ([213.133.102.198]:58662 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753288AbYJMRvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:51:25 -0400
Date: Mon, 13 Oct 2008 19:38:03 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates and fixes for 2.6.28
Message-ID: <20081013173803.GA18569@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The PCMCIA updates for 2.6.28 are available at

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

There's a small merge conflict due to Alan's bugfix to drivers/pcmcia/ds.c.
Could you either fix this up or explain me how to prepare the merge for you?

The diffstat and list of changes follows, the individual diffs are sent (at 
least) to the linux-pcmcia list.

Thanks,
	Dominik

----

Dominik Brodowski (50):
      pcmcia: only copy CIS override data once
      pcmcia: uniform device IDs of pata_pcmcia and ide-cs
      pcmcia: add pcmcia_loop_config() helper
      pcmcia: use pcmcia_loop_config in pata and ide drivers
      pcmcia: use pcmcia_loop_config in bluetooth drivers
      pcmcia: use pcmcia_loop_config in scsi pcmcia drivers
      pcmcia: use pcmcia_loop_config in ISDN pcmcia drivers
      pcmcia: use pcmcia_loop_config in net pcmcia drivers
      pcmcia: use pcmcia_loop_config in misc pcmcia drivers
      pcmcia: pcmcia_config_loop() ConfigIndex unification
      pcmcia: pcmcia_config_loop() default CIS entry handling
      pcmcia: pcmcia_config_loop() improvement by passing vcc
      pcmcia: use dev_printk and dev_dbg in yenta_socket
      pcmcia: use dev_printk in module pcmcia_core
      pcmcia: use dev_printk in module pcmcia
      pcmcia: use dev_printk in module rsrc_nonstatic
      pcmcia: remove unused cs_socket_name() definition
      pcmcia: don't add extra DEBUG cflag
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
      pcmcia: cs_internal.h is internal
      pcmcia: cleanup cs_internal.h
      pcmcia: merge ds_internal.h into cs_internal.h
      pcmcia: cleanup socket services header file
      pcmcia: cleanup device driver header file
      pcmcia: encapsulate ioaddr_t
      pcmcia: device_id header cleanup
      pcmcia: card services header cleanup
      pcmcia: remove unused argument to pcmcia_parse_tuple()
      pcmcia: cistpl header cleanup
      pcmcia: ioctl-internal definitions

 Documentation/pcmcia/driver-changes.txt |    6 +
 drivers/ata/pata_pcmcia.c               |  168 ++++++-------
 drivers/bluetooth/bluecard_cs.c         |    8 +-
 drivers/bluetooth/bt3c_cs.c             |  125 ++++------
 drivers/bluetooth/btuart_cs.c           |  126 ++++------
 drivers/bluetooth/dtl1_cs.c             |   67 ++----
 drivers/char/pcmcia/cm4000_cs.c         |   73 ++----
 drivers/char/pcmcia/cm4040_cs.c         |   80 +++----
 drivers/char/pcmcia/ipwireless/main.c   |   54 ++---
 drivers/char/pcmcia/synclink_cs.c       |    2 +-
 drivers/ide/legacy/ide-cs.c             |  158 ++++++-------
 drivers/isdn/hardware/avm/avm_cs.c      |   85 ++-----
 drivers/isdn/hisax/avma1_cs.c           |   81 ++-----
 drivers/isdn/hisax/elsa_cs.c            |   79 ++----
 drivers/isdn/hisax/sedlbauer_cs.c       |  197 +++++++--------
 drivers/isdn/hisax/teles_cs.c           |   79 ++----
 drivers/mtd/maps/pcmciamtd.c            |   34 +--
 drivers/net/pcmcia/3c574_cs.c           |    7 +-
 drivers/net/pcmcia/3c589_cs.c           |    7 +-
 drivers/net/pcmcia/axnet_cs.c           |   80 +++----
 drivers/net/pcmcia/com20020_cs.c        |    8 +-
 drivers/net/pcmcia/fmvj18x_cs.c         |   21 +-
 drivers/net/pcmcia/ibmtr_cs.c           |    2 +-
 drivers/net/pcmcia/nmclan_cs.c          |    2 +-
 drivers/net/pcmcia/pcnet_cs.c           |   86 +++----
 drivers/net/pcmcia/smc91c92_cs.c        |  151 +++++-------
 drivers/net/pcmcia/xirc2ps_cs.c         |   79 ++++---
 drivers/net/wireless/airo_cs.c          |  222 +++++++++---------
 drivers/net/wireless/atmel_cs.c         |  119 ++++-----
 drivers/net/wireless/b43/pcmcia.c       |   16 +-
 drivers/net/wireless/hostap/hostap_cs.c |  237 ++++++++----------
 drivers/net/wireless/libertas/if_cs.c   |    2 +-
 drivers/net/wireless/netwave_cs.c       |    5 +-
 drivers/net/wireless/orinoco_cs.c       |  165 ++++++-------
 drivers/net/wireless/ray_cs.c           |    4 +-
 drivers/net/wireless/spectrum_cs.c      |  162 +++++-------
 drivers/net/wireless/wavelan_cs.c       |   16 +-
 drivers/net/wireless/wl3501_cs.c        |    4 +-
 drivers/parport/parport_cs.c            |   70 +++---
 drivers/pcmcia/Makefile                 |    4 -
 drivers/pcmcia/au1000_generic.c         |    2 +-
 drivers/pcmcia/au1000_generic.h         |    2 +-
 drivers/pcmcia/au1000_pb1x00.c          |    1 -
 drivers/pcmcia/au1000_xxs1500.c         |    1 -
 drivers/pcmcia/cardbus.c                |    2 +-
 drivers/pcmcia/cistpl.c                 |  297 +++++++++++++---------
 drivers/pcmcia/cs.c                     |   78 +++---
 drivers/pcmcia/cs_internal.h            |  226 +++++++++++++-----
 drivers/pcmcia/ds.c                     |  239 ++++++++-----------
 drivers/pcmcia/ds_internal.h            |   23 --
 drivers/pcmcia/hd64465_ss.c             |    1 -
 drivers/pcmcia/i82365.c                 |    2 +-
 drivers/pcmcia/m32r_cfc.c               |    4 +-
 drivers/pcmcia/m32r_pcc.c               |    4 +-
 drivers/pcmcia/m8xx_pcmcia.c            |    4 +-
 drivers/pcmcia/o2micro.h                |   10 +-
 drivers/pcmcia/pcmcia_ioctl.c           |  120 +++++++--
 drivers/pcmcia/pcmcia_resource.c        |  381 ++++++++++++++++-------------
 drivers/pcmcia/pxa2xx_base.c            |    1 -
 drivers/pcmcia/rsrc_nonstatic.c         |   67 +++---
 drivers/pcmcia/soc_common.c             |    2 +-
 drivers/pcmcia/soc_common.h             |    3 +-
 drivers/pcmcia/socket_sysfs.c           |   13 +-
 drivers/pcmcia/tcic.c                   |    2 +-
 drivers/pcmcia/ti113x.h                 |   78 ++++---
 drivers/pcmcia/yenta_socket.c           |   86 ++++---
 drivers/scsi/pcmcia/aha152x_stub.c      |   58 ++---
 drivers/scsi/pcmcia/fdomain_stub.c      |   37 ++--
 drivers/scsi/pcmcia/nsp_cs.c            |  194 +++++++--------
 drivers/scsi/pcmcia/qlogic_stub.c       |   47 ++--
 drivers/scsi/pcmcia/sym53c500_cs.c      |   46 ++--
 drivers/serial/serial_cs.c              |  302 ++++++++++-------------
 drivers/ssb/pcmcia.c                    |   22 +-
 drivers/telephony/ixj_pcmcia.c          |   72 +++----
 drivers/usb/host/sl811_cs.c             |  133 ++++------
 include/pcmcia/ciscode.h                |    2 +-
 include/pcmcia/cistpl.h                 |   38 ---
 include/pcmcia/cs.h                     |  165 +------------
 include/pcmcia/cs_types.h               |    8 -
 include/pcmcia/device_id.h              |   18 ++-
 include/pcmcia/ds.h                     |  411 +++++++++++++++++++++++--------
 include/pcmcia/ss.h                     |  202 +++++++--------
 82 files changed, 3005 insertions(+), 3290 deletions(-)
 delete mode 100644 drivers/pcmcia/ds_internal.h
