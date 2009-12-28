Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZL1PCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZL1PCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZL1PCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:02:07 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:48768 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZL1PCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:02:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ZcGsgsa/PplX97rbO0DGUnUNWVciS5tPawgXnmSp7blnZoQK8ntTHybsgzeS+1Y9oT
         FqMdcQPkblhgY48RPHC/zYQj8BNJAB8OsBBO9lQiyhJO+te2prCbTNM5a5k4JS5bu60+
         4RAQQxFOoGdnlsQdxCx1Q/dbQry/dgPbcd+Xg=
MIME-Version: 1.0
In-Reply-To: <b3657a100912280701s7b1420bdkac8d3d90291639ae@mail.gmail.com>
References: <b3657a100912280659oda68e2o73527ec58b35075b@mail.gmail.com>
	 <b3657a100912280700h3e8fbb13iba7f0357feff36e3@mail.gmail.com>
	 <b3657a100912280701s7b1420bdkac8d3d90291639ae@mail.gmail.com>
Date: Mon, 28 Dec 2009 23:02:02 +0800
Message-ID: <b3657a100912280702m64fea251h8b9a50ac0f459a16@mail.gmail.com>
Subject: [PATCHv3 3/3]posix_acl: add the pointer check into fs/posix_acl.c
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>
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
