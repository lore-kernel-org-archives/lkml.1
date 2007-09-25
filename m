Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbXIYThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbXIYThl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbXIYThZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:37:25 -0400
Received: from xenotime.net ([66.160.160.81]:42501 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755429AbXIYThW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:37:22 -0400
Date: Tue, 25 Sep 2007 12:37:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: menuconfig idea: lift fs menu
Message-Id: <20070925123718.c98fd8c9.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.64.0709250134010.23305@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709250128510.23305@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709250132300.23305@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709250134010.23305@fbirervta.pbzchgretzou.qr>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 10:10:26 +0200 (CEST) Jan Engelhardt wrote:

> 
> Lift the FS menu a bit by moving filesystem-specific
> parts into their own menu.
> 
> This is an idea I had. Comments please, if any.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Hi Jan,

The current fs menu is too long IMO, so this helps.

This leaves minixfs and romfs in the main fs menu (where they were,
i.e., no change).  I would move them to the Miscellaneous fs menu...
and then move Quota support to after Dnotify so that Inotify & Dnotify
are next to each other.  Yes, I realize that they were already
separated by Quota and that this patch did not cause that.


> ---
>  fs/Kconfig      |   19 ++++++++++++++++---
>  fs/gfs2/Kconfig |    9 ++++++---
>  fs/xfs/Kconfig  |   10 +++++-----
>  3 files changed, 27 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6.23/fs/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/fs/Kconfig
> +++ linux-2.6.23/fs/Kconfig
> @@ -6,6 +6,17 @@ menu "File systems"
>  
>  if BLOCK
>  
> +menuconfig EXT_FS
> +	bool "Extended filesystem family"
> +	default y
> +	---help---
> +	  Say Y here to get to see options for the 'ext' filesystems.
> +	  This option alone does not add any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.
> +
> +if EXT_FS
> +
>  config EXT2_FS
>  	tristate "Second extended fs support"
>  	help
> @@ -272,7 +283,9 @@ config FS_MBCACHE
>  	default y if EXT2_FS=y || EXT3_FS=y || EXT4DEV_FS=y
>  	default m if EXT2_FS=m || EXT3_FS=m || EXT4DEV_FS=m
>  
> -config REISERFS_FS
> +endif # EXT_FS
> +
> +menuconfig REISERFS_FS
>  	tristate "Reiserfs support"
>  	help
>  	  Stores not just filenames but the files themselves in a balanced
> @@ -358,7 +371,7 @@ config REISERFS_FS_SECURITY
>  	  If you are not using a security module that requires using
>  	  extended attributes for file security labels, say N.
>  
> -config JFS_FS
> +menuconfig JFS_FS
>  	tristate "JFS filesystem support"
>  	select NLS
>  	help
> @@ -420,7 +433,7 @@ config FS_POSIX_ACL
>  source "fs/xfs/Kconfig"
>  source "fs/gfs2/Kconfig"
>  
> -config OCFS2_FS
> +menuconfig OCFS2_FS
>  	tristate "OCFS2 file system support"
>  	depends on NET && SYSFS
>  	select CONFIGFS_FS
> Index: linux-2.6.23/fs/gfs2/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/fs/gfs2/Kconfig
> +++ linux-2.6.23/fs/gfs2/Kconfig
> @@ -1,4 +1,4 @@
> -config GFS2_FS
> +menuconfig GFS2_FS
>  	tristate "GFS2 file system support"
>  	depends on EXPERIMENTAL
>  	select FS_POSIX_ACL
> @@ -18,9 +18,10 @@ config GFS2_FS
>  	  the below locking modules. Documentation and utilities for GFS2 can
>  	  be found here: http://sources.redhat.com/cluster
>  
> +if GFS2_FS
> +
>  config GFS2_FS_LOCKING_NOLOCK
>  	tristate "GFS2 \"nolock\" locking module"
> -	depends on GFS2_FS
>  	help
>  	  Single node locking module for GFS2.
>  
> @@ -34,7 +35,7 @@ config GFS2_FS_LOCKING_NOLOCK
>  
>  config GFS2_FS_LOCKING_DLM
>  	tristate "GFS2 DLM locking module"
> -	depends on GFS2_FS && SYSFS && NET && INET && (IPV6 || IPV6=n)
> +	depends on SYSFS && NET && INET && (IPV6 || IPV6=n)
>  	select IP_SCTP if DLM_SCTP
>  	select CONFIGFS_FS
>  	select DLM
> @@ -44,3 +45,5 @@ config GFS2_FS_LOCKING_DLM
>  	  Most users of GFS2 will require this module. It provides the locking
>  	  interface between GFS2 and the DLM, which is required to use GFS2
>  	  in a cluster environment.
> +
> +endif # GFS2_FS
> Index: linux-2.6.23/fs/xfs/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/fs/xfs/Kconfig
> +++ linux-2.6.23/fs/xfs/Kconfig
> @@ -1,4 +1,4 @@
> -config XFS_FS
> +menuconfig XFS_FS
>  	tristate "XFS filesystem support"
>  	depends on BLOCK
>  	help
> @@ -18,9 +18,10 @@ config XFS_FS
>  	  system of your root partition is compiled as a module, you'll need
>  	  to use an initial ramdisk (initrd) to boot.
>  
> +if XFS_FS
> +
>  config XFS_QUOTA
>  	bool "XFS Quota support"
> -	depends on XFS_FS
>  	help
>  	  If you say Y here, you will be able to set limits for disk usage on
>  	  a per user and/or a per group basis under XFS.  XFS considers quota
> @@ -37,7 +38,6 @@ config XFS_QUOTA
>  
>  config XFS_SECURITY
>  	bool "XFS Security Label support"
> -	depends on XFS_FS
>  	help
>  	  Security labels support alternative access control models
>  	  implemented by security modules like SELinux.  This option
> @@ -49,7 +49,6 @@ config XFS_SECURITY
>  
>  config XFS_POSIX_ACL
>  	bool "XFS POSIX ACL support"
> -	depends on XFS_FS
>  	help
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
> @@ -61,7 +60,6 @@ config XFS_POSIX_ACL
>  
>  config XFS_RT
>  	bool "XFS Realtime subvolume support"
> -	depends on XFS_FS
>  	help
>  	  If you say Y here you will be able to mount and use XFS filesystems
>  	  which contain a realtime subvolume.  The realtime subvolume is a
> @@ -76,3 +74,5 @@ config XFS_RT
>  	  See the xfs man page in section 5 for additional information.
>  
>  	  If unsure, say N.
> +
> +endif # XFS_FS
> 


---
~Randy
Phaedrus says that Quality is about caring.
