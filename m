Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0BRS5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:57:31 -0500
Received: from smtp.nokia.com ([192.100.105.134]:34019 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab0BRS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:28 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 00/12] Clean up code to use native kernel functions when convert or check hex digits
Date: Thu, 18 Feb 2010 20:55:39 +0200
Message-Id: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 18 Feb 2010 18:57:19.0264 (UTC) FILETIME=[32075A00:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Hello.

There are set of paches related to hex2bin, bin2hex, isxdigit custom
implementations. All of them are changed by native kernel functions. In case of
hex2bin there is generalized method [hex_to_bin] to do such thing which is put under
lib/hexxdump.c (kernel.h).

TODO: apply hex_to_bin() to kgdb code.

Andy Shevchenko (12):
  isdn: remove ishexdigit() in regard to isxdigit()
  audit: use kernel's method to get byte in hex form
  staging: remove unused methods
  scsi: ibmmca: use kernel native convertor
  lib: introduce common method to convert hex digits
  drivers: net: optimize hex2bin()
  usb: atm: speedtch: use new hex_to_bin() method
  net: use new hex_to_bin() method
  drivers: net: use kernel's method to get byte in hex form
  drivers: net: use new hex_to_bin() method
  drivers: isdn: use new hex_to_bin() method
  drivers: wireless: use kernel's method to get byte in hex form

 drivers/isdn/gigaset/capi.c         |   30 +++---------------------------
 drivers/net/cxgb3/t3_hw.c           |   16 ++++------------
 drivers/net/ppp_synctty.c           |    4 +---
 drivers/net/ps3_gelic_wireless.c    |   12 ++++--------
 drivers/net/sb1250-mac.c            |   32 ++------------------------------
 drivers/net/wireless/at76c50x-usb.c |    5 +----
 drivers/scsi/ibmmca.c               |    3 +--
 drivers/staging/otus/apdbg.c        |   25 -------------------------
 drivers/usb/atm/speedtch.c          |    5 ++---
 include/linux/kernel.h              |    2 ++
 kernel/audit.c                      |    8 +++-----
 lib/hexdump.c                       |   19 +++++++++++++++++++
 12 files changed, 42 insertions(+), 119 deletions(-)

