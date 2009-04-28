Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbZD1PiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbZD1PiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbZD1PiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:38:13 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33552 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754401AbZD1PiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:38:12 -0400
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Message-Id: <3C0B014B-1217-4802-88E0-0F3AE5D395B2@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <49F71F4A.3080908@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] lockd: fix FILE_LOCKING=n build error
Date: Tue, 28 Apr 2009 10:38:08 -0500
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F71F4A.3080908@oracle.com>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 28, 2009, at 10:22 AM, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> lockd/svclock.c is missing a header file <linux/fs.h>.
>
> <linux/fs.h> is missing a definition of locks_release_private()
> for the config case of FILE_LOCKING=n, causing a build error:
>
> fs/lockd/svclock.c:330: error: implicit declaration of function  
> 'locks_release_private'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Heh, I did miss it in my original patch, where I added
locks_release_private().
The fix looks good, thanks.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
> fs/lockd/svclock.c |    1 +
> include/linux/fs.h |    4 ++++
> 2 files changed, 5 insertions(+)
>
> --- linux-next-20090428.orig/fs/lockd/svclock.c
> +++ linux-next-20090428/fs/lockd/svclock.c
> @@ -22,6 +22,7 @@
>
> #include <linux/types.h>
> #include <linux/errno.h>
> +#include <linux/fs.h>
> #include <linux/kernel.h>
> #include <linux/sched.h>
> #include <linux/smp_lock.h>
> --- linux-next-20090428.orig/include/linux/fs.h
> +++ linux-next-20090428/include/linux/fs.h
> @@ -1183,6 +1183,10 @@ static inline void locks_remove_flock(st
> 	return;
> }
>
> +static inline void locks_release_private(struct file_lock *fl)
> +{
> +}
> +
> static inline void posix_test_lock(struct file *filp, struct  
> file_lock *fl)
> {
> 	return;
>
> -- 
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

