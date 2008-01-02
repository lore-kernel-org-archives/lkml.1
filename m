Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbYABUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbYABUK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbYABUJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:09:14 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55697 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbYABUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:09:12 -0500
Date: Wed, 2 Jan 2008 15:08:53 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Dominique Quatravaux <dominique@quatravaux.org>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/7] UML - Fix hostfs tv_usec calculations
Message-ID: <20080102200853.GA7949@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominique Quatravaux <dominique@quatravaux.org>

To convert from tv_nsec to tv_usec, one needs to divide by 1000, not
multiply.

Signed-off-by: Dominique Quatravaux <dominique@quatravaux.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 fs/hostfs/hostfs_user.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22/fs/hostfs/hostfs_user.c
===================================================================
--- linux-2.6.22.orig/fs/hostfs/hostfs_user.c	2007-11-21 12:04:56.000000000 -0500
+++ linux-2.6.22/fs/hostfs/hostfs_user.c	2007-11-21 13:01:28.000000000 -0500
@@ -285,17 +285,17 @@ int set_attr(const char *file, struct ho
 			return err;
 
 		times[0].tv_sec = atime_ts.tv_sec;
-		times[0].tv_usec = atime_ts.tv_nsec * 1000;
+		times[0].tv_usec = atime_ts.tv_nsec / 1000;
 		times[1].tv_sec = mtime_ts.tv_sec;
-		times[1].tv_usec = mtime_ts.tv_nsec * 1000;
+		times[1].tv_usec = mtime_ts.tv_nsec / 1000;
 
 		if (attrs->ia_valid & HOSTFS_ATTR_ATIME_SET) {
 			times[0].tv_sec = attrs->ia_atime.tv_sec;
-			times[0].tv_usec = attrs->ia_atime.tv_nsec * 1000;
+			times[0].tv_usec = attrs->ia_atime.tv_nsec / 1000;
 		}
 		if (attrs->ia_valid & HOSTFS_ATTR_MTIME_SET) {
 			times[1].tv_sec = attrs->ia_mtime.tv_sec;
-			times[1].tv_usec = attrs->ia_mtime.tv_nsec * 1000;
+			times[1].tv_usec = attrs->ia_mtime.tv_nsec / 1000;
 		}
 
 		if (fd >= 0) {
