Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZFYNnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZFYNnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZFYNnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:43:22 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41932 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZFYNnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:cc:content-type:content-transfer-encoding;
        b=jx69oC64LLn3DNVy0wbuYbA1ic8+FC4twoziiP7oJrUaMIuocpivdhUnCE0OqhsIdg
         wCviJtLvz9nZOesaG1bYZuHLrKTOqIdhx7zmDf+4an+NMpnYtgtI1pqYOIWcjDynUM6C
         cKWkXgei19roHgtako97hvTZbB3MOaZvu5E3c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] Staging: add rt3090 wireless driver
Date: Thu, 25 Jun 2009 15:40:31 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.31-rc1-next-20090625-02642-g2b5b204; KDE/4.2.3; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906251540.31722.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is the vendor driver for the Ralink RT3090 chipset.

It should be later cleaned and ported to use the existing rt2x00
infrastructure or just replaced by the proper version.

[ Unfortunately since it follows the same design/implementation like
  rt{286,287,307}0 drivers (already present in the staging tree)
  it is highly unlikely that it will see much love from the wireless
  development community.. ]

However since the development of the cleaner/proper version can take
significant time lets give distros (i.e. openSUSE seems to already
have the package with the original vendor driver) and users "something"
to use in the meantime.

I forward ported it to 2.6.31-rc1, ported to the Linux build system
and did some initial cleanups.  More fixes/cleanups to come later
(it seems that the driver can be made to share most of its code with
the other Ralink drivers already present in the staging tree).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Patch is too large to be posted on the list, it is here:

	http://www.kernel.org/pub/linux/kernel/people/bart/rt3090.patch.bz2

The original driver package:

	http://www.ralinktech.com.tw/data/drivers/2009_0612_RT3090_Linux_STA_V2.1.0.0_DPO.tar.gz

