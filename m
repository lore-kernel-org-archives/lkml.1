Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316Ab0ANLOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0ANLOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854Ab0ANLOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:14:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:35039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0ANLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:14:00 -0500
Subject: Re: [RFC] [PATCH 5/7] X86 Support for Uprobes
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100111122558.22050.431.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122558.22050.431.sendpatchset@srikar.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 12:13:51 +0100
Message-ID: <1263467631.4244.294.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> [PATCH] x86 support for Uprobes

So uhm,.. HAVE_UPROBE is basically HAVE_UBP?

> Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
> ---
>  arch/x86/Kconfig               |    1 +
>  arch/x86/include/asm/uprobes.h |   27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> Index: new_uprobes.git/arch/x86/Kconfig
> ===================================================================
> --- new_uprobes.git.orig/arch/x86/Kconfig
> +++ new_uprobes.git/arch/x86/Kconfig
> @@ -51,6 +51,7 @@ config X86
>  	select HAVE_KERNEL_LZMA
>  	select HAVE_HW_BREAKPOINT
>  	select HAVE_UBP
> +	select HAVE_UPROBES
>  	select HAVE_ARCH_KMEMCHECK
>  	select HAVE_USER_RETURN_NOTIFIER
>  
> Index: new_uprobes.git/arch/x86/include/asm/uprobes.h
> ===================================================================
> --- /dev/null
> +++ new_uprobes.git/arch/x86/include/asm/uprobes.h
> @@ -0,0 +1,27 @@
> +#ifndef _ASM_UPROBES_H
> +#define _ASM_UPROBES_H
> +/*
> + *  Userspace Probes (UProbes)
> + *  uprobes.h
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2008, 2009
> + */
> +#include <linux/signal.h>
> +
> +#define BREAKPOINT_SIGNAL SIGTRAP
> +#define SSTEP_SIGNAL SIGTRAP
> +#endif				/* _ASM_UPROBES_H */


