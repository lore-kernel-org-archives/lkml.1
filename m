Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbYKVRjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbYKVRjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759204AbYKVRgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:36:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58478 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570AbYKVRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:36:35 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 20/32] uninorth-agp section mess
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1L3wPK-0006Ym-Kq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:36:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'aperture' is declared devinitdata (the whole word of it) and
is used from ->fetch_size() which can, AFAICS, be used on
!HOTPLUG after init time.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/agp/uninorth-agp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -27,7 +27,7 @@
 static int uninorth_rev;
 static int is_u3;
 
-static char __devinitdata *aperture = NULL;
+static char *aperture = NULL;
 
 static int uninorth_fetch_size(void)
 {
