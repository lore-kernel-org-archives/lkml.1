Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZAEJ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZAEJ3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZAEJ3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:29:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45234 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZAEJ3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:29:44 -0500
Subject: Re: [PATCH 7/7] fs/gfs2: Use DEFINE_SPINLOCK
From: Steven Whitehouse <swhiteho@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812251535080.22039@ask.diku.dk>
References: <Pine.LNX.4.64.0812251535080.22039@ask.diku.dk>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 05 Jan 2009 09:25:10 +0000
Message-Id: <1231147510.9571.457.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now added to the GFS2 -nmw git tree. Thanks,

Steve.

On Thu, 2008-12-25 at 15:35 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> SPIN_LOCK_UNLOCKED is deprecated.  The following makes the change suggested
> in Documentation/spinlocks.txt
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> declarer name DEFINE_SPINLOCK;
> identifier xxx_lock;
> @@
> 
> - spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
> + DEFINE_SPINLOCK(xxx_lock);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> diff -u -p a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -65,7 +65,7 @@ static struct dentry *gfs2_root;
>  static struct workqueue_struct *glock_workqueue;
>  static LIST_HEAD(lru_list);
>  static atomic_t lru_count = ATOMIC_INIT(0);
> -static spinlock_t lru_lock = SPIN_LOCK_UNLOCKED;
> +static DEFINE_SPINLOCK(lru_lock);
>  
>  #define GFS2_GL_HASH_SHIFT      15
>  #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)

