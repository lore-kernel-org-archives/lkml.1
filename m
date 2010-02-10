Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0BJPPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:15:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0BJPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:15:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH, regression] compat_ioctl: ignore RAID_VERSION ioctl
Date: Wed, 10 Feb 2010 16:14:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>, NeilBrown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002101614.04387.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+XgQbEid4btcjo+iCj+vrgSwg2zhQtNO7c0kG
 YF4/ASOioict+elIPT2hRPjYQ+jTeq2IQAI26bPhXb/3FB9W9l
 hyyxWDWx/XSWiPTh6YzSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

md ioctls are now handled by the md driver itself, but mdadm
may call RAID_VERSION on other devices as well. Mark the command
as IGNORE_IOCTL so this fails silently rather than printing
an annoying message.

Reported-by: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c5c45de..b6f23b2 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1038,6 +1038,8 @@ COMPATIBLE_IOCTL(FIOQSIZE)
 #ifdef CONFIG_BLOCK
 /* loop */
 IGNORE_IOCTL(LOOP_CLR_FD)
+/* md calls this on random blockdevs */
+IGNORE_IOCTL(RAID_VERSION)
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
-- 
1.6.3.3

