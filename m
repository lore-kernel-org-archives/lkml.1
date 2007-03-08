Return-Path: <linux-kernel-owner+w=401wt.eu-S1030853AbXCHWuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853AbXCHWuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030851AbXCHWuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:50:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030841AbXCHWui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:50:38 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5] AF_RXRPC: Key facility changes for AF_RXRPC
To: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org,
       dhowells@redhat.com
Date: Thu, 08 Mar 2007 22:49:11 +0000
Message-ID: <20070308224910.17456.10596.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070308224806.17456.13944.stgit@warthog.cambridge.redhat.com>
References: <20070308224806.17456.13944.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export the keyring key type definition.

Add extra alternative types into the key's type_data union to make it more
useful.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/key.h     |    2 ++
 security/keys/keyring.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 169f05e..a9220e7 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -160,6 +160,8 @@ struct key {
 	 */
 	union {
 		struct list_head	link;
+		unsigned long		x[2];
+		void			*p[2];
 	} type_data;
 
 	/* key data
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index ad45ce7..88292e3 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -66,6 +66,8 @@ struct key_type key_type_keyring = {
 	.read		= keyring_read,
 };
 
+EXPORT_SYMBOL(key_type_keyring);
+
 /*
  * semaphore to serialise link/link calls to prevent two link calls in parallel
  * introducing a cycle

