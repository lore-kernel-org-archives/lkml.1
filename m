Return-Path: <linux-kernel-owner+w=401wt.eu-S1946461AbXBCO0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946461AbXBCO0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 09:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946460AbXBCO0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 09:26:09 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:41136 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946457AbXBCO0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 09:26:06 -0500
Subject: [GIT PATCH] SCSI final bug fixes for 2.6.20-rc7
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Feb 2007 08:25:59 -0600
Message-Id: <1170512760.3345.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are four small bug fixes in this:  A set of qla4xxx driver bugs, a
fix for uninitialised variables in sd during initial hotplug, a tape fix
for BUG 7864 and an async scan fix for the "none" scanning type with
RAID devices.

The fix is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

David C Somayajulu (1):
       qla4xxx: bug fixes

Kai Makisara (1):
       st: A MTIOCTOP/MTWEOF within the early warning will cause the file number to be incorrect

Matthew Wilcox (1):
       Fix scsi_add_device() for async scanning

Nagendra Singh Tomar (1):
       sd: udev accessing an uninitialized scsi_disk field results in a crash

and the diffstat:

 qla4xxx/ql4_def.h     |    1 
 qla4xxx/ql4_glbl.h    |    1 
 qla4xxx/ql4_init.c    |   18 +++++++-------
 qla4xxx/ql4_isr.c     |    4 +--
 qla4xxx/ql4_mbx.c     |   35 ++++++++++++++++-----------
 qla4xxx/ql4_os.c      |   64 ++++++++++++++++++++++++++++++--------------------
 qla4xxx/ql4_version.h |    2 -
 scsi_scan.c           |    6 ++++
 sd.c                  |   20 +++++++--------
 st.c                  |   19 ++++++++------
 10 files changed, 100 insertions(+), 70 deletions(-)

James


