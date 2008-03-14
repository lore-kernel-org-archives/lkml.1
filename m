Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYCNL6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYCNL6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYCNL6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:58:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbYCNL6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:58:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] KEYS: Document making the keyring quotas controllable
	through /proc/sys
To: torvalds@osdl.org, akpm@linux-foundation.org, kwc@citi.umich.edu
Cc: arunsr@cse.iitk.ac.in, dwalsh@redhat.com,
       linux-security-module@vger.kernel.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2008 11:58:23 +0000
Message-ID: <20080314115823.19124.76244.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alter the key management documentation to include information on keyring quota
controls as added in a previous patch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)


diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index be424b0..d5c7a57 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -170,7 +170,8 @@ The key service provides a number of features besides keys:
      amount of description and payload space that can be consumed.
 
      The user can view information on this and other statistics through procfs
-     files.
+     files.  The root user may also alter the quota limits through sysctl files
+     (see the section "New procfs files").
 
      Process-specific and thread-specific keyrings are not counted towards a
      user's quota.
@@ -329,6 +330,27 @@ about the status of the key service:
 	<bytes>/<max>		Key size quota
 
 
+Four new sysctl files have been added also for the purpose of controlling the
+quota limits on keys:
+
+ (*) /proc/sys/kernel/keys/root_maxkeys
+     /proc/sys/kernel/keys/root_maxbytes
+
+     These files hold the maximum number of keys that root may have and the
+     maximum total number of bytes of data that root may have stored in those
+     keys.
+
+ (*) /proc/sys/kernel/keys/maxkeys
+     /proc/sys/kernel/keys/maxbytes
+
+     These files hold the maximum number of keys that each non-root user may
+     have and the maximum total number of bytes of data that each of those
+     users may have stored in their keys.
+
+Root may alter these by writing each new limit as a decimal number string to
+the appropriate file.
+
+
 ===============================
 USERSPACE SYSTEM CALL INTERFACE
 ===============================

