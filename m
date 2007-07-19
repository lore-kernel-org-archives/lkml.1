Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbXGSMsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbXGSMsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758586AbXGSMs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:48:29 -0400
Received: from mail.fieldses.org ([66.93.2.214]:48988 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539AbXGSMs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:48:29 -0400
Date: Thu, 19 Jul 2007 08:48:22 -0400
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: AFS compile broken
Message-ID: <20070719124822.GA13180@fieldses.org>
References: <Pine.SOC.4.64.0707191516120.18397@math.ut.ee> <20070719143556.795cb458@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719143556.795cb458@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 02:35:56PM +0200, Cornelia Huck wrote:
> On Thu, 19 Jul 2007 15:19:40 +0300 (EEST),
> Meelis Roos <mroos@linux.ee> wrote:
> 
> > Trying to compile todays git with modular AFS and gcc 4.1.3 prerelease 
> > in Debian unstable (gcc version 4.1.3 20070629 (prerelease) (Debian 
> > 4.1.2-13)):
> > 
> >   CC [M]  fs/afs/flock.o
> > fs/afs/flock.c: In function 'afs_do_getlk':
> > fs/afs/flock.c:459: error: void value not ignored as it ought to be
> > make[3]: *** [fs/afs/flock.o] Error 1
> 
> Should probably be something like this, but I have no idea whether this
> is correct.

That's correct, and Andrew has the same patch.  (And the breakage was my
fault, apologies.)

--b.

> 
> ---
>  fs/afs/flock.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.22.orig/fs/afs/flock.c
> +++ linux-2.6.22/fs/afs/flock.c
> @@ -456,7 +456,8 @@ static int afs_do_getlk(struct file *fil
>  
>  	/* check local lock records first */
>  	ret = 0;
> -	if (posix_test_lock(file, fl) == 0) {
> +	posix_test_lock(file, fl);
> +	if (fl->fl_type == F_UNLCK) {
>  		/* no local locks; consult the server */
>  		ret = afs_vnode_fetch_status(vnode, NULL, key);
>  		if (ret < 0)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
