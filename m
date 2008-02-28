Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbYB1BGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbYB1BGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYB1BGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:06:46 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:59252 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYB1BGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:06:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T+ot5SHSUQ98oBJfB0UKmtdLxa00Q6fD3MQ/NkdvzzzzWyPLcJSiQNGScibGZdSO0aBZv6VXNADuvm6Nv5+BLB8VsQCqLRpDDEH0De9je5BbuvcBeVFT0l0N/uxSJWyE1fRSjMZjkACtv6OAGS21XN4fhvkJ8nkeQ5iAski2BUg=
Subject: [PATCH 13/12] sound: au88x0_core.c fix incorrect signedness
	warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 17:06:43 -0800
Message-Id: <1204160803.20280.62.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following, repeated at every callsite, vortex->fixed_res is always
passed in this argument, the change to unsigned int won't change anything.

sound/pci/au88x0/au88x0_core.c:2047:54: warning: incorrect type in argument 2 (different signedness)
sound/pci/au88x0/au88x0_core.c:2047:54:    expected int *resmap
sound/pci/au88x0/au88x0_core.c:2047:54:    got unsigned int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/au88x0/au88x0.h      |    4 ++--
 sound/pci/au88x0/au88x0_core.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index 4aad35b..31e6899 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -242,8 +242,8 @@ static int vortex_alsafmt_aspfmt(int alsafmt);
 static void vortex_connect_default(vortex_t * vortex, int en);
 static int vortex_adb_allocroute(vortex_t * vortex, int dma, int nr_ch,
 				 int dir, int type);
-static char vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
-				  int restype);
+static char vortex_adb_checkinout(vortex_t * vortex, unsigned int resmap[],
+				  int out, int restype);
 #ifndef CHIP_AU8810
 static int vortex_wt_allocroute(vortex_t * vortex, int dma, int nr_ch);
 static void vortex_wt_connect(vortex_t * vortex, int en);
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 333c62d..0ee8202 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -2000,7 +2000,7 @@ static int resnum[VORTEX_RESOURCE_LAST] =
  restype: Indicates type of resource to be checked in or out.
 */
 static char
-vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out, int restype)
+vortex_adb_checkinout(vortex_t * vortex, unsigned int resmap[], int out, int restype)
 {
 	int i, qty = resnum[restype], resinuse = 0;
 
-- 
1.5.4.3.342.g99e8



