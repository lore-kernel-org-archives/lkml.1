Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbXFMNoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbXFMNoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbXFMNnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:43:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:61605 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbXFMNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AY+OaqARkOSnwDMo3uRLpM8cVWBVQDeq6nlpM04aHQNdy5wSYUeW5ScgNzcRQuqnlS+/YmkCWjlJOX+l2C1XXHeW5+HjPog+PwBi5JYy98LBRryqQrd4Yq4oQ6SeQ1PvBwc3ucZD9J1SPGRl1YpKv/5GGEkff5K9uRczfFkNNmo=
Message-ID: <466FF491.30409@gmail.com>
Date: Wed, 13 Jun 2007 22:43:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] sysfs: Fix oops in sysfs_drop_dentry on x86_64
References: <200706131536.18882.rjw@sisk.pl>
In-Reply-To: <200706131536.18882.rjw@sisk.pl>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix oops on x86_64 caused by the dereference of dir in sysfs_drop_dentry() made
> before checking if dir is not NULL
> (cf. http://marc.info/?l=linux-kernel&m=118151626704924&w=2).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  fs/sysfs/inode.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.22-rc4-mm2/fs/sysfs/inode.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/fs/sysfs/inode.c
> +++ linux-2.6.22-rc4-mm2/fs/sysfs/inode.c
> @@ -285,7 +285,7 @@ void sysfs_drop_dentry(struct sysfs_dire
>  int sysfs_hash_and_remove(struct dentry * dir, const char * name)
>  {
>  	struct sysfs_dirent **pos, *sd;
> -	struct sysfs_dirent *parent_sd = dir->d_fsdata;
> +	struct sysfs_dirent *parent_sd;
>  	int found = 0;

Argh... Right.  My delusional mind somehow thought the nonsense early
dereferencing was there before any changes so I passed on that one.
Thanks a lot for catching it.  The whole sysfs patchset is pending
regeneration.  I'll include the fix patch.

Thanks a lot.  :-)

-- 
tejun
