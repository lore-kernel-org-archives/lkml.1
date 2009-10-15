Return-Path: <linux-kernel-owner+w=401wt.eu-S935125AbZJOQr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935125AbZJOQr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933392AbZJOQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:47:56 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31821 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988AbZJOQrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:47:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch] kallsyms: remove deprecated print_fn_descriptor_symbol()
Date: Thu, 15 Oct 2009 10:47:17 -0600
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20091015062942.4391.22306.sendpatchset@localhost.localdomain>
In-Reply-To: <20091015062942.4391.22306.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910151047.17998.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009 12:27:00 am Amerigo Wang wrote:
> 
> According to feature-removal-schedule.txt, it is the time
> to remove print_fn_descriptor_symbol().
> 
> And a quick grep shows that it no longer has any callers.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>

Thanks!

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

> ---
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 04e6c81..42ba573 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -283,15 +283,6 @@ Who:	Glauber Costa <gcosta@redhat.com>
>  
>  ---------------------------
>  
> -What: print_fn_descriptor_symbol()
> -When: October 2009
> -Why:  The %pF vsprintf format provides the same functionality in a
> -      simpler way.  print_fn_descriptor_symbol() is deprecated but
> -      still present to give out-of-tree modules time to change.
> -Who:  Bjorn Helgaas <bjorn.helgaas@hp.com>
> -
> ----------------------------
> -
>  What:	/sys/o2cb symlink
>  When:	January 2010
>  Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index 7922742..d8e9b3d 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -107,18 +107,6 @@ static inline void print_symbol(const char *fmt, unsigned long addr)
>  		       __builtin_extract_return_addr((void *)addr));
>  }
>  
> -/*
> - * Pretty-print a function pointer.  This function is deprecated.
> - * Please use the "%pF" vsprintf format instead.
> - */
> -static inline void __deprecated print_fn_descriptor_symbol(const char *fmt, void *addr)
> -{
> -#if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
> -	addr = *(void **)addr;
> -#endif
> -	print_symbol(fmt, (unsigned long)addr);
> -}
> -
>  static inline void print_ip_sym(unsigned long ip)
>  {
>  	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
> 


