Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbYEFJZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbYEFJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763710AbYEFJOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:14:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59527 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763547AbYEFJOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:14:31 -0400
Message-Id: <20080506091421.417527360@szeredi.hu>
References: <20080506091327.259950960@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 May 2008 11:13:39 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: [patch 12/24] vfs: utimes immutable fix
Content-Disposition: inline; filename=utimes_immutable_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If updating file times to the current time and using a file
descriptor, then don't check for immutable inode, only if the file is
opened for write.  In this case immutability has been checked at open
time.  This is the same as how write() and ftruncate() are handled.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Ulrich Drepper <drepper@redhat.com>
---
 fs/utimes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-06 11:04:35.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-06 11:04:36.000000000 +0200
@@ -130,7 +130,7 @@ long do_utimes(int dfd, char __user *fil
 	if (!times || (nsec_special(times[0].tv_nsec) &&
 		       nsec_special(times[1].tv_nsec))) {
 		error = -EACCES;
-                if (IS_IMMUTABLE(inode))
+		if (!f && IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
 
 		if (!is_owner_or_cap(inode)) {

--
