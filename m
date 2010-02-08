Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0BHXP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:15:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254Ab0BHXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:15:56 -0500
Date: Mon, 8 Feb 2010 15:15:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Dramatically improve #define
 parse times
Message-Id: <20100208151550.15796cad.akpm@linux-foundation.org>
In-Reply-To: <1265167112.1945.184.camel@Joe-Laptop.home>
References: <1265167112.1945.184.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Feb 2010 19:18:32 -0800
Joe Perches <joe@perches.com> wrote:

> 
> #define macros currently take a _very_ long time to parse because
> the macro is being searched for multiple statements and unnecessary
> searching is being done when comments are replaced with unprintable
> characters.
> 
> For instance:
> 
> Without this patch:
> $ time perl ./scripts/checkpatch.pl -f include/linux/mfd/wm831x/irq.h > /dev/null
> 
> real	3m43.229s
> user	3m42.254s
> sys	0m0.332s
> 
> With this patch: 
> $ time perl ./scripts/checkpatch.pl -f include/linux/mfd/wm831x/irq.h > /dev/null
> 
> real	0m1.372s
> user	0m1.348s
> sys	0m0.020s
> 
> A 160:1 improvement.
> 
> I don't know if this is correct, but it seems to work for me.

This patch triggers lots of warnings:

akpm:/usr/src/25> perl scripts/checkpatch.pl patches/drivers-char-memc-cleanups-fix.patch
Use of uninitialized value in length at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1597.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1655.
Use of uninitialized value in length at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1597.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1655.
Use of uninitialized value in length at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1597.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1655.
Use of uninitialized value in length at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1589.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1597.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1655.


Test case:


diff -puN drivers/char/mem.c~drivers-char-memc-cleanups-fix drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-cleanups-fix
+++ a/drivers/char/mem.c
@@ -579,7 +579,7 @@ static ssize_t read_port(struct file *fi
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-		if (__put_user(inb(i),tmp) < 0)
+		if (__put_user(inb(i), tmp) < 0)
 			return -EFAULT;
 		i++;
 		tmp++;
@@ -594,7 +594,7 @@ static ssize_t write_port(struct file *f
 	unsigned long i = *ppos;
 	const char __user * tmp = buf;
 
-	if (!access_ok(VERIFY_READ,buf,count))
+	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
 		char c;
@@ -603,7 +603,7 @@ static ssize_t write_port(struct file *f
 				break;
 			return -EFAULT;
 		}
-		outb(c,i);
+		outb(c, i);
 		i++;
 		tmp++;
 	}
@@ -630,7 +630,7 @@ static int pipe_to_null(struct pipe_inod
 	return sd->len;
 }
 
-static ssize_t splice_write_null(struct pipe_inode_info *pipe,struct file *out,
+static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
 				 loff_t *ppos, size_t len, unsigned int flags)
 {
 	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
@@ -831,7 +831,7 @@ static ssize_t kmsg_write(struct file *f
 }
 
 static const struct file_operations kmsg_fops = {
-	.write =	kmsg_write,
+	.write = kmsg_write,
 };
 
 static const struct memdev {
@@ -907,7 +907,7 @@ static int __init chr_dev_init(void)
 	if (err)
 		return err;
 
-	if (register_chrdev(MEM_MAJOR,"mem",&memory_fops))
+	if (register_chrdev(MEM_MAJOR, "mem", &memory_fops))
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
 	mem_class = class_create(THIS_MODULE, "mem");
_



