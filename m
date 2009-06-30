Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZF3KGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZF3KGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZF3KGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:06:42 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:57930 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZF3KGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E81Pj/rvY3MCtbjOkFI9HUSPqeppQ+W0zvu8FL2MASYGb78G7pGdAJWW6W37m7U4j1
         H5HwiNu/GGg9LdbiCm3iym7SfDZ6ovWZSDHSTadgLBPwwvr+RXOJODrJh7Z/0/tJzMpb
         xItdA1u/75s15RTQh05iv4e/2To5kBbiUlSFI=
Date: Tue, 30 Jun 2009 18:08:50 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tao Ma <tao.ma@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>, mtk.manpages@gmail.com
Subject: [RESEND Patch] kcore: remove its pointless size
Message-ID: <20090630100850.GD5873@cr0.nay.redhat.com>
References: <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0> <m17hzdhkr8.fsf@fess.ebiederm.org> <2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com> <m1my88568n.fsf@fess.ebiederm.org> <20090618030051.GA6133@cr0.nay.redhat.com> <m1tz2ei54r.fsf@fess.ebiederm.org> <20090618044055.GB6133@cr0.nay.redhat.com> <m1prd2rtdf.fsf@fess.ebiederm.org> <20090622085405.GA6499@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622085405.GA6499@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus fixes wrong size of /proc/kcore problem in commit 9063c61fd5cbd.

But its size still looks insane, since it never equals to the size
of physical memory.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: mtk.manpages@gmail.com

(Andrew, could you please just cut off the kernel part from below? :)

---
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 59b43a0..eca5201 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -405,9 +405,6 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
-	if (proc_root_kcore)
-		proc_root_kcore->size =
-				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	return 0;
 }
 module_init(proc_kcore_init);



---
diff --git a/man5/proc.5 b/man5/proc.5
index ed47f70..e31aae4 100644
--- a/man5/proc.5
+++ b/man5/proc.5
@@ -1246,8 +1246,6 @@ kernel
 binary, GDB can be used to
 examine the current state of any kernel data structures.
 
-The total length of the file is the size of physical memory (RAM) plus
-4KB.
 .TP
 .I /proc/kmsg
 This file can be used instead of the
