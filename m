Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZFSSej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZFSSej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZFSSec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:34:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZFSSeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:34:31 -0400
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <76DA7CFF-D6C7-44C3-BEC6-B7FDC6577B74@redhat.com>
From: Jonathan Brassow <jbrassow@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
In-Reply-To: <4A3BCD0D.3010801@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [dm-devel] [PATCH -next] dm: dm-log-userspace depends on NET
Date: Fri, 19 Jun 2009 13:31:39 -0500
References: <20090619172622.05adb236.sfr@canb.auug.org.au> <4A3BCD0D.3010801@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I've pulled this into my patch.

  brassow

On Jun 19, 2009, at 12:38 PM, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> DM_LOG_USERSPACE selects CONNECTOR, but when NET is not enabled,  
> this is
> useless and the build fails, so make DM_LOG_USERSPACE depend on NET.
>
> ERROR: "netlink_has_listeners" [drivers/connector/cn.ko] undefined!
> ERROR: "proc_net_fops_create" [drivers/connector/cn.ko] undefined!
> ERROR: "netlink_kernel_create" [drivers/connector/cn.ko] undefined!
> ERROR: "proc_net_remove" [drivers/connector/cn.ko] undefined!
> ERROR: "netlink_kernel_release" [drivers/connector/cn.ko] undefined!
> ERROR: "init_net" [drivers/connector/cn.ko] undefined!
> ERROR: "__alloc_skb" [drivers/connector/cn.ko] undefined!
> ERROR: "netlink_broadcast" [drivers/connector/cn.ko] undefined!
> ERROR: "kfree_skb" [drivers/connector/cn.ko] undefined!
> ERROR: "skb_put" [drivers/connector/cn.ko] undefined!
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jonathan Brassow <dm-devel@redhat.com>
> Cc: dm-devel@redhat.com
> ---
> drivers/md/Kconfig |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20090619.orig/drivers/md/Kconfig
> +++ linux-next-20090619/drivers/md/Kconfig
> @@ -233,7 +233,7 @@ config DM_MIRROR
>
> config DM_LOG_USERSPACE
> 	tristate "Mirror userspace logging (EXPERIMENTAL)"
> -	depends on DM_MIRROR && EXPERIMENTAL
> +	depends on DM_MIRROR && EXPERIMENTAL && NET
> 	select CONNECTOR
> 	---help---
> 	  The userspace logging module provides a mechanism for
>
>
>
> -- 
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

