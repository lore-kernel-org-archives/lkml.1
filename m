Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434Ab0B0Kod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:44:33 -0500
Received: from isilmar.linta.de ([213.133.102.198]:56258 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965301Ab0B0Koa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:44:30 -0500
Date: Sat, 27 Feb 2010 11:39:34 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA updates for 2.6.34
Message-ID: <20100227103934.GA4430@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

several PCMCIA updates for 2.6.33 are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Please pull from that location. The diffstat and list of changes is below,
the individual diffs are sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik

Dominik Brodowski (41):
      pcmcia: make use of pcmcia_dev_resume() return value
      pcmcia: remove remaining unused IRQ_FIRST_SHARED parameter
      pcmcia: do not meddle with already assigned resources
      pcmcia: validate CIS, not CIS cache.
      pcmcia: cleanup pccard_validate_cis()
      pcmcia: improve check for same card in slot after resume
      pcmcia: CardBus doesn't need CIS access
      pcmcia: call CIS cleanup from ds.c
      pcmcia: rsrc_nonstatic io memory probe improvements
      pcmcia: do not lock socket driver module in pcmcia_get_socket()
      pcmcia: do not lock socket driver module on card insert
      pcmcia: remove useless indirection
      pcmcia: remove some rsrc_mgr indirections
      pcmcia: m32r uses static socket resources
      pcmcia: m8xx_pcmcia.c should use iodyn resource manager
      pcmcia: move cistpl.c into pcmcia module
      pcmcia: remove remaining rsrc_mgr indirections
      pcmcia: do not use resource manager on !PCMCIA
      pcmcia: add locking to set_mem_map()
      pcmcia: also lock fake and cache CIS by ops_mutex
      pcmcia: lock ops->set_io_map()
      pcmcia: lock ops->set_socket
      pcmcia: properly lock skt->irq, skt->irq_mask
      pcmcia: protect s->device_count
      pcmcia: add locking to struct pcmcia_socket->pcmcia_state()
      pcmcia: simplify locking
      pcmcia: add locking documentation
      pcmcia: assert locking to struct pcmcia_device
      pcmcia: use mutex for dynid lock
      pcmcia: use ops_mutex for rsrc_{mgr,nonstatic} locking
      pcmcia: use pccardd to handle eject, insert, suspend and resume requests
      pcmcia: delay re-scanning and re-querying of PCMCIA bus
      pcmcia: use state machine for extended requery
      pcmcia: avoid sysfs-related lockup for cardbus
      pcmcia: avoid prod_id memleak
      pcmcia: add locking to pcmcia_{read,write}_cis_mem
      pcmcia: handle error in serial_cs config calls
      pcmcia: use read_cis_mem return value
      pcmcia: remove useless msleep in ds.c
      pcmcia: allow for extension of resource interval
      pcmcia: validate late-added resources

H Hartley Sweeten (1):
      cm4000_cs.c: Remove unnecessary cast

Michal Marek (1):
      pcmcia: fix yenta dependency on PCCARD_NONSTATIC

Márton Németh (1):
      pcmcia: make Open Firmware device id constant

Uwe Kleine-König (3):
      pcmcia/bfin_cf: don't check platform_get_irq's return value against zero
      pcmcia/at91_cf: don't redefine SZ_2K
      pcmcia/omap_cf: don't redefine SZ_2K

Wolfram Sang (2):
      pcmcia/yenta: add module parameter for O2 speedups
      pcmcia/i82365: fix typos in comments

 Documentation/pcmcia/locking.txt |  118 ++++++++
 drivers/char/pcmcia/cm4000_cs.c  |    2 +-
 drivers/net/pcmcia/smc91c92_cs.c |    6 +-
 drivers/pcmcia/Kconfig           |    9 +-
 drivers/pcmcia/Makefile          |    4 +-
 drivers/pcmcia/at91_cf.c         |    2 -
 drivers/pcmcia/bfin_cf_pcmcia.c  |    2 +-
 drivers/pcmcia/cardbus.c         |  175 +----------
 drivers/pcmcia/cistpl.c          |  606 +++++++++++++++++++++-----------------
 drivers/pcmcia/cs.c              |  312 +++++++++-----------
 drivers/pcmcia/cs_internal.h     |   89 ++----
 drivers/pcmcia/ds.c              |  333 ++++++++++++---------
 drivers/pcmcia/electra_cf.c      |    2 +-
 drivers/pcmcia/i82365.h          |    4 +-
 drivers/pcmcia/m32r_cfc.c        |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c     |    4 +-
 drivers/pcmcia/o2micro.h         |   45 ++-
 drivers/pcmcia/omap_cf.c         |    2 -
 drivers/pcmcia/pcmcia_ioctl.c    |   42 ++--
 drivers/pcmcia/pcmcia_resource.c |  169 +++++++++---
 drivers/pcmcia/rsrc_mgr.c        |   48 ---
 drivers/pcmcia/rsrc_nonstatic.c  |  285 +++++++++++-------
 drivers/pcmcia/socket_sysfs.c    |  196 ++-----------
 drivers/pcmcia/yenta_socket.c    |    5 +
 drivers/serial/serial_cs.c       |    7 +-
 include/pcmcia/ds.h              |    2 +-
 include/pcmcia/ss.h              |   40 ++-
 27 files changed, 1257 insertions(+), 1254 deletions(-)
 create mode 100644 Documentation/pcmcia/locking.txt
