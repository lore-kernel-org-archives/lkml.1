Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbXIYKjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbXIYKjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXIYKj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:39:28 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:53506 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbXIYKj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:39:27 -0400
Message-ID: <46F8E52A.2090209@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 16:08:34 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix messed hunks in generic_setlease
References: <46F8BF79.40405@openvz.org>
In-Reply-To: <46F8BF79.40405@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
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
> 

Hi Pavel,

I tested your patch and NULL pointer dereference is not triggered.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
