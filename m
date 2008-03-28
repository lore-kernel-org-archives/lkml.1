Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYC1OiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYC1OiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYC1OeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:34:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbYC1OeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:34:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/45] KEYS: Make key_serial() a function if CONFIG_KEYS=y
	[ver #35]
To: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 28 Mar 2008 14:30:46 +0000
Message-ID: <20080328143046.3483.46994.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make key_serial() an inline function rather than a macro if CONFIG_KEYS=y.
This prevents double evaluation of the key pointer and also provides better
type checking.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/key.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/include/linux/key.h b/include/linux/key.h
index ad02d9c..c45c962 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -264,7 +264,10 @@ extern int keyring_add_key(struct key *keyring,
 
 extern struct key *key_lookup(key_serial_t id);
 
-#define key_serial(key) ((key) ? (key)->serial : 0)
+static inline key_serial_t key_serial(struct key *key)
+{
+	return key ? key->serial : 0;
+}
 
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];

