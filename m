Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZG2KoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZG2KoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZG2KoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:44:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZG2KoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:44:14 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] trivial: Fix stale definition of file-nr in documentation
Date: Wed, 29 Jul 2009 18:37:37 +0800
Message-Id: <1248863857-5629-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 760df9 merged /proc/sys/fs documentation in Documentation/sysctl/
fs.txt and Documentation/filesystem/proc.txt, but stale file-nr definition
is remained. This patch add back the right fs-nr definition for 2.6 kernel.

Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
---
 Documentation/sysctl/fs.txt |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 1458448..6268250 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -96,13 +96,16 @@ handles that the Linux kernel will allocate. When you get lots
 of error messages about running out of file handles, you might
 want to increase this limit.
 
-The three values in file-nr denote the number of allocated
-file handles, the number of unused file handles and the maximum
-number of file handles. When the allocated file handles come
-close to the maximum, but the number of unused file handles is
-significantly greater than 0, you've encountered a peak in your 
-usage of file handles and you don't need to increase the maximum.
-
+Historically, the three values in file-nr denoted the number of
+allocated file handles, the number of allocated but unused file
+handles, and the maximum number of file handles. Linux 2.6 always
+reports 0 as the number of free file handles -- this is not an
+error, it just means that the number of allocated file handles
+exactly matches the number of used file handles.
+
+Attempts to allocate more file descriptors than file-max are
+reported with printk, look for "VFS: file-max limit <number>
+reached".
 ==============================================================
 
 nr_open:
-- 
1.6.2.5

