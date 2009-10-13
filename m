Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZJMPjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZJMPjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZJMPjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:39:07 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:47758 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZJMPjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:39:06 -0400
X-Greylist: delayed 3456 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 11:39:06 EDT
Subject: Re: [PATCH] sysfs: mark a locally-only used function static
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Morris <jmorris@namei.org>, "Stephen D. Smalley" <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org, greg@kroah.com
In-Reply-To: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de>
References: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 13 Oct 2009 10:42:44 -0400
Message-Id: <1255444964.11749.340.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 03:02 +0200, Stefan Richter wrote:
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index e28cecf..e144351 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -46,7 +46,7 @@ int __init sysfs_inode_init(void)
>  	return bdi_init(&sysfs_backing_dev_info);
>  }
>  
> -struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
> +static struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
>  {
>  	struct sysfs_inode_attrs *attrs;
>  	struct iattr *iattrs;
> @@ -64,6 +64,7 @@ struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
>  
>  	return attrs;
>  }
> +
>  int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>  {
>  	struct inode * inode = dentry->d_inode;
> 

I don't see why this shouldn't or can't be made static. I'll ACK it and
then you guys can deal with it however you like.

-Dave



