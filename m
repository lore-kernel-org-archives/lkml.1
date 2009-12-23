Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZLWI6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZLWI6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZLWI5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:57:37 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58850 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbZLWI5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:57:33 -0500
Message-Id: <20091223085553.389673883@vergenet.net>
User-Agent: quilt/0.48-1
Date: Wed, 23 Dec 2009 19:54:54 +1100
Subject: [patch 6/7] [patch] rtl8192su, rtl8192u: use min_t() in store_debug_level()
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Simon Horman <horms@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
Content-Disposition: inline; filename=rtl8192u-store_debug_level-min_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof() returns a size_t but the other types involved
are unsigned long, so using min() results in a warning.

As sizeof() is called on an 11 character buffer defined
immediately above unsigned long is obviously wide enough
for the result.

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

Compile tested only.

$ gcc --version
gcc (Debian 4.4.2-6) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make CONFIG_DEBUG_SECTION_MISMATCH=y
...
drivers/staging/rtl8192su/ieee80211/ieee80211_module.c: In function ‘store_debug_level’:
drivers/staging/rtl8192su/ieee80211/ieee80211_module.c:265: warning: comparison of distinct pointer types lacks a cast
...

Index: gregkh-2.6/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c	2009-12-23 19:24:36.000000000 +1100
+++ gregkh-2.6/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c	2009-12-23 19:24:38.000000000 +1100
@@ -262,7 +262,7 @@ static int store_debug_level(struct file
 			     unsigned long count, void *data)
 {
 	char buf[] = "0x00000000";
-	unsigned long len = min(sizeof(buf) - 1, count);
+	unsigned long len = min_t(unsigned long, sizeof(buf) - 1, count);
 	char *p = (char *)buf;
 	unsigned long val;
 
Index: gregkh-2.6/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c	2009-12-23 19:24:47.000000000 +1100
+++ gregkh-2.6/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c	2009-12-23 19:24:50.000000000 +1100
@@ -260,7 +260,7 @@ static int store_debug_level(struct file
 			     unsigned long count, void *data)
 {
 	char buf[] = "0x00000000";
-	unsigned long len = min(sizeof(buf) - 1, count);
+	unsigned long len = min_t(unsigned long, sizeof(buf) - 1, count);
 	char *p = (char *)buf;
 	unsigned long val;
 

