Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXJDU0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXJDU0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbXJDU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:26:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39433 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbXJDUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:25:59 -0400
Date: Thu, 4 Oct 2007 13:17:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Holzheu <holzheu@linux.vnet.ibm.com>,
       Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jesse Barnes <jesse.barnes@intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Emil Medve <Emilian.Medve@freescale.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>,
       Miguel Ojeda <maxextreme@gmail.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Message-Id: <20071004131703.25046db9.randy.dunlap@oracle.com>
In-Reply-To: <1191528247.13580.11.camel@grianne>
References: <1191528247.13580.11.camel@grianne>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 22:04:07 +0200 Vegard Nossum wrote:

> Description: This patch largely implements the kprint API as previously
> posted to the LKML and described in Documentation/kprint.txt (see patch).
> 
> The main purpose of this change is provide a unified logging API to the
> kernel and at the same time make it easy to add extensions, now and later.
> 
> My changes and additions are as follows:


$ diffstat -p1 -w70 kprint.patch 
 Documentation/kprint.txt                 |  238 ++++++++++++++
 arch/i386/kernel/traps.c                 |    2 
 arch/um/include/user.h                   |    6 
 crypto/tcrypt.c                          |    5 
 drivers/char/mem.c                       |   10 
 drivers/ide/ide-lib.c                    |    3 
 drivers/md/md.c                          |    5 
 drivers/media/dvb/frontends/tda10021.c   |   13 
 drivers/media/dvb/frontends/tda10023.c   |   13 
 drivers/media/dvb/frontends/ves1820.c    |    9 
 drivers/media/video/em28xx/em28xx-core.c |   16 
 drivers/media/video/usbvideo/usbvideo.h  |    7 
 drivers/net/e100.c                       |   10 
 drivers/net/e1000/e1000.h                |   12 
 drivers/net/irda/ma600.c                 |    5 
 drivers/net/ixgb/ixgb.h                  |   11 
 drivers/net/lib8390.c                    |   17 -
 drivers/net/pcmcia/axnet_cs.c            |   12 
 drivers/pcmcia/rsrc_nonstatic.c          |   10 
 drivers/scsi/advansys.c                  |    2 
 include/asm-generic/pgtable-nopmd.h      |    5 
 include/asm-generic/pgtable-nopud.h      |    5 
 include/linux/args.h                     |   29 +
 include/linux/kernel.h                   |   27 +
 include/linux/kprint-light.h             |   25 +
 include/linux/kprint.h                   |  201 ++++++++++++
 include/linux/ringbuffer.h               |   34 ++
 include/net/sctp/sctp.h                  |    6 
 include/scsi/scsi_device.h               |   14 
 include/scsi/sd.h                        |   13 
 init/Kconfig                             |    2 
 init/do_mounts_initrd.c                  |    2 
 kernel/Kconfig.kprint                    |  125 +++++++
 kernel/Makefile                          |    2 
 kernel/kprint.c                          |  345 +++++++++++++++++++++
 kernel/printk.c                          |    9 
 lib/Makefile                             |    3 
 lib/ringbuffer.c                         |  155 +++++++++
 lib/vsprintf.c                           |  321 +++++++++++++++++++
 net/tipc/dbg.c                           |    3 
 40 files changed, 1660 insertions(+), 72 deletions(-)
