Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYB0EDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYB0EDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYB0ECt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:02:49 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2895 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYB0ECt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:02:49 -0500
Subject: [PATCH] linux/fs.h - Convert debug functions declared inline
	__attribute__((format (printf,x,y) to statement expression macros
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1204081722.19319.405.camel@localhost>
References: <1204081722.19319.405.camel@localhost>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 20:02:27 -0800
Message-Id: <1204084947.19319.411.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting inline __attribute__((format (printf,x,y) functions
to macros or statement expressions produces smaller objects

before:
$ size vmlinux
   text    data     bss     dec     hex filename
4716770  474560  618496 5809826  58a6a2 vmlinux
after:
$ size vmlinux
   text    data     bss     dec     hex filename
4716706  474560  618496 5809762  58a662 vmlinux

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/fs.h |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b84b848..a0ba590 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2055,11 +2055,10 @@ static struct file_operations __fops = {				\
 	.write	 = simple_attr_write,					\
 };
 
-static inline void __attribute__((format(printf, 1, 2)))
-__simple_attr_check_format(const char *fmt, ...)
-{
-	/* don't do anything, just let the compiler check the arguments; */
-}
+/* don't do anything, just let the compiler check the arguments; */
+
+#define __simple_attr_check_format(fmt, args...) \
+	do { if (0) printk(fmt, ##args); } while (0)
 
 int simple_attr_open(struct inode *inode, struct file *file,
 		     int (*get)(void *, u64 *), int (*set)(void *, u64),


