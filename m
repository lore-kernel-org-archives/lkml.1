Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYGZQsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYGZQsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYGZQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:47:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35508 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYGZQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:47:56 -0400
Date: Sat, 26 Jul 2008 09:47:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
Message-Id: <20080726094718.b617c1e7.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
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

On Sat, 26 Jul 2008 09:20:49 -0400 (EDT) Robert P. J. Day wrote:

> 
> Use "menuconfig" to allow all advanced partitions to be deselectable
> from the top-level FS menu.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Hi,

I like the idea, but it does have one problem.  Before this patch, if someone
disabled PARTITION_ADVANCED, the .config would still contain
CONFIG_MSDOS_PARTITION=y
but after this change, that config line is missing.  Not good.

> ---
> 
>  fs/Kconfig            |    4 ----
>  fs/partitions/Kconfig |    9 +++++++--
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 37db79a..f06241f 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -2143,11 +2143,7 @@ config 9P_FS
>  endif # NETWORK_FILESYSTEMS
> 
>  if BLOCK
> -menu "Partition Types"
> -
>  source "fs/partitions/Kconfig"
> -
> -endmenu
>  endif
> 
>  source "fs/nls/Kconfig"
> diff --git a/fs/partitions/Kconfig b/fs/partitions/Kconfig
> index cb5f0a3..4bb87d2 100644
> --- a/fs/partitions/Kconfig
> +++ b/fs/partitions/Kconfig
> @@ -1,8 +1,9 @@
>  #
>  # Partition configuration
>  #
> -config PARTITION_ADVANCED
> -	bool "Advanced partition selection"
> +
> +menuconfig PARTITION_ADVANCED
> +	bool "Advanced partition support"
>  	help
>  	  Say Y here if you would like to use hard disks under Linux which
>  	  were partitioned under an operating system running on a different
> @@ -14,6 +15,8 @@ config PARTITION_ADVANCED
> 
>  	  If unsure, say N.
> 
> +if PARTITION_ADVANCED
> +
>  config ACORN_PARTITION
>  	bool "Acorn partition support" if PARTITION_ADVANCED
>  	default y if ARCH_ACORN
> @@ -249,3 +252,5 @@ config SYSV68_PARTITION
>  	  partition table format used by Motorola Delta machines (using
>  	  sysv68).
>  	  Otherwise, say N.
> +
> +endif # PARTITION_ADVANCED


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
