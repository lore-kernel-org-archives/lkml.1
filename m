Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYJ2XEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYJ2XEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbYJ2XCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:02:55 -0400
Received: from kroah.org ([198.145.64.141]:35893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757436AbYJ2XCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:02:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/6] sysfs: Fix return values for sysdev_store_{ulong,int}
Date: Wed, 29 Oct 2008 15:58:09 -0700
Message-Id: <1225321092-21933-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223824.GB21657@kroah.com>
References: <20081029223824.GB21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

SYSFS: Fix return values for sysdev_store_{ulong,int}

Always return the full size instead of the consumed
length of the string in sysdev_store_{ulong,int}

This avoids EINVAL errors in some echo versions.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 3ca9c5e..c98c31e 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -488,7 +488,8 @@ ssize_t sysdev_store_ulong(struct sys_device *sysdev,
 	if (end == buf)
 		return -EINVAL;
 	*(unsigned long *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_ulong);
 
@@ -511,7 +512,8 @@ ssize_t sysdev_store_int(struct sys_device *sysdev,
 	if (end == buf || new > INT_MAX || new < INT_MIN)
 		return -EINVAL;
 	*(int *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_int);
 
-- 
1.6.0.2

