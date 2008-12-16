Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYLPM55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYLPM55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYLPM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:57:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:58070 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbYLPM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:57:38 -0500
Message-ID: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Tue, 16 Dec 2008 13:31:31 +0100
Subject: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: include a prototype for the exported function in the macro

Fix about 20 of this warnings:

  drivers/hid/hid-a4tech.c:162:1: warning: symbol 'hid_compat_a4tech' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 include/linux/hid.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 215035b..81aa84d 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -793,6 +793,8 @@ dbg_hid(const char *fmt, ...)
 
 #ifdef CONFIG_HID_COMPAT
 #define HID_COMPAT_LOAD_DRIVER(name)	\
+/* prototype to avoid sparse warning */	\
+extern void hid_compat_##name(void);	\
 void hid_compat_##name(void) { }	\
 EXPORT_SYMBOL(hid_compat_##name)
 #else
-- 
1.5.6.3

