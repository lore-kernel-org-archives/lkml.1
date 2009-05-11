Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZEKMMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZEKMMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZEKMMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:12:23 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:57337 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZEKMMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TElVmxHeAw0aiKu0egkJePhQ6v12Brw/kDK8cc0yRFkeYNPRuocGFDMUZIGIPKd9Ql
         DilMopvpLXbUogNDPL12Fw0wYv+Ts3C2gX/yO/NgSapPEHnedQWwqrElv+XououVyYfx
         2fZBJ8DEZE0krS3kBTnSxXRUNQRGCFFgkicyI=
MIME-Version: 1.0
In-Reply-To: <20090511115240.GC25673@in.ibm.com>
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com>
	 <20090511115240.GC25673@in.ibm.com>
Date: Mon, 11 May 2009 17:42:22 +0530
Message-ID: <344eb09a0905110512h4f4c98d0oa207e12d88f69e87@mail.gmail.com>
Subject: Re: [Patch 02/12] Introducing generic hardware breakpoint handler 
	interfaces
From: Bharata B Rao <bharata.rao@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 5:22 PM, K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> This patch introduces the generic Hardware Breakpoint interfaces for both user
> and kernel space requests.
>
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  arch/Kconfig           |    4
>  kernel/Makefile        |    1
>  kernel/hw_breakpoint.c |  367 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 372 insertions(+)
>
> Index: arch/Kconfig
> ===================================================================
> --- arch/Kconfig.orig
> +++ arch/Kconfig
> @@ -112,3 +112,7 @@ config HAVE_DMA_API_DEBUG
>
>  config HAVE_DEFAULT_NO_SPIN_MUTEXES
>        bool
> +
> +config HAVE_HW_BREAKPOINT
> +       bool
> +
> Index: kernel/Makefile
> ===================================================================
> --- kernel/Makefile.orig
> +++ kernel/Makefile
> @@ -97,6 +97,7 @@ obj-$(CONFIG_X86_DS) += trace/
>  obj-$(CONFIG_SMP) += sched_cpupri.o
>  obj-$(CONFIG_SLOW_WORK) += slow-work.o
>  obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
> +obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
>
>  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
> Index: kernel/hw_breakpoint.c
> ===================================================================
> --- /dev/null
> +++ kernel/hw_breakpoint.c
> @@ -0,0 +1,367 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) 2007 Alan Stern
> + * Copyright (C) IBM Corporation, 2009
> + */
> +
> +/*
> + * HW_breakpoint: a unified kernel/user-space hardware breakpoint facility,
> + * using the CPU's debug registers.
> + *
> + * This file contains the arch-independent routines.  It is not meant
> + * to be compiled as a standalone source file; rather it should be
> + * #include'd by the arch-specific implementation.

That's no longer true, right ?

Regards,
Bharata.
