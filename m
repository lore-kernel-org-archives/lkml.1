Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab0BPOdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:33:47 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47721 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab0BPOdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:33:45 -0500
Subject: Re: [PATCH] vfs: don't call ima_file_check() unconditionally in
 nfsd_open()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <201002152307.o1FN7f10019719@int-mx02.intmail.prod.int.phx2.redhat.com>
References: <201002152307.o1FN7f10019719@int-mx02.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain
Date: Tue, 16 Feb 2010 09:33:22 -0500
Message-Id: <1266330802.4416.9.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 18:07 -0500, Chuck Ebbert wrote:
> From: Chuck Ebbert <cebbert@redhat.com>
> 
> vfs: don't call ima_file_check() unconditionally in nfsd_open()
> 
> commit 1e41568d7378d1ba8c64ba137b9ddd00b59f893a ("Take ima_path_check()
> in nfsd past dentry_open() in nfsd_open()") moved this code back to its
> original location but missed the "else".
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Thanks for catching it.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

> --- linux-2.6.32.noarch.orig/fs/nfsd/vfs.c
> +++ linux-2.6.32.noarch/fs/nfsd/vfs.c
> @@ -752,7 +752,8 @@ nfsd_open(struct svc_rqst *rqstp, struct
>  			    flags, current_cred());
>  	if (IS_ERR(*filp))
>  		host_err = PTR_ERR(*filp);
> -	host_err = ima_file_check(*filp, access);
> +	else
> +		host_err = ima_file_check(*filp, access);
>  out_nfserr:
>  	err = nfserrno(host_err);
>  out:

