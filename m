Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXIYMLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXIYMLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXIYMLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:11:06 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:10502 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbXIYMLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:11:04 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] PowerPC: ibmebus refactoring and fixes
Date: Tue, 25 Sep 2007 14:10:29 +0200
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mackerras <pmac@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709251410.29780.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset will merge the ibmebus and of_platform bus drivers by basing a
lot of ibmebus functionality on of_platform code and adding the features
specific to ibmebus on top of that.

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

 arch/powerpc/kernel/ibmebus.c             |  263 ++++++++---------------------
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
 11 files changed, 226 insertions(+), 348 deletions(-)

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com

