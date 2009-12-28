Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZL1PBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZL1PBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZL1PB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:01:29 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49883 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZL1PB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=XJ+i6s1rdlFc41hSw4A9ljf9yTP2a9slSuUnNYhWgltq5+mppfDQMZRT9tuiQC2XnN
         gWjl0OeIYPPIz1Nd4W0UIBEyXc3O7SQBBvsrzLyngVmbCzetY3xWP9RigCMXcGZgP9rd
         pGAkSWBpCC4w61XFA8XHKuzAFj4egK/FiteI4=
MIME-Version: 1.0
In-Reply-To: <b3657a100912280700h3e8fbb13iba7f0357feff36e3@mail.gmail.com>
References: <b3657a100912280659oda68e2o73527ec58b35075b@mail.gmail.com>
	 <b3657a100912280700h3e8fbb13iba7f0357feff36e3@mail.gmail.com>
Date: Mon, 28 Dec 2009 23:01:27 +0800
Message-ID: <b3657a100912280701s7b1420bdkac8d3d90291639ae@mail.gmail.com>
Subject: Re: [PATCHv3 2/3]posix_acl: add the pointer check into fs/posix_acl.c
From: liu weni <qingshenlwy@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two acl pointer checks before this function.

---

Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..0d2a7a2 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -150,6 +150,12 @@ posix_acl_equiv_mode(const struct posix_acl *acl,
mode_t *mode_p)
 	mode_t mode = 0;
 	int not_equiv = 0;

+	if (!acl)
+		return -EINVAL;
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch (pa->e_tag) {
 			case ACL_USER_OBJ:
