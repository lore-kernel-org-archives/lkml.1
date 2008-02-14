Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYBNCIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYBNCIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYBNCHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:07:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:32779 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYBNCHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w49ddR+5s0plykiogBHQkH56OBImwBdBCQEFhZiCcEYtYGuaqeS5LCj2U02i3gQetXc3sRWYS5m/ynki8VMkNQQ0ydCItsuBloTl9CoqiIiYoqZ6Gu2PyY8xgiJbZwO8uSW9ziQEEsCM3jxhnx4pQXv9hBB+6CY6lfX9LYHnRJw=
Subject: [PATCH] adfs: trivial sparse fix
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 18:07:48 -0800
Message-Id: <1202954868.18204.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/adfs/dir_f.c:126:4: warning: do-while statement is not a compound statement

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/adfs/dir_f.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/adfs/dir_f.c b/fs/adfs/dir_f.c
index b9b2b27..ea7df21 100644
--- a/fs/adfs/dir_f.c
+++ b/fs/adfs/dir_f.c
@@ -122,9 +122,9 @@ adfs_dir_checkbyte(const struct adfs_dir *dir)
 		ptr.ptr8 = bufoff(bh, i);
 		end.ptr8 = ptr.ptr8 + last - i;
 
-		do
+		do {
 			dircheck = *ptr.ptr8++ ^ ror13(dircheck);
-		while (ptr.ptr8 < end.ptr8);
+		} while (ptr.ptr8 < end.ptr8);
 	}
 
 	/*
-- 
1.5.4.1.1278.gc75be



