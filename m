Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZL1PBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZL1PBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZL1PA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:00:59 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49883 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZL1PA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=UG4RI1Q6hKHQ6KcURqD55ZeiRFgC8UL70zA+F8VV2RifGcm2kyLKLQBvYZVxQKZXaY
         pjRO0zrchhSDkBwG6oDbWc8t38KfmS+KH6ln1COgb3EjisliKp6UXetJxYNLyN7815LZ
         UQmQMd73rSU4QUqEAm4LABA8uIj74Di2UHi20=
MIME-Version: 1.0
In-Reply-To: <b3657a100912280659oda68e2o73527ec58b35075b@mail.gmail.com>
References: <b3657a100912280659oda68e2o73527ec58b35075b@mail.gmail.com>
Date: Mon, 28 Dec 2009 23:00:58 +0800
Message-ID: <b3657a100912280700h3e8fbb13iba7f0357feff36e3@mail.gmail.com>
Subject: [PATCHv3 1/3]posix_acl: add the pointer check into fs/posix_acl.c
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the acl pointer is NULL or have some error, the acl is invalid.
The Macro of FOREACH_ACL_ENTRY will make some error.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..45f8afa 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -76,6 +76,12 @@ posix_acl_valid(const struct posix_acl *acl)
 	unsigned int id = 0;  /* keep gcc happy */
 	int needs_mask = 0;

+	if (!acl)
+		return -EINVAL;
+
+	if (IS_ERR)
+		return PTR_ERR(acl);
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		if (pa->e_perm & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 			return -EINVAL;
