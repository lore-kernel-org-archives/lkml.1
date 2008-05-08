Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbYEHN6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbYEHN6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761582AbYEHN4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:56:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:1946 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761475AbYEHN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VVZQhgwWXhJKl+lpe20WLYMdHMBWy+xX0/gMAgFap74hpPzsWwFSdRmZNSp7rDCvuKqZeYFrciFDU0n6bGpdDX6qKostr7pFmLw3UPYv1g9p3pyYbvcunOiEi9LE9SINLh/eZQ/DKddbXVjPDMnS0+IxWu0zuvJKEfo4DTSG994=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [Patch 9/9] fs/exec.c: fix a wrong goto path
Date: Thu,  8 May 2008 21:52:34 +0800
Message-Id: <12102548752866-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nameidata_to_filp() fails, I see no reasons to fall into 'out' path
where doesn't free any resources at all.


Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/exec.c b/fs/exec.c
index aeaa979..0220427 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -123,7 +123,7 @@ asmlinkage long sys_uselib(const char __user * library)
 	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out;
+		goto exit;
 
 	error = -ENOEXEC;
 	if(file->f_op) {
