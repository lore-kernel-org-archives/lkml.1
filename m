Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZC0T7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZC0T7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZC0T7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:59:03 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:42534 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbZC0T7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:59:01 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 5EB792C2E44
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Allow relatime to update atime once a day
To: Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, mingo@elte.hu, tytso@mit.edu,
       jack@suse.cz, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
       drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org,
       oleg@redhat.com, roland@redhat.com, willy@linux.intel.com,
       vaurora@redhat.com
Reply-To: 7eggert@gmx.de
Date: Fri, 27 Mar 2009 20:58:55 +0100
References: <cjKHX-5MF-17@gated-at.bofh.it> <cjLb2-6no-13@gated-at.bofh.it> <cjTLl-3ln-15@gated-at.bofh.it> <cjW6r-72f-21@gated-at.bofh.it> <cjYrG-2u0-23@gated-at.bofh.it> <cjZ4h-3jp-21@gated-at.bofh.it> <cjZQH-4AG-21@gated-at.bofh.it> <ck0a6-51w-39@gated-at.bofh.it> <ck0D7-5Ua-9@gated-at.bofh.it> <ck1IK-7zR-19@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LnICd-0001mx-EH@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> wrote:

> diff --git a/fs/inode.c b/fs/inode.c
> index 0487ddb..057c92b 100644
> --- a/fs/inode.c

>  now = current_fs_time(inode->i_sb);
> +
> +     if (!relatime_need_update(mnt, inode, now))
> +             goto out;
> +
>  if (timespec_equal(&inode->i_atime, &now))
>  goto out;

Forget what I just said, I should rather read than assume.

But I'm wondering if inlining this once-used function would be a good thing,
since relatime is supposed to be a common option? Otherwise, I'd pull the
flags check out and avoid the function call.

