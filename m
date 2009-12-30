Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbZL3FV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbZL3FV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZL3FVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:21:54 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64490 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZL3FVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=J8aQQILQirPHdxRVfPwB8BvWCTWjIyCIMv6z0iHnbZ4YgStt/8JgRWYDupwpTZbdLd
         fLgMv7L6/GNIXP8eU7qZnib5P479Myf/cfgtMzl7ziVaEEn5j93nUdiejKbvQwKCQIzs
         bHGkhAkAJDlpi3yzrg0XYMRD0p1OCkLuJtQ/U=
Message-ID: <4B3AE419.8040401@gmail.com>
Date: Wed, 30 Dec 2009 13:24:41 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] some clean up in fs/proc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL(proc_symlink);
EXPORT_SYMBOL(proc_mkdir);
EXPORT_SYMBOL(create_proc_entry);
EXPORT_SYMBOL(proc_create_data);
EXPORT_SYMBOL(remove_proc_entry);

Those EXPORT_SYMBOL shouldn't be in fs/proc/root.c,
should be in fs/proc/generic.c.

Signed-off-by: Helight.Xu <helight.xu@gmail.com>
---
 fs/proc/generic.c |    5 +++++
 fs/proc/root.c    |    6 ------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 480cb10..9580abe 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -662,6 +662,7 @@ struct proc_dir_entry *proc_symlink(const char *name,
        }
        return ent;
 }
+EXPORT_SYMBOL(proc_symlink);

 struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
                struct proc_dir_entry *parent)
@@ -700,6 +701,7 @@ struct proc_dir_entry *proc_mkdir(const char *name,
 {
        return proc_mkdir_mode(name, S_IRUGO | S_IXUGO, parent);
 }
+EXPORT_SYMBOL(proc_mkdir);

 struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
                                         struct proc_dir_entry *parent)
@@ -728,6 +730,7 @@ struct proc_dir_entry *create_proc_entry(const char 
*name, mode_t mode,
        }
        return ent;
 }
+EXPORT_SYMBOL(create_proc_entry);

 struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
                                        struct proc_dir_entry *parent,
@@ -762,6 +765,7 @@ out_free:
 out:
        return NULL;
 }
+EXPORT_SYMBOL(proc_create_data);

 static void free_proc_entry(struct proc_dir_entry *de)
 {
@@ -853,3 +857,4 @@ continue_removing:
                        de->parent->name, de->name, de->subdir->name);
        pde_put(de);
 }
+EXPORT_SYMBOL(remove_proc_entry);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index b080b79..757c069 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -220,9 +220,3 @@ void pid_ns_release_proc(struct pid_namespace *ns)
 {
        mntput(ns->proc_mnt);
 }
-
-EXPORT_SYMBOL(proc_symlink);
-EXPORT_SYMBOL(proc_mkdir);
-EXPORT_SYMBOL(create_proc_entry);
-EXPORT_SYMBOL(proc_create_data);
-EXPORT_SYMBOL(remove_proc_entry);                                                                                                                                                                                                                         

-- 
1.6.5.3


-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

