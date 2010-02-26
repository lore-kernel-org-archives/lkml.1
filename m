Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965492Ab0BZR1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:27:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461Ab0BZR1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:27:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Remove EXPERIMENTAL from NFS_FSCACHE
To: torvalds@osdl.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-cachefs@redhat.com, Christian Kujau <lists@nerdbynature.de>,
       David Howells <dhowells@redhat.com>
Date: Fri, 26 Feb 2010 17:25:14 +0000
Message-ID: <20100226172513.12926.81221.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Kujau <lists@nerdbynature.de>

There's currently an open Ubuntu bug[0], with the intent to compile NFS_FSCACHE
(and possibly AFS_FSCACHE, 9P_FSCACHE) into the standard Ubuntu kernel.
However, since *_FSCACHE still depends on EXPERIMENTAL, this won't happen.

As Arjan van de Ven pointed out[1], the EXPERIMENTAL flag doesn't mean that
much any more, I propose the following patch to fs/nfs/Kconfig.  I'd do the
same for fs/9p/Kconfig and fs/afs/Kconfig, but as I did not test 9p or AFS, I
feel it would not be appropriate for me to remove the flag.

[0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/440522/comments/5
[1] http://lkml.org/lkml/2010/1/23/145

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 59e5673..a43d07e 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -95,8 +95,7 @@ config ROOT_NFS
 	  Most people say N here.
 
 config NFS_FSCACHE
-	bool "Provide NFS client caching support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Provide NFS client caching support"
 	depends on NFS_FS=m && FSCACHE || NFS_FS=y && FSCACHE=y
 	help
 	  Say Y here if you want NFS data to be cached locally on disc through

