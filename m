Return-Path: <linux-kernel-owner+w=401wt.eu-S1760412AbYECMYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbYECMYD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764003AbYECMXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:23:51 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:41281 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763989AbYECMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:23:50 -0400
MIME-Version: 1.0
Date: Sat, 03 May 2008 14:23:45 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [OP] 02-vfs-utimes-Honour-CAP_FOWNER-when-times-NULL.patch added to
 queue-2.6.22.23-op1
Reply-To: oliver.pntr@gmail.com
Message-ID: <977557808d0b0654e508d292edd47c48@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch added to queue-2.6.22.23-op1.
If anyone has any objections, please let us know.

http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
git://repo.or.cz/linux-2.6.22.y-op-patches.git

---

>From 5b37696fda07b8acf37beba3853f83106397ccdf Mon Sep 17 00:00:00 2001
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Date: Tue, 17 Jul 2007 00:24:23 +0530
Subject: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL

do_utimes() does not honour CAP_FOWNER when times==NULL.
Trivial and obvious one-line fix.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/utimes.c b/fs/utimes.c
index b3c8895..83a7e69 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -106,7 +106,7 @@ long do_utimes(int dfd, char __user *filename, struct
timespec *times, int flags
                 if (IS_IMMUTABLE(inode))
                         goto dput_and_out;
 
-		if (current->fsuid != inode->i_uid) {
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
 			if (f) {
 				if (!(f->f_mode & FMODE_WRITE))
 					goto dput_and_out;


