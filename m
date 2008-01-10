Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYAJPQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYAJPQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759593AbYAJPQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:16:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37555 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844AbYAJPQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:16:41 -0500
Date: Thu, 10 Jan 2008 16:16:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 1/7] Add tests/ directory
Message-ID: <20080110151635.GA15361@uranus.ravnborg.org>
References: <20080110115428.GA26577@in.ibm.com> <20080110115537.GB26577@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110115537.GB26577@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 05:25:37PM +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Create a toplevel tests/ directory to house in-kernel subsystem specific
> tests.
> 
> PS: I am not sure if I've gotten the Makefile change right.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  Makefile          |    3 +++
>  lib/Kconfig.debug |    2 ++
>  tests/Kconfig     |   11 +++++++++++
>  tests/Makefile    |    3 +++
>  4 files changed, 19 insertions(+)
> 
> Index: linux-2.6.24-rc6/lib/Kconfig.debug
> ===================================================================
> --- linux-2.6.24-rc6.orig/lib/Kconfig.debug
> +++ linux-2.6.24-rc6/lib/Kconfig.debug
> @@ -596,3 +596,5 @@ config PROVIDE_OHCI1394_DMA_INIT
>  	  See Documentation/debugging-via-ohci1394.txt for more information.
>  
>  source "samples/Kconfig"
> +
> +source "tests/Kconfig"
> Index: linux-2.6.24-rc6/tests/Kconfig
> ===================================================================
> --- /dev/null
> +++ linux-2.6.24-rc6/tests/Kconfig
> @@ -0,0 +1,11 @@
> +# tests/Kconfig
> +
> +menuconfig KERNEL_TESTS
> +	bool "Kernel subsystem tests"
> +	help
> +	  You can build kernel subsystem specific tests.
> +
> +if KERNEL_TESTS
> +
> +endif # KERNEL_TESTS
> +
> Index: linux-2.6.24-rc6/tests/Makefile
> ===================================================================
> --- /dev/null
> +++ linux-2.6.24-rc6/tests/Makefile
> @@ -0,0 +1,3 @@
> +#
> +# Makefile for kernel subsystem specific tests
> +#
> Index: linux-2.6.24-rc6/Makefile
> ===================================================================
> --- linux-2.6.24-rc6.orig/Makefile
> +++ linux-2.6.24-rc6/Makefile
> @@ -598,6 +598,9 @@ export mod_strip_cmd
>  
>  ifeq ($(KBUILD_EXTMOD),)
>  core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> +ifdef CONFIG_KERNEL_TESTS
> +core-y		+= tests/
> +endif

CONFIG_KERNEL_TESTS is a bool so this should be written as:
core-$(CONFIG_KERNEL_TESTS) += tests/

With this change:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
