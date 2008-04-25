Return-Path: <linux-kernel-owner+w=401wt.eu-S1764790AbYDYXDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764790AbYDYXDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYDYXDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:03:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:45320 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYDYXDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:03:43 -0400
Date: Fri, 25 Apr 2008 19:03:36 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
Subject: Re: [PATCH] Export __locks_copy_lock() so modular lockd builds
Message-ID: <20080425230336.GC9597@fieldses.org>
References: <adar6ct5zvw.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar6ct5zvw.fsf@cisco.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 03:32:51PM -0700, Roland Dreier wrote:
> Commit 1a747ee0 ("locks: don't call ->copy_lock methods on return of
> conflicting locks") changed fs/lockd/svclock.c to call
> __locks_copy_lock() instead of locks_copy_lock(), but lockd can be built
> as a module and __locks_copy_lock() is not exported, which causes a
> build error
> 
>     ERROR: "__locks_copy_lock" [fs/lockd/lockd.ko] undefined!
> 
> with CONFIG_LOCKD=m.
> 
> Fix this by exporting __locks_copy_lock().

Oog, sorry.  Thaks for the fix!

> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Acked-by: J. Bruce Fields <bfields@citi.umich.edu>

> ---
>  fs/locks.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index e1ea2fe..44d9a6a 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -236,6 +236,7 @@ void __locks_copy_lock(struct file_lock *new, const struct file_lock *fl)
>  	new->fl_ops = NULL;
>  	new->fl_lmops = NULL;
>  }
> +EXPORT_SYMBOL(__locks_copy_lock);
>  
>  void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
>  {
