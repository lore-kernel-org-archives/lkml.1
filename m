Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZLINt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZLINt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZLINt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:49:57 -0500
Received: from smtp.nokia.com ([192.100.122.230]:61243 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZLINt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:49:57 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: dbrownell@users.sourceforge.net, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org,
       ext-jani.1.nikula@nokia.com
Subject: [PATCH 0/3] gpiolib: gpio naming in sysfs
Date: Wed,  9 Dec 2009 15:49:01 +0200
Message-Id: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 09 Dec 2009 13:49:10.0557 (UTC) FILETIME=[62924CD0:01CA78D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David and Greg -

There's been debate in the past about naming gpios exported to the
sysfs. Long story short, there are users for that, and there are now
two ways of naming gpios in the sysfs: char **names in struct
gpio_chip [1], and gpio_export_link() [2].

This patchset combines these two by allowing gpio_export_link() to
have dev == NULL to make the link under gpiolib sysfs (instead of
arbitrary device), and to use gpio_chip names to create links (instead
of naming the actual devices with those). This gpio_export_link() with
dev == NULL would also be useful for gpios not associated with a
driver.

Greg, patch 1/3 introduces class_{create,remove}_link(), is that
acceptable?

CC Daniel, you introduced names in struct gpio_chip in the first
place, does this (especially patch 3/3) look acceptable to you?


BR,
Jani.


[1] commit 926b663ce8215ba448960e1ff6e58b67a2c3b99b
[2] commit a4177ee7f1a83eecb1d75e85d32664b023ef65e9


Artem Bityutskiy (1):
  device class: add symlink creation helpers

Jani Nikula (2):
  gpiolib: add support for having symlinks under gpio class directory
  gpiolib: use chip->names for symlinks, always use gpioN for device
    names

 drivers/base/class.c   |   21 ++++++++++
 drivers/gpio/gpiolib.c |  101 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h |    4 ++
 3 files changed, 120 insertions(+), 6 deletions(-)

