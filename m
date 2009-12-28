Return-Path: <linux-kernel-owner+w=401wt.eu-S1751420AbZL1Pis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbZL1Pis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZL1Pir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:38:47 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:60980 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZL1Piq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:38:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BauOdRPRTxMabZxBaTswQVNtWvESqvC384CetcG9e99XXenQvn3MVi06XnhVTMwBGQ
         m3jToedDzyliv1us1ulAuke9hJ9mcLsvOPluZxf3ZnHbBK0N5P3VpPS+Ce02JjzAhadt
         cejHwKtXdZCbb0K+A8hM8iBn1tSTJs4+vu930=
Date: Mon, 28 Dec 2009 23:32:36 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: liu weni <qingshenlwy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCHv3 1/3]posix_acl: add the pointer check into
	fs/posix_acl.c
Message-ID: <20091228153236.GB10490@hack>
References: <b3657a100912280659oda68e2o73527ec58b35075b@mail.gmail.com> <b3657a100912280700h3e8fbb13iba7f0357feff36e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3657a100912280700h3e8fbb13iba7f0357feff36e3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 11:00:58PM +0800, liu weni wrote:
>If the acl pointer is NULL or have some error, the acl is invalid.
>The Macro of FOREACH_ACL_ENTRY will make some error.
>
>---
>Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
>Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>Cc: linux-fsdevel@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org
>
>---
>diff --git a/fs/posix_acl.c b/fs/posix_acl.c
>index 39df95a..45f8afa 100644
>--- a/fs/posix_acl.c
>+++ b/fs/posix_acl.c
>@@ -76,6 +76,12 @@ posix_acl_valid(const struct posix_acl *acl)
> 	unsigned int id = 0;  /* keep gcc happy */
> 	int needs_mask = 0;
>
>+	if (!acl)
>+		return -EINVAL;
>+
>+	if (IS_ERR)

Did you even do a compile test?
I don't think this line will work...


>+		return PTR_ERR(acl);
>+
> 	FOREACH_ACL_ENTRY(pa, acl, pe) {
> 		if (pa->e_perm & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
> 			return -EINVAL;
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
