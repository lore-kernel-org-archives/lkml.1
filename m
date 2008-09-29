Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYI2Dxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYI2Dxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 23:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYI2DxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 23:53:07 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:48221 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159AbYI2DxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 23:53:06 -0400
Message-Id: <20080929032837.772588451@linux-m68k.org>
References: <20080929032709.693370201@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 05:27:11 +0200
From: zippel@linux-m68k.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: [PATCH 2/2] readd lost change count
Content-Disposition: inline; filename=fix-conf2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f072181e6403b0fe2e2aa800a005497b748fd284 simply dropped the warnings,
but it does a little more than that, it also marks the current .config
as needed saving, so add this back.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Index: linux-2.6/scripts/kconfig/confdata.c
===================================================================
--- linux-2.6.orig/scripts/kconfig/confdata.c
+++ linux-2.6/scripts/kconfig/confdata.c
@@ -222,8 +222,10 @@ load:
 				continue;
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 9);
-				if (!sym)
+				if (!sym) {
+					sym_add_change_count(1);
 					break;
+				}
 			} else {
 				sym = sym_lookup(line + 9, 0);
 				if (sym->type == S_UNKNOWN)
@@ -259,8 +261,10 @@ load:
 			}
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 7);
-				if (!sym)
+				if (!sym) {
+					sym_add_change_count(1);
 					break;
+				}
 			} else {
 				sym = sym_lookup(line + 7, 0);
 				if (sym->type == S_UNKNOWN)

-- 

