Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbYBTQQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbYBTQQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764920AbYBTQJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:09:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763943AbYBTQJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:09:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/37] Security: Add a kernel_service object class to SELinux
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:41 +0000
Message-ID: <20080220160641.4715.92438.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
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
index d569669..fd6bef7 100644
--- a/security/selinux/include/av_perm_to_string.h
+++ b/security/selinux/include/av_perm_to_string.h
@@ -171,3 +171,5 @@
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NAME_CONNECT, "name_connect")
    S_(SECCLASS_MEMPROTECT, MEMPROTECT__MMAP_ZERO, "mmap_zero")
    S_(SECCLASS_PEER, PEER__RECV, "recv")
+   S_(SECCLASS_KERNEL_SERVICE, KERNEL_SERVICE__USE_AS_OVERRIDE, "use_as_override")
+   S_(SECCLASS_KERNEL_SERVICE, KERNEL_SERVICE__CREATE_FILES_AS, "create_files_as")
diff --git a/security/selinux/include/av_permissions.h b/security/selinux/include/av_permissions.h
index 75b4131..02ddf8d 100644
--- a/security/selinux/include/av_permissions.h
+++ b/security/selinux/include/av_permissions.h
@@ -836,3 +836,5 @@
 #define DCCP_SOCKET__NAME_CONNECT                 0x00800000UL
 #define MEMPROTECT__MMAP_ZERO                     0x00000001UL
 #define PEER__RECV                                0x00000001UL
+#define KERNEL_SERVICE__USE_AS_OVERRIDE           0x00000001UL
+#define KERNEL_SERVICE__CREATE_FILES_AS           0x00000002UL
diff --git a/security/selinux/include/class_to_string.h b/security/selinux/include/class_to_string.h
index bd813c3..373b191 100644
--- a/security/selinux/include/class_to_string.h
+++ b/security/selinux/include/class_to_string.h
@@ -72,3 +72,4 @@
     S_(NULL)
     S_("peer")
     S_("capability2")
+    S_("kernel_service")
diff --git a/security/selinux/include/flask.h b/security/selinux/include/flask.h
index febf886..f3c5166 100644
--- a/security/selinux/include/flask.h
+++ b/security/selinux/include/flask.h
@@ -52,6 +52,7 @@
 #define SECCLASS_MEMPROTECT                              61
 #define SECCLASS_PEER                                    68
 #define SECCLASS_CAPABILITY2                             69
+#define SECCLASS_KERNEL_SERVICE                          70
 
 /*
  * Security identifier indices for initial entities

