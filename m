Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXDFSoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXDFSoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXDFSoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:44:38 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39330 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXDFSog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:44:36 -0400
Date: Fri, 6 Apr 2007 11:42:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.20.5
Message-ID: <20070406184208.GR10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.5 kernel.
It contains a number of important bugfixes including a fix for possible
remote DoS.

f8c08c340b83: APPLETALK: Fix a remotely triggerable crash [CVE-2007-1357] 

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.4 and 2.6.20.5.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,
-chris
--------

 Makefile                                |    2 
 arch/um/include/sysdep-x86_64/ptrace.h  |    4 -
 arch/um/os-Linux/elf_aux.c              |    3 
 arch/um/os-Linux/skas/mem.c             |   10 ++-
 arch/um/os-Linux/skas/process.c         |    6 -
 arch/um/os-Linux/sys-i386/registers.c   |    5 -
 arch/um/os-Linux/sys-x86_64/registers.c |    4 -
 arch/um/sys-i386/delay.c                |   11 ---
 arch/um/sys-x86_64/delay.c              |   11 ---
 crypto/scatterwalk.c                    |    4 -
 drivers/ata/libata-core.c               |   11 +++
 drivers/ata/libata-scsi.c               |    1 
 drivers/ata/sata_mv.c                   |   31 +++++++---
 drivers/ata/sata_nv.c                   |   10 +++
 drivers/char/generic_serial.c           |    7 --
 drivers/ide/ide-cd.c                    |   15 ++--
 drivers/ide/ide-io.c                    |   11 +++
 drivers/ide/ide-iops.c                  |    9 ++
 drivers/ide/ide.c                       |    1 
 drivers/ide/pci/jmicron.c               |   29 +++++++--
 drivers/ide/pci/piix.c                  |   67 +++++++++++++++-------
 drivers/ieee1394/dv1394.c               |   12 +--
 drivers/media/dvb/dvb-core/dmxdev.c     |   12 ---
 drivers/media/dvb/dvb-core/dvb_demux.c  |   21 ++----
 drivers/media/dvb/dvb-core/dvbdev.c     |    9 --
 drivers/media/dvb/frontends/isl6421.c   |    1 
 drivers/media/dvb/frontends/nxt200x.c   |    4 -
 drivers/media/radio/Kconfig             |    2 
 drivers/media/video/msp3400-driver.c    |    4 -
 drivers/media/video/saa7115.c           |    2 
 drivers/message/i2o/i2o_block.c         |   12 ---
 drivers/net/ppp_generic.c               |    3 
 drivers/video/ffb.c                     |   84 +++++++++++++++++++--------
 fs/cifs/inode.c                         |   21 +++++-
 fs/cifs/readdir.c                       |    4 +
 include/asm-sparc/mostek.h              |    2 
 include/asm-sparc64/mostek.h            |    2 
 include/asm-um/common.lds.S             |    1 
 include/asm-um/delay.h                  |   17 ++++-
 include/linux/eventpoll.h               |    7 ++
 include/linux/ide.h                     |    2 
 include/media/saa7146_vv.h              |    3 
 include/net/fib_rules.h                 |    1 
 include/net/ip6_fib.h                   |    1 
 net/appletalk/ddp.c                     |    7 +-
 net/core/dev.c                          |    4 -
 net/core/fib_rules.c                    |   30 +++++++++
 net/dccp/proto.c                        |    4 -
 net/decnet/dn_rules.c                   |   21 +++---
 net/ipv4/fib_rules.c                    |   14 +---
 net/ipv6/fib6_rules.c                   |   14 +---
 net/ipv6/ip6_fib.c                      |    8 ++
 net/ipv6/route.c                        |   97 +++++++++++++++++++-------------
 net/sched/cls_basic.c                   |   16 ++---
 net/socket.c                            |    7 +-
 55 files changed, 446 insertions(+), 255 deletions(-)

Summary of changes from v2.6.20.4 to v2.6.20.5
==============================================

Al Viro (1):
      FRA_{DST,SRC} are le16 for decnet

Alan Tyson (1):
      CIFS: reset mode when client notices that ATTR_READONLY is no longer set

Albert Lee (2):
      ide: clear bmdma status in ide_intr() for ICHx controllers (revised #4)
      ide: remove clearing bmdma status from cdrom_decode_status() (rev #4)

Alexey Dobriyan (1):
      NET: Fix sock_attach_fd() failure in sys_accept()

Arnaldo Carvalho de Melo (1):
      DCCP: Fix exploitable hole in DCCP socket options

Bartlomiej Zolnierkiewicz (1):
      ide: revert "ide: fix drive side 80c cable check, take 2" for now

Daniel Drake (1):
      generic_serial: fix decoding of baud rate

David Miller (2):
      IPV6: Fix ipv6 round-robin locking.
      VIDEO: Fix FFB DAC revision probing

G. Liakhovetski (1):
      PPP: Fix PPP skb leak

Greg Kroah-Hartman (1):
      Linux 2.6.20.5

Hans Verkuil (1):
      V4L: msp_attach must return 0 if no msp3400 was found.

J. Bruce Fields (1):
      CRYPTO: api: scatterwalk_copychunks() fails to advance through scatterlist

Jean Delvare (1):
      APPLETALK: Fix a remotely triggerable crash

Jeff Dike (4):
      UML - fix epoll
      UML - host VDSO fix
      UML - Fix static linking
      UML - use correct register file size everywhere

Jeff Garzik (2):
      libata: sata_mv: don't touch reserved bits in EDMA config register
      libata: sata_mv: Fix 50xx irq mask

Mark Lord (1):
      libata bugfix: HDIO_DRIVE_TASK

Mauro Carvalho Chehab (1):
      V4L: Fix SECAM handling on saa7115

Michael Krufky (1):
      DVB: fix nxt200x rf input switching

Mikael Pettersson (1):
      SPARC: Fix sparc builds with gcc-4.2.x

Oliver Endriss (1):
      V4L: saa7146: Fix allocation of clipping memory

Paolo 'Blaisorblade' Giarrusso (1):
      uml: fix unreasonably long udelay

Patrick McHardy (2):
      NET: Fix packet classidier NULL pointer OOPS
      NET_SCHED: Fix ingress qdisc locking.

Robert Hancock (1):
      sata_nv: delay on switching between NCQ and non-NCQ commands

Simon Arlott (1):
      dvb-core: fix several locking related problems

Stefan Richter (1):
      ieee1394: dv1394: fix CardBus card ejection

Steve French (1):
      CIFS: Allow reset of file to ATTR_NORMAL when archive bit not set

Tejun Heo (2):
      jmicron: make ide jmicron driver play nice with libata ones
      libata: clear TF before IDENTIFYing

Thomas Graf (1):
      NET: Fix FIB rules compatability

Thomas Viehweger (1):
      DVB: isl6421: don't reference freed memory

Trent Piepho (1):
      V4L: radio: Fix error in Kbuild file

Vasily Averin (1):
      i2o: block IO errors on i2o disk

