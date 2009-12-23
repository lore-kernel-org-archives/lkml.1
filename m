Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZLWI5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZLWI5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZLWI5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:57:37 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58851 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZLWI5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:57:33 -0500
Message-Id: <20091223085553.089696530@vergenet.net>
User-Agent: quilt/0.48-1
Date: Wed, 23 Dec 2009 19:54:53 +1100
Subject: [patch 5/7] [patch] rtl8192e: remove some functions from the __exit section
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Simon Horman <horms@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
Content-Disposition: inline; filename=rtl8192e-sections.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ieee80211_crypto_tkip_exit(), ieee80211_crypto_deinit() and
ieee80211_crypto_ccmp_exit() are called by ieee80211_rtl_init()
which are in section __init, so they can't be in section __exit.

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

WARNING: drivers/staging/rtl8192e/r8192e_pci.o(.init.text+0xda): Section mismatch in reference from the function ieee80211_rtl_init() to the function .exit.text:ieee80211_crypto_tkip_exit()
The function __init ieee80211_rtl_init() references
a function __exit ieee80211_crypto_tkip_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
ieee80211_crypto_tkip_exit() so it may be used outside an exit section.

WARNING: drivers/staging/rtl8192e/r8192e_pci.o(.init.text+0xdf): Section mismatch in reference from the function ieee80211_rtl_init() to the function .exit.text:ieee80211_crypto_deinit()
The function __init ieee80211_rtl_init() references
a function __exit ieee80211_crypto_deinit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
ieee80211_crypto_deinit() so it may be used outside an exit section.

WARNING: drivers/staging/rtl8192e/r8192e_pci.o(.init.text+0xf4): Section mismatch in reference from the function ieee80211_rtl_init() to the function .exit.text:ieee80211_crypto_ccmp_exit()
The function __init ieee80211_rtl_init() references
a function __exit ieee80211_crypto_ccmp_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
ieee80211_crypto_ccmp_exit() so it may be used outside an exit section.

WARNING: drivers/staging/rtl8192e/r8192e_pci.o(.init.text+0xf9): Section mismatch in reference from the function ieee80211_rtl_init() to the function .exit.text:ieee80211_crypto_tkip_exit()
The function __init ieee80211_rtl_init() references
a function __exit ieee80211_crypto_tkip_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
ieee80211_crypto_tkip_exit() so it may be used outside an exit section.

WARNING: drivers/staging/rtl8192e/r8192e_pci.o(.init.text+0xfe): Section mismatch in reference from the function ieee80211_rtl_init() to the function .exit.text:ieee80211_crypto_deinit()
The function __init ieee80211_rtl_init() references
a function __exit ieee80211_crypto_deinit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
ieee80211_crypto_deinit() so it may be used outside an exit section.

Index: gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c	2009-12-23 19:35:06.000000000 +1100
+++ gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c	2009-12-23 19:45:05.000000000 +1100
@@ -225,7 +225,7 @@ out:
 }
 
 
-void __exit ieee80211_crypto_deinit(void)
+void ieee80211_crypto_deinit(void)
 {
 	struct list_head *ptr, *n;
 
Index: gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c	2009-12-23 19:45:05.000000000 +1100
+++ gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c	2009-12-23 19:45:05.000000000 +1100
@@ -524,7 +524,7 @@ int __init ieee80211_crypto_ccmp_init(vo
 }
 
 
-void __exit ieee80211_crypto_ccmp_exit(void)
+void ieee80211_crypto_ccmp_exit(void)
 {
 	ieee80211_unregister_crypto_ops(&ieee80211_crypt_ccmp);
 }
Index: gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c	2009-12-23 19:45:00.000000000 +1100
+++ gregkh-2.6/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c	2009-12-23 19:45:05.000000000 +1100
@@ -1012,7 +1012,7 @@ int __init ieee80211_crypto_tkip_init(vo
 }
 
 
-void __exit ieee80211_crypto_tkip_exit(void)
+void ieee80211_crypto_tkip_exit(void)
 {
 	ieee80211_unregister_crypto_ops(&ieee80211_crypt_tkip);
 }

