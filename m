Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0BHPrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:47:53 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59957 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0BHPrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:47:52 -0500
Subject: Re: [PATCH] security/integrity/ima/ima_main.c: Fix return value
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <628d1651002072300i59bc192dy86fddca9713b5701@mail.gmail.com>
References: <628d1651002072300i59bc192dy86fddca9713b5701@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 08 Feb 2010 10:47:38 -0500
Message-Id: <1265644058.4038.79.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 15:00 +0800, wzt wzt wrote:
> Hi:
>   In security/integrity/ima/ima_main.c ima_file_mmap() called by
> security_file_mmap(), it depend on the return value of
> ima_file_mmap(), not always return 0. see also in ima_bprm_check().
> 
> 
> Signed-off-by: wzt <zhitong.wangzt@alibaba-inc.com>
> 
> diff --git a/security/integrity/ima/ima_main.c
> b/security/integrity/ima/ima_main.c
> index 294b005..705a991 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -271,7 +271,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
>         if (prot & PROT_EXEC)
>                 rc = process_measurement(file, file->f_dentry->d_name.name,
>                                          MAY_EXEC, FILE_MMAP);
> -       return 0;
> +       return rc;
>  }
> 
>  /**
> @@ -293,7 +293,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
> 
>         rc = process_measurement(bprm->file, bprm->filename,
>                                  MAY_EXEC, BPRM_CHECK);
> -       return 0;
> +       return rc;
>  }

nack.  Sorry, we're not at the point where we can enforce integrity. The
return code will eventually be based on measurement appraisal.

Mimi

