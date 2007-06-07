Return-Path: <linux-kernel-owner+w=401wt.eu-S1764418AbXFGQkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764418AbXFGQkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbXFGQkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:40:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbXFGQkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:40:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NFS: Make NFS root work again
To: torvalds@osdl.org, akpm@osdl.org, trond.myklebust@fys.uio.no
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 07 Jun 2007 17:40:03 +0100
Message-ID: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make NFS root work by creating a "/root" directory to satisfy the mount,
otherwise the path lookup for the mount fails with ENOENT.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 init/do_mounts.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 46fe407..967b852 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -270,7 +270,10 @@ static void __init get_fs_names(char *page)
 
 static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 {
-	int err = sys_mount(name, "/root", fs, flags, data);
+	int err;
+
+	sys_mkdir("/root", 0755);
+	err = sys_mount(name, "/root", fs, flags, data);
 	if (err)
 		return err;
 

