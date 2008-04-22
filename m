Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbYDVP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbYDVP4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763147AbYDVP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:56:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763457AbYDVP4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:56:02 -0400
Message-ID: <480E0A7C.2060907@redhat.com>
Date: Tue, 22 Apr 2008 10:55:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] mark loop functions as noinline_for_stack
References: <480E06A6.1080803@redhat.com>
In-Reply-To: <480E06A6.1080803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the self-documenting noinline_for_stack attribute
in loop functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.25/drivers/block/loop.c
===================================================================
--- linux-2.6.25.orig/drivers/block/loop.c	2008-04-22 10:31:05.015471118 -0500
+++ linux-2.6.25/drivers/block/loop.c	2008-04-22 10:51:18.070407735 -0500
@@ -1182,9 +1182,8 @@ struct compat_loop_info {
 
 /*
  * Transfer 32-bit compatibility structure in userspace to 64-bit loop info
- * - noinlined to reduce stack space usage in main part of driver
  */
-static noinline int
+static noinline_for_stack int
 loop_info64_from_compat(const struct compat_loop_info __user *arg,
 			struct loop_info64 *info64)
 {
@@ -1215,9 +1214,8 @@ loop_info64_from_compat(const struct com
 
 /*
  * Transfer 64-bit loop info to 32-bit compatibility structure in userspace
- * - noinlined to reduce stack space usage in main part of driver
  */
-static noinline int
+static noinline_for_stack int
 loop_info64_to_compat(const struct loop_info64 *info64,
 		      struct compat_loop_info __user *arg)
 {

