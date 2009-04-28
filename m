Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZD1VlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZD1VlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZD1VlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:41:04 -0400
Received: from mail.fieldses.org ([141.211.133.115]:52615 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZD1VlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:41:01 -0400
Date: Tue, 28 Apr 2009 17:40:43 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] lockd: fix FILE_LOCKING=n build error
Message-ID: <20090428214043.GM23924@fieldses.org>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F71F4A.3080908@oracle.com> <20090428172137.GA22451@fieldses.org> <49F7421A.1090709@oracle.com> <1240942554.7376.38.camel@heimdal.trondhjem.org> <49F76E8C.3070808@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F76E8C.3070808@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 02:01:00PM -0700, Randy Dunlap wrote:
> Trond Myklebust wrote:
> > Until someone finds time to go through the code and add in all the
> > CONFIG_FILE_LOCKING special cases, the above needs to be a 'depends on
> > INET && FILE_LOCKING'.
> 
> That seems to work.  Thanks.

Looks good to me.--b.

> 
> 
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> lockd without FILE_LOCKING doesn't make sense, so make LOCKD and
> LOCKD_V4 depend on FILE_LOCKING, and make NFS depend on FILE_LOCKING.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/Kconfig     |    2 ++
>  fs/nfs/Kconfig |    2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-next-20090428.orig/fs/Kconfig
> +++ linux-next-20090428/fs/Kconfig
> @@ -226,10 +226,12 @@ source "fs/nfsd/Kconfig"
>  
>  config LOCKD
>  	tristate
> +	depends on FILE_LOCKING
>  
>  config LOCKD_V4
>  	bool
>  	depends on NFSD_V3 || NFS_V3
> +	depends on FILE_LOCKING
>  	default y
>  
>  config EXPORTFS
> --- linux-next-20090428.orig/fs/nfs/Kconfig
> +++ linux-next-20090428/fs/nfs/Kconfig
> @@ -1,6 +1,6 @@
>  config NFS_FS
>  	tristate "NFS client support"
> -	depends on INET
> +	depends on INET && FILE_LOCKING
>  	select LOCKD
>  	select SUNRPC
>  	select NFS_ACL_SUPPORT if NFS_V3_ACL
