Return-Path: <linux-kernel-owner+w=401wt.eu-S934515AbXHGUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbXHGUh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXHGUhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:37:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:50793 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbXHGUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GhVzlHJKXiXg07nGISBW2J+SdxqPBgsm9RXz8r0rrZ6iE9MP+rHMU39lChJanK8oNsLvm6+wRUoS6FxMMTDeG1tMHnMxvpcrSxphAZSSinb0LwG434TVQEKdBgz5SZg/1d3OhvGpMZsWAjgMGqjd9SvAoWP0KdNP+r+AUx3mpf8=
Date: Wed, 8 Aug 2007 00:37:07 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove binfmts.h from header exports
Message-ID: <20070807203707.GB5844@martell.zuzino.mipt.ru>
References: <20070807201603.GB31501@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807201603.GB31501@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 10:16:03PM +0200, Olaf Hering wrote:
> remove linux/binfmts.h from make headers_install
> 
> A recent patch added PAGE_SIZE to the part outside of __KERNEL__.
> qemu and ia32el have their own define of MAX_ARG_PAGES.

Should they use kernel header instead?

> No package uses linux/binfmts.h, so it is safe to not provide it.

And? Does it contain stuff which is userspace visible?
binfmts.h has at least CORENAME_MAX_SIZE and SUID_DUMP_*

"userspace doesn't use header" is something headers_install has never
been about.

> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -173,7 +173,6 @@ unifdef-y += atm.h
>  unifdef-y += atm_tcp.h
>  unifdef-y += audit.h
>  unifdef-y += auto_fs.h
> -unifdef-y += binfmts.h
>  unifdef-y += capability.h
>  unifdef-y += capi.h
>  unifdef-y += cciss_ioctl.h
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -17,7 +17,6 @@ struct pt_regs;
>  /* sizeof(linux_binprm->buf) */
>  #define BINPRM_BUF_SIZE 128
>  
> -#ifdef __KERNEL__
>  
>  #define CORENAME_MAX_SIZE 128
>  
> @@ -99,5 +98,4 @@ extern void compute_creds(struct linux_b
>  extern int do_coredump(long signr, int exit_code, struct pt_regs * regs);
>  extern int set_binfmt(struct linux_binfmt *new);
>  
> -#endif /* __KERNEL__ */
>  #endif /* _LINUX_BINFMTS_H */

