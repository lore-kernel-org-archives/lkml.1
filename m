Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZL1Xfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZL1Xfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZL1Xfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:35:50 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:41726 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZL1Xft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:35:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Bd/xLgh/2ZTZUReXtJR3XY+Q61VU/DkN6oEEDmKyEzBh9InczNwcEllYy2q2jCkNuD
         K5fuuSc96WWkME23cMkGP+a5Hd+rrZKEd9wPXtc8lHlieobkqWBCPoBpYMebucWYZpFp
         tr5BHZlrlWjKNYE/W2UgIgUwYAoS5KRRtgJOc=
MIME-Version: 1.0
In-Reply-To: <b3657a100912281534y7381a07evd076aabd3371b171@mail.gmail.com>
References: <b3657a100912281534y7381a07evd076aabd3371b171@mail.gmail.com>
Date: Tue, 29 Dec 2009 07:35:48 +0800
Message-ID: <b3657a100912281535x5e5f0ba4w67736250f1eebb5c@mail.gmail.com>
Subject: [PATCHv4 1/3]posix_acl: Add the acl pointer check
From: liu weni <qingshenlwy@gmail.com>
To: viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
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
index 39df95a..d4bacb9 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -76,6 +76,12 @@ posix_acl_valid(const struct posix_acl *acl)
 	unsigned int id = 0;  /* keep gcc happy */
 	int needs_mask = 0;

+	if (!acl)
+		return -EINVAL;
+
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		if (pa->e_perm & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 			return -EINVAL;
