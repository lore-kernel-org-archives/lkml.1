Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYKQHjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYKQHjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbYKQHim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:38:42 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:33617 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYKQHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:38:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=ROdhqV7yhv9TpyiyoB8A57WgvNcCyRQLhfPO4YQFZpt8wNUQgGa9pC3wh71JJAUmro
         tIzrjVbJ+ZxUx3+X45iJwj/n/botBqi9ak9o+/ndA5/Jd24KhIKmnO6PuX4VucwgiUj+
         fzzSbIJPDOdIF82rY2HM+RTzZWUkKAUgNtDlk=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       qhfeng.kernel@gmail.com
Subject: [PATCH] fs/binfmt_misc.c: let binfmt status be more readable 
Date: Mon, 17 Nov 2008 15:38:16 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <49211f7b.09876e0a.012d.079f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is what it looks like before patching.
It is not much readable.

user@ubuntu:/proc/sys/fs/binfmt_misc$ cat status 
enableduser@ubuntu:/proc/sys/fs/binfmt_misc$

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index f2744ab..72e8b24 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -652,7 +652,7 @@ static const struct file_operations bm_register_operations = {
 static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	char *s = enabled ? "enabled" : "disabled";
+	char *s = enabled ? "enabled\n" : "disabled\n";
 
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }

