Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZCXOBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZCXOBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZCXOBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:01:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60127 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755564AbZCXOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:01:19 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/30] Serial and tty for 2.6.30
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:01:40 +0000
Message-ID: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly consolidation work and in part reflects the fact I've been
between jobs relaxing. There are quite a few niggling little bug fixes here
that will probably become candidates for 2.6.29.foo

Alan


---

Alan Cox (2):
      ucc: Fix leaky error path
      isicom: isicom kref leak fix

Alexander Beregalov (1):
      mux: fix build problem

Breno Leitao (3):
      icom: remove unused variables
      jsm: define init function as __devinit
      jsm: Fix the return variable and removing the unused retval.

Clark Williams (1):
      disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE

Danny Kukawka (1):
      8250_pnp.c: add another Wacom tablet

Graf Yang (2):
      blackfin: Subtract ANOMALY_05000230 on quot
      Use barrier instead of cpu_relax for early blackfin boot

Jiri Slaby (3):
      mxser: remove tty_port_tty_get from mxser_check_modem_status
      tty: moxa, fix refcounting in moxa_poll_port
      PCI: quirks, don't mark one netmos as class other

Kay Sievers (1):
      vcs: hook sysfs devices into object lifetime instead of "binding"

Matthew Garrett (1):
      serial: Update PNP IDs

Michael Hennerich (1):
      blackfin: BF538/9 serial uart support

Mike Frysinger (2):
      blackfin: Use unsigned long for flags with irq functions
      blackfin: Explain why we cannot cpu_relax() in early serial code

Roel Kluin (1):
      rio: addition has higher precedence than ?:

Scott James Remnant (5):
      riscom8: Auto-load riscom8 module when device opened.
      usb: Auto-load cdc_acm module when device opened.
      specialix: Auto-load specialix module when device opened.
      cyclades: Auto-load cyclades module when device opened.
      applicom: Auto-load applicom module when device opened.

Shawn Bohrer (1):
      8250_pci: add support for National Instruments 843x RS232 devices

Sonic Zhang (2):
      Fix DMA rx ring buffer handling
      blackfin: Fix tty compile error in PIO mode

Sukadev Bhattiprolu (1):
      devpts: must release s_umount on error

Xiaotian Feng (1):
      cpm_uart: fix non-console port startup bug


 drivers/char/applicom.c                 |    1 
 drivers/char/cyclades.c                 |    2 
 drivers/char/isicom.c                   |    1 
 drivers/char/moxa.c                     |    9 -
 drivers/char/mxser.c                    |    1 
 drivers/char/rio/rio_linux.c            |    2 
 drivers/char/riscom8.c                  |    2 
 drivers/char/specialix.c                |    1 
 drivers/char/vc_screen.c                |   16 +
 drivers/char/vt.c                       |    5 
 drivers/pci/quirks.c                    |    6 
 drivers/serial/8250_pci.c               |  411 +++++++++++++++++++++++++++++++
 drivers/serial/8250_pnp.c               |    7 -
 drivers/serial/Kconfig                  |    4 
 drivers/serial/bfin_5xx.c               |   22 +-
 drivers/serial/cpm_uart/cpm_uart_core.c |   14 +
 drivers/serial/icom.c                   |   14 -
 drivers/serial/jsm/jsm_driver.c         |    9 -
 drivers/serial/jsm/jsm_tty.c            |    4 
 drivers/serial/ucc_uart.c               |    1 
 drivers/usb/class/cdc-acm.c             |    2 
 fs/devpts/inode.c                       |    2 
 include/linux/console.h                 |    4 
 include/linux/pci_ids.h                 |   26 ++
 include/linux/serial_core.h             |    2 
 25 files changed, 516 insertions(+), 52 deletions(-)

-- 
