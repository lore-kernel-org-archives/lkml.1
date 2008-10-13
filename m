Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbYJMKOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbYJMKOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763630AbYJMKDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:03:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39543 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763635AbYJMKDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:03:07 -0400
Date: Mon, 13 Oct 2008 12:03:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH] SYSFS: Fix return values for sysdev_store_{ulong,int}
Message-ID: <20081013100303.GA32199@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSFS: Fix return values for sysdev_store_{ulong,int}

Always return the full size instead of the consumed
length of the string in sysdev_store_{ulong,int}

This avoids EINVAL errors in some echo versions.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/drivers/base/sys.c
===================================================================
--- linux.orig/drivers/base/sys.c
+++ linux/drivers/base/sys.c
@@ -488,7 +488,8 @@ ssize_t sysdev_store_ulong(struct sys_de
 	if (end == buf)
 		return -EINVAL;
 	*(unsigned long *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_ulong);
 
@@ -511,7 +512,8 @@ ssize_t sysdev_store_int(struct sys_devi
 	if (end == buf || new > INT_MAX || new < INT_MIN)
 		return -EINVAL;
 	*(int *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_int);
 
