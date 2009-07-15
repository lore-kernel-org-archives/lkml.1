Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZGOHhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZGOHhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZGOHho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:37:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:39573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZGOHho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="707936150"
Subject: [PATCH 0/8] device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2009 15:38:32 +0800
Message-Id: <1247643512.26272.74.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the patch set I made to speed up the device
suspend/resume/shutdown process.

A new mechanism called Device Async Actions is introduced in this patch set.
The basic idea is that,
1. device declares to support certain kinds of device async action,
   like suspend, resume, shutdown, etc.
2. a async domain is create for this device
3. the child device inherits the async domain
4. devices in the same domain suspend/resume/shutdown asynchronously with
   the other devices.

Currently, in order to make sure that it won't bring any side effects,
I only convert the ACPI battery and i8042 to use this framework, which reduces
0.5s+ S3 time(suspend time plus resume time)﻿, from 7.0s to less than 6.5s.
and about 0.5s shutdown time in my test.

Any comments are welcome. :)

thanks,
rui


 drivers/acpi/battery.c      |   13 +++
 drivers/base/Makefile       |    3 +-
 drivers/base/async_dev.c    |  210 +++++++++++++++++++++++++++++++++++++++++++
 drivers/base/core.c         |   16 +++-
 drivers/base/power/main.c   |   10 ++-
 drivers/input/serio/i8042.c |   10 ++-
 include/linux/async.h       |    3 +
 include/linux/async_dev.h   |   45 +++++++++
 include/linux/device.h      |    2 +
 9 files changed, 306 insertions(+), 6 deletions(-)



