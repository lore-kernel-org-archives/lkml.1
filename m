Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXEUEf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXEUEf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXEUEfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:35:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56142 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXEUEfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:35:14 -0400
Date: Mon, 21 May 2007 10:05:40 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 1/2] sysfs: fix condition check in sysfs_drop_dentry()
Message-ID: <20070521043540.GA9214@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20070515185350.2e77bf21.akpm@linux-foundation.org> <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9675.3030101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464C9675.3030101@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 07:52:53PM +0200, Tejun Heo wrote:
> The condition check doesn't make much sense as it basically always
> succeeds.  This causes NULL dereferencing on certain cases.  It seems
> that parentheses are put in the wrong place.  Fix it.
> 
> DON'T APPLY JUST YET
> ---
> 
> Maneesh, is this correct?
> 
Yes.

>  fs/sysfs/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: work/fs/sysfs/inode.c
> ===================================================================
> --- work.orig/fs/sysfs/inode.c
> +++ work/fs/sysfs/inode.c
> @@ -250,7 +250,7 @@ void sysfs_drop_dentry(struct sysfs_dire
>  	if (dentry) {
>  		spin_lock(&dcache_lock);
>  		spin_lock(&dentry->d_lock);
> -		if (!(d_unhashed(dentry) && dentry->d_inode)) {
> +		if (!d_unhashed(dentry) && dentry->d_inode) {
>  			inode = dentry->d_inode;
>  			spin_lock(&inode->i_lock);
>  			__iget(inode);


Ack'ed

Thanks
Maneesh

-- 
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India
