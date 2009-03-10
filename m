Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZCJQxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZCJQxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZCJQoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:44:07 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34582 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZCJQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:39 -0400
Message-Id: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Tue, 10 Mar 2009 16:23:48 +0000
Subject: [PATCH 00/31] *** SUBJECT HERE ***
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module-init-tools on most distributions ships with a file that contains a
large list of aliases to auto-load modules on demand, either by matching
a MODALIAS string from the kernel uevent, or by the {block,char}-major-*
aliases requested by the kernel when device nodes are opened.

There are convenient macros for defining these inside the kernel modules
themselves, so they are exported by file2alias and put into the files
created by depmod.  This is far preferable to a file in another package
that has to be parsed every time modprobe is called (many, many times
on a typical boot) and may get out of date.

The majority of these are of the type that cause modules to be loaded
when devices are opened, which are not generally needed in a udev system.
If the maintainers feel they aren't warranted, so be it.

Some match network protocols instead, it'd be nice if they could be merged.

And one (sg) is a missing match from a device driver to a MODALIAS,
we'd definitely like that one to be merged.

Thanks!

Scott

Scott James Remnant (30):
  bridge: Auto-load bridge module when socket opened.
  netlink: Auto-load af_netlink module when socket opened.
  wanrouter: Auto-load wanrouter module when socket opened.
  netfilter: Auto-load ip_queue module when socket opened.
  netfilter: Auto-load ip6_queue module when socket opened.
  connector: Auto-load cn module when socket opened.
  scsi: Auto-load scsi_transport_iscsi module when socket opened.
  mtd: Auto-load ftl module when device opened.
  paride: Auto-load pcd module when device opened.
  paride: Auto-load pf module when device opened.
  mtd: Auto-load nftl module when device opened.
  input: Auto-load mousedev module when psaux device opened.
  input: Auto-load mousedev module when /dev/input/mice opened.
  hw_random: Auto-load rng-core module when device opened.
  sbus: Auto-load openprom module when device opened.
  applicom: Auto-load applicom module when device opened.
  toshiba: Auto-load toshiba module when device opened.
  cyclades: Auto-load cyclades module when device opened.
  riscom8: Auto-load riscom8 module when device opened.
  specialix: Auto-load specialix module when device opened.
  video: Auto-load videodev module when device opened.
  i2c: Auto-load i2c_dev module when device opened.
  mtd: Auto-load mtdchar module when device opened.
  paride: Auto-load pt module when device opened.
  paride: Auto-load pg module when device opened.
  usb: Auto-load cdc_acm module when device opened.
  x86: Auto-load msr module when device opened.
  x86: Auto-load cpuid module when device opened.
  mwave: Auto-load mwave module when device opened.
  scsi: Add scsi type modalias to ch.

Tim Gardner (1):
  esp: Auto-load esp module when device opened.

 arch/x86/kernel/cpuid.c             |    1 +
 arch/x86/kernel/msr.c               |    1 +
 drivers/block/paride/pcd.c          |    1 +
 drivers/block/paride/pf.c           |    1 +
 drivers/block/paride/pg.c           |    1 +
 drivers/block/paride/pt.c           |    1 +
 drivers/char/applicom.c             |    1 +
 drivers/char/cyclades.c             |    2 ++
 drivers/char/esp.c                  |    3 +++
 drivers/char/hw_random/core.c       |    1 +
 drivers/char/mwave/mwavedd.c        |    1 +
 drivers/char/riscom8.c              |    2 ++
 drivers/char/specialix.c            |    1 +
 drivers/char/toshiba.c              |    1 +
 drivers/connector/connector.c       |    2 ++
 drivers/i2c/i2c-dev.c               |    1 +
 drivers/input/mousedev.c            |    3 +++
 drivers/media/video/v4l2-dev.c      |    1 +
 drivers/mtd/ftl.c                   |    2 ++
 drivers/mtd/mtdchar.c               |    1 +
 drivers/mtd/nftlcore.c              |    2 ++
 drivers/sbus/char/openprom.c        |    1 +
 drivers/scsi/ch.c                   |    1 +
 drivers/scsi/scsi_transport_iscsi.c |    3 +++
 drivers/usb/class/cdc-acm.c         |    2 +-
 net/bridge/br.c                     |    2 ++
 net/ipv4/netfilter/ip_queue.c       |    2 ++
 net/ipv6/netfilter/ip6_queue.c      |    1 +
 net/netlink/af_netlink.c            |    2 ++
 net/wanrouter/wanmain.c             |    1 +
 30 files changed, 44 insertions(+), 1 deletions(-)

