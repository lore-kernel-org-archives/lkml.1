Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXDQNKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXDQNKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXDQNKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:10:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60361 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbXDQNKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:10:34 -0400
Date: Tue, 17 Apr 2007 18:47:54 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  3/15] Add the whiteout file type
Message-ID: <20070417131754.GD4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Add the whiteout file type

A white-out stops the VFS from further lookups of the white-outs name and
returns -ENOENT. This is the same behaviour as if the filename isn't
found. This can be used in combination with union mounts to virtually
delete (white-out) files by creating a file with this file type.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 include/linux/stat.h |    2 ++
 1 files changed, 2 insertions(+)

--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -10,6 +10,7 @@
 #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
 
 #define S_IFMT  00170000
+#define S_IFWHT  0160000	/* whiteout */
 #define S_IFSOCK 0140000
 #define S_IFLNK	 0120000
 #define S_IFREG  0100000
@@ -28,6 +29,7 @@
 #define S_ISBLK(m)	(((m) & S_IFMT) == S_IFBLK)
 #define S_ISFIFO(m)	(((m) & S_IFMT) == S_IFIFO)
 #define S_ISSOCK(m)	(((m) & S_IFMT) == S_IFSOCK)
+#define S_ISWHT(m)	(((m) & S_IFMT) == S_IFWHT)
 
 #define S_IRWXU 00700
 #define S_IRUSR 00400
