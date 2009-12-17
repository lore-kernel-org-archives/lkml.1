Return-Path: <linux-kernel-owner+w=401wt.eu-S965130AbZLQSO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130AbZLQSO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbZLQSOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:14:09 -0500
Received: from smtp.nokia.com ([192.100.122.233]:36416 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935077AbZLQSN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:13:58 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/6] Driver core: Encourage use of const attributes
Date: Thu, 17 Dec 2009 20:12:10 +0200
Message-Id: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 17 Dec 2009 18:11:52.0781 (UTC) FILETIME=[68E4CFD0:01CA7F44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know now's probably a bad time to be mentioning const issues
but I recently a reviewed a patch where 'const' was being removed 
from a device_attribute structure, and I enquired why. The reason
was simply so that device_create_file() could be called, it taking
a non-const attribute pointer. Looking inside, all that function 
did was pass a pointer to sysfs_create_file, which itself took a
const pointer. Non-constness was not required at all.

So here I offer a small patchset which I hope will permit and 
encourage device and other attributes to be made const, and put 
in read-only sections.

1-3 address the three attribute types which seemed to be trivially 
const-able, and are the important part of the set.

4 adds a new macro to encourage the use of Const ATTRibutes,
and may need a better name. (I wanted to avoid RO, for example.)

5 and 6 are merely two quick examples of how easy it is to adopt 
the new const convention. In reality, these structures have been
constant and treated as constant by the driver core all along, it's
just that one word was missing from a few important places.

I would hope to submit a patchset with 1-3 and a possibly modified 
4. The migrations themselves will belong in different trees.

These have been compile/sparse tested against arm and x86_64 targets, 
and through my usual suite of tests on the arm platform I use.

Regards,
Phil

Phil Carmody (6):
  Driver core: device_attribute parameters can often be const*
  Driver core: bin_attribute parameters can often be const*
  Driver core: driver_attribute parameters can often be const*
  Driver core: Easy macros to encourage const attributes
  PM: Example of how easy it is to mark attributes const
  gpio: Example of how easy it is to mark attributes const

 drivers/base/core.c      |   12 ++++++++----
 drivers/base/driver.c    |    4 ++--
 drivers/gpio/gpiolib.c   |   12 ++++++------
 drivers/regulator/core.c |   38 +++++++++++++++++++-------------------
 fs/sysfs/bin.c           |    6 ++++--
 include/linux/device.h   |   20 ++++++++++++++------
 include/linux/sysfs.h    |    9 +++++----
 7 files changed, 58 insertions(+), 43 deletions(-)

