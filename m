Return-Path: <linux-kernel-owner+w=401wt.eu-S1763252AbYBMOrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763252AbYBMOrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbYBMOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:47:16 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42066 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbYBMOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:47:15 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] V4L, include ioctl.h in videodev headers
Date: Wed, 13 Feb 2008 15:47:11 +0100
Message-Id: <1202914031-6048-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation of user processes which includes videodev*.h but not includes
linux/ioctl.h:

v4l2ext_helper.c: In function ‘process_ioctl’:
v4l2ext_helper.c:183: warning: implicit declaration of function ‘_IOWR’
v4l2ext_helper.c:183: error: expected expression before ‘struct’
v4l2ext_helper.c:183: error: case label does not reduce to an integer constant

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/videodev.h  |    1 +
 include/linux/videodev2.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev.h b/include/linux/videodev.h
index 52e3d5f..9385a56 100644
--- a/include/linux/videodev.h
+++ b/include/linux/videodev.h
@@ -12,6 +12,7 @@
 #ifndef __LINUX_VIDEODEV_H
 #define __LINUX_VIDEODEV_H
 
+#include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
 #if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 439474f..17a8017 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -62,6 +62,7 @@
 #define __user
 #include <sys/time.h>
 #endif
+#include <linux/ioctl.h>
 #include <linux/types.h>
 
 /*
-- 
1.5.3.8

