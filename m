Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0CCXZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:25:45 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:37958 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754822Ab0CCXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:25:39 -0500
Date: Thu, 4 Mar 2010 10:25:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH mmotm] xfs: needs LIST_SORT
Message-ID: <20100303232522.GC14317@discord.disaster>
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org> <4B8EB545.8060806@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8EB545.8060806@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:15:17AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> xfs uses list_sort (library function), so it needs to select it.
> Fixes these build errors:
> fs/xfs/linux-2.6/xfs_buf.c:1918: undefined reference to `list_sort'
> fs/xfs/linux-2.6/xfs_buf.c:1996: undefined reference to `list_sort'
> fs/xfs/linux-2.6/xfs_buf.c:1950: undefined reference to `list_sort'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/xfs/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- mmotm-2010-0302-1838.orig/fs/xfs/Kconfig
> +++ mmotm-2010-0302-1838/fs/xfs/Kconfig
> @@ -2,6 +2,7 @@ config XFS_FS
>  	tristate "XFS filesystem support"
>  	depends on BLOCK
>  	select EXPORTFS
> +	select LIST_SORT
>  	help
>  	  XFS is a high performance journaling filesystem which originated
>  	  on the SGI IRIX platform.  It is completely multi-threaded, can

Looks OK, but when and why did a config option get introduced for
this? I thought that Andi was trying to cull unused symbols in
library functions automatically, so config options weren't needed...

FWIW, did UBIFS and DRM also get this select line added to them?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
