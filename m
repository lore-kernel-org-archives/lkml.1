Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbXA2ORM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbXA2ORM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXA2ORM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:17:12 -0500
Received: from pat.uio.no ([129.240.10.15]:52590 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbXA2ORL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:17:11 -0500
Subject: Re: [NFS] 2.6.17.8 - do_vfs_lock: VFS is out of sync with lock
	manager!
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Neil Brown <neilb@suse.de>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, nfs@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <17853.33116.113629.65031@notabene.brown>
References: <9a8748490608080739w2e14e5ceg44a7bf0a3b475704@mail.gmail.com>
	 <17636.4462.975774.528003@cse.unsw.edu.au>
	 <9a8748490608170258s32df0272r60c8c540e5871485@mail.gmail.com>
	 <17641.10665.116168.867041@cse.unsw.edu.au>
	 <1156190098.6158.109.camel@localhost>
	 <17853.33116.113629.65031@notabene.brown>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 09:16:50 -0500
Message-Id: <1170080210.5757.6.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: D72AA3BBBFF1FCC036E93ACA56C88EE2CD206071
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 572 total 144598 max/h 1952 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 16:08 +1100, Neil Brown wrote:
> On Monday August 21, trond.myklebust@fys.uio.no wrote:
> > 
> > Could we instead replace it with a dprintk() that returns the value of
> > "res"? That will keep it useful for debugging purposes.
> 
> (only 5 months later...)
> 
> Sure, how about this?
> 
> Thanks,
> NeilBrown

ACKed.

Thanks Neil!

Trond

> 
> Remove warning: VFS is out of sync with lock manager.
> 
> But keep it as a dprintk
> 
> The message can be generated in a quite normal situation:
>  If a 'lock' request is interrupted, then the lock client needs to
>   record that the server has the lock, incase it does.
>  When we come the unlock, the server might say it doesn't, even
>   though we think it does (or might) and this generates the message.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./fs/nfs/file.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff .prev/fs/nfs/file.c ./fs/nfs/file.c
> --- .prev/fs/nfs/file.c	2007-01-29 16:04:09.000000000 +1100
> +++ ./fs/nfs/file.c	2007-01-29 16:04:45.000000000 +1100
> @@ -434,8 +434,9 @@ static int do_vfs_lock(struct file *file
>  			BUG();
>  	}
>  	if (res < 0)
> -		printk(KERN_WARNING "%s: VFS is out of sync with lock manager!\n",
> -				__FUNCTION__);
> +		dprintk(KERN_WARNING "%s: VFS is out of sync with lock manager"
> +			" - error %d!\n",
> +				__FUNCTION__, res);
>  	return res;
>  }
>  

