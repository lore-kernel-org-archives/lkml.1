Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZL1XhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZL1XhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZL1XhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:37:04 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:48188 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZL1XhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:37:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=qrPXE1qMUF5WbWMML50N8230IeLkPfS5WCG/1eiFIX7hU+sP0wzLnmqUT50u3DpOTS
         NqM3HfXK4GZIbkIWkXAbRp7vvaFe+Ruk0PKR7oAgBlNpzEMq1mEMsZYzEv4YHfpuWvEM
         ku9kWiz+SfiG+Kt78vsUQ8xKdvW7oTngMs9JI=
MIME-Version: 1.0
In-Reply-To: <b3657a100912281536s7a2ce33en2cae43889b99bfae@mail.gmail.com>
References: <b3657a100912281534y7381a07evd076aabd3371b171@mail.gmail.com>
	 <b3657a100912281535x5e5f0ba4w67736250f1eebb5c@mail.gmail.com>
	 <b3657a100912281536s7a2ce33en2cae43889b99bfae@mail.gmail.com>
Date: Tue, 29 Dec 2009 07:37:02 +0800
Message-ID: <b3657a100912281537m3bc6b49euebdd75563d4b3cfb@mail.gmail.com>
Subject: [PATCHv4 3/3]posix_acl: Add the acl pointer check
From: liu weni <qingshenlwy@gmail.com>
To: viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the acl pointer is IS_ERR, We cannot get the correct return.

And the acl pointer is NULL. Oh, my god! The FOREACH_ACL_ENTRY will
call that.

---

Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


---
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..4e0261b 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -213,6 +213,12 @@ posix_acl_permission(struct inode *inode, const
struct posix_acl *acl, int want)
 	const struct posix_acl_entry *pa, *pe, *mask_obj;
 	int found = 0;

+	if (!acl)
+		return -EINVAL;
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
