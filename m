Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYJ2Nud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYJ2Nud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYJ2NuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:50:25 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:45165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYJ2NuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:50:24 -0400
Subject: [PATCH] resource: fix section mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 14:50:08 +0100
Message-Id: <1225288208.5439.25.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reserve_region_with_list uses __reserve_region_with_split which is
__init, and is used only from e820 init which is __init too, so it can
be __init. Fixes a section mismatch warning.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 kernel/resource.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- everything.orig/kernel/resource.c	2008-10-29 02:49:07.000000000 +0100
+++ everything/kernel/resource.c	2008-10-29 02:49:19.000000000 +0100
@@ -571,7 +571,8 @@ static void __init __reserve_region_with
 
 }
 
-void reserve_region_with_split(struct resource *root,
+void __init
+reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
 		const char *name)
 {


