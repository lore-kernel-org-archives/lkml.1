Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYIRJrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYIRJrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYIRJq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:46:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:42332 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbYIRJq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:46:56 -0400
Message-ID: <28fa9c5e0809180246g3af92d31nfee5bfd765a57bb7@mail.gmail.com>
Date: Thu, 18 Sep 2008 17:46:55 +0800
From: "Eugene Teo" <eugeneteo@kernel.sg>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext2: Avoid printk floods in the face of directory corruption
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Eric Sandeen" <sandeen@redhat.com>, linux-ext4@vger.kernel.org
In-Reply-To: <1221319971-29879-3-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
	 <1221319971-29879-2-git-send-email-tytso@mit.edu>
	 <1221319971-29879-3-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 11:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
[...]
>  Eend:
> -       p = (ext2_dirent *)(kaddr + offs);
> -       ext2_error (sb, "ext2_check_page",
> -               "entry in directory #%lu spans the page boundary"
> -               "offset=%lu, inode=%lu",
> -               dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
> -               (unsigned long) le32_to_cpu(p->inode));
> +       if (!quiet) {
> +               p = (ext2_dirent *)(kaddr + offs);
> +               ext2_error (sb, "ext2_check_page",
                                                ^^^^^^^^^^^^^^^^^^
> +                       "entry in directory #%lu spans the page boundary"
> +                       "offset=%lu, inode=%lu",
> +                       dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
> +                       (unsigned long) le32_to_cpu(p->inode));

Minor issue. Since you are already changing "ext2_check_page" to
__func__, you might as well change it here too.

Thanks, Eugene
