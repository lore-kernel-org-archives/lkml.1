Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbXJ3XOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbXJ3XOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXJ3XN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:13:56 -0400
Received: from xenotime.net ([66.160.160.81]:36993 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751989AbXJ3XN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:13:56 -0400
Date: Tue, 30 Oct 2007 16:13:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mmap: restore -ENODEV on missing f_op->mmap
Message-Id: <20071030161352.80656280.rdunlap@xenotime.net>
In-Reply-To: <alpine.LFD.0.999.0710301541050.30120@woody.linux-foundation.org>
References: <4727AE44.10902@suse.com>
	<alpine.LFD.0.999.0710301541050.30120@woody.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 15:45:56 -0700 (PDT) Linus Torvalds wrote:

> 
> 
> On Tue, 30 Oct 2007, Jeff Mahoney wrote:
> > 
> >  Personally, I think this is probably a case of LTP codifying existing
> >  behavior rather than testing the for the specification. If that's the case
> >  and nobody really cares about the change in behavior, I'm fine letting this
> >  drop.
> 
> Hmm.. I think it's kind of stupid adding that special case early on, just 
> to get one particular error case return when there are multiple possible 
> ones. 
> 
> I don't care deeply, but this does smell like a test issue rather than a 
> code issue.
> 
> Looking at that path, there are *other* things that might be worth 
> cleaning up, but this wasn't one of them..


Jeff, will you (at least) notify the LTP project of this issue and
need for a patch?

Thanks.

> ---
> diff --git a/mm/mmap.c b/mm/mmap.c
> index facc1a7..fe286f7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -893,7 +893,6 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
>  			unsigned long flags, unsigned long pgoff)
>  {
>  	struct mm_struct * mm = current->mm;
> -	struct inode *inode;
>  	unsigned int vm_flags;
>  	int error;
>  	int accountable = 1;
> @@ -959,9 +958,9 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
>  			return -EAGAIN;
>  	}
>  
> -	inode = file ? file->f_path.dentry->d_inode : NULL;
> -
>  	if (file) {
> +		struct inode *inode = file->f_path.dentry->d_inode;
> +
>  		switch (flags & MAP_TYPE) {
>  		case MAP_SHARED:
>  			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
> -

---
~Randy
