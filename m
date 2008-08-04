Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYHDRqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYHDRqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYHDRqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:46:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41916 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYHDRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:46:43 -0400
Date: Mon, 4 Aug 2008 10:45:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] KBUILD:  Extend "menuconfig" for modules to simplify
 Kconfig file.
Message-Id: <20080804104511.2e02f15e.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0808041328440.6174@localhost.localdomain>
References: <alpine.LFD.1.10.0808041328440.6174@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 13:31:32 -0400 (EDT) Robert P. J. Day wrote:

> 
> Given that the init/Kconfig file uses a "menuconfig" directive for
> modules already, might as well wrap all the submenu entries in an "if"
> to toss all those dependencies.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Looks good to me.  and tested.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 7e6dae1..b678803 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -845,9 +845,10 @@ menuconfig MODULES
> 
>  	  If unsure, say Y.
> 
> +if MODULES
> +
>  config MODULE_FORCE_LOAD
>  	bool "Forced module loading"
> -	depends on MODULES
>  	default n
>  	help
>  	  Allow loading of modules without version information (ie. modprobe
> @@ -856,7 +857,6 @@ config MODULE_FORCE_LOAD
> 
>  config MODULE_UNLOAD
>  	bool "Module unloading"
> -	depends on MODULES
>  	help
>  	  Without this option you will not be able to unload any
>  	  modules (note that some modules may not be unloadable
> @@ -875,7 +875,6 @@ config MODULE_FORCE_UNLOAD
> 
>  config MODVERSIONS
>  	bool "Module versioning support"
> -	depends on MODULES
>  	help
>  	  Usually, you have to use modules compiled with your kernel.
>  	  Saying Y here makes it sometimes possible to use modules
> @@ -886,7 +885,6 @@ config MODVERSIONS
> 
>  config MODULE_SRCVERSION_ALL
>  	bool "Source checksum for all modules"
> -	depends on MODULES
>  	help
>  	  Modules which contain a MODULE_VERSION get an extra "srcversion"
>  	  field inserted into their modinfo section, which contains a
> @@ -898,11 +896,12 @@ config MODULE_SRCVERSION_ALL
> 
>  config KMOD
>  	def_bool y
> -	depends on MODULES
>  	help
>  	  This is being removed soon.  These days, CONFIG_MODULES
>  	  implies CONFIG_KMOD, so use that instead.
> 
> +endif # MODULES
> +
>  config STOP_MACHINE
>  	bool
>  	default y


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
