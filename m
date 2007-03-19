Return-Path: <linux-kernel-owner+w=401wt.eu-S1751014AbXCSKKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbXCSKKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXCSKKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:10:12 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:37942 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbXCSKKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:10:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: sysfs_drop_dentry(): possible NULL dereference
Date: Mon, 19 Mar 2007 11:09:56 +0100
User-Agent: KMail/1.9.1
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20070319092211.GG752@stusta.de>
In-Reply-To: <20070319092211.GG752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703191109.57683.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH7LvUpHAk=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 19. März 2007 10:22 schrieb Adrian Bunk:

>  void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
>  {
>         struct dentry * dentry = sd->s_dentry;
> +       struct inode *inode;
>  
>         if (dentry) {
>                 spin_lock(&dcache_lock);
>                 spin_lock(&dentry->d_lock);
>                 if (!(d_unhashed(dentry) && dentry->d_inode)) {
> +                       inode = dentry->d_inode;
> +                       spin_lock(&inode->i_lock);
> ...
> 
> <--  snip  -->
> 
> If (!dentry->d_inode), then it's a NULL dereference.

As far as I can tell, sysfs being a virtual filesystem, does not use
dentries without inodes associated.

	Regards
		Oliver
