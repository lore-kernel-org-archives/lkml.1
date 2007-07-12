Return-Path: <linux-kernel-owner+w=401wt.eu-S933164AbXGLNJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbXGLNJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763863AbXGLNJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:09:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50912 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011AbXGLNJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:09:04 -0400
Date: Thu, 12 Jul 2007 18:39:10 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: David Patrick Quigley <dpquigl@tycho.nsa.gov>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       eparis@redhat.com, jmorris@namei.org, sds@tycho.nsa.gov
Subject: Re: [PATCH 2/7] fallocate() implementation in i386, x86_64 and powerpc
Message-ID: <20070712130910.GB21606@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com> <20070710202000.GB8797@amitarora.in.ibm.com> <1184244990.18175.6.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184244990.18175.6.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 08:56:30AM -0400, David Patrick Quigley wrote:
> From: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> Revalidate the write permissions for fallocate(2), in case security policy has
> changed since the files were opened.

Thanks for your patch! Will include it in the patchset.

--
Regards,
Amit Arora
> 
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> fs/open.c |    3 +++
> 1 file changed, 3 insertions(+)
> 
> diff -uprN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22-fallocate/fs/open.c linux-2.6.22-fallocate-selinux/fs/open.c
> --- linux-2.6.22-fallocate/fs/open.c	2007-07-11 15:51:10.000000000 -0400
> +++ linux-2.6.22-fallocate-selinux/fs/open.c	2007-07-11 16:10:43.000000000 -0400
> @@ -411,6 +411,9 @@ asmlinkage long sys_fallocate(int fd, in
>  		goto out;
>  	if (!(file->f_mode & FMODE_WRITE))
>  		goto out_fput;
> +	ret = security_file_permission(file, MAY_WRITE);
> +	if (ret)
> +		goto out_fput;
> 
>  	inode = file->f_path.dentry->d_inode;
