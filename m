Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbYAWAte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbYAWAte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYAWApW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:45:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbYAWAom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:44:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/27] Security: Add a kernel_service object class to SELinux
To: Trond.Myklebust@netapp.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 23 Jan 2008 00:44:39 +0000
Message-ID: <20080123004438.15602.45852.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080123004344.15602.35710.stgit@warthog.procyon.org.uk>
References: <20080123004344.15602.35710.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 'kernel_service' object class to SELinux and give this object class two
access vectors: 'use_as_override' and 'create_files_as'.

The first vector is used to grant a process the right to nominate an alternate
process security ID for the kernel to use as an override for the SELinux
subjective security when accessing stuff on behalf of another process.

For example, CacheFiles when accessing the cache on behalf on a process
accessing an NFS file needs to use a subjective security ID appropriate to the
cache rather then the one the calling process is using.  The cachefilesd
daemon will nominate the security ID to be used.

The second vector is used to grant a process the right to nominate a file
creation label for a kernel service to use.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/include/av_perm_to_string.h |    2 ++
 security/selinux/include/av_permissions.h    |    2 ++
 security/selinux/include/class_to_string.h   |    1 +
 security/selinux/include/flask.h             |    1 +
 4 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/security/selinux/include/av_perm_to_string.h b/security/selinux/include/av_perm_to_string.h
index caa0634..6ba8200 100644
--- a/security/selinux/include/av_perm_to_string.h
+++ b/security/selinux/include/av_perm_to_string.h
@@ -164,3 +164,5 @@
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NAME_CONNECT, "name_connect")
    S_(SECCLASS_MEMPROTECT, MEMPROTECT__MMAP_ZERO, "mmap_zero")
    S_(SECCLASS_PEER, PEER__RECV, "recv")
+   S_(SECCLASS_KERNEL_SERVICE, KERNEL_SERVICE__USE_AS_OVERRIDE, "use_as_override")
+   S_(SECCLASS_KERNEL_SERVICE, KERNEL_SERVICE__CREATE_FILES_AS, "create_files_as")
diff --git a/security/selinux/include/av_permissions.h b/security/selinux/include/av_permissions.h
index c2b5bb2..9500ba3 100644
--- a/security/selinux/include/av_permissions.h
+++ b/security/selinux/include/av_permissions.h
@@ -829,3 +829,5 @@
 #define DCCP_SOCKET__NAME_CONNECT                 0x00800000UL
 #define MEMPROTECT__MMAP_ZERO                     0x00000001UL
 #define PEER__RECV                                0x00000001UL
+#define KERNEL_SERVICE__USE_AS_OVERRIDE           0x00000001UL
+#define KERNEL_SERVICE__CREATE_FILES_AS           0x00000002UL
diff --git a/security/selinux/include/class_to_string.h b/security/selinux/include/class_to_string.h
index b1b0d1d..efe9efa 100644
--- a/security/selinux/include/class_to_string.h
+++ b/security/selinux/include/class_to_string.h
@@ -71,3 +71,4 @@
     S_(NULL)
     S_(NULL)
     S_("peer")
+    S_("kernel_service")
diff --git a/security/selinux/include/flask.h b/security/selinux/include/flask.h
index 09e9dd2..2bc251a 100644
--- a/security/selinux/include/flask.h
+++ b/security/selinux/include/flask.h
@@ -51,6 +51,7 @@
 #define SECCLASS_DCCP_SOCKET                             60
 #define SECCLASS_MEMPROTECT                              61
 #define SECCLASS_PEER                                    68
+#define SECCLASS_KERNEL_SERVICE                          69
 
 /*
  * Security identifier indices for initial entities

