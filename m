Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYKVCN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYKVCN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYKVCNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:13:46 -0500
Received: from khc.piap.pl ([195.187.100.11]:57382 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYKVCNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:13:45 -0500
To: David Miller <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [Pull request] WAN aka generic HDLC (net-next)
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 22 Nov 2008 03:13:42 +0100
Message-ID: <m3ljvcqzhl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Can you pull my WAN tree into net-next, please?
Freshly rebased, with duplicate "dev->priv" commits removed, this is
basically:
- updates to Hitachi/Renesas SCA/SCA-II-based drivers (including
  hd6457x.c split into hd64570.c and hd64572.c)
- the second=last part of syncppp conversion (all drivers are already
  using hdlc_ppp)
- smaller things

The following changes since commit e245a3855eec42127b722ed9688a49ec3f3c9a27:
  Matt Carlson (1):
        tg3: Update version to 3.96

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git for-david

me (16):
      WAN: split hd6457x.c into hd64570.c and hd64572.c
      WAN: remove SCA II support from SCA drivers
      WAN: remove SCA support from SCA-II drivers
      WAN: convert HD64572-based drivers to NAPI.
      WAN: TX-done handler now uses the ownership bit in HD64572 drivers.
      WAN: HD64572 already handles TX underruns with DMAC.
      WAN: rework HD64572 interrupts a bit.
      WAN: Simplify HD64572 status handling.
      WAN: don't print HD64572 driver versions anymore.
      WAN: Simplify HD64572 drivers.
      WAN: HD64572 drivers don't use next_desc() anymore.
      WAN: Correct comments in hd6457[02].c
      WAN: Simplify sca_init_port() in HD64572 driver.
      WAN: new synchronous PPP implementation for generic HDLC.
      WAN: syncppp.c is no longer used by any kernel code. Remove it.
      WAN pc300too.c: Fix PC300-X.21 detection

 Documentation/DocBook/Makefile            |    2 +-
 Documentation/DocBook/networking.tmpl     |    3 -
 Documentation/DocBook/wanbook.tmpl        |   99 --
 Documentation/networking/generic-hdlc.txt |    8 +-
 drivers/net/wan/Makefile                  |    2 +-
 drivers/net/wan/c101.c                    |    6 +-
 drivers/net/wan/{hd6457x.c => hd64570.c}  |  254 ++----
 drivers/net/wan/hd64572.c                 |  640 +++++++++++++
 drivers/net/wan/hdlc_ppp.c                |  648 ++++++++++++-
 drivers/net/wan/n2.c                      |    9 +-
 drivers/net/wan/pc300too.c                |  119 +--
 drivers/net/wan/pci200syn.c               |   77 +-
 drivers/net/wan/syncppp.c                 | 1476 -----------------------------
 include/net/syncppp.h                     |  102 --
 14 files changed, 1379 insertions(+), 2066 deletions(-)
 delete mode 100644 Documentation/DocBook/wanbook.tmpl
 rename drivers/net/wan/{hd6457x.c => hd64570.c} (78%)
 create mode 100644 drivers/net/wan/hd64572.c
 delete mode 100644 drivers/net/wan/syncppp.c
 delete mode 100644 include/net/syncppp.h
-- 
Krzysztof Halasa
