Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYBSUTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYBSUTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYBSUTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:19:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:63357 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYBSUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:19:15 -0500
Date: Tue, 19 Feb 2008 12:17:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Andrew <nick@nick-andrew.net>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 5/9]
Message-Id: <20080219121736.c4936240.randy.dunlap@oracle.com>
In-Reply-To: <20080219145309.GC27352@tull.net>
References: <20080219140609.GA26619@tull.net>
	<20080219145309.GC27352@tull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Wed, 20 Feb 2008 01:53:09 +1100 Nick Andrew wrote:

> On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> > Here is a series of 9 patches to init/Kconfig intended to improve the
> > usefulness and consistency of the help descriptions. The patches are
> > against linux-2.6.24.2.
> > [...]
> > Patch 5
> > 	IKCONFIG
> > 	IKCONFIG_PROC
> > 	LOG_BUF_SHIFT

Those parts are fine.  Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


Please read http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt,
esp. section 2, Subject.


> Changelog:
> 
> Improve usefulness and consistency of kernel configuration help messages.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> 
> 
> --- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
> +++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
> @@ -254,20 +254,30 @@ config IKCONFIG
>  	tristate "Kernel .config support"
>  	---help---
>  	  This option enables the complete Linux kernel ".config" file
> -	  contents to be saved in the kernel. It provides documentation
> -	  of which kernel options are used in a running kernel or in an
> -	  on-disk kernel.  This information can be extracted from the kernel
> -	  image file with the script scripts/extract-ikconfig and used as
> -	  input to rebuild the current kernel or to build another kernel.
> -	  It can also be extracted from a running kernel by reading
> -	  /proc/config.gz if enabled (below).
> +	  contents to be saved in the kernel.
> +
> +	  It provides documentation of which kernel options are used in
> +	  a running kernel or in an on-disk kernel.  This information
> +	  can be extracted from the kernel image file with the script
> +	  "scripts/extract-ikconfig" and used as input to rebuild the
> +	  current kernel or to build another kernel.
> +
> +	  It can also be extracted from a running kernel with
> +	  "zcat /proc/config.gz" if CONFIG_IKCONFIG_PROC is enabled
> +	  below.
> +
> +	  Your kernel size will increase by around 14k.
> +
> +	  If unsure, say N.
>  
>  config IKCONFIG_PROC
>  	bool "Enable access to .config through /proc/config.gz"
>  	depends on IKCONFIG && PROC_FS
>  	---help---
> -	  This option enables access to the kernel configuration file
> -	  through /proc/config.gz.
> +	  This option enables access to the configuration of the running
> +	  kernel through /proc/config.gz.
> +
> +	  If unsure, say Y.
>  
>  config LOG_BUF_SHIFT
>  	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
> @@ -277,14 +287,15 @@ config LOG_BUF_SHIFT
>  	default 15 if SMP
>  	default 14
>  	help
> -	  Select kernel log buffer size as a power of 2.
> -	  Defaults and Examples:
> +	  Select the kernel log buffer size as a power of 2.
> +
> +	  Defaults and examples:
>  	  	     17 => 128 KB for S/390
> -		     16 => 64 KB for x86 NUMAQ or IA-64
> -	             15 => 32 KB for SMP
> -	             14 => 16 KB for uniprocessor
> -		     13 =>  8 KB
> -		     12 =>  4 KB
> +		     16 =>  64 KB for x86 NUMAQ or IA-64
> +	             15 =>  32 KB for SMP
> +	             14 =>  16 KB for uniprocessor
> +		     13 =>   8 KB
> +		     12 =>   4 KB
>  
>  config CGROUPS
>  	bool "Control Group support"


---
~Randy
