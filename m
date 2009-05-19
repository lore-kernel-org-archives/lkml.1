Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZESPcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZESPcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZESPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:32:26 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:35964 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZESPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:32:25 -0400
Message-Id: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Date: Tue, 19 May 2009 15:27:28 +0200
Subject: [PATCH 00/19] mISDN update for linux-next
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a update of the mISDN driver for linux-next.
It syncs the mISDN driver with the development on git.misdn.org.
More updates (new hardware support) will follow.

You can pull it from 
git://master.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6-next.git master


Andreas Eversberg (14):
  Add XHFC support for embedded Speech-Design board to hfcmulti
  Fix bug in XHFC registering
  Add PCI ID for Junghanns 8S card
  Add watchdog functionality to hfcmulti driver
  DSP now uses ring buffer for echo canceler
  Fix hfcmulti's PCI IRQ bug during init
  Echo canceler now gets delay information from hardware
  Fixed missing spin lock on pipeline process
  Added layer-1-hold feature
  Fix DTMF locking bug issue
  Hardware acceleration is now possible in conjunction with audio
    recording
  Fix TEI and SAPI handling
  Add "sapi" information to debug messages
  Added PCI ID for new Junghanns.net Single E1 cards.

Frank Seidel (2):
  Reduce stack size in dsp_cmx_send()
  Add allocation of recvbuf[1500] at run time to reduce stack size

Karsten Keil (2):
  Fix skb leak in error cases
  Cleanup debug messages

Roel Kluin (1):
  isdn: get_free_devid() failure ignored

 drivers/isdn/hardware/mISDN/hfc_multi.h |   75 +++-
 drivers/isdn/hardware/mISDN/hfcmulti.c  |  711 +++++++++++++++++++++++--------
 drivers/isdn/hardware/mISDN/hfcpci.c    |   98 +++--
 drivers/isdn/hardware/mISDN/hfcsusb.c   |    4 +-
 drivers/isdn/mISDN/core.c               |    8 +-
 drivers/isdn/mISDN/dsp.h                |   18 +-
 drivers/isdn/mISDN/dsp_audio.c          |    5 +-
 drivers/isdn/mISDN/dsp_cmx.c            |  115 ++++--
 drivers/isdn/mISDN/dsp_core.c           |   70 ++--
 drivers/isdn/mISDN/dsp_ecdis.h          |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c       |    5 +-
 drivers/isdn/mISDN/dsp_tones.c          |   23 +-
 drivers/isdn/mISDN/hwchannel.c          |    4 +-
 drivers/isdn/mISDN/l1oip_codec.c        |    1 +
 drivers/isdn/mISDN/l1oip_core.c         |   51 ++-
 drivers/isdn/mISDN/layer2.c             |   37 +-
 drivers/isdn/mISDN/layer2.h             |    2 +-
 drivers/isdn/mISDN/socket.c             |   45 ++-
 drivers/isdn/mISDN/tei.c                |   80 +++--
 drivers/isdn/mISDN/timerdev.c           |    2 +-
 include/linux/mISDNdsp.h                |    4 +-
 include/linux/mISDNhw.h                 |    2 +-
 include/linux/mISDNif.h                 |   19 +-
 include/linux/pci_ids.h                 |    2 +
 24 files changed, 965 insertions(+), 418 deletions(-)

