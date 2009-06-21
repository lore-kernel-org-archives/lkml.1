Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZFUQ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZFUQ1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 12:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFUQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 12:27:14 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:38099 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZFUQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 12:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=PTeTEk7xSazMAHThAeQqo2Je3U/RIsUYegakY9P4n1PPvGc0XNEk9K+dO0P0eUw0Ce
         I5tlSzc6lQHiW9kBbZiGRK165rDQLYVzo5t1dt+BkeYMX9+NmI/crbzm4HCplu+e3THU
         W3gpeC9Oa/KcFVUOccb0nz2yy7+pXFe/OQiQ4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [git patches] Staging: rtl8192su build fix + cleanups
Date: Sun, 21 Jun 2009 18:30:01 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906211830.01727.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The following patchset against Linus' tree contains all my previously
posted rtl8192su patches (8 first commits) plus a bunch of new stuff
(removal of incomplete/disabled features, unused files and dead code):

git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git rtl8192su

[ Greg, this may be pushed to Linus "now" IMHO (due to COMPAT_NET_DEV_OPS
  removal the rtl8192su driver has never been buildable in Linus' tree).

  If somebody prefers to get patches by mail, please just ping me. ]

 drivers/staging/rtl8192su/Kconfig                  |    2 +-
 drivers/staging/rtl8192su/Makefile                 |   23 +-
 drivers/staging/rtl8192su/dot11d.h                 |  102 -
 drivers/staging/rtl8192su/ieee80211.h              | 2901 ------------
 drivers/staging/rtl8192su/ieee80211/EndianFree.h   |  199 -
 drivers/staging/rtl8192su/ieee80211/Makefile       |    3 +-
 drivers/staging/rtl8192su/ieee80211/aes.c          |  469 --
 drivers/staging/rtl8192su/ieee80211/api.c          |  246 -
 drivers/staging/rtl8192su/ieee80211/arc4.c         |  103 -
 drivers/staging/rtl8192su/ieee80211/autoload.c     |   40 -
 drivers/staging/rtl8192su/ieee80211/cipher.c       |  299 --
 drivers/staging/rtl8192su/ieee80211/compress.c     |   64 -
 .../staging/rtl8192su/ieee80211/crypto_compat.h    |   90 -
 drivers/staging/rtl8192su/ieee80211/digest.c       |  108 -
 drivers/staging/rtl8192su/ieee80211/dot11d.c       |   18 +-
 drivers/staging/rtl8192su/ieee80211/dot11d.h       |    4 -
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    |  354 +--
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.c  |   14 -
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.h  |    7 -
 .../rtl8192su/ieee80211/ieee80211_crypt_ccmp.c     |   51 +-
 .../rtl8192su/ieee80211/ieee80211_crypt_tkip.c     |  266 +-
 .../rtl8192su/ieee80211/ieee80211_crypt_wep.c      |  113 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |   65 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c |  126 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |  338 +--
 .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |   69 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |   22 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |  198 +-
 drivers/staging/rtl8192su/ieee80211/internal.h     |  115 -
 drivers/staging/rtl8192su/ieee80211/kmap_types.h   |   20 -
 drivers/staging/rtl8192su/ieee80211/michael_mic.c  |  194 -
 drivers/staging/rtl8192su/ieee80211/proc.c         |  116 -
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   |   43 -
 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h   |    9 -
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   |  277 +--
 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h  |  168 +-
 .../staging/rtl8192su/ieee80211/rtl819x_TSProc.c   |   34 +-
 drivers/staging/rtl8192su/ieee80211/rtl_crypto.h   |  399 --
 drivers/staging/rtl8192su/ieee80211/scatterwalk.c  |  126 -
 drivers/staging/rtl8192su/ieee80211/scatterwalk.h  |   51 -
 drivers/staging/rtl8192su/ieee80211_crypt.h        |   86 -
 drivers/staging/rtl8192su/r8180_93cx6.h            |    5 -
 drivers/staging/rtl8192su/r8190_rtl8256.c          |  312 --
 drivers/staging/rtl8192su/r8192S_Efuse.c           |  113 -
 drivers/staging/rtl8192su/r8192S_firmware.c        |  477 --
 drivers/staging/rtl8192su/r8192S_firmware.h        |    5 -
 drivers/staging/rtl8192su/r8192S_hw.h              |  184 -
 drivers/staging/rtl8192su/r8192S_phy.c             |  923 +----
 drivers/staging/rtl8192su/r8192S_phy.h             |    5 +-
 drivers/staging/rtl8192su/r8192S_rtl6052.c         |  104 -
 drivers/staging/rtl8192su/r8192S_rtl6052.h         |   47 -
 drivers/staging/rtl8192su/r8192U.h                 |  528 +---
 drivers/staging/rtl8192su/r8192U_core.c            | 4835 +-------------------
 drivers/staging/rtl8192su/r8192U_dm.c              |  549 +---
 drivers/staging/rtl8192su/r8192U_dm.h              |   55 -
 drivers/staging/rtl8192su/r8192U_hw.h              |  746 ---
 drivers/staging/rtl8192su/r8192U_pm.c              |   19 +-
 drivers/staging/rtl8192su/r8192U_pm.h              |    2 -
 drivers/staging/rtl8192su/r8192U_wx.c              |  128 +-
 drivers/staging/rtl8192su/r8192U_wx.h              |    1 -
 drivers/staging/rtl8192su/r819xU_HTType.h          |    9 -
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |  113 +-
 drivers/staging/rtl8192su/r819xU_cmdpkt.h          |   20 -
 drivers/staging/rtl8192su/r819xU_firmware.c        |  707 ---
 drivers/staging/rtl8192su/r819xU_firmware.h        |  106 -
 drivers/staging/rtl8192su/r819xU_phy.c             | 1826 --------
 drivers/staging/rtl8192su/r819xU_phy.h             |   94 -
 drivers/staging/rtl8192su/r819xU_phyreg.h          |  871 ----
 68 files changed, 134 insertions(+), 20582 deletions(-)
 delete mode 100644 drivers/staging/rtl8192su/dot11d.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/EndianFree.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/aes.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/api.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/arc4.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/autoload.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/cipher.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/compress.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/crypto_compat.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/digest.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/internal.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/kmap_types.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/michael_mic.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/proc.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl_crypto.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/scatterwalk.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/scatterwalk.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211_crypt.h
 delete mode 100644 drivers/staging/rtl8192su/r8190_rtl8256.c
 delete mode 100644 drivers/staging/rtl8192su/r8192U_hw.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_firmware.c
 delete mode 100644 drivers/staging/rtl8192su/r819xU_firmware.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_phy.c
 delete mode 100644 drivers/staging/rtl8192su/r819xU_phy.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_phyreg.h


Bartlomiej Zolnierkiewicz (30):
      Staging: rtl8192su: convert to net_device_ops
      Staging: rtl8192su/ieee80211: remove unused files
      Staging: rtl8192su: remove duplicate dot11d.h and ieee80211.h includes
      Staging: rtl8192su: remove unused ieee80211_crypt.h
      Staging: rtl8192su: remove kernel version compatibility wrappers
      Staging: rtl8192su: remove support for older wireless extensions
      Staging: rtl8192su/ieee80211: remove unused _ReasonCode enums
      Staging: rtl8192su/ieee80211: switch to use <linux/ieee80211.h>
      Staging: rtl8192su: remove ENABLE_DOT11D ifdefs
      Staging: rtl8192su: remove CONFIG_RTL8192_PM ifdefs
      Staging: rtl8192su: remove THOMAS_TURBO ifdefs
      Staging: rtl8192su: remove USE_ONE_PIPE ifdefs
      Staging: rtl8192su: remove EEPROM_OLD_FORMAT_SUPPORT ifdefs
      Staging: rtl8192su: remove USB_RX_AGGREGATION_SUPPORT ifdefs
      Staging: rtl8192su: remove USB_TX_DRIVER_AGGREGATION_ENABLE ifdefs
      Staging: rtl8192su: remove RTL8192SU_DISABLE_CCK_RATE ifdefs
      Staging: rtl8192su: remove RTL8192S_DISABLE_FW_DM ifdefs
      Staging: rtl8192su: remove DISABLE_BB_RF ifdefs
      Staging: rtl8192su: remove RTL8192SU_USE_PARAM_TXPWR ifdefs
      Staging: rtl8192su: remove RTL8192SU_FPGA_UNSPECIFIED_NETWORK ifdefs
      Staging: rtl8192su: remove RTL8192SU_FPGA_2MAC_VERIFICATION ifdefs
      Staging: rtl8192su: remove RTL8192SU_ASIC_VERIFICATION ifdefs
      Staging: rtl8192su: remove RTL8192SU_USB_PHY_TEST ifdefs
      Staging: rtl8192su: remove RTL8190_Download_Firmware_From_Header ifdefs
      Staging: rtl8192su: remove RTL8192S_PREPARE_FOR_NORMAL_RELEASE ifdefs
      Staging: rtl8192su: remove RTL8192SU_DISABLE_IQK ifdefs
      Staging: rtl8192su: remove RTL8192SE ifdefs
      Staging: rtl8192su: remove RTL8192SU ifdefs
      Staging: rtl8192su: remove unused files
      Staging: rtl8192su: remove dead code

