Return-Path: <linux-kernel-owner+w=401wt.eu-S1765616AbXHOI4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765616AbXHOI4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbXHOI4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:56:42 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34310 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756774AbXHOI4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:56:41 -0400
Message-ID: <387168197.02674@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 16:56:37 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] seqfile: fix uninitialized memory allocation in
	mounts_open()
Message-ID: <20070815085637.GA19293@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

proc_mounts.m.buf is not explicitly zeroed at allocation time, which
may later confuse the seqfile code and triggle an kfree(m->buf).

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

--- linux.orig/fs/proc/base.c
+++ linux/fs/proc/base.c
@@ -380,7 +380,7 @@ static int mounts_open(struct inode *ino
 
 	if (ns) {
 		ret = -ENOMEM;
-		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
+		p = kzalloc(sizeof(struct proc_mounts), GFP_KERNEL);
 		if (p) {
 			file->private_data = &p->m;
 			ret = seq_open(file, &mounts_op);

