Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZL1Xg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZL1Xg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZL1Xg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:36:27 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:59599 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZL1Xg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=pzJy6n3qAGQguh1xn+hj2Ig+HCPvjjttje3wPDDYAAFRL6ilCTG7fCjP7LQ8JTsg71
         hYJnnEOPAE7u6k9Znt25wMjXu+7fO8x60/RHPm2N29I9AO+HWsMfiEDwl/omB9tqoSwv
         6JtgrINU1P3hhGo8ySxfUJY+GehGbJ9JCq7aI=
MIME-Version: 1.0
In-Reply-To: <b3657a100912281535x5e5f0ba4w67736250f1eebb5c@mail.gmail.com>
References: <b3657a100912281534y7381a07evd076aabd3371b171@mail.gmail.com>
	 <b3657a100912281535x5e5f0ba4w67736250f1eebb5c@mail.gmail.com>
Date: Tue, 29 Dec 2009 07:36:25 +0800
Message-ID: <b3657a100912281536s7a2ce33en2cae43889b99bfae@mail.gmail.com>
Subject: [PATCHv4 2/3]posix_acl: Add the acl pointer check
From: liu weni <qingshenlwy@gmail.com>
To: viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
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
