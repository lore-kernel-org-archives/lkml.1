Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbXIZJni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbXIZJni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXIZJn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:43:29 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:17313 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXIZJn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:43:28 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] [REPOST] PowerPC: ibmebus refactoring and fixes
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2967
Date: Wed, 26 Sep 2007 11:43:24 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200709261143.24735.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset will merge the ibmebus and of_platform bus drivers by basing a
lot of ibmebus functionality on of_platform code and adding the features
specific to ibmebus on top of that.

This is a repost of my previous patchset incorporating Arnd's comments.

I split the actual ibmebus rework into three patches (2/5-4/5) for easier
readability. The kernel will compile during the intermediate states, and
ibmebus will not crash, but not work either.

As a side-effect of patch 3/5, a problem with bus_id collisions in case of
two devices sharing the same location code is resolved -- the bus_id is now
determined differently.

[1/5] moves of_device allocation into of_device.[ch]
[2/5] removes the old bus match/probe/remove functions
[3/5] adds device creation and bus probing based on of_device
[4/5] finally moves to of_device and of_platform_driver by changing
      ibmebus.h and matching the eHCA and eHEA drivers
[5/5] just changes a nit in ibmebus_store_probe()

These patches should apply cleanly, in order, against 2.6.23-rc5 and against
Linus' git. Please review and comment them, and queue them up for 2.6.24 if
you think they're okay.

Thanks and regards,
  Joachim


 arch/powerpc/kernel/ibmebus.c             |  267 ++++++++---------------------
 arch/powerpc/kernel/of_device.c           |   80 +++++++++
 arch/powerpc/kernel/of_platform.c         |   70 +--------
 drivers/infiniband/hw/ehca/ehca_classes.h |    2 +-
 drivers/infiniband/hw/ehca/ehca_eq.c      |    6 +-
 drivers/infiniband/hw/ehca/ehca_main.c    |   32 ++--
 drivers/net/ehea/ehea.h                   |    2 +-
 drivers/net/ehea/ehea_main.c              |   72 ++++----
 include/asm-powerpc/ibmebus.h             |   38 +----
 include/asm-powerpc/of_device.h           |    4 +
 include/linux/of_device.h                 |    5 +
 11 files changed, 228 insertions(+), 350 deletions(-)

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com


