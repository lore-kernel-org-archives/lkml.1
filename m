Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYAWAtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYAWAtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYAWApU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:45:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYAWAoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:44:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/27] Security: Pre-add additional non-caching classes
To: Trond.Myklebust@netapp.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 23 Jan 2008 00:44:33 +0000
Message-ID: <20080123004433.15602.56611.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080123004344.15602.35710.stgit@warthog.procyon.org.uk>
References: <20080123004344.15602.35710.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pre-add additional non-caching classes that are in the SELinux upstream
repository, but not in the upstream kernel so they don't get in the fscache
class patch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/include/av_perm_to_string.h |    5 +++++
 security/selinux/include/av_permissions.h    |    5 +++++
 security/selinux/include/class_to_string.h   |    7 +++++++
 security/selinux/include/flask.h             |    1 +
 4 files changed, 18 insertions(+), 0 deletions(-)


diff --git a/security/selinux/include/av_perm_to_string.h b/security/selinux/include/av_perm_to_string.h
index 049bf69..caa0634 100644
--- a/security/selinux/include/av_perm_to_string.h
+++ b/security/selinux/include/av_perm_to_string.h
@@ -37,6 +37,8 @@
    S_(SECCLASS_NODE, NODE__ENFORCE_DEST, "enforce_dest")
    S_(SECCLASS_NODE, NODE__DCCP_RECV, "dccp_recv")
    S_(SECCLASS_NODE, NODE__DCCP_SEND, "dccp_send")
+   S_(SECCLASS_NODE, NODE__RECVFROM, "recvfrom")
+   S_(SECCLASS_NODE, NODE__SENDTO, "sendto")
    S_(SECCLASS_NETIF, NETIF__TCP_RECV, "tcp_recv")
    S_(SECCLASS_NETIF, NETIF__TCP_SEND, "tcp_send")
    S_(SECCLASS_NETIF, NETIF__UDP_RECV, "udp_recv")
@@ -45,6 +47,8 @@
    S_(SECCLASS_NETIF, NETIF__RAWIP_SEND, "rawip_send")
    S_(SECCLASS_NETIF, NETIF__DCCP_RECV, "dccp_recv")
    S_(SECCLASS_NETIF, NETIF__DCCP_SEND, "dccp_send")
+   S_(SECCLASS_NETIF, NETIF__INGRESS, "ingress")
+   S_(SECCLASS_NETIF, NETIF__EGRESS, "egress")
    S_(SECCLASS_UNIX_STREAM_SOCKET, UNIX_STREAM_SOCKET__CONNECTTO, "connectto")
    S_(SECCLASS_UNIX_STREAM_SOCKET, UNIX_STREAM_SOCKET__NEWCONN, "newconn")
    S_(SECCLASS_UNIX_STREAM_SOCKET, UNIX_STREAM_SOCKET__ACCEPTFROM, "acceptfrom")
@@ -159,3 +163,4 @@
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NODE_BIND, "node_bind")
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NAME_CONNECT, "name_connect")
    S_(SECCLASS_MEMPROTECT, MEMPROTECT__MMAP_ZERO, "mmap_zero")
+   S_(SECCLASS_PEER, PEER__RECV, "recv")
diff --git a/security/selinux/include/av_permissions.h b/security/selinux/include/av_permissions.h
index eda89a2..c2b5bb2 100644
--- a/security/selinux/include/av_permissions.h
+++ b/security/selinux/include/av_permissions.h
@@ -292,6 +292,8 @@
 #define NODE__ENFORCE_DEST                        0x00000040UL
 #define NODE__DCCP_RECV                           0x00000080UL
 #define NODE__DCCP_SEND                           0x00000100UL
+#define NODE__RECVFROM                            0x00000200UL
+#define NODE__SENDTO                              0x00000400UL
 #define NETIF__TCP_RECV                           0x00000001UL
 #define NETIF__TCP_SEND                           0x00000002UL
 #define NETIF__UDP_RECV                           0x00000004UL
@@ -300,6 +302,8 @@
 #define NETIF__RAWIP_SEND                         0x00000020UL
 #define NETIF__DCCP_RECV                          0x00000040UL
 #define NETIF__DCCP_SEND                          0x00000080UL
+#define NETIF__INGRESS                            0x00000100UL
+#define NETIF__EGRESS                             0x00000200UL
 #define NETLINK_SOCKET__IOCTL                     0x00000001UL
 #define NETLINK_SOCKET__READ                      0x00000002UL
 #define NETLINK_SOCKET__WRITE                     0x00000004UL
@@ -824,3 +828,4 @@
 #define DCCP_SOCKET__NODE_BIND                    0x00400000UL
 #define DCCP_SOCKET__NAME_CONNECT                 0x00800000UL
 #define MEMPROTECT__MMAP_ZERO                     0x00000001UL
+#define PEER__RECV                                0x00000001UL
diff --git a/security/selinux/include/class_to_string.h b/security/selinux/include/class_to_string.h
index e77de0e..b1b0d1d 100644
--- a/security/selinux/include/class_to_string.h
+++ b/security/selinux/include/class_to_string.h
@@ -64,3 +64,10 @@
     S_(NULL)
     S_("dccp_socket")
     S_("memprotect")
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_("peer")
diff --git a/security/selinux/include/flask.h b/security/selinux/include/flask.h
index a9c2b20..09e9dd2 100644
--- a/security/selinux/include/flask.h
+++ b/security/selinux/include/flask.h
@@ -50,6 +50,7 @@
 #define SECCLASS_KEY                                     58
 #define SECCLASS_DCCP_SOCKET                             60
 #define SECCLASS_MEMPROTECT                              61
+#define SECCLASS_PEER                                    68
 
 /*
  * Security identifier indices for initial entities

