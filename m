Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZL1X3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZL1X3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZL1X3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:29:10 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:39460 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZL1X3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pr5ylfF6cMeFR1hvquKi4Re3xOy1421bqmHsYEghDNkeHMX5WNo18WRuS9G9rDC7cy
         LxiRWmEmD2EosXjscLjhywI+R1au09eMHNf0yzblC1ElfN6E8Bdj0MNO0vpM14y6MKoL
         ywNg+ZV4XTjbmmBr0FyZ/4zK+x5+xmE2YkQxk=
MIME-Version: 1.0
In-Reply-To: <20091228153236.GB10490@hack>
References: <b3657a100912280659oda68e2o73527ec58b35075b@mail.gmail.com>
	 <b3657a100912280700h3e8fbb13iba7f0357feff36e3@mail.gmail.com>
	 <20091228153236.GB10490@hack>
Date: Tue, 29 Dec 2009 07:29:05 +0800
Message-ID: <b3657a100912281529t7a21d0c8v14d34c18b5a8207f@mail.gmail.com>
Subject: Re: [PATCHv3 1/3]posix_acl: add the pointer check into fs/posix_acl.c
From: liu weni <qingshenlwy@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. I forgot diff it again.

2009/12/28 Américo Wang <xiyou.wangcong@gmail.com>:
> On Mon, Dec 28, 2009 at 11:00:58PM +0800, liu weni wrote:
>>If the acl pointer is NULL or have some error, the acl is invalid.
>>The Macro of FOREACH_ACL_ENTRY will make some error.
>>
>>---
>>Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
>>Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>>Cc: linux-fsdevel@vger.kernel.org
>>Cc: linux-kernel@vger.kernel.org
>>
>>---
>>diff --git a/fs/posix_acl.c b/fs/posix_acl.c
>>index 39df95a..45f8afa 100644
>>--- a/fs/posix_acl.c
>>+++ b/fs/posix_acl.c
>>@@ -76,6 +76,12 @@ posix_acl_valid(const struct posix_acl *acl)
>>       unsigned int id = 0;  /* keep gcc happy */
>>       int needs_mask = 0;
>>
>>+      if (!acl)
>>+              return -EINVAL;
>>+
>>+      if (IS_ERR)
>
> Did you even do a compile test?
> I don't think this line will work...
>
>
>>+              return PTR_ERR(acl);
>>+
>>       FOREACH_ACL_ENTRY(pa, acl, pe) {
>>               if (pa->e_perm & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
>>                       return -EINVAL;
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Live like a child, think like the god.
>
>
