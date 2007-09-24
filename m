Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXIXPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXIXPJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbXIXPJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:09:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47151 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXIXPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:09:11 -0400
Date: Mon, 24 Sep 2007 08:08:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrey Mirkin <major@openvz.org>
Cc: John McCutchan <ttb@tentacle.dhs.org>,
       Robert Love <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, devel@openvz.org
Subject: Re: [PATCH] change inotifyfs magic as the same magic is used for
 futexfs (v2)
Message-Id: <20070924080808.83be8eed.randy.dunlap@oracle.com>
In-Reply-To: <200709241246.08138.major@openvz.org>
References: <200709241246.08138.major@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 12:46:06 +0400 Andrey Mirkin wrote:

> From: Andrey Mirkin <major@openvz.org>
> 
> Right now futexfs and inotifyfs have one magic 0xBAD1DEA, that looks a little 
> bit confusing.
> Use 0xBAD1DEA as magic for futexfs and 0x2BAD1DEA as magic for inotifyfs.
> 
> Signed-off-by: Andrey Mirkin <major@openvz.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ----
> 
>  fs/inotify_user.c     |    4 +++-
>  include/linux/magic.h |    3 +++
>  kernel/futex.c        |    3 ++-
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/inotify_user.c b/fs/inotify_user.c
> index 9bf2f6c..5e00933 100644
> --- a/fs/inotify_user.c
> +++ b/fs/inotify_user.c
> @@ -31,6 +31,7 @@ #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/inotify.h>
>  #include <linux/syscalls.h>
> +#include <linux/magic.h>
>  
>  #include <asm/ioctls.h>
>  
> @@ -684,7 +685,8 @@ static int
>  inotify_get_sb(struct file_system_type *fs_type, int flags,
>  	       const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> -	return get_sb_pseudo(fs_type, "inotify", NULL, 0xBAD1DEA, mnt);
> +	return get_sb_pseudo(fs_type, "inotify", NULL,
> +			INOTIFYFS_SUPER_MAGIC, mnt);
>  }
>  
>  static struct file_system_type inotify_fs_type = {
> diff --git a/include/linux/futex.h b/include/linux/futex.h
> diff --git a/include/linux/inotify.h b/include/linux/inotify.h
> diff --git a/include/linux/magic.h b/include/linux/magic.h
> index 36cc20d..722d475 100644
> --- a/include/linux/magic.h
> +++ b/include/linux/magic.h
> @@ -38,4 +38,7 @@ #define REISER2FS_JR_SUPER_MAGIC_STRING	
>  #define SMB_SUPER_MAGIC		0x517B
>  #define USBDEVICE_SUPER_MAGIC	0x9fa2
>  
> +#define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
> +#define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
> +
>  #endif /* __LINUX_MAGIC_H__ */
> diff --git a/kernel/futex.c b/kernel/futex.c
> index e8935b1..856dfba 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -52,6 +52,7 @@ #include <linux/pagemap.h>
>  #include <linux/syscalls.h>
>  #include <linux/signal.h>
>  #include <linux/module.h>
> +#include <linux/magic.h>
>  #include <asm/futex.h>
>  
>  #include "rtmutex_common.h"
> @@ -2074,7 +2075,7 @@ static int futexfs_get_sb(struct file_sy
>  			  int flags, const char *dev_name, void *data,
>  			  struct vfsmount *mnt)
>  {
> -	return get_sb_pseudo(fs_type, "futex", NULL, 0xBAD1DEA, mnt);
> +	return get_sb_pseudo(fs_type, "futex", NULL, FUTEXFS_SUPER_MAGIC, mnt);
>  }
>  
>  static struct file_system_type futex_fs_type = {
> -

---
~Randy
Phaedrus says that Quality is about caring.
