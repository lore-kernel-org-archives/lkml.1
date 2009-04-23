Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZDWKYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZDWKYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZDWKXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:23:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379AbZDWKXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:23:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CacheFiles: Fix the documentation to use the correct
	credential pointer names
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Marc Dionne <marc.c.dionne@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Thu, 23 Apr 2009 11:21:55 +0100
Message-ID: <20090423102155.18047.68135.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Dionne <marc.c.dionne@gmail.com>

Adjust the CacheFiles documentation to use the correct names of the credential
pointers in task_struct.

The documentation was using names from the old versions of the credentials
patches.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/cachefiles.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/Documentation/filesystems/caching/cachefiles.txt b/Documentation/filesystems/caching/cachefiles.txt
index c78a49b..748a1ae 100644
--- a/Documentation/filesystems/caching/cachefiles.txt
+++ b/Documentation/filesystems/caching/cachefiles.txt
@@ -407,7 +407,7 @@ A NOTE ON SECURITY
 ==================
 
 CacheFiles makes use of the split security in the task_struct.  It allocates
-its own task_security structure, and redirects current->act_as to point to it
+its own task_security structure, and redirects current->cred to point to it
 when it acts on behalf of another process, in that process's context.
 
 The reason it does this is that it calls vfs_mkdir() and suchlike rather than
@@ -429,9 +429,9 @@ This means it may lose signals or ptrace events for example, and affects what
 the process looks like in /proc.
 
 So CacheFiles makes use of a logical split in the security between the
-objective security (task->sec) and the subjective security (task->act_as).  The
-objective security holds the intrinsic security properties of a process and is
-never overridden.  This is what appears in /proc, and is what is used when a
+objective security (task->real_cred) and the subjective security (task->cred).
+The objective security holds the intrinsic security properties of a process and
+is never overridden.  This is what appears in /proc, and is what is used when a
 process is the target of an operation by some other process (SIGKILL for
 example).
 

