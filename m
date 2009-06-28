Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZF1OL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZF1OL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZF1OLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:11:50 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43467 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF1OLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=emmpJ5eukc66/WOs5PngK3JYk11C1rNmqdTLE8TrMVrzbQ+1C3/gn02+feHMp7X/0o
         WvaOr7kELKxpEaqhFMz6dfKemBIQ9P2Biyz3BlRd3cKTRAjqKyHH0TXgnRpc4P/ymaPb
         eSgmoIbbmyard017S1Lnh88tJMMFeb8bdZKXI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [git patches] Staging: rtl8187se cleanups
Date: Sun, 28 Jun 2009 16:17:19 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906281617.20325.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The following patchset against Linus' tree contains all my previously
posted rtl8187se patches (9 first commits) plus a bunch of new stuff:

git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git rtl8187se

[ I'll also post new patches in a separate thread. ]

 drivers/staging/rtl8187se/Makefile                 |   14 -
 drivers/staging/rtl8187se/dot11d.h                 |  101 -
 drivers/staging/rtl8187se/ieee80211.h              | 1755 ------------
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |   22 -
 drivers/staging/rtl8187se/ieee80211/dot11d.h       |    2 -
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |  140 +-
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |   17 -
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |   73 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |  293 +--
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |  120 +-
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |   88 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |  242 +--
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |  995 +-------
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   30 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |  241 --
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |  123 +-
 drivers/staging/rtl8187se/ieee80211/internal.h     |  115 -
 drivers/staging/rtl8187se/ieee80211/rtl_crypto.h   |  399 ---
 drivers/staging/rtl8187se/ieee80211_crypt.h        |   86 -
 drivers/staging/rtl8187se/r8180.h                  |   24 +-
 drivers/staging/rtl8187se/r8180_93cx6.h            |    2 -
 drivers/staging/rtl8187se/r8180_core.c             | 2946 ++------------------
 drivers/staging/rtl8187se/r8180_dm.c               |   58 -
 drivers/staging/rtl8187se/r8180_dm.h               |   18 -
 drivers/staging/rtl8187se/r8180_gct.c              |  296 --
 drivers/staging/rtl8187se/r8180_gct.h              |   25 -
 drivers/staging/rtl8187se/r8180_hw.h               |  393 +---
 drivers/staging/rtl8187se/r8180_max2820.c          |  240 --
 drivers/staging/rtl8187se/r8180_max2820.h          |   21 -
 drivers/staging/rtl8187se/r8180_pm.c               |   92 -
 drivers/staging/rtl8187se/r8180_pm.h               |   28 -
 drivers/staging/rtl8187se/r8180_rtl8225.c          |  933 -------
 drivers/staging/rtl8187se/r8180_rtl8225.h          |   12 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        | 1552 ++++-------
 drivers/staging/rtl8187se/r8180_rtl8255.c          | 1838 ------------
 drivers/staging/rtl8187se/r8180_rtl8255.h          |   19 -
 drivers/staging/rtl8187se/r8180_sa2400.c           |  233 --
 drivers/staging/rtl8187se/r8180_sa2400.h           |   26 -
 drivers/staging/rtl8187se/r8180_wx.c               |   51 +-
 drivers/staging/rtl8187se/r8180_wx.h               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |  663 +-----
 41 files changed, 906 insertions(+), 13422 deletions(-)
 delete mode 100644 drivers/staging/rtl8187se/dot11d.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/internal.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211/rtl_crypto.h
 delete mode 100644 drivers/staging/rtl8187se/ieee80211_crypt.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_gct.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_gct.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_max2820.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_max2820.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_pm.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_pm.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8225.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8255.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_rtl8255.h
 delete mode 100644 drivers/staging/rtl8187se/r8180_sa2400.c
 delete mode 100644 drivers/staging/rtl8187se/r8180_sa2400.h


Bartlomiej Zolnierkiewicz (27):
      Staging: rtl8187se/ieee80211: remove unused files
      Staging: rtl8187se: remove duplicate dot11d.h and ieee80211.h includes
      Staging: rtl8187se: remove unused ieee80211_crypt.h
      Staging: rtl8187se: remove kernel version compatibility wrappers
      Staging: rtl8187se: remove support for older wireless extensions
      Staging: rtl8187se/ieee80211: remove dead _RTL8187_EXT_PATCH_ code
      Staging: rtl8187se/ieee80211: remove superfluous ieee80211_* defines
      Staging: rtl8187se/ieee80211: remove unused dump_chnl_map()
      Staging: rtl8187se/ieee80211: remove superfluous JOHN_* ifdefs
      Staging: rtl8187se: remove ENABLE_DOT11D ifdefs
      Staging: rtl8187se: remove CONFIG_RTL8180_PM ifdefs
      Staging: rtl8187se: remove THOMAS_TURBO ifdefs
      Staging: rtl8187se: remove CONFIG_RTL818x_S ifdefs
      Staging: rtl8187se: remove CONFIG_RTL8185B ifdefs
      Staging: rtl8187se: remove CONFIG_RTL8180_IO_MAP ifdefs
      Staging: rtl8187se: remove dead code
      Staging: rtl8187se: remove unused radio frontends
      Staging: rtl8187se: remove debugging code from r8180_core.c
      Staging: rtl8187se: remove unused rtl8225_rf_* functions
      Staging: rtl8187se: cleanup r8180_rtl8225.c
      Staging: rtl8187se: merge r8180_rtl8225.c with r8180_rtl8225z2.c
      Staging: rtl8187se: cleanup r8180_pm.c
      Staging: rtl8187se: merge r8180_pm.c with r8180_core.c
      Staging: rtl8187se: remove unused definitions from r8180_hw.h
      Staging: rtl8187se: remove unused definitions from r8180.h
      Staging: rtl8187se: cleanup r8180_rtl8225z2.c
      Staging: rtl8187se: cleanup r8180_core.c

