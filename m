Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZLUCLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZLUCLi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 21:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZLUCLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 21:11:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZLUCLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 21:11:37 -0500
Message-ID: <4B2ED9F4.5050109@redhat.com>
Date: Sun, 20 Dec 2009 21:14:12 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] elf_fdpic_core_dump(): fix build break in 2.6.33-rc1
References: <20091221.110431.189715673.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20091221.110431.189715673.d.hatayama@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Daisuke HATAYAMA wrote:
> The commit f6151dfea21496d43dbaba32cfcd9c9f404769bc causes build
> break, so this patch fixes it together with the correction for printk
> format.
> 
> Thanks.
> 
> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

Thanks for fixing that! looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  fs/binfmt_elf_fdpic.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index c25256a..b0f2732 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -1798,11 +1798,11 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
>  	ELF_CORE_WRITE_EXTRA_DATA;
>  #endif
>  
> -	if (file->f_pos != offset) {
> +	if (cprm->file->f_pos != offset) {
>  		/* Sanity check */
>  		printk(KERN_WARNING
> -		       "elf_core_dump: file->f_pos (%lld) != offset (%lld)\n",
> -		       file->f_pos, offset);
> +		       "elf_fdpic_core_dump: cprm->file->f_pos (%lld) != offset (%lld)\n",
> +		       cprm->file->f_pos, offset);
>  	}
>  
>  end_coredump:

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

