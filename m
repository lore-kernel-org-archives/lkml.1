Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYCNMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYCNMGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 08:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYCNMGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 08:06:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbYCNMGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 08:06:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] KEYS: Make key_serial() a function if CONFIG_KEYS=y [try
	#2]
To: torvalds@osdl.org, akpm@linux-foundation.org, kwc@citi.umich.edu
Cc: arunsr@cse.iitk.ac.in, dwalsh@redhat.com,
       linux-security-module@vger.kernel.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2008 12:06:04 +0000
Message-ID: <20080314120604.19668.14312.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080314120559.19668.88801.stgit@warthog.procyon.org.uk>
References: <20080314120559.19668.88801.stgit@warthog.procyon.org.uk>
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

