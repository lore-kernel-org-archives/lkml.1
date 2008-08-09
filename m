Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYHIXC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYHIXC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 19:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYHIXCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 19:02:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:53012 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbYHIXCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 19:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oKPCRuqXAtOqBaKg9iGkSH4DlZfDuysfiStZk3NZW2B7KTAEv7jPKG4onEL0hC9Rg+
         OJp1qlQiVZ5LP4PiAEejMX3kg2SrOLJi7fv6YsIhzDVqdctLnGLvA+cEaQ44SspEBBL8
         /2HTMDwxvwRBsAzyHn8WG27fiNhPbGkemupM4=
Subject: [PATCH] cred: remove const qualifiers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 09 Aug 2008 16:02:20 -0700
Message-Id: <1218322941.24441.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_new_cred clearly writes through the pointer, so const isn't
appropriate.  Sparse warns thusly:

include/linux/cred.h: In function ‘get_cred’:
include/linux/cred.h:181: warning: passing argument 1 of ‘get_new_cred’ discards qualifiers from pointer target type

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/cred.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index b156ed4..174eb56 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -176,9 +176,9 @@ static inline struct cred *get_new_cred(struct cred *cred)
  * Get a reference on the specified set of credentials.  The caller must
  * release the reference.
  */
-static inline const struct cred *get_cred(const struct cred *cred)
+static inline struct cred *get_cred(struct cred *cred)
 {
-	return get_new_cred((struct cred *) cred);
+	return get_new_cred(cred);
 }
 
 /**
-- 
1.6.0.rc1.278.g9c632



