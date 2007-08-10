Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbXHJHpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbXHJHpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXHJHpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:45:12 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46740 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXHJHpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:45:10 -0400
Date: Fri, 10 Aug 2007 11:44:59 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, ak@suse.de
Subject: Re: + sysctl-x86_64-remove-unnecessary-binary-paths.patch added to -mm tree
Message-ID: <20070810074459.GC6639@localhost.sw.ru>
References: <200708100142.l7A1g1ZZ029579@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708100142.l7A1g1ZZ029579@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 06:42:01PM -0700, akpm@linux-foundation.org wrote:
> --- a/arch/x86_64/ia32/ia32_binfmt.c~sysctl-x86_64-remove-unnecessary-binary-paths
> +++ a/arch/x86_64/ia32/ia32_binfmt.c
> @@ -258,7 +258,6 @@ static void elf32_init(struct pt_regs *r
>  
>  static ctl_table abi_table2[] = {
>  	{
> -		.ctl_name	= 99,
>  		.procname	= "vsyscall32",
>  		.data		= &sysctl_vsyscall32,
>  		.maxlen		= sizeof(int),
> diff -puN arch/x86_64/kernel/vsyscall.c~sysctl-x86_64-remove-unnecessary-binary-paths arch/x86_64/kernel/vsyscall.c
> --- a/arch/x86_64/kernel/vsyscall.c~sysctl-x86_64-remove-unnecessary-binary-paths
> +++ a/arch/x86_64/kernel/vsyscall.c
> @@ -260,18 +260,10 @@ out:
>  	return ret;
>  }
>  
> -static int vsyscall_sysctl_nostrat(ctl_table *t, int __user *name, int nlen,
> -				void __user *oldval, size_t __user *oldlenp,
> -				void __user *newval, size_t newlen)
> -{
> -	return -ENOSYS;
> -}
> -
>  static ctl_table kernel_table2[] = {
> -	{ .ctl_name = 99, .procname = "vsyscall64",
> +	{ .procname = "vsyscall64",
>  	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
>  	  .mode = 0644,
> -	  .strategy = vsyscall_sysctl_nostrat,
>  	  .proc_handler = vsyscall_sysctl_change },

Looks good. It clearly newer worked.

