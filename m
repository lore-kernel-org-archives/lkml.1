Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbXJDP7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbXJDP7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 11:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbXJDP5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:57:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759510AbXJDP5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:57:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/32] Add an ERR_CAST() macro to complement ERR_PTR and co.
	[try #2]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 04 Oct 2007 16:56:07 +0100
Message-ID: <20071004155607.2814.74947.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ERR_CAST() macro to complement ERR_PTR and co. for the purposes of
casting an error entyped as one pointer type to an error of another pointer
type whilst making it explicit as to what is going on.

This provides a replacement for the ERR_PTR(PTR_ERR(p)) construct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/err.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index 1ab1d44..e810ca4 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -34,6 +34,18 @@ static inline long IS_ERR(const void *ptr)
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+/**
+ * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
+ * ptr: The pointer to cast.
+ *
+ * Explicitly cast an error-valued pointer to another pointer type in such a
+ * way as to make it clear that's what's going on.
+ */
+static inline void *ERR_CAST(const void *ptr)
+{
+	return (void *) ptr;
+}
+
 #endif
 
 #endif /* _LINUX_ERR_H */

