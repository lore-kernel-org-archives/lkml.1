Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZEKXRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZEKXRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbZEKXRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:17:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42131 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759402AbZEKXRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:17:43 -0400
Subject: Re: [PATCH 1/3] IMA: use current_cred() instead of current->cred
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org
In-Reply-To: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
References: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 19:16:22 -0400
Message-Id: <1242083782.4131.2.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 13:59 -0400, Eric Paris wrote:
> Proper invocation of the current credentials is to use current_cred() not
> current->cred.  This patches makes IMA use the new method.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
> 
>  security/integrity/ima/ima_audit.c |    2 +-
>  security/integrity/ima/ima_main.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_audit.c b/security/integrity/ima/ima_audit.c
> index b628eea..ff513ff 100644
> --- a/security/integrity/ima/ima_audit.c
> +++ b/security/integrity/ima/ima_audit.c
> @@ -41,7 +41,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
> 
>  	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
>  	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u ses=%u",
> -			 current->pid, current->cred->uid,
> +			 current->pid, current_cred()->uid,
>  			 audit_get_loginuid(current),
>  			 audit_get_sessionid(current));
>  	audit_log_task_context(ab);
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 122f17f..cdae13c 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -184,7 +184,7 @@ int ima_path_check(struct path *path, int mask)
>  		struct dentry *dentry = dget(path->dentry);
>  		struct vfsmount *mnt = mntget(path->mnt);
> 
> -		file = dentry_open(dentry, mnt, O_RDONLY, current->cred);
> +		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
>  		rc = get_path_measurement(iint, file, dentry->d_name.name);
>  	}
>  out:
> 

