Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXIRWH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXIRWH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXIRWHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:07:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37492 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbXIRWHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:07:19 -0400
Date: Tue, 18 Sep 2007 15:02:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/7] Immediate Values - Kconfig menu in EMBEDDED
Message-Id: <20070918150232.128397b4.randy.dunlap@oracle.com>
In-Reply-To: <20070918210852.945316226@polymtl.ca>
References: <20070918210747.828804366@polymtl.ca>
	<20070918210852.945316226@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 17:07:49 -0400 Mathieu Desnoyers wrote:

> Immediate values provide a way to use dynamic code patching to update variables
> sitting within the instruction stream. It saves caches lines normally used by
> static read mostly variables. Enable it by default, but let users disable it
> through the EMBEDDED menu with the "Disable immediate values" submenu entry.
> 
> Note: Since I think that I really should let embedded systems developers using
> RO memory the option to disable the immediate values, I choose to leave this
> menu option there, in the EMBEDDED menu. Also, the "CONFIG_IMMEDIATE" makes
> sense because we want to compile out all the immediate code when we decide not
> to use optimized immediate values at all (it removes otherwise unused code).
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Adrian Bunk <bunk@stusta.de>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Christoph Hellwig <hch@infradead.org>
> ---
>  init/Kconfig |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> Index: linux-2.6-lttng/init/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/init/Kconfig	2007-09-18 10:09:40.000000000 -0400
> +++ linux-2.6-lttng/init/Kconfig	2007-09-18 13:14:58.000000000 -0400
> @@ -407,6 +407,17 @@ config CC_OPTIMIZE_FOR_SIZE
>  config SYSCTL
>  	bool
>  
> +config IMMEDIATE
> +	default y if !DISABLE_IMMEDIATE

So DISABLE_IMMEDIATE is just an intermediate symbol to make this option
be displayed in the EMBEDDED menu instead of in the General Setup menu ?


> +	depends on X86_32 || PPC || PPC64
> +	bool
> +	help
> +	  Immediate values are used as read-mostly variables that are rarely
> +	  updated. They use code patching to modify the values inscribed in the
> +	  instruction stream. It provides a way to save precious cache lines
> +	  that would otherwise have to be used by these variables. They can be
> +	  disabled through the EMBEDDED menu.
> +
>  menuconfig EMBEDDED
>  	bool "Configure standard kernel features (for small systems)"
>  	help
> @@ -646,6 +657,16 @@ config PROC_KPAGEMAP
>            information on page-level memory usage. Disabling this interface
>            will reduce the size of the kernel by around 600 bytes.
>  
> +config DISABLE_IMMEDIATE
> +	default y if EMBEDDED
> +	bool "Disable immediate values" if EMBEDDED
> +	depends on X86_32 || PPC || PPC64
> +	help
> +	  Disable code patching based immediate values for embedded systems. It
> +	  consumes slightly more memory and requires to modify the instruction
> +	  stream each time a variable is updated. Should really be disabled for
> +	  embedded systems with read-only text.
> +
>  endmenu		# General setup
>  
>  config RT_MUTEXES

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
