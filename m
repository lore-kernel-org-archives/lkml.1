Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZF2Mjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZF2Mjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZF2MjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:39:24 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44371 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZF2MjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=suwlx2FZUg8g8QEwRi+VDA5mXkYPhwaWJIHxFTC/Bpn6HPE7ZoriGJxhDOxFaIlhSV
         s1xje6NMwfSNASdZW35KDwVrX1gg7yeIwJ5WCAxWtH/M/rXUdwwpxorQGtR58muYwlEt
         BGjLGFn5ai1eRZIXIGAGWzIjTX7kmzeGZg+sI=
MIME-Version: 1.0
In-Reply-To: <20090629121657.GA9848@qemfd.net>
References: <20090629121657.GA9848@qemfd.net>
Date: Mon, 29 Jun 2009 15:39:26 +0300
X-Google-Sender-Auth: 1fb56131f2e3bf28
Message-ID: <84144f020906290539m3d24af6ap37f9da9371b786dd@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: publish HUGETLBFS_MAGIC via linux/magic.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: nick black <dank@qemfd.net>
Cc: William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       man-pages <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, Jun 29, 2009 at 3:16 PM, nick black<dank@qemfd.net> wrote:
> statfs(2)'s man page (release 3.21) lists HUGETLBFS_MAGIC among the other
> constants, as one would expect. It's not actually exported, though; it's
> buried within inode.c in fs/hugetlbfs/ (iirc, the kvm userland code has
> cut-and-pasted the definition into their sources). This patch brings the
> exported interface into conformance with documentation, is necessary for
> [f]statfs(2)-based verification of hugetlbfs mounts, and eliminates a
> duplicate definition of TMPFS_MAGIC floating around in smack_lsm.c.
>
> This is against 2.6.30-rc1. --rigorously, nick
> Signed-off-by: Nick Black <dank@qemfd.net>

> diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31-rc1-pristine/fs/hugetlbfs/inode.c linux-2.6.31-rc1/fs/hugetlbfs/inode.c
> --- linux-2.6.31-rc1-pristine/fs/hugetlbfs/inode.c      2009-06-24 19:25:37.000000000 -0400
> +++ linux-2.6.31-rc1/fs/hugetlbfs/inode.c       2009-06-29 07:52:43.000000000 -0400
> @@ -31,12 +31,10 @@
>  #include <linux/statfs.h>
>  #include <linux/security.h>
>  #include <linux/ima.h>
> +#include <linux/magic.h>
>
>  #include <asm/uaccess.h>
>
> -/* some random number */
> -#define HUGETLBFS_MAGIC        0x958458f6
> -
>  static const struct super_operations hugetlbfs_ops;
>  static const struct address_space_operations hugetlbfs_aops;
>  const struct file_operations hugetlbfs_file_operations;
> diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31-rc1-pristine/include/linux/magic.h linux-2.6.31-rc1/include/linux/magic.h
> --- linux-2.6.31-rc1-pristine/include/linux/magic.h     2009-06-24 19:25:37.000000000 -0400
> +++ linux-2.6.31-rc1/include/linux/magic.h      2009-06-29 07:58:15.000000000 -0400
> @@ -13,6 +13,7 @@
>  #define SECURITYFS_MAGIC       0x73636673
>  #define SELINUX_MAGIC          0xf97cff8c
>  #define TMPFS_MAGIC            0x01021994
> +#define HUGETLBFS_MAGIC        0x958458f6      /* some random number */
>  #define SQUASHFS_MAGIC         0x73717368
>  #define EFS_SUPER_MAGIC                0x414A53
>  #define EXT2_SUPER_MAGIC       0xEF53

Looks good to me.

> diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31-rc1-pristine/security/smack/smack_lsm.c linux-2.6.31-rc1/security/smack/smack_lsm.c
> --- linux-2.6.31-rc1-pristine/security/smack/smack_lsm.c        2009-06-24 19:25:37.000000000 -0400
> +++ linux-2.6.31-rc1/security/smack/smack_lsm.c 2009-06-29 07:54:28.000000000 -0400
> @@ -30,6 +30,7 @@
>  #include <net/netlabel.h>
>  #include <net/cipso_ipv4.h>
>  #include <linux/audit.h>
> +#include <linux/magic.h>
>  #include "smack.h"
>
>  #define task_security(task)    (task_cred_xxx((task), security))
> @@ -39,7 +40,6 @@
>  */
>  #define DEVPTS_SUPER_MAGIC     0x1cd1
>  #define SOCKFS_MAGIC           0x534F434B
> -#define TMPFS_MAGIC            0x01021994

This looks good to me as well but it should be a separate patch as the
change has nothing to do with hugetlbfs. While at it, you should
probably move SOCKFS_MAGIC and DEVPTS_SUPER_MAGIC to <linux/magic.h>
and remove the definitions from smack.

                                        Pekka
