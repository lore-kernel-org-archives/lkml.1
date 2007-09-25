Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbXIYIIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbXIYIIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbXIYIHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:07:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754923AbXIYIHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:07:48 -0400
Date: Tue, 25 Sep 2007 01:07:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix messed hunks in generic_setlease
Message-Id: <20070925010728.b65e5b27.akpm@linux-foundation.org>
In-Reply-To: <46F8BF79.40405@openvz.org>
References: <46F8BF79.40405@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 11:57:45 +0400 Pavel Emelyanov <xemul@openvz.org> wrote:

> I have noticed, that one hunk was lost and one duplicated 
> during merging the fix-potential-oops-in-generic_setlease(-xxx) 
> patches. One of the fixes is already in the hot-fixes, but the
> second one is still lost.
> 
> The returned pointer was not the one allocated, but some temporary
> used to scan through the inode's locks list. This caused and OOPS 
> during Kamalesh's testing.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index c0fe71a..c1198e3 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1423,7 +1418,7 @@ int generic_setlease(struct file *filp, 
>  	locks_copy_lock(new_fl, lease);
>  	locks_insert_lock(before, new_fl);
>  
> -	*flp = fl;
> +	*flp = new_fl;
>  	return 0;
>  
>  out:

argh, what a mess - there are way too many trees playing with fs/locks.c.

umm, I think this is not a mismerge and that the original patch
(http://lkml.org/lkml/2007/9/20/141) had this bug in it.

And I've just sent that buggy patch to Linus.  Do you agree?
