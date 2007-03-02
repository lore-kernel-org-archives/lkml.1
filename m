Return-Path: <linux-kernel-owner+w=401wt.eu-S1422735AbXCBCzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422735AbXCBCzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422739AbXCBCzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:55:19 -0500
Received: from xenotime.net ([66.160.160.81]:37877 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422734AbXCBCzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:55:10 -0500
Date: Thu, 1 Mar 2007 18:52:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, rpeterso@redhat.com,
       rdunlap@xenotime.net, rusty@rustcorp.com.au, sam@ravnborg.org,
       zippel@linux-m68k.org
Subject: Re: + extend-print_symbol-capability.patch added to -mm tree
Message-Id: <20070301185250.58564692.rdunlap@xenotime.net>
In-Reply-To: <200703020217.l222HuBt029850@shell0.pdx.osdl.net>
References: <200703020217.l222HuBt029850@shell0.pdx.osdl.net>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 18:17:56 -0800 akpm@linux-foundation.org wrote:

> Today's print_symbol function dumps a kernel symbol with printk.  This
> patch extends the functionality of kallsyms.c so that the symbol lookup
> function may be used without the printk.  This is useful for modules that
> want to dump symbols elsewhere, for example, to debugfs.  I intend to use
> the new function call in the GFS2 file system (which will be a separate
> patch).

Hey, I've needed this one in the past.  Thanks.

> ---
> 
>  include/linux/kallsyms.h |   10 ++++++++++
>  kernel/kallsyms.c        |   21 ++++++++++++++-------
>  2 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff -puN kernel/kallsyms.c~extend-print_symbol-capability kernel/kallsyms.c
> --- a/kernel/kallsyms.c~extend-print_symbol-capability
> +++ a/kernel/kallsyms.c

> @@ -288,6 +285,15 @@ void __print_symbol(const char *fmt, uns
>  		else
>  			sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
>  	}
> +}
> +
> +/* Replace "%s" in format with address, or returns -errno. */

Please fix the comment above...

> +void __print_symbol(const char *fmt, unsigned long address)
> +{
> +	char buffer[KSYM_SYMBOL_LEN];
> +
> +	lookup_symbol(address, buffer);
> +
>  	printk(fmt, buffer);
>  }


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
