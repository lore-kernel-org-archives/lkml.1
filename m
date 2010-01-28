Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650Ab0A1PqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0A1PqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536Ab0A1PqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:46:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0A1PqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:46:01 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7][linux-next v2] ramzswap: bug fixes and some cleanups
Date: Thu, 28 Jan 2010 21:13:36 +0530
Message-Id: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Changelog v2
 - replace stat_*() with rzs_stat*() to avoid conflict with core kernel
 - split changes across separate patches

ramzswap driver creates virtual block devices which can
be used (only) as swap disks. Pages swapped to these disks
are compressed and stored in memory itself. Project home:
http://code.google.com/p/compcache/

These patches apply to linux-next.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Nitin Gupta (7):
  Use lock for 64-bit stats
  Flush block device before reset
  Set block size to PAGE_SIZE
  Return proper error code on device create failure
  Remove redundant check for zero page
  Handle case for invalid backing swap
  Update copyright notice

 drivers/staging/ramzswap/ramzswap_drv.c   |  148 +++++++++++++++++------------
 drivers/staging/ramzswap/ramzswap_drv.h   |   61 ++++++++++--
 drivers/staging/ramzswap/ramzswap_ioctl.h |    3 +-
 drivers/staging/ramzswap/xvmalloc.c       |    2 +-
 drivers/staging/ramzswap/xvmalloc.h       |    2 +-
 drivers/staging/ramzswap/xvmalloc_int.h   |    2 +-
 6 files changed, 141 insertions(+), 77 deletions(-)

