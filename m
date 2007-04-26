Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbXDZFz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbXDZFz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXDZFz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:55:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740AbXDZFz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:55:27 -0400
Date: Wed, 25 Apr 2007 22:55:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH -mm] x86_64: kill 19000+ sparse warnings
Message-Id: <20070425225516.8b573d34.akpm@linux-foundation.org>
In-Reply-To: <20070425224509.46153baa.randy.dunlap@oracle.com>
References: <20070425224509.46153baa.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 22:45:09 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Eliminate 19439 (!!) sparse warnings like:
> include/linux/mm.h:321:22: warning: constant 0xffff810000000000 is so big it is unsigned long
> 
> Eliminate 56 sparse warnings like:
> arch/x86_64/kernel/setup.c:248:16: warning: constant 0xffffffff80000000 is so big it is unsigned long
> 
> Eliminate 5 sparse warnings like:
> arch/x86_64/kernel/module.c:49:13: warning: constant 0xfffffffffff00000 is so big it is unsigned long
> 
> Eliminate 23 sparse warnings like:
> arch/x86_64/mm/init.c:551:37: warning: constant 0xffffc20000000000 is so big it is unsigned long
> 
> Eliminate 6 sparse warnings like:
> arch/x86_64/kernel/module.c:49:13: warning: constant 0xffffffff88000000 is so big it is unsigned long
> 
> Eliminate 23 sparse warnings like:
> arch/x86_64/mm/init.c:552:6: warning: constant 0xffffe1ffffffffff is so big it is unsigned long
> 
> Eliminate 3 sparse warnings like:
> arch/x86_64/kernel/e820.c:186:17: warning: constant 0x3fffffffffff is so big it is long
> 
> ...
>
> +#ifdef __ASSEMBLY__
>  #define MAXMEM		 0x3fffffffffff
>  #define VMALLOC_START    0xffffc20000000000
>  #define VMALLOC_END      0xffffe1ffffffffff
>  #define MODULES_VADDR    0xffffffff88000000
>  #define MODULES_END      0xfffffffffff00000
>  #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
> +#else
> +#define MAXMEM		 0x3fffffffffffUL
> +#define VMALLOC_START    0xffffc20000000000UL
> +#define VMALLOC_END      0xffffe1ffffffffffUL
> +#define MODULES_VADDR    0xffffffff88000000UL
> +#define MODULES_END      0xfffffffffff00000UL
> +#define MODULES_LEN   (MODULES_END - MODULES_VADDR)
> +#endif
>  

hm, the duplication is unfortunate.

I wonder if it's worth doing a cpp token-pasting trick to avoid having to
do that.

