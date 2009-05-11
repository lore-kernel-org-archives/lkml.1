Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbZEKXRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbZEKXRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbZEKXRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:17:10 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47405 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997AbZEKXRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:17:08 -0400
Subject: Re: [PATCH 3/3] IMA: open all files O_LARGEFILE
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org
In-Reply-To: <20090511175922.7719.32980.stgit@dhcp231-142.rdu.redhat.com>
References: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
	 <20090511175922.7719.32980.stgit@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 19:17:07 -0400
Message-Id: <1242083827.4131.3.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 13:59 -0400, Eric Paris wrote:
> If IMA tried to measure a file which was larger than 4G dentry_open would fail
> with -EOVERFLOW since IMA wasn't passing O_LARGEFILE.  This patch passes
> O_LARGEFILE to all IMA opens to avoid this problem.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
> 
>  security/integrity/ima/ima_main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 1987424..c4228c0 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -180,7 +180,8 @@ int ima_path_check(struct path *path, int mask)
>  		struct dentry *dentry = dget(path->dentry);
>  		struct vfsmount *mnt = mntget(path->mnt);
> 
> -		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
> +		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
> +				   current_cred());
>  		if (IS_ERR(file)) {
>  			pr_info("%s dentry_open failed\n", dentry->d_name.name);
>  			rc = PTR_ERR(file);
> 

