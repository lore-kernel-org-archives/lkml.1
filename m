Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZHPT3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZHPT3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZHPT3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:29:23 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49711 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZHPT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=XnUNRousY2typksmIDqomWf7WOOWyEHcoPK8bq34AOKKgly1hpELr/EtYZEd4nFMc6
         cP9+67VAYA/dTwDEe9BwK3ZxW+XG9p/slHTnDgd9flOn9K5yCx8F6C4ER166y89tDe8H
         jiA5FcETe754P87fl/E0uEZA6wb3mJuDaFAgk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:29:34 +0200
Message-Id: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/22] Staging: rt{286,287,307}0: various fixes/cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Some fixes, some cleanups and a lot of preparations for finally merging
rt{28,30}70 drivers together.

Tested with RT2860 (Asus Eee 901) and RT3070 (el cheapo USB dongle that
I've bought recently to speed up the development, I'm posting this mail
using it right now) chipsets.

PS I tried using rt2800usb driver found in 2.6.31-rc6 (with overdue fix
for memory corruption in rf cache from Pavel Roskin) for RT3070 chipset
but it doesn't seem to work yet (iwlist wlan0 scan => no stations)..


diffstat:
 drivers/staging/rt2860/ap.h                    |  453 ---
 drivers/staging/rt2860/common/action.c         |   11 
 drivers/staging/rt2860/common/ba_action.c      |   15 
 drivers/staging/rt2860/common/cmm_data.c       |  162 -
 drivers/staging/rt2860/common/cmm_sanity.c     |  184 -
 drivers/staging/rt2860/common/cmm_wpa.c        |  794 ------
 drivers/staging/rt2860/common/eeprom.c         |   32 
 drivers/staging/rt2860/common/mlme.c           |  307 --
 drivers/staging/rt2860/common/rtmp_init.c      |  227 -
 drivers/staging/rt2860/common/spectrum.c       |    5 
 drivers/staging/rt2860/dfs.h                   |   12 
 drivers/staging/rt2860/link_list.h             |  134 -
 drivers/staging/rt2860/oid.h                   |  163 -
 drivers/staging/rt2860/rt28xx.h                |   22 
 drivers/staging/rt2860/rt_config.h             |    4 
 drivers/staging/rt2860/rt_linux.c              |    9 
 drivers/staging/rt2860/rt_linux.h              |   83 
 drivers/staging/rt2860/rt_main_dev.c           |   40 
 drivers/staging/rt2860/rt_profile.c            |   11 
 drivers/staging/rt2860/rtmp.h                  |  682 -----
 drivers/staging/rt2860/rtmp_ckipmic.h          |   35 
 drivers/staging/rt2860/rtmp_def.h              |   14 
 drivers/staging/rt2860/sta/assoc.c             |    6 
 drivers/staging/rt2860/sta/connect.c           |   11 
 drivers/staging/rt2860/sta/rtmp_data.c         |   10 
 drivers/staging/rt2860/sta/sync.c              |    2 
 drivers/staging/rt2860/sta_ioctl.c             | 2984 -------------------------
 drivers/staging/rt2860/wpa.h                   |    2 
 drivers/staging/rt2870/2870_main_dev.c         |  255 +-
 drivers/staging/rt2870/common/2870_rtmp_init.c |   58 
 drivers/staging/rt2870/common/rtusb_io.c       |   33 
 drivers/staging/rt2870/link_list.h             |    1 
 drivers/staging/rt2870/rt2870.h                |  194 -
 drivers/staging/rt3070/link_list.h             |    1 
 34 files changed, 252 insertions(+), 6704 deletions(-)
