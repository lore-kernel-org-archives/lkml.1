Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYIPM63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYIPM63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYIPM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:58:20 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37740 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbYIPM6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:58:20 -0400
Date: Tue, 16 Sep 2008 15:58:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080916125802.GA15951@cs181140183.pp.htv.fi>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1221567763-17060-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 03:22:43PM +0300, Kirill A. Shutemov wrote:
> <linux/fcntl.h> conflicts with glibc's <fcntl.h>.
> 
> It breaks building kdelibs, kdepim and pinot.

We should rather fix the actual bug.

What is the error message?

>...
> --- a/include/linux/inotify.h
> +++ b/include/linux/inotify.h
> @@ -7,8 +7,10 @@
>  #ifndef _LINUX_INOTIFY_H
>  #define _LINUX_INOTIFY_H
>  
> +#ifdef __KERNEL__
>  /* For O_CLOEXEC and O_NONBLOCK */
>  #include <linux/fcntl.h>
> +#endif
>...  

This breaks the header for users of IN_CLOEXEC/IN_NONBLOCK.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

