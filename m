Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZJYUgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZJYUgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 16:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZJYUgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 16:36:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62913 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZJYUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 16:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=DcRFS4E4a2/SouVnMR0H1MFHZAELdXR1Ge2XlgkHHa4pQIR4iy70IVlIDwiXBmbTbl
         P1iGtkGmd+NdRcmztQE8l7bIvJhsUxwObA5riA7PIQBLtaAzHXRNrO8uuGtHLk+YuptM
         fjc+KzAEqjnGxSB+7xNGx4jq9MYMt6HbhPGSw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [quilt patches] Staging: rt28x0: more cleanups
Date: Sun, 25 Oct 2009 21:34:17 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200910252134.17360.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

More cleanups:
- run all files through scripts/Lindent
- convert C++ style comments to C style
- remove typedefs

As a result those drivers start looking Linux-like and become easier
to comprehend, also as an added bonus another 1.5 KLOC are gone..

The downside is that it will be harder now to port over updates from
the original vendor source code than it was in the past..

As usual all changes were tested with RT2860 and RT3070.


Cause patches are too big for a mailing list they are available at:

http://www.kernel.org/pub/linux/kernel/people/bart/staging-rt28x0-more-cleanups/


diffstat:
 drivers/staging/rt2860/ap.h                   |   88 
 drivers/staging/rt2860/chip/mac_pci.h         |  262 
 drivers/staging/rt2860/chip/mac_usb.h         |  558 -
 drivers/staging/rt2860/chip/rt2860.h          |   18 
 drivers/staging/rt2860/chip/rt2870.h          |    9 
 drivers/staging/rt2860/chip/rt3070.h          |   11 
 drivers/staging/rt2860/chip/rt3090.h          |   22 
 drivers/staging/rt2860/chip/rt30xx.h          |    9 
 drivers/staging/rt2860/chip/rtmp_mac.h        | 3677 +++---
 drivers/staging/rt2860/chip/rtmp_phy.h        |  152 
 drivers/staging/rt2860/chips/rt3070.c         |  164 
 drivers/staging/rt2860/chips/rt3090.c         |   84 
 drivers/staging/rt2860/chips/rt30xx.c         |  477 
 drivers/staging/rt2860/chlist.h               |  109 
 drivers/staging/rt2860/common/action.c        |  880 -
 drivers/staging/rt2860/common/action.h        |   51 
 drivers/staging/rt2860/common/ba_action.c     | 2262 +---
 drivers/staging/rt2860/common/cmm_aes.c       | 1341 +-
 drivers/staging/rt2860/common/cmm_asic.c      | 3505 +++---
 drivers/staging/rt2860/common/cmm_cfg.c       |  294 
 drivers/staging/rt2860/common/cmm_data.c      | 2955 ++---
 drivers/staging/rt2860/common/cmm_data_pci.c  | 1299 +-
 drivers/staging/rt2860/common/cmm_data_usb.c  | 1325 +-
 drivers/staging/rt2860/common/cmm_info.c      | 1492 +-
 drivers/staging/rt2860/common/cmm_mac_pci.c   | 2259 ++--
 drivers/staging/rt2860/common/cmm_mac_usb.c   | 1237 +-
 drivers/staging/rt2860/common/cmm_sanity.c    | 2184 +--
 drivers/staging/rt2860/common/cmm_sync.c      |  988 -
 drivers/staging/rt2860/common/cmm_tkip.c      |  991 -
 drivers/staging/rt2860/common/cmm_wep.c       |  336 
 drivers/staging/rt2860/common/cmm_wpa.c       | 4380 +++----
 drivers/staging/rt2860/common/crypt_hmac.c    |  275 
 drivers/staging/rt2860/common/crypt_md5.c     |  423 
 drivers/staging/rt2860/common/crypt_sha2.c    |  321 
 drivers/staging/rt2860/common/dfs.c           |   18 
 drivers/staging/rt2860/common/ee_efuse.c      |  412 
 drivers/staging/rt2860/common/ee_prom.c       |  179 
 drivers/staging/rt2860/common/eeprom.c        |   72 
 drivers/staging/rt2860/common/firmware.h      |    2 
 drivers/staging/rt2860/common/firmware_3070.h |    2 
 drivers/staging/rt2860/common/mlme.c          | 8309 +++++++--------
 drivers/staging/rt2860/common/rt_channel.c    | 3515 +++---
 drivers/staging/rt2860/common/rt_rf.c         |  122 
 drivers/staging/rt2860/common/rtmp_init.c     | 3882 +++----
 drivers/staging/rt2860/common/rtmp_mcu.c      |  266 
 drivers/staging/rt2860/common/rtmp_timer.c    |  193 
 drivers/staging/rt2860/common/spectrum.c      | 2491 ++--
 drivers/staging/rt2860/crypt_hmac.h           |   38 
 drivers/staging/rt2860/crypt_md5.h            |   69 
 drivers/staging/rt2860/crypt_sha2.h           |   68 
 drivers/staging/rt2860/dfs.h                  |    8 
 drivers/staging/rt2860/eeprom.h               |   53 
 drivers/staging/rt2860/iface/rtmp_pci.h       |    9 
 drivers/staging/rt2860/iface/rtmp_usb.h       |   62 
 drivers/staging/rt2860/mlme.h                 | 2955 ++---
 drivers/staging/rt2860/oid.h                  | 1844 +--
 drivers/staging/rt2860/pci_main_dev.c         | 1481 +-
 drivers/staging/rt2860/rt2860sta.mod.c        |    2 
 drivers/staging/rt2860/rt_config.h            |    7 
 drivers/staging/rt2860/rt_linux.c             | 1585 +-
 drivers/staging/rt2860/rt_linux.h             |  390 
 drivers/staging/rt2860/rt_main_dev.c          |  663 -
 drivers/staging/rt2860/rt_pci_rbus.c          |  877 -
 drivers/staging/rt2860/rt_usb.c               |  925 -
 drivers/staging/rt2860/rtmp.h                 |14345 +++++++++++---------------
 drivers/staging/rt2860/rtmp_chip.h            |  462 
 drivers/staging/rt2860/rtmp_ckipmic.h         |   87 
 drivers/staging/rt2860/rtmp_def.h             | 1234 +-
 drivers/staging/rt2860/rtmp_dot11.h           |  284 
 drivers/staging/rt2860/rtmp_iface.h           |   85 
 drivers/staging/rt2860/rtmp_mcu.h             |   34 
 drivers/staging/rt2860/rtmp_os.h              |   72 
 drivers/staging/rt2860/rtmp_timer.h           |  143 
 drivers/staging/rt2860/rtmp_type.h            |  250 
 drivers/staging/rt2860/rtusb_io.h             |  224 
 drivers/staging/rt2860/spectrum.h             |  296 
 drivers/staging/rt2860/spectrum_def.h         |  281 
 drivers/staging/rt2860/sta/assoc.c            | 2179 ++-
 drivers/staging/rt2860/sta/auth.c             |  793 -
 drivers/staging/rt2860/sta/auth_rsp.c         |  172 
 drivers/staging/rt2860/sta/connect.c          | 3486 +++---
 drivers/staging/rt2860/sta/rtmp_data.c        | 3534 +++---
 drivers/staging/rt2860/sta/sanity.c           |  687 -
 drivers/staging/rt2860/sta/sync.c             | 2844 ++---
 drivers/staging/rt2860/sta/wpa.c              |  458 
 drivers/staging/rt2860/sta_ioctl.c            | 4061 +++----
 drivers/staging/rt2860/usb_main_dev.c         |  885 -
 drivers/staging/rt2860/wpa.h                  |  709 -
 drivers/staging/rt2870/common/rtusb_bulk.c    | 1294 +-
 drivers/staging/rt2870/common/rtusb_data.c    |  261 
 drivers/staging/rt2870/common/rtusb_io.c      | 2920 +++--
 drivers/staging/rt3070/firmware.h             |    2 
 drivers/staging/rt3070/md4.h                  |   12 
 drivers/staging/rt3090/firmware.h             |    2 
 94 files changed, 52778 insertions(+), 54255 deletions(-)