The individual porting steps can be seen in the following git tree:

	git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git rt3090

 drivers/staging/Kconfig                          |    2 
 drivers/staging/Makefile                         |    1 
 drivers/staging/rt3090/Kconfig                   |    5 
 drivers/staging/rt3090/Makefile                  |   80 
 drivers/staging/rt3090/action.h                  |   66 
 drivers/staging/rt3090/ap.h                      |  512 +
 drivers/staging/rt3090/ap_apcli.h                |  276 
 drivers/staging/rt3090/ap_autoChSel.h            |   79 
 drivers/staging/rt3090/ap_autoChSel_cmm.h        |   66 
 drivers/staging/rt3090/ap_cfg.h                  |  118 
 drivers/staging/rt3090/ap_ids.h                  |   82 
 drivers/staging/rt3090/ap_mbss.h                 |   72 
 drivers/staging/rt3090/ap_uapsd.h                |  636 +
 drivers/staging/rt3090/ap_wds.h                  |  212 
 drivers/staging/rt3090/chips/rt3090.c            |  123 
 drivers/staging/rt3090/chips/rt30xx.c            |  525 +
 drivers/staging/rt3090/chips/rt3370.c            |  121 
 drivers/staging/rt3090/chips/rt3390.c            |  122 
 drivers/staging/rt3090/chips/rt33xx.c            |  536 +
 drivers/staging/rt3090/chlist.h                  |  130 
 drivers/staging/rt3090/common/action.c           | 1057 +++
 drivers/staging/rt3090/common/ba_action.c        | 1779 +++++
 drivers/staging/rt3090/common/cmm_aes.c          | 1560 ++++
 drivers/staging/rt3090/common/cmm_asic.c         | 2753 ++++++++
 drivers/staging/rt3090/common/cmm_cfg.c          |  295 
 drivers/staging/rt3090/common/cmm_data.c         | 2763 ++++++++
 drivers/staging/rt3090/common/cmm_data_pci.c     | 1576 ++++
 drivers/staging/rt3090/common/cmm_info.c         | 3717 +++++++++++
 drivers/staging/rt3090/common/cmm_mac_pci.c      | 1757 +++++
 drivers/staging/rt3090/common/cmm_profile.c      | 2321 +++++++
 drivers/staging/rt3090/common/cmm_sanity.c       | 1718 +++++
 drivers/staging/rt3090/common/cmm_sync.c         |  734 ++
 drivers/staging/rt3090/common/cmm_tkip.c         |  966 ++
 drivers/staging/rt3090/common/cmm_wep.c          |  500 +
 drivers/staging/rt3090/common/cmm_wpa.c          | 3149 +++++++++
 drivers/staging/rt3090/common/crypt_aes.c        | 1007 +++
 drivers/staging/rt3090/common/crypt_biginteger.c | 1119 +++
 drivers/staging/rt3090/common/crypt_dh.c         |  234 
 drivers/staging/rt3090/common/crypt_hmac.c       |  279 
 drivers/staging/rt3090/common/crypt_md5.c        |  353 +
 drivers/staging/rt3090/common/crypt_sha2.c       |  536 +
 drivers/staging/rt3090/common/dfs.c              |  481 +
 drivers/staging/rt3090/common/ee_efuse.c         | 1548 ++++
 drivers/staging/rt3090/common/ee_prom.c          |  308 
 drivers/staging/rt3090/common/eeprom.c           |   98 
 drivers/staging/rt3090/common/igmp_snoop.c       | 1365 ++++
 drivers/staging/rt3090/common/mlme.c             | 6550 +++++++++++++++++++
 drivers/staging/rt3090/common/mlme_ex.c          |  215 
 drivers/staging/rt3090/common/netif_block.c      |  147 
 drivers/staging/rt3090/common/rt_channel.c       | 1287 +++
 drivers/staging/rt3090/common/rt_rf.c            |  201 
 drivers/staging/rt3090/common/rtmp_init.c        | 3882 +++++++++++
 drivers/staging/rt3090/common/rtmp_mcu.c         |  560 +
 drivers/staging/rt3090/common/rtmp_timer.c       |  327 
 drivers/staging/rt3090/common/spectrum.c         | 2221 ++++++
 drivers/staging/rt3090/config.mk                 |  187 
 drivers/staging/rt3090/crypt_hmac.h              |   81 
 drivers/staging/rt3090/crypt_md5.h               |   78 
 drivers/staging/rt3090/crypt_sha2.h              |  107 
 drivers/staging/rt3090/dfs.h                     |  137 
 drivers/staging/rt3090/eeprom.h                  |   82 
 drivers/staging/rt3090/firmware.h                |  517 +
 drivers/staging/rt3090/igmp_snoop.h              |  152 
 drivers/staging/rt3090/ipv6.h                    |  215 
 drivers/staging/rt3090/link_list.h               |  133 
 drivers/staging/rt3090/mac_pci.h                 |  454 +
 drivers/staging/rt3090/mlme.h                    | 1360 ++++
 drivers/staging/rt3090/mlme_ex.h                 |   83 
 drivers/staging/rt3090/mlme_ex_def.h             |   53 
 drivers/staging/rt3090/netif_block.h             |   56 
 drivers/staging/rt3090/oid.h                     | 1144 +++
 drivers/staging/rt3090/pci_main_dev.c            | 1194 +++
 drivers/staging/rt3090/rt3090.h                  |   77 
 drivers/staging/rt3090/rt30xx.h                  |   48 
 drivers/staging/rt3090/rt3370.h                  |   64 
 drivers/staging/rt3090/rt3390.h                  |   77 
 drivers/staging/rt3090/rt33xx.h                  |   48 
 drivers/staging/rt3090/rt_ate.c                  | 6089 ++++++++++++++++++
 drivers/staging/rt3090/rt_ate.h                  |  314 
 drivers/staging/rt3090/rt_config.h               |  126 
 drivers/staging/rt3090/rt_linux.c                | 1623 ++++
 drivers/staging/rt3090/rt_linux.h                | 1034 +++
 drivers/staging/rt3090/rt_main_dev.c             |  897 ++
 drivers/staging/rt3090/rt_pci_rbus.c             |  989 +++
 drivers/staging/rt3090/rt_profile.c              |  101 
 drivers/staging/rt3090/rtmp.h                    | 6873 ++++++++++++++++++++
 drivers/staging/rt3090/rtmp_chip.h               |  355 +
 drivers/staging/rt3090/rtmp_def.h                | 1650 +++++
 drivers/staging/rt3090/rtmp_dot11.h              |  146 
 drivers/staging/rt3090/rtmp_iface.h              |   81 
 drivers/staging/rt3090/rtmp_mac.h                | 2304 +++++++
 drivers/staging/rt3090/rtmp_mcu.h                |   55 
 drivers/staging/rt3090/rtmp_os.h                 |   93 
 drivers/staging/rt3090/rtmp_pci.h                |  110 
 drivers/staging/rt3090/rtmp_phy.h                |  631 +
 drivers/staging/rt3090/rtmp_timer.h              |  162 
 drivers/staging/rt3090/rtmp_type.h               |  147 
 drivers/staging/rt3090/spectrum.h                |  234 
 drivers/staging/rt3090/spectrum_def.h            |  257 
 drivers/staging/rt3090/sta/assoc.c               | 1673 +++++
 drivers/staging/rt3090/sta/auth.c                |  491 +
 drivers/staging/rt3090/sta/auth_rsp.c            |  151 
 drivers/staging/rt3090/sta/connect.c             | 2759 ++++++++
 drivers/staging/rt3090/sta/dls.c                 | 2207 ++++++
 drivers/staging/rt3090/sta/rtmp_ckipmic.c        |  579 +
 drivers/staging/rt3090/sta/rtmp_data.c           | 2661 ++++++++
 drivers/staging/rt3090/sta/sanity.c              |  382 +
 drivers/staging/rt3090/sta/sync.c                | 1840 +++++
 drivers/staging/rt3090/sta/wpa.c                 |  396 +
 drivers/staging/rt3090/sta_ioctl.c               | 7559 +++++++++++++++++++++++
 drivers/staging/rt3090/vr_ikans.h                |   71 
 drivers/staging/rt3090/wpa.h                     |  447 +
 112 files changed, 104961 insertions(+)

