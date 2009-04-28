Return-Path: <linux-kernel-owner+w=401wt.eu-S1763164AbZD1RW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763164AbZD1RW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761557AbZD1RWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:22:01 -0400
Received: from mail.fieldses.org ([141.211.133.115]:59415 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762295AbZD1RV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:21:59 -0400
Date: Tue, 28 Apr 2009 13:21:37 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] lockd: fix FILE_LOCKING=n build error
Message-ID: <20090428172137.GA22451@fieldses.org>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F71F4A.3080908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F71F4A.3080908@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 08:22:50AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> lockd/svclock.c is missing a header file <linux/fs.h>.
> 
> <linux/fs.h> is missing a definition of locks_release_private()
> for the config case of FILE_LOCKING=n, causing a build error:
> 
> fs/lockd/svclock.c:330: error: implicit declaration of function 'locks_release_private'

LOCKD without FILE_LOCKING doesn't really make sense; would it be better
to add a config dependency?

--b.

> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/lockd/svclock.c |    1 +
>  include/linux/fs.h |    4 ++++
>  2 files changed, 5 insertions(+)
> 
> --- linux-next-20090428.orig/fs/lockd/svclock.c
> +++ linux-next-20090428/fs/lockd/svclock.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/errno.h>
> +#include <linux/fs.h>
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/smp_lock.h>
> --- linux-next-20090428.orig/include/linux/fs.h
> +++ linux-next-20090428/include/linux/fs.h
> @@ -1183,6 +1183,10 @@ static inline void locks_remove_flock(st
>  	return;
>  }
>  
> +static inline void locks_release_private(struct file_lock *fl)
> +{
> +}
> +
>  static inline void posix_test_lock(struct file *filp, struct file_lock *fl)
>  {
>  	return;
> 
> -- 
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
