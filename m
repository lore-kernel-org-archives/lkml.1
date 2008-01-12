Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbYALJjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbYALJjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760270AbYALJjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:39:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:59791 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYALJjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:39:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=VHlQpKvsVUypKUOY5YIF9ME6A4WyvBh1zXSafip8QU7nVaIVO1wGmbjRo+bTf17rxE4MupTP7A+tk0y1HFlniZOkbmkN1Z7wC0OGnQGxFo4X9L45xctIn567V9h1dIQMQP6YjzQM+TbWJ+aq2LNDPsZrN7pGf1ELJI+0+Z5q9gY=
Date: Sat, 12 Jan 2008 17:42:33 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: stefanr@s5r6.in-berlin.de, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       krh@redhat.com, stern@rowland.harvard.edu, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
Subject: [PATCH 0/7] Add class iteration api and convert semaphore to mutex
Message-ID: <20080112094233.GA2879@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series do three things:

1.[PATCH 1/7]
  Add some class iteration functions in driver core:
  class_for_each_device
  class_find_device
  class_for_each_child
  class_find_child

2.[PATCH {2,3,4,5,6}/7]
  Make the drivers with class iterating to use class iteration api.

3.[PATCH 7/7]
  Convert the class semaphore to mutex.

toc:
---
1-driver-core-add-class-iteration-api.patch
2-ieee1394-use-class-iteration-api.patch
3-power_supply-use-class-iteration-api.patch
4-rtc-use-class-iteration-api.patch
5-scsi-use-class-iteration-api.patch
6-spi-use-class-iteration-api.patch
7-driver-core-class-convert-semaphore-to-mutex.patch

Summary diffstat:
---
 drivers/base/class.c              |  197 +++++++++++++++++++++--
 drivers/base/core.c               |   18 --
 drivers/ieee1394/nodemgr.c        |  319 +++++++++++++++++++++-----------------
 drivers/power/apm_power.c         |  116 ++++++++-----
 drivers/power/power_supply_core.c |   72 ++++----
 drivers/rtc/interface.c           |   22 +-
 drivers/scsi/hosts.c              |   26 +--
 drivers/spi/spi.c                 |   26 +--
 include/linux/device.h            |   11 +
 9 files changed, 523 insertions(+), 284 deletions(-)

Thanks all your comment and help. If there's some problem in these ones, please help to point out.

Thanks again.

Regards
dave
