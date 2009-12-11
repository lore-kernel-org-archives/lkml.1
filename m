Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbZLKEyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbZLKEyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761317AbZLKEyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:54:22 -0500
Received: from kroah.org ([198.145.64.141]:36801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760590AbZLKEf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:59 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:49 2009
Message-Id: <20091211042748.760455091@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [30/90] ext4: Fix include/trace/events/ext4.h to work with Systemtap
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0030-ext4-Fix-include-trace-events-ext4.h-to-work-with-Sy.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 3661d28615ea580c1db02a972fd4d3898df1cb01)

Using relative pathnames in #include statements interacts badly with
SystemTap, since the fs/ext4/*.h header files are not packaged up as
part of a distribution kernel's header files.  Since systemtap doesn't
use TP_fast_assign(), we can use a blind structure definition and then
make sure the needed header files are defined before the ext4 source
files #include the trace/events/ext4.h header file.

https://bugzilla.redhat.com/show_bug.cgi?id=512478

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c             |    1 +
 include/trace/events/ext4.h |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -45,6 +45,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "mballoc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -5,10 +5,12 @@
 #define _TRACE_EXT4_H
 
 #include <linux/writeback.h>
-#include "../../../fs/ext4/ext4.h"
-#include "../../../fs/ext4/mballoc.h"
 #include <linux/tracepoint.h>
 
+struct ext4_allocation_context;
+struct ext4_allocation_request;
+struct ext4_prealloc_space;
+
 TRACE_EVENT(ext4_free_inode,
 	TP_PROTO(struct inode *inode),
 


